import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:imax_movie_ticket_booking/Model/show_time_model.dart';
import 'package:imax_movie_ticket_booking/Services/firestore_service.dart';

class ShowTimeProvider extends ChangeNotifier {
  final List<String> showTime = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  final List<String> weekDay = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  final List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  late final List<DateTime> showDates;
  final List<ShowTimeModel> selectDateTime = [];

  final FirestoreService _firestoreService = FirestoreService();
  StreamSubscription? _showtimeSubscription;

  ShowTimeProvider() {
    final today = DateTime.now();
    showDates = List.generate(7, ((index) => today.add(Duration(days: index))));
    _initDefaultShowTimes();
    _listenToFirestoreShowTimes();
  }

  void _initDefaultShowTimes() {
    selectDateTime.addAll([
      ShowTimeModel(
        time: "7:00 AM",
        price: "500",
        screen: "Audi 1",
        format: "2D",
        isAvailable: true,
      ),
      ShowTimeModel(
        time: "9:30 AM",
        price: "700",
        screen: "Audi 2",
        format: "3D",
        isAvailable: true,
      ),
      ShowTimeModel(
        time: "12:00 PM",
        price: "500",
        screen: "Audi 1",
        format: "2D",
        isAvailable: true,
      ),
      ShowTimeModel(
        time: "3:45 PM",
        price: "700",
        screen: "Audi 2",
        format: "3D",
        isAvailable: true,
      ),
      ShowTimeModel(
        time: "6:15 PM",
        price: "1000",
        screen: "Audi 3",
        format: "IMAX 3D",
        isAvailable: true,
      ),
      ShowTimeModel(
        time: "9:00 PM",
        price: "1000",
        screen: "Audi 3",
        format: "IMAX 3D",
        isAvailable: true,
      ),
    ]);
  }

  void _listenToFirestoreShowTimes() {
    _showtimeSubscription?.cancel();
    _showtimeSubscription = _firestoreService.streamShowTimes().listen((
      newTimes,
    ) {
      if (newTimes.isNotEmpty) {
        selectDateTime.clear();
        selectDateTime.addAll(newTimes);
        notifyListeners();
      } else {
        for (var st in selectDateTime) {
          _firestoreService.saveShowTime(st);
        }
      }
    });
  }

  @override
  void dispose() {
    _showtimeSubscription?.cancel();
    super.dispose();
  }

  void addShowTime(ShowTimeModel model) {
    selectDateTime.add(model);
    notifyListeners();
    _firestoreService.saveShowTime(model);
  }

  void updateShowTime(int index, ShowTimeModel model) {
    if (index >= 0 && index < selectDateTime.length) {
      selectDateTime[index] = model;
      notifyListeners();
      _firestoreService.saveShowTime(model);
    }
  }

  void deleteShowTime(int index) {
    if (index >= 0 && index < selectDateTime.length) {
      selectDateTime.removeAt(index);
      notifyListeners();
    }
  }
}
