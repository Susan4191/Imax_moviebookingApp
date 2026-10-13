class BookingModel {
  final String id;
  final String customerName;
  final String customerPhone;
  final String movieTitle;
  final String date;
  final String time;
  final List<String> seats;
  final double totalPrice;
  final String status; // 'Confirmed' or 'Cancelled'
  final String paymentMethod;
  final DateTime createdAt;

  BookingModel({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.movieTitle,
    required this.date,
    required this.time,
    required this.seats,
    required this.totalPrice,
    required this.status,
    required this.paymentMethod,
    required this.createdAt,
  });

  BookingModel copyWith({
    String? id,
    String? customerName,
    String? customerPhone,
    String? movieTitle,
    String? date,
    String? time,
    List<String>? seats,
    double? totalPrice,
    String? status,
    String? paymentMethod,
    DateTime? createdAt,
  }) {
    return BookingModel(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      movieTitle: movieTitle ?? this.movieTitle,
      date: date ?? this.date,
      time: time ?? this.time,
      seats: seats ?? this.seats,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
