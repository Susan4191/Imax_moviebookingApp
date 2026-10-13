import 'package:flutter/material.dart';
import 'package:imax_movie_ticket_booking/LoginSignAccountScreen/login_screen.dart';
import 'package:imax_movie_ticket_booking/Provider/movie_provider.dart';
import 'package:imax_movie_ticket_booking/Provider/super_admin_provider.dart';
import 'package:imax_movie_ticket_booking/PublicScreens/ticket_detail_screen.dart';
import 'package:imax_movie_ticket_booking/utils/app_color.dart';
import 'package:imax_movie_ticket_booking/utils/app_text_style.dart';
import 'package:imax_movie_ticket_booking/utils/app_toast.dart';
import 'package:provider/provider.dart';

import 'super_admin_bookings_screen.dart';
import 'super_admin_cinema_admins_screen.dart';
import 'super_admin_customers_screen.dart';
import 'super_admin_movies_screen.dart';
import 'super_admin_reports_screen.dart';
import 'super_admin_settings_screen.dart';
import 'super_admin_showtimes_screen.dart';

class SuperAdminDashboardScreen extends StatefulWidget {
  const SuperAdminDashboardScreen({super.key});

  @override
  State<SuperAdminDashboardScreen> createState() =>
      _SuperAdminDashboardScreenState();
}

class _SuperAdminDashboardScreenState extends State<SuperAdminDashboardScreen> {
  int _selectedNavIndex = 0;

  final List<String> _navTitles = [
    'Dashboard',
    'Movies',
    'Showtimes',
    'Cinema Admins',
    'Bookings',
    'Customers',
    'Reports',
    'Settings',
  ];

  final List<IconData> _navIcons = [
    Icons.dashboard_rounded,
    Icons.movie_rounded,
    Icons.schedule_rounded,
    Icons.admin_panel_settings_rounded,
    Icons.confirmation_number_rounded,
    Icons.people_alt_rounded,
    Icons.analytics_rounded,
    Icons.settings_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktopOrTablet = screenWidth >= 900;

    final List<Widget> pages = [
      _buildDashboardHome(context),
      const SuperAdminMoviesScreen(),
      const SuperAdminShowtimesScreen(),
      const SuperAdminCinemaAdminsScreen(),
      const SuperAdminBookingsScreen(),
      const SuperAdminCustomersScreen(),
      const SuperAdminReportsScreen(),
      const SuperAdminSettingsScreen(),
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
                      Icons.star_rounded,
                      color: AppColor.themeColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'IMAX Super Admin',
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColor.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

      drawer: isDesktopOrTablet ? null : _buildSidebarDrawer(context),

      bottomNavigationBar: isDesktopOrTablet
          ? null
          : BottomNavigationBar(
              currentIndex: _selectedNavIndex >= _navTitles.length
                  ? 0
                  : _selectedNavIndex,
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
                fontSize: 10,
              ),
              unselectedLabelStyle: AppTextStyles.labelSmall.copyWith(
                fontSize: 10,
              ),
              items: List.generate(
                5, // Show first 5 items on bottom bar for mobile
                (index) => BottomNavigationBarItem(
                  icon: Icon(_navIcons[index], size: 20),
                  label: _navTitles[index],
                ),
              ),
            ),

      body: isDesktopOrTablet
          ? Row(
              children: [
                SizedBox(width: 260, child: _buildSidebarDrawer(context)),
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
    final superAdminProvider = context.watch<SuperAdminProvider>();

    return Drawer(
      backgroundColor: AppColor.cardColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Super Admin Profile Banner
            Padding(
              padding: const EdgeInsets.all(18.0),
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
                          Icons.security_rounded,
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
                              'SUPER ADMIN',
                              style: AppTextStyles.titleSmall.copyWith(
                                color: AppColor.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            Text(
                              'System Control',
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
                  const SizedBox(height: 14),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.surfaceColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColor.borderColor),
                    ),
                    child: Text(
                      'Logged in as: ${superAdminProvider.superAdminName}',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColor.white,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(color: AppColor.borderColor, height: 1),

            /// Navigation Menu Items (1 - 8)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 6),
                itemCount: _navTitles.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedNavIndex == index;
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 2,
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
                      dense: true,
                      leading: Icon(
                        _navIcons[index],
                        color: isSelected ? AppColor.themeColor : AppColor.grey,
                        size: 20,
                      ),
                      title: Text(
                        _navTitles[index],
                        style: AppTextStyles.labelMedium.copyWith(
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
                            MediaQuery.of(context).size.width < 900) {
                          Navigator.pop(context);
                        }
                      },
                    ),
                  );
                },
              ),
            ),

            const Divider(color: AppColor.borderColor, height: 1),

            /// Bottom Action: 9. Logout Super Admin
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListTile(
                dense: true,
                leading: const Icon(
                  Icons.logout_rounded,
                  color: AppColor.red,
                  size: 20,
                ),
                title: Text(
                  'Logout Super Admin',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColor.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () => _confirmLogoutSuperAdmin(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLogoutSuperAdmin(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColor.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Logout Super Admin',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColor.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to end the Super Admin session?',
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
              context.read<SuperAdminProvider>().logoutSuperAdmin();
              AppToast.showInfo('Logged out of Super Admin Panel');
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

  /// Dashboard Home Main Content
  Widget _buildDashboardHome(BuildContext context) {
    final movieProvider = context.watch<MovieProvider>();
    final superAdminProvider = context.watch<SuperAdminProvider>();

    final totalMovies =
        movieProvider.nowShowingMovies.length +
        movieProvider.nextReleaseMovies.length +
        movieProvider.comingSoonMovies.length;

    final recentBookings = superAdminProvider.allBookings.take(5).toList();
    final recentlyAddedMovies = movieProvider.nowShowingMovies.take(4).toList();

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
                  AppColor.themeColor.withValues(alpha: 0.9),
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
                      Icons.stars_rounded,
                      color: AppColor.white,
                      size: 28,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'IMAX Super Admin Dashboard',
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
                  'Highest access privileges: Overseeing cinema administrators, catalog, customers, and revenues.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColor.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// Stat Cards Grid (4 Key Super Admin Metrics)
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 800 ? 4 : 2;
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.35,
                children: [
                  _buildStatCard(
                    title: 'Total Movies',
                    value: '$totalMovies',
                    subtitle: 'Global Catalog',
                    icon: Icons.movie_rounded,
                    color: AppColor.themeColor,
                    onTap: () => setState(() => _selectedNavIndex = 1),
                  ),
                  _buildStatCard(
                    title: 'Customers',
                    value:
                        '${superAdminProvider.totalRegisteredCustomersCount}',
                    subtitle: 'Registered Accounts',
                    icon: Icons.people_alt_rounded,
                    color: AppColor.purple,
                    onTap: () => setState(() => _selectedNavIndex = 5),
                  ),
                  _buildStatCard(
                    title: 'Cinema Admins',
                    value: '${superAdminProvider.totalCinemaAdminsCount}',
                    subtitle: 'Hall Managers',
                    icon: Icons.admin_panel_settings_rounded,
                    color: AppColor.blue,
                    onTap: () => setState(() => _selectedNavIndex = 3),
                  ),
                  _buildStatCard(
                    title: 'Total Bookings',
                    value: '${superAdminProvider.totalBookingsCount}',
                    subtitle: 'All Halls Combined',
                    icon: Icons.confirmation_number_rounded,
                    color: AppColor.orange,
                    onTap: () => setState(() => _selectedNavIndex = 4),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 20),

          /// Quick Action Shortcuts
          Text(
            'Super Admin Shortcuts',
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
                  icon: Icons.person_add_alt_1_rounded,
                  label: 'Create Cinema Admin',
                  color: AppColor.blue,
                  onTap: () => setState(() => _selectedNavIndex = 3),
                ),
                _buildQuickActionButton(
                  icon: Icons.receipt_long_rounded,
                  label: 'View All Bookings',
                  color: AppColor.orange,
                  onTap: () => setState(() => _selectedNavIndex = 4),
                ),
                _buildQuickActionButton(
                  icon: Icons.movie_filter_rounded,
                  label: 'Manage Movies',
                  color: AppColor.purple,
                  onTap: () => setState(() => _selectedNavIndex = 1),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          /// Weekly Booking Trend Chart Card
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
                    Expanded(
                      child: Text(
                        'Weekly Booking & Ticket Sales Trend',
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.titleSmall.copyWith(
                          color: AppColor.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Updated Live',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColor.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                SizedBox(
                  height: 140,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildMiniChartColumn('Mon', 0.5, '5 Shows'),
                      _buildMiniChartColumn('Tue', 0.7, '7 Shows'),
                      _buildMiniChartColumn('Wed', 0.4, '4 Shows'),
                      _buildMiniChartColumn('Thu', 0.8, '8 Shows'),
                      _buildMiniChartColumn('Fri', 0.95, '12 Shows'),
                      _buildMiniChartColumn('Sat', 1.0, '15 Shows'),
                      _buildMiniChartColumn('Sun', 0.85, '10 Shows'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          /// Recent Bookings & Recently Added Movies Stacked in Column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Recent Bookings Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                        onPressed: () => setState(() => _selectedNavIndex = 4),
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

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recentBookings.length,
                    itemBuilder: (context, index) {
                      final booking = recentBookings[index];
                      final isConfirmed = booking.status == 'Confirmed';

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(10),
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
                                color:
                                    (isConfirmed
                                            ? AppColor.green
                                            : AppColor.red)
                                        .withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isConfirmed ? Icons.check : Icons.close,
                                color: isConfirmed
                                    ? AppColor.green
                                    : AppColor.red,
                                size: 14,
                              ),
                            ),
                            const SizedBox(width: 10),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    booking.customerName,
                                    style: AppTextStyles.labelMedium.copyWith(
                                      color: AppColor.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    booking.movieTitle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColor.grey,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Text(
                              'NPR ${booking.totalPrice.toInt()}',
                              style: AppTextStyles.labelMedium.copyWith(
                                color: AppColor.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.chevron_right,
                                color: AppColor.grey,
                                size: 18,
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

              const SizedBox(height: 24),

              /// Active Catalog Movies Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Active Catalog Movies',
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColor.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () => setState(() => _selectedNavIndex = 1),
                        child: Text(
                          'Manage',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColor.themeColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recentlyAddedMovies.length,
                    itemBuilder: (context, index) {
                      final movie = recentlyAddedMovies[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColor.cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColor.borderColor),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network(
                                movie.poster,
                                width: 40,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      width: 40,
                                      height: 50,
                                      color: AppColor.surfaceColor,
                                      child: const Icon(
                                        Icons.movie,
                                        color: AppColor.themeColor,
                                        size: 18,
                                      ),
                                    ),
                              ),
                            ),
                            const SizedBox(width: 10),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    movie.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.labelMedium.copyWith(
                                      color: AppColor.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    movie.information,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColor.grey,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColor.green.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Now Showing',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColor.green,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
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
            ],
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
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColor.cardColor,
          borderRadius: BorderRadius.circular(12),
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
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColor.grey.withValues(alpha: 0.5),
                  size: 10,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColor.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColor.grey,
                    fontSize: 11,
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

  Widget _buildMiniChartColumn(
    String dayLabel,
    double ratio,
    String labelText,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          labelText,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColor.grey,
            fontSize: 9,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 20,
          height: 80 * ratio,
          decoration: BoxDecoration(
            color: AppColor.themeColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          dayLabel,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColor.white,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
