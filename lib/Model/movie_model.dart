class MovieModel {
  final String title;
  final String poster;
  final String? rating;
  final String? durations;
  final String? seat;
  final String information;
  final String? format;
  final String? id;

  MovieModel({
    required this.title,
    required this.poster,
    this.rating,
    this.durations,
    this.seat,
    required this.information,
    this.format = 'IMAX 3D',
    this.id,
  });

  MovieModel copyWith({
    String? title,
    String? poster,
    String? rating,
    String? durations,
    String? seat,
    String? information,
    String? format,
    String? id,
  }) {
    return MovieModel(
      title: title ?? this.title,
      poster: poster ?? this.poster,
      rating: rating ?? this.rating,
      durations: durations ?? this.durations,
      seat: seat ?? this.seat,
      information: information ?? this.information,
      format: format ?? this.format,
      id: id ?? this.id,
    );
  }
}
