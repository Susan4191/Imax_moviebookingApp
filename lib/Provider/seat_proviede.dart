import 'package:flutter/foundation.dart';
import 'package:imax_movie_ticket_booking/Model/seat_model.dart';

class SeatProvider extends ChangeNotifier {
  static const int seatsPerRow = 10;
  static const int maximumSelection = 6;

  final List<String> rows = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];

  /// Key format: "$movieName_$time_$date"
  String _currentKey = 'default';

  /// Mapped booked seats per movie / showtime key
  final Map<String, Set<String>> _bookedSeatsMap = {};

  /// Mapped selected seats per movie / showtime key
  final Map<String, Set<String>> _selectedSeatsMap = {};

  double _ticketPrice = 600.0;
  final double _serviceFee = 50.0;

  double get ticketPrice => _ticketPrice;
  double get serviceFeeAmount => _serviceFee;

  String get currentKey => _currentKey;

  void setMovieAndShowtime({
    required String movieName,
    String time = '',
    String date = '',
    double? ticketPrice,
  }) {
    final key = '${movieName.trim()}_${time.trim()}_${date.trim()}';
    bool needsNotify = false;

    if (_currentKey != key) {
      _currentKey = key;
      _ensureSessionExists(_currentKey);
      needsNotify = true;
    }

    if (ticketPrice != null && _ticketPrice != ticketPrice) {
      _ticketPrice = ticketPrice;
      needsNotify = true;
    }

    if (needsNotify) {
      notifyListeners();
    }
  }

  void _ensureSessionExists(String key) {
    if (!_bookedSeatsMap.containsKey(key)) {
      _bookedSeatsMap[key] = _generateInitialBookedSeats(key);
    }
    if (!_selectedSeatsMap.containsKey(key)) {
      _selectedSeatsMap[key] = {};
    }
  }

  Set<String> _generateInitialBookedSeats(String key) {
    if (key == 'default') {
      return {'D8', 'D9', 'F5'};
    }
    final hash = key.hashCode.abs();
    final seatOptions = [
      'B3',
      'B4',
      'C5',
      'C6',
      'D8',
      'D9',
      'E4',
      'E7',
      'F5',
      'F6',
      'C3',
      'D4',
    ];
    final set = <String>{};
    set.add(seatOptions[hash % seatOptions.length]);
    set.add(seatOptions[(hash + 3) % seatOptions.length]);
    set.add(seatOptions[(hash + 7) % seatOptions.length]);
    return set;
  }

  Set<String> get _currentBooked {
    _ensureSessionExists(_currentKey);
    return _bookedSeatsMap[_currentKey]!;
  }

  Set<String> get _currentSelected {
    _ensureSessionExists(_currentKey);
    return _selectedSeatsMap[_currentKey]!;
  }

  void setTicketPrice(double price) {
    if (_ticketPrice != price) {
      _ticketPrice = price;
      notifyListeners();
    }
  }

  Set<String> get bookedSeats => Set.unmodifiable(_currentBooked);

  List<String> get selectedSeats {
    final seats = _currentSelected.toList();
    seats.sort((firstSeat, secondSeat) {
      final rowComparison = firstSeat[0].compareTo(secondSeat[0]);
      if (rowComparison != 0) {
        return rowComparison;
      }
      final firstNumber = int.parse(firstSeat.substring(1));
      final secondNumber = int.parse(secondSeat.substring(1));
      return firstNumber.compareTo(secondNumber);
    });
    return seats;
  }

  int get selectedSeatCount => _currentSelected.length;

  bool isBooked(String seatNumber) {
    return _currentBooked.contains(seatNumber);
  }

  bool isSelected(String seatNumber) {
    return _currentSelected.contains(seatNumber);
  }

  bool isPremium(String seatNumber) {
    final row = seatNumber[0];
    return row == 'G' || row == 'H';
  }

  SeatType getSeatType(String seatNumber) {
    if (isBooked(seatNumber)) return SeatType.booked;
    if (isSelected(seatNumber)) return SeatType.selected;
    if (isPremium(seatNumber)) return SeatType.premium;
    return SeatType.available;
  }

  double getSeatPrice(String seatNumber) {
    if (isPremium(seatNumber)) {
      return _ticketPrice + 150;
    }
    return _ticketPrice;
  }

  double get ticketTotalPrice {
    return _currentSelected.fold(0.0, (total, seatNumber) {
      return total + getSeatPrice(seatNumber);
    });
  }

  double get currentServiceFee {
    return _currentSelected.isEmpty ? 0.0 : _serviceFee;
  }

  double get grandTotal {
    return ticketTotalPrice + currentServiceFee;
  }

  String? toggleSeat(String seatNumber) {
    if (isBooked(seatNumber)) {
      return 'This seat is already booked';
    }

    if (isSelected(seatNumber)) {
      _currentSelected.remove(seatNumber);
      notifyListeners();
      return null;
    }

    if (_currentSelected.length >= maximumSelection) {
      return 'You can select a maximum of $maximumSelection seats';
    }

    _currentSelected.add(seatNumber);
    notifyListeners();
    return null;
  }

  void clearSelectedSeats() {
    _currentSelected.clear();
    notifyListeners();
  }

  void confirmBooking() {
    _currentBooked.addAll(_currentSelected);
    _currentSelected.clear();
    notifyListeners();
  }

  /// Admin methods
  void adminToggleBookedSeat(String seatNumber) {
    if (_currentBooked.contains(seatNumber)) {
      _currentBooked.remove(seatNumber);
    } else {
      _currentBooked.add(seatNumber);
      _currentSelected.remove(seatNumber);
    }
    notifyListeners();
  }

  void adminClearAllBookings() {
    _currentBooked.clear();
    _currentSelected.clear();
    notifyListeners();
  }

  void adminBookSeats(List<String> seats) {
    _currentBooked.addAll(seats);
    _currentSelected.removeAll(seats);
    notifyListeners();
  }
}
