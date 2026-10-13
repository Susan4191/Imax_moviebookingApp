class CinemaAdminModel {
  final String id;
  final String name;
  final String email;
  final String assignedLocation;
  final bool isActive;
  final String createdDate;

  CinemaAdminModel({
    required this.id,
    required this.name,
    required this.email,
    required this.assignedLocation,
    this.isActive = true,
    required this.createdDate,
  });

  CinemaAdminModel copyWith({
    String? id,
    String? name,
    String? email,
    String? assignedLocation,
    bool? isActive,
    String? createdDate,
  }) {
    return CinemaAdminModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      assignedLocation: assignedLocation ?? this.assignedLocation,
      isActive: isActive ?? this.isActive,
      createdDate: createdDate ?? this.createdDate,
    );
  }
}
