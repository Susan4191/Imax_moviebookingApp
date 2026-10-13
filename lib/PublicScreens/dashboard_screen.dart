import 'package:flutter/material.dart';
import 'bookings_screen.dart';
import 'home_Screen.dart';
import 'movie_screen.dart';
import 'profile_screen.dart';
import '../utils/app_color.dart';
import '../utils/app_text_style.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int currentIndex = 0;

  final List<Widget> screens = const [
    HomeScreen(),
    MovieScreen(),
    BookingScreen(),
    ProfileScreen(),
  ];

  void changeScreen(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide = constraints.maxWidth > 600;

        if (isWide) {
          return Scaffold(
            backgroundColor: AppColor.backgroundColor,
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: currentIndex,
                  onDestinationSelected: changeScreen,
                  backgroundColor: AppColor.cardColor,
                  selectedIconTheme: const IconThemeData(
                    color: AppColor.themeColor,
                  ),
                  unselectedIconTheme: const IconThemeData(
                    color: AppColor.grey,
                  ),
                  selectedLabelTextStyle: AppTextStyles.labelSmall.copyWith(
                    color: AppColor.themeColor,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelTextStyle: AppTextStyles.labelSmall.copyWith(
                    color: AppColor.grey,
                  ),
                  labelType: NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home_rounded),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.movie_outlined),
                      selectedIcon: Icon(Icons.movie_rounded),
                      label: Text('Movies'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.confirmation_number_outlined),
                      selectedIcon: Icon(Icons.confirmation_number_rounded),
                      label: Text('Bookings'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person_rounded),
                      label: Text('Profile'),
                    ),
                  ],
                ),
                const VerticalDivider(
                  thickness: 1,
                  width: 1,
                  color: AppColor.borderColor,
                ),
                Expanded(
                  child: IndexedStack(index: currentIndex, children: screens),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColor.backgroundColor,
          body: IndexedStack(index: currentIndex, children: screens),
          bottomNavigationBar: SafeArea(
            minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColor.borderColor),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.black.withValues(alpha: 0.40),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BottomNavigationBar(
                  currentIndex: currentIndex,
                  onTap: changeScreen,
                  type: BottomNavigationBarType.fixed,
                  elevation: 0,
                  backgroundColor: AppColor.cardColor,
                  selectedItemColor: AppColor.themeColor,
                  unselectedItemColor: AppColor.grey,
                  selectedLabelStyle: AppTextStyles.labelSmall,
                  unselectedLabelStyle: AppTextStyles.labelSmall,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined, size: 24),
                      activeIcon: Icon(Icons.home_rounded, size: 24),
                      label: "Home",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.movie_outlined, size: 24),
                      activeIcon: Icon(Icons.movie_rounded, size: 24),
                      label: "Movies",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.confirmation_number_outlined, size: 24),
                      activeIcon: Icon(
                        Icons.confirmation_number_rounded,
                        size: 24,
                      ),
                      label: "Bookings",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_outline, size: 24),
                      activeIcon: Icon(Icons.person_rounded, size: 24),
                      label: "Profile",
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
