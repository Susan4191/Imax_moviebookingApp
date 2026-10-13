class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String registeredDate;
  final int bookingCount;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.registeredDate,
    required this.bookingCount,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? registeredDate,
    int? bookingCount,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      registeredDate: registeredDate ?? this.registeredDate,
      bookingCount: bookingCount ?? this.bookingCount,
    );
  }
}
