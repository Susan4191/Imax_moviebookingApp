import 'package:flutter/material.dart';
import '../utils/app_color.dart';
import '../utils/app_text_style.dart';
import '../utils/app_toast.dart';

class TicketDetailScreen extends StatelessWidget {
  const TicketDetailScreen({
    super.key,
    required this.movieName,
    required this.moviePoster,
    required this.date,
    required this.time,
    this.format = 'IMAX 2D',
    this.screen = 'Screen 1',
    required this.selectedSeats,
    required this.totalAmount,
    this.ticketId = 'IMAX-892014',
    this.isBoxOffice = false,
  });

  final String movieName;
  final String moviePoster;
  final String date;
  final String time;
  final String format;
  final String screen;
  final List<String> selectedSeats;
  final double totalAmount;
  final String ticketId;
  final bool isBoxOffice;

  @override
  Widget build(BuildContext context) {
    final ticketCount = selectedSeats.length;
    final seatsStr = selectedSeats.isEmpty
        ? 'E5, E6'
        : selectedSeats.join(', ');
    final formattedAmount = totalAmount.toInt().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColor.white),
        ),
        centerTitle: true,
        title: Image.asset('assets/images/logo_logo.png', scale: 10),
        actions: [
          IconButton(
            onPressed: () =>
                isBoxOffice ? _printTicket(context) : _downloadTicket(context),
            icon: Icon(
              isBoxOffice ? Icons.print_rounded : Icons.download_rounded,
              color: AppColor.white,
            ),
            tooltip: isBoxOffice ? 'Print Ticket' : 'Download Ticket',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ticket Details',
                style: AppTextStyles.headingMedium.copyWith(
                  color: AppColor.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              /// Ticket Card Container
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColor.borderColor, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    /// Top Section: Poster & Movie Details
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Poster Image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: _buildPosterWidget(moviePoster),
                              ),
                              const SizedBox(width: 16),

                              /// Movie Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /// Movie Format / Type Tag (2D, 3D, IMAX)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColor.red.withValues(
                                          alpha: 0.15,
                                        ),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: AppColor.red.withValues(
                                            alpha: 0.5,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        format,
                                        style: AppTextStyles.labelSmall
                                            .copyWith(
                                              color: AppColor.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),

                                    Text(
                                      movieName,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.titleLarge.copyWith(
                                        color: AppColor.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),

                                    Text(
                                      'Order ID: #$ticketId',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColor.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          const Divider(color: AppColor.borderColor, height: 1),
                          const SizedBox(height: 20),

                          /// Details Grid
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _TicketDetailColumn(label: 'DATE', value: date),
                              _TicketDetailColumn(label: 'TIME', value: time),
                            ],
                          ),
                          const SizedBox(height: 16),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _TicketDetailColumn(
                                label: 'MOVIE TYPE & SCREEN',
                                value: '$format • $screen',
                              ),
                              _TicketDetailColumn(
                                label: 'SEATS ($ticketCount)',
                                value: seatsStr,
                                isHighlight: true,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const _TicketDetailColumn(
                                label: 'LOCATION',
                                value: 'IMAX Cinema, Center',
                              ),
                              _TicketDetailColumn(
                                label: 'PRICE PAID',
                                value: 'NPR $formattedAmount',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    /// Semi-circle cutouts & Dashed Divider Line
                    Row(
                      children: [
                        Container(
                          width: 16,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: AppColor.backgroundColor,
                            borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(16),
                            ),
                          ),
                        ),
                        Expanded(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final count = (constraints.maxWidth / 10).floor();
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: List.generate(
                                  count,
                                  (_) => Container(
                                    width: 5,
                                    height: 1.5,
                                    color: AppColor.borderColor,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          width: 16,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: AppColor.backgroundColor,
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(16),
                            ),
                          ),
                        ),
                      ],
                    ),

                    /// Bottom Stub Section: QR Code & Verification
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          /// Mock QR / Barcode container
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.qr_code_2_rounded,
                                  size: 110,
                                  color: Colors.black,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  ticketId,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),

                          Text(
                            'Scan this QR code at the entrance hall',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColor.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              /// Action Buttons
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => isBoxOffice
                      ? _printTicket(context)
                      : _downloadTicket(context),
                  icon: Icon(
                    isBoxOffice
                        ? Icons.print_outlined
                        : Icons.file_download_outlined,
                    color: AppColor.white,
                  ),
                  label: Text(
                    isBoxOffice ? 'Print Ticket' : 'Download Ticket',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColor.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: AppColor.borderColor,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Back to Home',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColor.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _downloadTicket(BuildContext context) {
    AppToast.showSuccess('Downloading Ticket #$ticketId...');
  }

  void _printTicket(BuildContext context) {
    AppToast.showSuccess('Printing Ticket #$ticketId...');
  }

  Widget _buildPosterWidget(String posterPath) {
    if (posterPath.isEmpty) {
      return Container(
        width: 85,
        height: 120,
        color: AppColor.surfaceColor,
        child: const Icon(Icons.movie, color: AppColor.red, size: 40),
      );
    }

    if (posterPath.startsWith('http://') || posterPath.startsWith('https://')) {
      return Image.network(
        posterPath,
        width: 85,
        height: 120,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: 85,
          height: 120,
          color: AppColor.surfaceColor,
          child: const Icon(Icons.movie, color: AppColor.red, size: 40),
        ),
      );
    }

    return Image.asset(
      posterPath,
      width: 85,
      height: 120,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        width: 85,
        height: 120,
        color: AppColor.surfaceColor,
        child: const Icon(Icons.movie, color: AppColor.red, size: 40),
      ),
    );
  }
}

class _TicketDetailColumn extends StatelessWidget {
  const _TicketDetailColumn({
    required this.label,
    required this.value,
    this.isHighlight = false,
  });

  final String label;
  final String value;
  final bool isHighlight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColor.textMuted,
            letterSpacing: 1,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isHighlight ? AppColor.red : AppColor.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
