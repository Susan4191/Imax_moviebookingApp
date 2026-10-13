import 'package:flutter/material.dart';
import 'package:imax_movie_ticket_booking/utils/app_toast.dart';
import 'package:provider/provider.dart';
import '../Provider/payment_provider.dart';
import '../utils/app_color.dart';
import '../utils/app_text_style.dart';

class PromoCodeWidget extends StatefulWidget {
  const PromoCodeWidget({super.key});

  @override
  State<PromoCodeWidget> createState() => _PromoCodeWidgetState();
}

class _PromoCodeWidgetState extends State<PromoCodeWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paymentProvider = context.watch<PaymentProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            /// TextField input box
            Expanded(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: AppColor.cardColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColor.borderColor),
                ),
                child: TextField(
                  controller: _controller,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColor.white,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter promo code',
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColor.textMuted,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: InputBorder.none,
                  ),
                  onChanged: (val) {
                    paymentProvider.setPromoCode(val);
                  },
                ),
              ),
            ),

            const SizedBox(width: 10),

            /// Apply Button
            SizedBox(
              height: 48,
              child: OutlinedButton(
                onPressed: () {
                  final errorMsg = paymentProvider.applyPromoCode(
                    _controller.text,
                  );
                  if (errorMsg != null) {
                    AppToast.showError(errorMsg);
                  } else {
                    AppToast.showSuccess('Promo code applied!');
                  }
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColor.red,
                  side: const BorderSide(color: AppColor.red, width: 1.5),
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Apply',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColor.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),

        if (paymentProvider.promoMessage != null &&
            paymentProvider.isPromoApplied)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 4),
            child: Text(
              paymentProvider.promoMessage!,
              style: AppTextStyles.bodySmall.copyWith(color: AppColor.green),
            ),
          ),
      ],
    );
  }
}
