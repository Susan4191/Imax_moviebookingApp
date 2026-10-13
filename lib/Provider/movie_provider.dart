import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:imax_movie_ticket_booking/Model/movie_model.dart';
import 'package:imax_movie_ticket_booking/Services/firestore_service.dart';

class MovieProvider extends ChangeNotifier {
  int selectedCategory = 0;

  final List<String> category = ["Now Showing", "Next Release", "Coming Soon"];

  final List<MovieModel> nowShowingMovies = [];
  final List<MovieModel> nextReleaseMovies = [];
  final List<MovieModel> comingSoonMovies = [];

  final FirestoreService _firestoreService = FirestoreService();
  StreamSubscription? _moviesSubscription;

  MovieProvider() {
    _initDefaultMovies();
    _listenToFirestoreMovies();
  }

  void _initDefaultMovies() {
    nowShowingMovies.addAll([
      MovieModel(
        title: 'Dune: Part Two',
        poster: 'assets/images/logo.png',
        rating: '8.6',
        durations: '2.45 hr',
        information: 'Action / Sci-Fi / Adventure',
        format: 'IMAX 3D',
      ),
      MovieModel(
        title: 'Godzilla x Kong',
        poster: 'assets/images/logo.png',
        rating: '7.2',
        durations: '1.55 hr',
        information: 'Action / Sci-Fi',
        format: '3D',
      ),
    ]);

    nextReleaseMovies.addAll([
      MovieModel(
        title: 'Kingdom of the Planet of the Apes',
        poster: 'assets/images/logo.png',
        rating: '7.8',
        durations: '2.25 hr',
        information: 'Action / Sci-Fi',
        format: 'IMAX 2D',
      ),
    ]);

    comingSoonMovies.addAll([
      MovieModel(
        title: 'Deadpool & Wolverine',
        poster: 'assets/images/logo.png',
        rating: '8.9',
        durations: '2.10 hr',
        information: 'Action / Comedy',
        format: 'IMAX 3D',
      ),
    ]);
  }

  void _listenToFirestoreMovies() {
    _moviesSubscription?.cancel();
    _moviesSubscription = _firestoreService.streamMovies().listen((docsList) {
      if (docsList.isNotEmpty) {
        final List<MovieModel> nowShowing = [];
        final List<MovieModel> nextRelease = [];
        final List<MovieModel> comingSoon = [];

        for (var data in docsList) {
          final movie = MovieModel(
            id: data['id'] ?? '',
            title: data['title'] ?? 'Untitled Movie',
            poster: data['poster'] ?? 'assets/images/logo.png',
            rating: data['rating']?.toString() ?? '8.0',
            durations: data['durations']?.toString() ?? '2.0 hr',
            information: data['information'] ?? 'Genre',
            format: data['format'] ?? 'IMAX 3D',
          );

          final int catIdx = data['categoryIndex'] ?? 0;
          if (catIdx == 0) {
            nowShowing.add(movie);
          } else if (catIdx == 1) {
            nextRelease.add(movie);
          } else {
            comingSoon.add(movie);
          }
        }

        nowShowingMovies.clear();
        nowShowingMovies.addAll(nowShowing);

        nextReleaseMovies.clear();
        nextReleaseMovies.addAll(nextRelease);

        comingSoonMovies.clear();
        comingSoonMovies.addAll(comingSoon);

        notifyListeners();
      } else {
        // Seed default movies to Firestore
        for (var m in nowShowingMovies) {
          _firestoreService.addMovie(m, 0);
        }
        for (var m in nextReleaseMovies) {
          _firestoreService.addMovie(m, 1);
        }
        for (var m in comingSoonMovies) {
          _firestoreService.addMovie(m, 2);
        }
      }
    });
  }

  @override
  void dispose() {
    _moviesSubscription?.cancel();
    super.dispose();
  }

  void setNowShowingMovies(List<MovieModel> movies) {
    nowShowingMovies.clear();
    nowShowingMovies.addAll(movies);
    notifyListeners();
  }

  void setNextReleaseMovies(List<MovieModel> movies) {
    nextReleaseMovies.clear();
    nextReleaseMovies.addAll(movies);
    notifyListeners();
  }

  void setComingSoonMovies(List<MovieModel> movies) {
    comingSoonMovies.clear();
    comingSoonMovies.addAll(movies);
    notifyListeners();
  }

  void changeCategory(int index) {
    selectedCategory = index;
    notifyListeners();
  }

  List<MovieModel> get selectedMovies {
    switch (selectedCategory) {
      case 0:
        return nowShowingMovies;
      case 1:
        return nextReleaseMovies;
      case 2:
        return comingSoonMovies;
      default:
        return [];
    }
  }

  void addMovie(MovieModel movie, int categoryIndex) {
    if (categoryIndex == 0) {
      nowShowingMovies.add(movie);
    } else if (categoryIndex == 1) {
      nextReleaseMovies.add(movie);
    } else if (categoryIndex == 2) {
      comingSoonMovies.add(movie);
    }
    notifyListeners();
    _firestoreService.addMovie(movie, categoryIndex);
  }

  void deleteMovie(MovieModel movie, int categoryIndex) {
    if (categoryIndex == 0) {
      nowShowingMovies.removeWhere((m) => m.title == movie.title);
    } else if (categoryIndex == 1) {
      nextReleaseMovies.removeWhere((m) => m.title == movie.title);
    } else if (categoryIndex == 2) {
      comingSoonMovies.removeWhere((m) => m.title == movie.title);
    }
    notifyListeners();
    _firestoreService.deleteMovie(movie.title);
  }

  void updateMovie(
    MovieModel oldMovie,
    MovieModel updatedMovie,
    int categoryIndex,
  ) {
    List<MovieModel> list;
    if (categoryIndex == 0) {
      list = nowShowingMovies;
    } else if (categoryIndex == 1) {
      list = nextReleaseMovies;
    } else {
      list = comingSoonMovies;
    }

    final index = list.indexWhere((m) => m.title == oldMovie.title);
    if (index != -1) {
      list[index] = updatedMovie;
      notifyListeners();
    }
    _firestoreService.updateMovie(oldMovie.title, updatedMovie, categoryIndex);
  }
}
