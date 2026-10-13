import 'package:flutter/material.dart';

import '../utils/app_color.dart';
import '../utils/app_text_style.dart';

class TermsAndConditionsDialog extends StatelessWidget {
  const TermsAndConditionsDialog({super.key, this.onAccept});

  final VoidCallback? onAccept;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      backgroundColor: AppColor.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: AppColor.borderColor),
      ),
      title: Text(
        'Terms and Conditions',
        style: AppTextStyles.headingSmall.copyWith(color: AppColor.white),
      ),
      content: Text('''
Welcome to IMAXNP.

1. Users must provide correct information while creating an account.

2. Movie tickets are valid only for the selected movie, date, time, screen, and seats.

3. Tickets cannot be transferred or reused after entry.

4. Booking cancellation and refund depend on the cinema's cancellation policy.

5. Users are responsible for keeping their account and booking information secure.

6. IMAXNP is not responsible for delays caused by payment providers or internet connection problems.

7. Users must follow all cinema rules while visiting the theatre.

8. By using this application, you agree to these terms and conditions.
''', style: AppTextStyles.bodyMedium.copyWith(color: AppColor.grey)),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Close',
            style: AppTextStyles.labelMedium.copyWith(color: AppColor.grey),
          ),
        ),

        if (onAccept != null)
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onAccept!();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.themeColor,
              foregroundColor: AppColor.white,
            ),
            child: Text("Accept"),
          ),
      ],
    );
  }
}
