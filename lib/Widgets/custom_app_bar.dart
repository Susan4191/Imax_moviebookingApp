import 'package:flutter/material.dart';
import 'package:imax_movie_ticket_booking/utils/app_color.dart';
import 'package:imax_movie_ticket_booking/utils/app_toast.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    final bool canGoBack = Navigator.canPop(context);

    return AppBar(
      backgroundColor: AppColor.backgroundColor,
      elevation: 0,
      centerTitle: true,
      toolbarHeight: 80,

      /// Back button or 3-dash menu icon
      leading: IconButton(
        onPressed: () {
          if (canGoBack) {
            Navigator.pop(context);
          }
        },
        icon: Icon(
          canGoBack ? Icons.arrow_back_ios_new : Icons.menu,
          color: AppColor.white,
          size: 28,
        ),
        tooltip: canGoBack ? 'Back' : 'Menu',
      ),

      /// App logo
      title: Image.asset('assets/images/logo_logo.png', scale: 10),

      /// Notification button
      actions: [
        IconButton(
          onPressed: () {
            AppToast.showInfo('No new notifications');
          },
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(
                Icons.notifications_none_rounded,
                color: AppColor.white,
                size: 28,
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: AppColor.themeColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
