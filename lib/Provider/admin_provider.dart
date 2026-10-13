import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:imax_movie_ticket_booking/Model/booking_model.dart';
import 'package:imax_movie_ticket_booking/Model/user_model.dart';
import 'package:imax_movie_ticket_booking/Services/firestore_service.dart';

class AdminProvider extends ChangeNotifier {
  bool _isAdminLoggedIn = true;

  final List<BookingModel> _bookings = [];
  final List<UserModel> _users = [];

  String _bookingSearchQuery = '';
  String _bookingStatusFilter = 'All';
  String _userSearchQuery = '';

  final FirestoreService _firestoreService = FirestoreService();
  StreamSubscription? _bookingsSubscription;

  AdminProvider() {
    _listenToFirestoreBookings();
  }

  void _listenToFirestoreBookings() {
    _bookingsSubscription?.cancel();
    _bookingsSubscription = _firestoreService.streamBookings().listen((
      newBookings,
    ) {
      if (newBookings.isNotEmpty) {
        _bookings.clear();
        _bookings.addAll(newBookings);
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _bookingsSubscription?.cancel();
    super.dispose();
  }

  bool get isAdminLoggedIn => _isAdminLoggedIn;
  List<BookingModel> get bookings => List.unmodifiable(_bookings);
  List<UserModel> get users => List.unmodifiable(_users);

  String get bookingSearchQuery => _bookingSearchQuery;
  String get bookingStatusFilter => _bookingStatusFilter;
  String get userSearchQuery => _userSearchQuery;

  double get totalRevenue {
    return _bookings
        .where((b) => b.status == 'Confirmed')
        .fold(0.0, (sum, b) => sum + b.totalPrice);
  }

  int get totalBookingsCount => _bookings.length;
  int get activeBookingsCount =>
      _bookings.where((b) => b.status == 'Confirmed').length;
  int get cancelledBookingsCount =>
      _bookings.where((b) => b.status == 'Cancelled').length;
  int get totalUsersCount => _users.length;

  List<BookingModel> get filteredBookings {
    return _bookings.where((b) {
      final matchesSearch =
          b.id.toLowerCase().contains(_bookingSearchQuery.toLowerCase()) ||
          b.customerName.toLowerCase().contains(
            _bookingSearchQuery.toLowerCase(),
          ) ||
          b.movieTitle.toLowerCase().contains(
            _bookingSearchQuery.toLowerCase(),
          );

      final matchesFilter =
          _bookingStatusFilter == 'All' || b.status == _bookingStatusFilter;

      return matchesSearch && matchesFilter;
    }).toList();
  }

  List<UserModel> get filteredUsers {
    if (_userSearchQuery.isEmpty) return _users;
    final query = _userSearchQuery.toLowerCase();
    return _users.where((u) {
      return u.name.toLowerCase().contains(query) ||
          u.email.toLowerCase().contains(query) ||
          u.phone.contains(query);
    }).toList();
  }

  void loginAdmin() {
    _isAdminLoggedIn = true;
    notifyListeners();
  }

  void logoutAdmin() {
    _isAdminLoggedIn = false;
    notifyListeners();
  }

  void setBookingSearchQuery(String query) {
    _bookingSearchQuery = query;
    notifyListeners();
  }

  void setBookingStatusFilter(String filter) {
    _bookingStatusFilter = filter;
    notifyListeners();
  }

  void setUserSearchQuery(String query) {
    _userSearchQuery = query;
    notifyListeners();
  }

  void setBookings(List<BookingModel> newBookings) {
    _bookings.clear();
    _bookings.addAll(newBookings);
    notifyListeners();
  }

  void setUsers(List<UserModel> newUsers) {
    _users.clear();
    _users.addAll(newUsers);
    notifyListeners();
  }

  void addBooking(BookingModel booking) {
    _bookings.insert(0, booking);

    final index = _users.indexWhere(
      (u) =>
          u.name.toLowerCase() == booking.customerName.toLowerCase() ||
          (u.phone.isNotEmpty && u.phone == booking.customerPhone),
    );
    if (index != -1) {
      _users[index] = _users[index].copyWith(
        bookingCount: _users[index].bookingCount + 1,
      );
    } else if (booking.customerName.isNotEmpty) {
      _users.add(
        UserModel(
          id: 'USR-${_users.length + 101}',
          name: booking.customerName,
          email:
              '${booking.customerName.toLowerCase().replaceAll(' ', '')}@gmail.com',
          phone: booking.customerPhone.isEmpty ? 'N/A' : booking.customerPhone,
          registeredDate: 'Today',
          bookingCount: 1,
        ),
      );
    }

    notifyListeners();
    _firestoreService.saveBooking(booking);
  }

  void updateBookingStatus(String bookingId, String newStatus) {
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      _bookings[index] = _bookings[index].copyWith(status: newStatus);
      notifyListeners();
    }
    _firestoreService.updateBookingStatus(bookingId, newStatus);
  }

  void deleteBooking(String bookingId) {
    _bookings.removeWhere((b) => b.id == bookingId);
    notifyListeners();
    _firestoreService.deleteBooking(bookingId);
  }

  void addUser(UserModel user) {
    _users.insert(0, user);
    notifyListeners();
  }

  void updateUser(String userId, UserModel updatedUser) {
    final index = _users.indexWhere((u) => u.id == userId);
    if (index != -1) {
      _users[index] = updatedUser;
      notifyListeners();
    }
  }

  void deleteUser(String userId) {
    _users.removeWhere((u) => u.id == userId);
    notifyListeners();
  }
}
