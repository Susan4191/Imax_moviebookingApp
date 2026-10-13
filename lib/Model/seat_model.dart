enum SeatType { available, selected, booked, premium }

class SeatModel {
  final String id;
  final String row;
  final int number;
  final SeatType type;
  final double price;

  SeatModel({
    required this.id,
    required this.row,
    required this.number,
    this.type = SeatType.available,
    required this.price,
  });
}
