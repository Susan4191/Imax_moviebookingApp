import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:imax_movie_ticket_booking/Model/booking_model.dart';
import 'package:imax_movie_ticket_booking/Model/cinema_admin_model.dart';
import 'package:imax_movie_ticket_booking/Model/user_model.dart';
import 'package:imax_movie_ticket_booking/Services/firestore_service.dart';

class SuperAdminProvider extends ChangeNotifier {
  bool _isSuperAdminLoggedIn = true;
  String _superAdminName = 'Susan Khatri';
  String _superAdminEmail = 'superadmin@imaxcinemas.com';

  bool _maintenanceMode = false;
  bool _allowWalkInBooking = true;
  bool _systemNotifications = true;
  final String _currencySymbol = 'NPR';

  final List<CinemaAdminModel> _cinemaAdmins = [];
  final List<UserModel> _customers = [];
  final Map<String, bool> _customerActiveStatus = {};
  final List<BookingModel> _allBookings = [];

  String _cinemaAdminSearchQuery = '';
  String _customerSearchQuery = '';
  String _bookingSearchQuery = '';
  String _bookingStatusFilter = 'All';

  final FirestoreService _firestoreService = FirestoreService();
  StreamSubscription? _cinemaAdminSub;

  SuperAdminProvider() {
    _initDefaultAdmins();
    _listenToFirestoreCinemaAdmins();
  }

  void _initDefaultAdmins() {
    _cinemaAdmins.addAll([
      CinemaAdminModel(
        id: 'CADM-001',
        name: 'Binod Shrestha',
        email: 'binod@admin.com',
        assignedLocation: 'Audi 1 - Main Hall',
        isActive: true,
        createdDate: '12 Jan 2024',
      ),
      CinemaAdminModel(
        id: 'CADM-002',
        name: 'Anita Gurung',
        email: 'anita@admin.com',
        assignedLocation: 'Audi 2 - VIP 3D Screen',
        isActive: true,
        createdDate: '01 Mar 2024',
      ),
    ]);
  }

  void _listenToFirestoreCinemaAdmins() {
    _cinemaAdminSub?.cancel();
    _cinemaAdminSub = _firestoreService.streamCinemaAdmins().listen((
      newAdmins,
    ) {
      if (newAdmins.isNotEmpty) {
        _cinemaAdmins.clear();
        _cinemaAdmins.addAll(newAdmins);
        notifyListeners();
      } else {
        for (var admin in _cinemaAdmins) {
          _firestoreService.saveCinemaAdmin(admin);
        }
      }
    });
  }

  @override
  void dispose() {
    _cinemaAdminSub?.cancel();
    super.dispose();
  }

  // Getters
  bool get isSuperAdminLoggedIn => _isSuperAdminLoggedIn;
  String get superAdminName => _superAdminName;
  String get superAdminEmail => _superAdminEmail;

  bool get maintenanceMode => _maintenanceMode;
  bool get allowWalkInBooking => _allowWalkInBooking;
  bool get systemNotifications => _systemNotifications;
  String get currencySymbol => _currencySymbol;

  List<CinemaAdminModel> get cinemaAdmins => List.unmodifiable(_cinemaAdmins);
  List<UserModel> get customers => List.unmodifiable(_customers);
  List<BookingModel> get allBookings => List.unmodifiable(_allBookings);

  String get cinemaAdminSearchQuery => _cinemaAdminSearchQuery;
  String get customerSearchQuery => _customerSearchQuery;
  String get bookingSearchQuery => _bookingSearchQuery;
  String get bookingStatusFilter => _bookingStatusFilter;

  // Filtered Getters
  List<CinemaAdminModel> get filteredCinemaAdmins {
    if (_cinemaAdminSearchQuery.isEmpty) return _cinemaAdmins;
    final q = _cinemaAdminSearchQuery.toLowerCase();
    return _cinemaAdmins.where((a) {
      return a.name.toLowerCase().contains(q) ||
          a.email.toLowerCase().contains(q) ||
          a.assignedLocation.toLowerCase().contains(q);
    }).toList();
  }

  List<UserModel> get filteredCustomers {
    if (_customerSearchQuery.isEmpty) return _customers;
    final q = _customerSearchQuery.toLowerCase();
    return _customers.where((c) {
      return c.name.toLowerCase().contains(q) ||
          c.email.toLowerCase().contains(q) ||
          c.phone.contains(q);
    }).toList();
  }

  List<BookingModel> get filteredBookings {
    return _allBookings.where((b) {
      final matchesSearch =
          _bookingSearchQuery.isEmpty ||
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

  // Statistics
  int get totalRegisteredCustomersCount => _customers.length;
  int get totalCinemaAdminsCount => _cinemaAdmins.length;
  int get totalBookingsCount => _allBookings.length;
  int get confirmedBookingsCount =>
      _allBookings.where((b) => b.status == 'Confirmed').length;
  int get cancelledBookingsCount =>
      _allBookings.where((b) => b.status == 'Cancelled').length;

  double get totalTicketRevenue {
    return _allBookings
        .where((b) => b.status == 'Confirmed')
        .fold(0.0, (sum, b) => sum + b.totalPrice);
  }

  double get dailyRevenue => totalTicketRevenue * 0.25;
  double get weeklyRevenue => totalTicketRevenue * 0.75;
  double get monthlyRevenue => totalTicketRevenue;

  String get mostBookedMovieTitle =>
      _allBookings.isNotEmpty ? _allBookings.first.movieTitle : 'N/A';

  bool isCustomerActive(String customerId) {
    return _customerActiveStatus[customerId] ?? true;
  }

  // Setters & Actions
  void loginSuperAdmin() {
    _isSuperAdminLoggedIn = true;
    notifyListeners();
  }

  void logoutSuperAdmin() {
    _isSuperAdminLoggedIn = false;
    notifyListeners();
  }

  void setCinemaAdminSearchQuery(String query) {
    _cinemaAdminSearchQuery = query;
    notifyListeners();
  }

  void setCustomerSearchQuery(String query) {
    _customerSearchQuery = query;
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

  void addCinemaAdmin(CinemaAdminModel admin) {
    _cinemaAdmins.insert(0, admin);
    notifyListeners();
    _firestoreService.saveCinemaAdmin(admin);
  }

  void updateCinemaAdmin(String id, CinemaAdminModel updatedAdmin) {
    final idx = _cinemaAdmins.indexWhere((a) => a.id == id);
    if (idx != -1) {
      _cinemaAdmins[idx] = updatedAdmin;
      notifyListeners();
      _firestoreService.saveCinemaAdmin(updatedAdmin);
    }
  }

  void toggleCinemaAdminStatus(String id) {
    final idx = _cinemaAdmins.indexWhere((a) => a.id == id);
    if (idx != -1) {
      final current = _cinemaAdmins[idx];
      final newStatus = !current.isActive;
      _cinemaAdmins[idx] = current.copyWith(isActive: newStatus);
      notifyListeners();
      _firestoreService.toggleCinemaAdminStatus(id, newStatus);
    }
  }

  void deleteCinemaAdmin(String id) {
    _cinemaAdmins.removeWhere((a) => a.id == id);
    notifyListeners();
    _firestoreService.deleteCinemaAdmin(id);
  }

  void toggleCustomerStatus(String customerId) {
    final current = isCustomerActive(customerId);
    _customerActiveStatus[customerId] = !current;
    notifyListeners();
  }

  void updateSuperAdminProfile(String name, String email) {
    _superAdminName = name;
    _superAdminEmail = email;
    notifyListeners();
  }

  void setMaintenanceMode(bool val) {
    _maintenanceMode = val;
    notifyListeners();
  }

  void setAllowWalkInBooking(bool val) {
    _allowWalkInBooking = val;
    notifyListeners();
  }

  void setSystemNotifications(bool val) {
    _systemNotifications = val;
    notifyListeners();
  }
}
