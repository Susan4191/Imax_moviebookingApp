import 'package:flutter/material.dart';
import 'package:imax_movie_ticket_booking/BoxOfficeScreens/box_office_booking_screen.dart';
import 'package:imax_movie_ticket_booking/LoginSignAccountScreen/login_screen.dart';
import 'package:imax_movie_ticket_booking/Provider/admin_provider.dart';
import 'package:imax_movie_ticket_booking/Provider/movie_provider.dart';
import 'package:imax_movie_ticket_booking/PublicScreens/dashboard_screen.dart';
import 'package:imax_movie_ticket_booking/PublicScreens/ticket_detail_screen.dart';
import 'package:imax_movie_ticket_booking/utils/app_color.dart';
import 'package:imax_movie_ticket_booking/utils/app_text_style.dart';
import 'package:imax_movie_ticket_booking/utils/app_toast.dart';
import 'package:provider/provider.dart';

import 'admin_bookings_screen.dart';
import 'admin_movies_screen.dart';
import 'admin_showtimes_screen.dart';
import 'admin_users_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedNavIndex = 0;

  final List<String> _navTitles = [
    'Dashboard',
    'Movies',
    'Showtimes',
    'Bookings',
    'Box Office',
    'Users',
  ];

  final List<IconData> _navIcons = [
    Icons.dashboard_rounded,
    Icons.movie_rounded,
    Icons.schedule_rounded,
    Icons.confirmation_number_rounded,
    Icons.point_of_sale_rounded,
    Icons.people_alt_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktopOrTablet = screenWidth >= 850;

    final List<Widget> pages = [
      _buildDashboardHome(context),
      const AdminMoviesScreen(),
      const AdminShowtimesScreen(),
      const AdminBookingsScreen(),
      const BoxOfficeBookingScreen(),
      const AdminUsersScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,

      appBar: isDesktopOrTablet
          ? null
          : AppBar(
              backgroundColor: AppColor.cardColor,
              elevation: 0,
              centerTitle: false,
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColor.themeColor.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.movie_filter_rounded,
                      color: AppColor.themeColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'IMAX Admin',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColor.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

      drawer: isDesktopOrTablet ? null : _buildSidebarDrawer(context),

      bottomNavigationBar: isDesktopOrTablet
          ? null
          : BottomNavigationBar(
              currentIndex: _selectedNavIndex,
              onTap: (idx) {
                setState(() {
                  _selectedNavIndex = idx;
                });
              },
              backgroundColor: AppColor.cardColor,
              selectedItemColor: AppColor.themeColor,
              unselectedItemColor: AppColor.grey,
              type: BottomNavigationBarType.fixed,
              selectedLabelStyle: AppTextStyles.labelSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: AppTextStyles.labelSmall,
              items: List.generate(
                _navTitles.length,
                (index) => BottomNavigationBarItem(
                  icon: Icon(_navIcons[index]),
                  label: _navTitles[index],
                ),
              ),
            ),

      body: isDesktopOrTablet
          ? Row(
              children: [
                SizedBox(width: 250, child: _buildSidebarDrawer(context)),
                const VerticalDivider(color: AppColor.borderColor, width: 1),
                Expanded(
                  child: IndexedStack(
                    index: _selectedNavIndex,
                    children: pages,
                  ),
                ),
              ],
            )
          : IndexedStack(index: _selectedNavIndex, children: pages),
    );
  }

  Widget _buildSidebarDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: AppColor.cardColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Admin Header Profile Banner
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColor.themeColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColor.themeColor),
                        ),
                        child: const Icon(
                          Icons.local_activity_rounded,
                          color: AppColor.themeColor,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'IMAX CINEMAS',
                              style: AppTextStyles.titleMedium.copyWith(
                                color: AppColor.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                            Text(
                              'Admin Management',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColor.grey,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.surfaceColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColor.borderColor),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.verified_user,
                          color: AppColor.green,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Role: Cinema Administrator',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColor.white,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(color: AppColor.borderColor, height: 1),

            /// Navigation Menu Items
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _navTitles.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedNavIndex == index;
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColor.themeColor.withValues(alpha: 0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: isSelected
                          ? Border.all(color: AppColor.themeColor, width: 1)
                          : null,
                    ),
                    child: ListTile(
                      leading: Icon(
                        _navIcons[index],
                        color: isSelected ? AppColor.themeColor : AppColor.grey,
                      ),
                      title: Text(
                        _navTitles[index],
                        style: AppTextStyles.labelLarge.copyWith(
                          color: isSelected ? AppColor.white : AppColor.grey,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedNavIndex = index;
                        });
                        if (Navigator.canPop(context) &&
                            MediaQuery.of(context).size.width < 850) {
                          Navigator.pop(context);
                        }
                      },
                    ),
                  );
                },
              ),
            ),

            const Divider(color: AppColor.borderColor, height: 1),

            /// Bottom Action: Customer App / Logout
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.smartphone_rounded,
                      color: AppColor.blue,
                    ),
                    title: Text(
                      'Customer View',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColor.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DashboardScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.logout_rounded,
                      color: AppColor.red,
                    ),
                    title: Text(
                      'Logout Admin',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColor.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () => _confirmLogoutAdmin(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLogoutAdmin(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColor.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Logout Admin Panel',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColor.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to log out of the IMAX Admin Panel?',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColor.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: AppTextStyles.labelMedium.copyWith(color: AppColor.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AdminProvider>().logoutAdmin();
              AppToast.showInfo('Logged out of Admin Panel');
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.themeColor,
            ),
            child: Text(
              'Logout',
              style: AppTextStyles.labelMedium.copyWith(color: AppColor.white),
            ),
          ),
        ],
      ),
    );
  }

  /// Dashboard Main Content Page
  Widget _buildDashboardHome(BuildContext context) {
    final movieProvider = context.watch<MovieProvider>();
    final adminProvider = context.watch<AdminProvider>();

    final totalMovies =
        movieProvider.nowShowingMovies.length +
        movieProvider.nextReleaseMovies.length +
        movieProvider.comingSoonMovies.length;

    final recentBookings = adminProvider.bookings.take(5).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Welcome Banner Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColor.themeColor.withValues(alpha: 0.8),
                  AppColor.cardColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColor.borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.admin_panel_settings,
                      color: AppColor.white,
                      size: 28,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Welcome to IMAX Admin Panel',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.headingSmall.copyWith(
                          color: AppColor.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Manage movies, schedule showtimes, track bookings, users and box office sales.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColor.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// Stat Cards Grid (3 Key Metrics)
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 700 ? 3 : 2;
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.4,
                children: [
                  _buildStatCard(
                    title: 'Total Movies',
                    value: '$totalMovies',
                    subtitle:
                        '${movieProvider.nowShowingMovies.length} Now Showing',
                    icon: Icons.movie_rounded,
                    color: AppColor.themeColor,
                    onTap: () => setState(() => _selectedNavIndex = 1),
                  ),
                  _buildStatCard(
                    title: 'Total Bookings',
                    value: '${adminProvider.totalBookingsCount}',
                    subtitle:
                        '${adminProvider.activeBookingsCount} Active Confirmed',
                    icon: Icons.confirmation_number_rounded,
                    color: AppColor.blue,
                    onTap: () => setState(() => _selectedNavIndex = 3),
                  ),
                  _buildStatCard(
                    title: 'Registered Users',
                    value: '${adminProvider.totalUsersCount}',
                    subtitle: 'Customer Accounts',
                    icon: Icons.people_alt_rounded,
                    color: AppColor.purple,
                    onTap: () => setState(() => _selectedNavIndex = 5),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 20),

          /// Quick Actions Banner
          Text(
            'Quick Actions',
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColor.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildQuickActionButton(
                  icon: Icons.add_rounded,
                  label: 'Add Movie',
                  color: AppColor.themeColor,
                  onTap: () => setState(() => _selectedNavIndex = 1),
                ),
                _buildQuickActionButton(
                  icon: Icons.add_alarm_rounded,
                  label: 'Schedule Showtime',
                  color: AppColor.blue,
                  onTap: () => setState(() => _selectedNavIndex = 2),
                ),
                _buildQuickActionButton(
                  icon: Icons.point_of_sale_rounded,
                  label: 'Box Office Ticket',
                  color: AppColor.green,
                  onTap: () => setState(() => _selectedNavIndex = 4),
                ),
                _buildQuickActionButton(
                  icon: Icons.people_rounded,
                  label: 'Customer List',
                  color: AppColor.purple,
                  onTap: () => setState(() => _selectedNavIndex = 5),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          /// Sales Summary Visual Breakdown Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColor.cardColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColor.borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Booking Status Overview',
                      style: AppTextStyles.titleSmall.copyWith(
                        color: AppColor.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${adminProvider.totalBookingsCount} Total Transactions',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColor.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                /// Visual bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    height: 12,
                    child: Row(
                      children: [
                        Expanded(
                          flex: adminProvider.activeBookingsCount > 0
                              ? adminProvider.activeBookingsCount
                              : 1,
                          child: Container(color: AppColor.green),
                        ),
                        Expanded(
                          flex: adminProvider.cancelledBookingsCount > 0
                              ? adminProvider.cancelledBookingsCount
                              : 1,
                          child: Container(color: AppColor.red),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: AppColor.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Confirmed: ${adminProvider.activeBookingsCount}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColor.white,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: AppColor.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Cancelled: ${adminProvider.cancelledBookingsCount}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColor.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          /// Recent Bookings Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Bookings',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColor.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () => setState(() => _selectedNavIndex = 3),
                child: Text(
                  'View All',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColor.themeColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          /// Recent Bookings Table / List
          if (recentBookings.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColor.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColor.borderColor),
              ),
              child: Center(
                child: Text(
                  'No recent bookings recorded.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColor.grey,
                  ),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentBookings.length,
              itemBuilder: (context, index) {
                final booking = recentBookings[index];
                final isConfirmed = booking.status == 'Confirmed';

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColor.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColor.borderColor),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: (isConfirmed ? AppColor.green : AppColor.red)
                              .withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isConfirmed ? Icons.check : Icons.close,
                          color: isConfirmed ? AppColor.green : AppColor.red,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking.customerName,
                              style: AppTextStyles.titleSmall.copyWith(
                                color: AppColor.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${booking.movieTitle}  •  Seats: ${booking.seats.join(', ')}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColor.grey,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'NPR ${booking.totalPrice.toInt()}',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: AppColor.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            booking.time,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColor.grey,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),

                      IconButton(
                        icon: const Icon(
                          Icons.chevron_right,
                          color: AppColor.grey,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TicketDetailScreen(
                                movieName: booking.movieTitle,
                                moviePoster: '',
                                date: booking.date,
                                time: booking.time,
                                selectedSeats: booking.seats,
                                totalAmount: booking.totalPrice,
                                ticketId: booking.id,
                                isBoxOffice: true,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColor.cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColor.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColor.grey.withValues(alpha: 0.5),
                  size: 12,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: AppTextStyles.headingSmall.copyWith(
                    color: AppColor.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  title,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColor.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColor.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColor.borderColor),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 16),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColor.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
