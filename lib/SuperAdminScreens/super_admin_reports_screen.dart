import 'package:flutter/material.dart';
import 'package:imax_movie_ticket_booking/Provider/super_admin_provider.dart';
import 'package:imax_movie_ticket_booking/utils/app_color.dart';
import 'package:imax_movie_ticket_booking/utils/app_text_style.dart';
import 'package:provider/provider.dart';

class SuperAdminReportsScreen extends StatefulWidget {
  const SuperAdminReportsScreen({super.key});

  @override
  State<SuperAdminReportsScreen> createState() =>
      _SuperAdminReportsScreenState();
}

class _SuperAdminReportsScreenState extends State<SuperAdminReportsScreen> {
  String _selectedReportPeriod = 'Weekly';

  @override
  Widget build(BuildContext context) {
    final superAdminProvider = context.watch<SuperAdminProvider>();

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header & Period Selector
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reports & Analytics',
                          style: AppTextStyles.headingMedium.copyWith(
                            color: AppColor.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Comprehensive revenue breakdown, movie popularity, and booking trends',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColor.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  DropdownButton<String>(
                    value: _selectedReportPeriod,
                    dropdownColor: AppColor.cardColor,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColor.white,
                    ),
                    underline: Container(),
                    icon: const Icon(
                      Icons.calendar_today_rounded,
                      color: AppColor.themeColor,
                      size: 16,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Daily',
                        child: Text('Daily Report'),
                      ),
                      DropdownMenuItem(
                        value: 'Weekly',
                        child: Text('Weekly Report'),
                      ),
                      DropdownMenuItem(
                        value: 'Monthly',
                        child: Text('Monthly Report'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedReportPeriod = val;
                        });
                      }
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// Revenue Cards Grid
              Row(
                children: [
                  Expanded(
                    child: _buildReportMetricCard(
                      title: 'Daily Revenue',
                      amount: 'NPR ${superAdminProvider.dailyRevenue.toInt()}',
                      subtitle: '24-Hour Sales',
                      icon: Icons.today_rounded,
                      color: AppColor.blue,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildReportMetricCard(
                      title: 'Weekly Revenue',
                      amount: 'NPR ${superAdminProvider.weeklyRevenue.toInt()}',
                      subtitle: 'Last 7 Days',
                      icon: Icons.date_range_rounded,
                      color: AppColor.themeColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildReportMetricCard(
                      title: 'Monthly Revenue',
                      amount:
                          'NPR ${superAdminProvider.monthlyRevenue.toInt()}',
                      subtitle: 'Current Month Total',
                      icon: Icons.calendar_month_rounded,
                      color: AppColor.green,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// Bar Chart Trend Visualizer Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColor.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColor.borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Revenue Trend ($_selectedReportPeriod)',
                          style: AppTextStyles.titleMedium.copyWith(
                            color: AppColor.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.green.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppColor.green),
                          ),
                          child: Text(
                            '+18.5% Growth',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColor.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    /// Custom Bar Chart
                    SizedBox(
                      height: 160,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildChartBar('Mon', 0.45, 'NPR 1.2k'),
                          _buildChartBar('Tue', 0.60, 'NPR 1.8k'),
                          _buildChartBar('Wed', 0.35, 'NPR 900'),
                          _buildChartBar('Thu', 0.70, 'NPR 2.1k'),
                          _buildChartBar('Fri', 0.95, 'NPR 3.4k'),
                          _buildChartBar('Sat', 1.00, 'NPR 4.0k'),
                          _buildChartBar('Sun', 0.85, 'NPR 2.9k'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// Top Performing Movies & Booking Breakdown Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Most Booked Movies
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColor.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColor.borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Most-Booked Movies',
                            style: AppTextStyles.titleSmall.copyWith(
                              color: AppColor.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),

                          _buildMovieRankRow(
                            '1. Spider-Man Brand New Day',
                            '128 Bookings',
                            'NPR 82,400',
                            AppColor.themeColor,
                          ),
                          const Divider(color: AppColor.borderColor),
                          _buildMovieRankRow(
                            '2. Dune: Part Two',
                            '94 Bookings',
                            'NPR 65,800',
                            AppColor.blue,
                          ),
                          const Divider(color: AppColor.borderColor),
                          _buildMovieRankRow(
                            '3. Obsession',
                            '62 Bookings',
                            'NPR 41,200',
                            AppColor.purple,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  /// Booking Status Breakdown
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColor.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColor.borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Booking Status Breakdown',
                            style: AppTextStyles.titleSmall.copyWith(
                              color: AppColor.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Confirmed Tickets',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColor.white,
                                ),
                              ),
                              Text(
                                '${superAdminProvider.confirmedBookingsCount} (${(superAdminProvider.confirmedBookingsCount * 100 / (superAdminProvider.totalBookingsCount > 0 ? superAdminProvider.totalBookingsCount : 1)).toInt()}%)',
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: AppColor.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          LinearProgressIndicator(
                            value:
                                superAdminProvider.confirmedBookingsCount /
                                (superAdminProvider.totalBookingsCount > 0
                                    ? superAdminProvider.totalBookingsCount
                                    : 1),
                            backgroundColor: AppColor.borderColor,
                            color: AppColor.green,
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(4),
                          ),

                          const SizedBox(height: 16),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Cancelled Requests',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColor.white,
                                ),
                              ),
                              Text(
                                '${superAdminProvider.cancelledBookingsCount} (${(superAdminProvider.cancelledBookingsCount * 100 / (superAdminProvider.totalBookingsCount > 0 ? superAdminProvider.totalBookingsCount : 1)).toInt()}%)',
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: AppColor.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          LinearProgressIndicator(
                            value:
                                superAdminProvider.cancelledBookingsCount /
                                (superAdminProvider.totalBookingsCount > 0
                                    ? superAdminProvider.totalBookingsCount
                                    : 1),
                            backgroundColor: AppColor.borderColor,
                            color: AppColor.red,
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportMetricCard({
    required String title,
    required String amount,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColor.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColor.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              amount,
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColor.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColor.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            subtitle,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColor.grey,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartBar(String dayLabel, double heightRatio, String amount) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          amount,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColor.grey,
            fontSize: 9,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 24,
          height: 100 * heightRatio,
          decoration: BoxDecoration(
            color: AppColor.themeColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          dayLabel,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColor.white,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildMovieRankRow(
    String title,
    String bookings,
    String revenue,
    Color tagColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.labelMedium.copyWith(color: AppColor.white),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                revenue,
                style: AppTextStyles.labelMedium.copyWith(
                  color: tagColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                bookings,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColor.grey,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
