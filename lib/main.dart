import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:imax_movie_ticket_booking/Provider/admin_provider.dart';
import 'package:imax_movie_ticket_booking/Provider/movie_provider.dart';
import 'package:imax_movie_ticket_booking/Provider/payment_provider.dart';
import 'package:imax_movie_ticket_booking/Provider/seat_proviede.dart';
import 'package:imax_movie_ticket_booking/Provider/show_time_provider.dart';
import 'package:imax_movie_ticket_booking/Provider/super_admin_provider.dart';
import 'package:imax_movie_ticket_booking/PublicScreens/on_boarding_screen.dart';
import 'package:imax_movie_ticket_booking/firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }
    } catch (e2) {
      debugPrint('Firebase initialization warning: $e2');
    }
  }
  runApp(const ImaxMovies());
}

class ImaxMovies extends StatelessWidget {
  const ImaxMovies({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MovieProvider()),
        ChangeNotifierProvider(create: (context) => ShowTimeProvider()),
        ChangeNotifierProvider(create: (context) => SeatProvider()),
        ChangeNotifierProvider(create: (context) => PaymentProvider()),
        ChangeNotifierProvider(create: (context) => AdminProvider()),
        ChangeNotifierProvider(create: (context) => SuperAdminProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF0F0F14),
        ),
        home: const OnBoardingScreen(),
      ),
    );
  }
}
