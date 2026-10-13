import 'package:flutter/material.dart';
import 'package:imax_movie_ticket_booking/LoginSignAccountScreen/login_screen.dart';
import 'package:imax_movie_ticket_booking/Model/booking_model.dart';
import 'package:imax_movie_ticket_booking/Model/movie_model.dart';
import 'package:imax_movie_ticket_booking/Model/seat_model.dart';
import 'package:imax_movie_ticket_booking/Model/show_time_model.dart';
import 'package:imax_movie_ticket_booking/Provider/admin_provider.dart';
import 'package:imax_movie_ticket_booking/Provider/movie_provider.dart';
import 'package:imax_movie_ticket_booking/Provider/seat_proviede.dart';
import 'package:imax_movie_ticket_booking/Provider/show_time_provider.dart';
import 'package:imax_movie_ticket_booking/PublicScreens/ticket_detail_screen.dart';
import 'package:imax_movie_ticket_booking/Services/firebase_app_auth.dart';
import 'package:imax_movie_ticket_booking/Widgets/seat_item_widget.dart';
import 'package:imax_movie_ticket_booking/Widgets/seat_legend_widget.dart';
import 'package:imax_movie_ticket_booking/utils/app_color.dart';
import 'package:imax_movie_ticket_booking/utils/app_text_style.dart';
import 'package:imax_movie_ticket_booking/utils/app_toast.dart';
import 'package:provider/provider.dart';

class BoxOfficeBookingScreen extends StatefulWidget {
  const BoxOfficeBookingScreen({super.key});

  @override
  State<BoxOfficeBookingScreen> createState() => _BoxOfficeBookingScreenState();
}

class _BoxOfficeBookingScreenState extends State<BoxOfficeBookingScreen> {
  MovieModel? _selectedMovie;
  ShowTimeModel? _selectedShowTime;
  String _selectedFormat = 'IMAX 3D';
  String _selectedScreen = 'Audi 1';
  final String _selectedDate = 'Today, 17 May';
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _customerPhoneController =
      TextEditingController();

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = context.watch<MovieProvider>();
    final seatProvider = context.watch<SeatProvider>();
    final showTimeProvider = context.watch<ShowTimeProvider>();

    final nowShowingMovies = movieProvider.nowShowingMovies;
    final showTimes = showTimeProvider.selectDateTime;

    if (_selectedMovie == null && nowShowingMovies.isNotEmpty) {
      _selectedMovie = nowShowingMovies.first;
    }

    if (_selectedShowTime == null && showTimes.isNotEmpty) {
      _selectedShowTime = showTimes.first;
      _selectedFormat = _selectedShowTime!.format;
      _selectedScreen = _selectedShowTime!.screen;
    }

    if (_selectedMovie != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<SeatProvider>().setMovieAndShowtime(
          movieName: _selectedMovie!.title,
          time: _selectedShowTime?.time ?? '01:45 PM',
          date: _selectedDate,
        );
      });
    }

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColor,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Box Office Booking',
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColor.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Counter Booking & Ticket Printing',
              style: AppTextStyles.bodySmall.copyWith(color: AppColor.grey),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColor.green.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColor.green),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.point_of_sale,
                  color: AppColor.green,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  'Box Office',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColor.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: AppColor.red),
            tooltip: 'Logout',
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: AppColor.cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: Text(
                    'Logout Box Office',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColor.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: Text(
                    'Are you sure you want to log out?',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColor.textSecondary,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text(
                        'Cancel',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColor.grey,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(ctx);
                        await FirebaseAuthService().signOut();
                        AppToast.showInfo('Logged out of Box Office counter');
                        if (context.mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                            (route) => false,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.themeColor,
                      ),
                      child: Text(
                        'Logout',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColor.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Now Showing Movies Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Now Showing Movies (${nowShowingMovies.length})',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColor.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Select a Movie',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColor.themeColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              /// Horizontal Movie Cards
              SizedBox(
                height: 170,
                child: nowShowingMovies.isEmpty
                    ? Center(
                        child: Text(
                          'No Now Showing movies available.',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColor.grey,
                          ),
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: nowShowingMovies.length,
                        itemBuilder: (context, index) {
                          final movie = nowShowingMovies[index];
                          final isSelected =
                              _selectedMovie?.title == movie.title;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedMovie = movie;
                              });
                              context.read<SeatProvider>().setMovieAndShowtime(
                                movieName: movie.title,
                                time: _selectedShowTime?.time ?? '01:45 PM',
                                date: _selectedDate,
                              );
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 110,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                color: AppColor.cardColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColor.themeColor
                                      : AppColor.borderColor,
                                  width: isSelected ? 2.5 : 1.0,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: AppColor.themeColor.withValues(
                                            alpha: 0.3,
                                          ),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                    : [],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(10),
                                      ),
                                      child: Stack(
                                        children: [
                                          Positioned.fill(
                                            child: _buildMoviePoster(
                                              movie.poster,
                                            ),
                                          ),
                                          if (isSelected)
                                            Positioned(
                                              top: 6,
                                              right: 6,
                                              child: Container(
                                                padding: const EdgeInsets.all(
                                                  2,
                                                ),
                                                decoration: const BoxDecoration(
                                                  color: AppColor.themeColor,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.check,
                                                  color: AppColor.white,
                                                  size: 14,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          movie.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppTextStyles.labelMedium
                                              .copyWith(
                                                color: AppColor.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          movie.information,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppTextStyles.bodySmall
                                              .copyWith(
                                                color: AppColor.grey,
                                                fontSize: 10,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),

              const SizedBox(height: 20),

              /// Selected Movie Banner Summary
              if (_selectedMovie != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColor.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColor.borderColor),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _buildMoviePoster(
                          _selectedMovie!.poster,
                          width: 50,
                          height: 70,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Selected: ${_selectedMovie!.title}',
                              style: AppTextStyles.titleMedium.copyWith(
                                color: AppColor.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _selectedMovie!.information,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColor.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                if (_selectedMovie!.rating != null) ...[
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    _selectedMovie!.rating!,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColor.white,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                ],
                                if (_selectedMovie!.durations != null) ...[
                                  const Icon(
                                    Icons.access_time,
                                    color: AppColor.grey,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    _selectedMovie!.durations!,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColor.grey,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              /// Select Showtime (Auto selects Format & Screen / Audi)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Showtime',
                    style: AppTextStyles.titleSmall.copyWith(
                      color: AppColor.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Auto-assigns Format & Audi',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColor.grey,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              /// Showtime Selection Grid (Like Public Screen)
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 500;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: showTimes.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isWide ? 6 : 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: isWide ? 1.8 : 1.45,
                    ),
                    itemBuilder: (context, index) {
                      final showTime = showTimes[index];
                      final isSelected =
                          _selectedShowTime?.time == showTime.time;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedShowTime = showTime;
                            _selectedFormat = showTime.format;
                            _selectedScreen = showTime.screen;
                          });
                          if (_selectedMovie != null) {
                            context.read<SeatProvider>().setMovieAndShowtime(
                              movieName: _selectedMovie!.title,
                              time: showTime.time,
                              date: _selectedDate,
                            );
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColor.themeColor.withValues(alpha: 0.25)
                                : AppColor.cardColor,
                            border: Border.all(
                              color: isSelected
                                  ? AppColor.themeColor
                                  : AppColor.borderColor,
                              width: isSelected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                showTime.time,
                                style: AppTextStyles.titleSmall.copyWith(
                                  color: AppColor.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColor.themeColor.withValues(
                                        alpha: 0.2,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      showTime.screen,
                                      style: AppTextStyles.labelSmall.copyWith(
                                        color: AppColor.themeColor,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    showTime.format,
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: AppColor.blue,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 16),

              /// Auto-Selected Details Info Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColor.cardColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColor.borderColor),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: AppColor.green,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Showtime: ${_selectedShowTime?.time ?? "N/A"}  •  Format: $_selectedFormat  •  Hall: $_selectedScreen',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColor.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              /// Customer Information
              Text(
                'Customer Details (Optional)',
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColor.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _customerNameController,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColor.white,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Customer Name',
                        hintStyle: AppTextStyles.bodySmall.copyWith(
                          color: AppColor.grey,
                        ),
                        filled: true,
                        fillColor: AppColor.cardColor,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColor.borderColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColor.themeColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _customerPhoneController,
                      keyboardType: TextInputType.phone,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColor.white,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Phone Number',
                        hintStyle: AppTextStyles.bodySmall.copyWith(
                          color: AppColor.grey,
                        ),
                        filled: true,
                        fillColor: AppColor.cardColor,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColor.borderColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColor.themeColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// Seat Selection Legend & Arc
              const SeatLegendWidget(),
              const SizedBox(height: 16),

              Center(
                child: Container(
                  width: double.infinity,
                  height: 18,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: AppColor.themeColor.withValues(alpha: 0.3),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(50),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${_selectedScreen.toUpperCase()} ($_selectedFormat)',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColor.white,
                        letterSpacing: 2,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// Seat Layout Grid
              Column(
                children: seatProvider.rows.map((row) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          child: Text(
                            row,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColor.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Row(
                          children: List.generate(SeatProvider.seatsPerRow, (
                            index,
                          ) {
                            final seatNumber = '$row${index + 1}';
                            final seatType = seatProvider.getSeatType(
                              seatNumber,
                            );

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 2,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  final error = seatProvider.toggleSeat(
                                    seatNumber,
                                  );
                                  if (error != null) {
                                    AppToast.showError(error);
                                  }
                                },
                                child: SeatShapeContainer(
                                  seatType: seatType,
                                  displayText: seatType == SeatType.booked
                                      ? 'X'
                                      : '${index + 1}',
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              /// Booking Summary & Issue Ticket Button
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColor.cardColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColor.borderColor),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Selected Seats (${seatProvider.selectedSeats.length})',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColor.grey,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              seatProvider.selectedSeats.isEmpty
                                  ? 'None Selected'
                                  : seatProvider.selectedSeats.join(', '),
                              style: AppTextStyles.titleSmall.copyWith(
                                color: AppColor.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Total Amount',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColor.grey,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'NPR ${seatProvider.grandTotal.toStringAsFixed(0)}',
                              style: AppTextStyles.titleLarge.copyWith(
                                color: AppColor.themeColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed:
                            seatProvider.selectedSeats.isEmpty ||
                                _selectedMovie == null
                            ? null
                            : () {
                                final seats = List<String>.from(
                                  seatProvider.selectedSeats,
                                );
                                final total = seatProvider.grandTotal;
                                final movieTitle = _selectedMovie!.title;
                                final poster = _selectedMovie!.poster;
                                final customerName = _customerNameController
                                    .text
                                    .trim();
                                final customerPhone = _customerPhoneController
                                    .text
                                    .trim();
                                final ticketId =
                                    'BOX-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

                                context.read<AdminProvider>().addBooking(
                                  BookingModel(
                                    id: ticketId,
                                    customerName: customerName.isEmpty
                                        ? 'Counter Customer'
                                        : customerName,
                                    customerPhone: customerPhone,
                                    movieTitle: movieTitle,
                                    date: _selectedDate,
                                    time: _selectedShowTime?.time ?? '01:45 PM',
                                    seats: seats,
                                    totalPrice: total,
                                    status: 'Confirmed',
                                    paymentMethod: 'Cash',
                                    createdAt: DateTime.now(),
                                  ),
                                );

                                seatProvider.confirmBooking();

                                AppToast.showSuccess(
                                  'Box Office Ticket Booked Successfully!',
                                );

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TicketDetailScreen(
                                      movieName: movieTitle,
                                      moviePoster: poster,
                                      date: _selectedDate,
                                      time:
                                          _selectedShowTime?.time ?? '01:45 PM',
                                      format: _selectedFormat,
                                      screen: _selectedScreen,
                                      selectedSeats: seats,
                                      totalAmount: total,
                                      ticketId: ticketId,
                                      isBoxOffice: true,
                                    ),
                                  ),
                                );
                              },
                        icon: const Icon(
                          Icons.print_outlined,
                          color: AppColor.white,
                        ),
                        label: Text(
                          'Confirm & Print Ticket',
                          style: AppTextStyles.titleMedium.copyWith(
                            color: AppColor.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.themeColor,
                          disabledBackgroundColor: AppColor.borderColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoviePoster(
    String posterPath, {
    double width = double.infinity,
    double height = double.infinity,
  }) {
    if (posterPath.isEmpty) {
      return Container(
        width: width,
        height: height,
        color: AppColor.surfaceColor,
        child: const Icon(Icons.movie, color: AppColor.red, size: 24),
      );
    }

    if (posterPath.startsWith('http://') || posterPath.startsWith('https://')) {
      return Image.network(
        posterPath,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: width,
          height: height,
          color: AppColor.surfaceColor,
          child: const Icon(Icons.movie, color: AppColor.red, size: 24),
        ),
      );
    }

    return Image.asset(
      posterPath,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        width: width,
        height: height,
        color: AppColor.surfaceColor,
        child: const Icon(Icons.movie, color: AppColor.red, size: 24),
      ),
    );
  }
}
