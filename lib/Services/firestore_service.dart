import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:imax_movie_ticket_booking/Model/booking_model.dart';
import 'package:imax_movie_ticket_booking/Model/cinema_admin_model.dart';
import 'package:imax_movie_ticket_booking/Model/movie_model.dart';
import 'package:imax_movie_ticket_booking/Model/show_time_model.dart';

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  FirebaseFirestore? get _db {
    try {
      if (Firebase.apps.isNotEmpty) {
        final instance = FirebaseFirestore.instance;
        instance.settings = const Settings(
          persistenceEnabled: true,
          cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
        );
        return instance;
      }
      return null;
    } catch (e) {
      debugPrint('Firestore instance error: $e');
      return null;
    }
  }

  // ==================== MOVIES ====================

  /// Stream movies live from Firestore
  Stream<List<Map<String, dynamic>>> streamMovies() {
    try {
      final db = _db;
      if (db == null) return const Stream.empty();

      return db.collection('movies').snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList();
      });
    } catch (e) {
      debugPrint('Error streaming movies: $e');
      return const Stream.empty();
    }
  }

  /// Add Movie to Firestore
  Future<void> addMovie(MovieModel movie, int categoryIndex) async {
    try {
      final db = _db;
      if (db == null) return;

      final docId = movie.id ?? 'MOV-${DateTime.now().millisecondsSinceEpoch}';

      await db.collection('movies').doc(docId).set({
        'id': docId,
        'title': movie.title,
        'poster': movie.poster,
        'rating': movie.rating ?? '8.5',
        'durations': movie.durations ?? '2.0 hr',
        'information': movie.information,
        'format': movie.format ?? 'IMAX 3D',
        'categoryIndex': categoryIndex,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error adding movie to Firestore: $e');
    }
  }

  /// Update Movie in Firestore
  Future<void> updateMovie(
    String movieTitle,
    MovieModel movie,
    int categoryIndex,
  ) async {
    try {
      final db = _db;
      if (db == null) return;

      final querySnapshot = await db
          .collection('movies')
          .where('title', isEqualTo: movieTitle)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          await doc.reference.update({
            'title': movie.title,
            'poster': movie.poster,
            'rating': movie.rating ?? '8.5',
            'durations': movie.durations ?? '2.0 hr',
            'information': movie.information,
            'format': movie.format ?? 'IMAX 3D',
            'categoryIndex': categoryIndex,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
      } else {
        await addMovie(movie, categoryIndex);
      }
    } catch (e) {
      debugPrint('Error updating movie in Firestore: $e');
    }
  }

  /// Delete Movie from Firestore
  Future<void> deleteMovie(String movieTitle) async {
    try {
      final db = _db;
      if (db == null) return;

      final querySnapshot = await db
          .collection('movies')
          .where('title', isEqualTo: movieTitle)
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      debugPrint('Error deleting movie from Firestore: $e');
    }
  }

  // ==================== BOOKINGS ====================

  /// Stream Bookings live from Firestore
  Stream<List<BookingModel>> streamBookings() {
    try {
      final db = _db;
      if (db == null) return const Stream.empty();

      return db.collection('bookings').snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          DateTime createdDate;
          try {
            if (data['createdAt'] is Timestamp) {
              createdDate = (data['createdAt'] as Timestamp).toDate();
            } else if (data['createdAt'] is String) {
              createdDate = DateTime.parse(data['createdAt']);
            } else {
              createdDate = DateTime.now();
            }
          } catch (_) {
            createdDate = DateTime.now();
          }

          return BookingModel(
            id: doc.id,
            customerName: data['customerName'] ?? 'Counter Customer',
            customerPhone: data['customerPhone'] ?? '',
            movieTitle: data['movieTitle'] ?? 'Movie',
            date: data['date'] ?? 'Today',
            time: data['time'] ?? '12:00 PM',
            seats: List<String>.from(data['seats'] ?? []),
            totalPrice: (data['totalPrice'] ?? 0).toDouble(),
            status: data['status'] ?? 'Confirmed',
            paymentMethod: data['paymentMethod'] ?? 'Cash',
            createdAt: createdDate,
          );
        }).toList();
      });
    } catch (e) {
      debugPrint('Error streaming bookings: $e');
      return const Stream.empty();
    }
  }

  /// Save Booking to Firestore
  Future<void> saveBooking(BookingModel booking) async {
    try {
      final db = _db;
      if (db == null) return;

      await db.collection('bookings').doc(booking.id).set({
        'id': booking.id,
        'customerName': booking.customerName,
        'customerPhone': booking.customerPhone,
        'movieTitle': booking.movieTitle,
        'date': booking.date,
        'time': booking.time,
        'seats': booking.seats,
        'totalPrice': booking.totalPrice,
        'status': booking.status,
        'paymentMethod': booking.paymentMethod,
        'createdAt': booking.createdAt.toIso8601String(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error saving booking to Firestore: $e');
    }
  }

  /// Update Booking Status in Firestore
  Future<void> updateBookingStatus(String bookingId, String newStatus) async {
    try {
      final db = _db;
      if (db == null) return;

      await db.collection('bookings').doc(bookingId).update({
        'status': newStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error updating booking status: $e');
    }
  }

  /// Delete Booking from Firestore
  Future<void> deleteBooking(String bookingId) async {
    try {
      final db = _db;
      if (db == null) return;

      await db.collection('bookings').doc(bookingId).delete();
    } catch (e) {
      debugPrint('Error deleting booking: $e');
    }
  }

  // ==================== CINEMA ADMINS ====================

  /// Stream Cinema Admins live from Firestore
  Stream<List<CinemaAdminModel>> streamCinemaAdmins() {
    try {
      final db = _db;
      if (db == null) return const Stream.empty();

      return db.collection('cinema_admins').snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          return CinemaAdminModel(
            id: doc.id,
            name: data['name'] ?? '',
            email: data['email'] ?? '',
            assignedLocation: data['assignedLocation'] ?? 'All Cinema Screens',
            isActive: data['isActive'] ?? true,
            createdDate: data['createdDate'] ?? 'Today',
          );
        }).toList();
      });
    } catch (e) {
      debugPrint('Error streaming cinema admins: $e');
      return const Stream.empty();
    }
  }

  /// Save Cinema Admin to Firestore
  Future<void> saveCinemaAdmin(CinemaAdminModel admin) async {
    try {
      final db = _db;
      if (db == null) return;

      await db.collection('cinema_admins').doc(admin.id).set({
        'id': admin.id,
        'name': admin.name,
        'email': admin.email,
        'assignedLocation': admin.assignedLocation,
        'isActive': admin.isActive,
        'createdDate': admin.createdDate,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error saving cinema admin: $e');
    }
  }

  /// Toggle Cinema Admin Active Status in Firestore
  Future<void> toggleCinemaAdminStatus(String adminId, bool isActive) async {
    try {
      final db = _db;
      if (db == null) return;

      await db.collection('cinema_admins').doc(adminId).update({
        'isActive': isActive,
      });
    } catch (e) {
      debugPrint('Error toggling admin status: $e');
    }
  }

  /// Delete Cinema Admin from Firestore
  Future<void> deleteCinemaAdmin(String adminId) async {
    try {
      final db = _db;
      if (db == null) return;

      await db.collection('cinema_admins').doc(adminId).delete();
    } catch (e) {
      debugPrint('Error deleting cinema admin: $e');
    }
  }

  // ==================== SHOWTIMES ====================

  /// Stream ShowTimes live from Firestore
  Stream<List<ShowTimeModel>> streamShowTimes() {
    try {
      final db = _db;
      if (db == null) return const Stream.empty();

      return db.collection('showtimes').snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          return ShowTimeModel(
            time: data['time'] ?? '12:00 PM',
            price: data['price']?.toString() ?? '500',
            screen: data['screen'] ?? 'Audi 1',
            format: data['format'] ?? '2D',
            isAvailable: data['isAvailable'] ?? true,
          );
        }).toList();
      });
    } catch (e) {
      debugPrint('Error streaming showtimes: $e');
      return const Stream.empty();
    }
  }

  /// Save ShowTime to Firestore
  Future<void> saveShowTime(ShowTimeModel showTime) async {
    try {
      final db = _db;
      if (db == null) return;

      final docId =
          'ST-${showTime.time.replaceAll(' ', '_')}-${showTime.screen.replaceAll(' ', '_')}';

      await db.collection('showtimes').doc(docId).set({
        'time': showTime.time,
        'price': showTime.price,
        'screen': showTime.screen,
        'format': showTime.format,
        'isAvailable': showTime.isAvailable,
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error saving showtime: $e');
    }
  }
}
