import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Model/payment_model.dart';
import '../Provider/payment_provider.dart';
import '../Widgets/booking_summary_card.dart';
import '../Widgets/payment_auth_bottom_sheet.dart';
import '../Widgets/payment_method_tile.dart';
import '../Widgets/promo_code_widget.dart';
import 'ticket_detail_screen.dart';
import '../utils/app_color.dart';
import '../utils/app_text_style.dart';
import '../utils/app_toast.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({
    super.key,
    required this.movieName,
    required this.moviePoster,
    required this.date,
    required this.time,
    this.format = 'IMAX 2D',
    this.screen = 'Screen 1',
    required this.selectedSeats,
    required this.ticketPrice,
    this.serviceFee = 50.0,
    required this.totalAmount,
  });

  final String movieName;
  final String moviePoster;
  final String date;
  final String time;
  final String format;
  final String screen;
  final List<String> selectedSeats;
  final double ticketPrice;
  final double serviceFee;
  final double totalAmount;

  @override
  Widget build(BuildContext context) {
    final paymentProvider = context.watch<PaymentProvider>();
    final double finalAmount = (totalAmount - paymentProvider.discount).clamp(
      0,
      double.infinity,
    );
    final String formattedFinalAmount = _formatCurrency(finalAmount);

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColor.white),
        ),
        centerTitle: true,
        title: Image.asset('assets/images/logo_logo.png', scale: 10),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.lock_outline, color: AppColor.white),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Payment Screen Heading
              Text(
                'Payment',
                style: AppTextStyles.headingMedium.copyWith(
                  color: AppColor.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),

              /// Security Notice
              Row(
                children: [
                  const Icon(
                    Icons.verified_user_outlined,
                    color: AppColor.textSecondary,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Your payment information is securely encrypted.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColor.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              /// Booking Summary Section
              Text(
                'Booking Summary',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColor.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              BookingSummaryCard(
                movieName: movieName,
                moviePoster: moviePoster,
                date: date,
                time: time,
                format: format,
                screen: screen,
                selectedSeats: selectedSeats,
                ticketPrice: ticketPrice,
                serviceFee: serviceFee,
                totalAmount: finalAmount,
                onEditTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 24),

              /// Choose Payment Method Section
              Text(
                'Choose Payment Method',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColor.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              /// Option 1: eSewa
              PaymentMethodTile(
                type: PaymentMethodType.esewa,
                title: 'eSewa',
                subtitle: 'Pay securely with eSewa',
                isSelected:
                    paymentProvider.selectedMethod == PaymentMethodType.esewa,
                onTap: () {
                  context.read<PaymentProvider>().selectPaymentMethod(
                    PaymentMethodType.esewa,
                  );
                },
              ),
              const SizedBox(height: 10),

              /// Option 2: Khalti
              PaymentMethodTile(
                type: PaymentMethodType.khalti,
                title: 'Khalti',
                subtitle: 'Pay securely with Khalti',
                isSelected:
                    paymentProvider.selectedMethod == PaymentMethodType.khalti,
                onTap: () {
                  context.read<PaymentProvider>().selectPaymentMethod(
                    PaymentMethodType.khalti,
                  );
                },
              ),
              const SizedBox(height: 10),

              /// Option 3: Debit / Credit Card
              PaymentMethodTile(
                type: PaymentMethodType.card,
                title: 'Debit / Credit Card',
                subtitle: 'Visa, Mastercard',
                isSelected:
                    paymentProvider.selectedMethod == PaymentMethodType.card,
                onTap: () {
                  context.read<PaymentProvider>().selectPaymentMethod(
                    PaymentMethodType.card,
                  );
                },
              ),
              const SizedBox(height: 10),

              /// Option 4: More payment options
              GestureDetector(
                onTap: () {
                  AppToast.showInfo('No additional payment methods available');
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.cardColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColor.borderColor),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'More payment options',
                        style: AppTextStyles.titleSmall.copyWith(
                          color: AppColor.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColor.white,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              /// Promo Code Section
              const PromoCodeWidget(),
              const SizedBox(height: 20),

              /// Payment Terms text
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'By continuing, you agree to our ',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColor.textSecondary,
                    ),
                    children: [
                      TextSpan(
                        text: 'payment terms.',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColor.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              /// Pay Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: paymentProvider.isProcessing
                      ? null
                      : () async {
                          final result = await showModalBottomSheet<bool>(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => PaymentAuthBottomSheet(
                              methodType: paymentProvider.selectedMethod,
                              amount: finalAmount,
                            ),
                          );

                          if (result == true && context.mounted) {
                            final success = await context
                                .read<PaymentProvider>()
                                .processPayment();
                            if (success && context.mounted) {
                              AppToast.showSuccess('Payment Successful!');
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) => AlertDialog(
                                  backgroundColor: AppColor.cardColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  title: const Icon(
                                    Icons.check_circle_rounded,
                                    color: AppColor.green,
                                    size: 60,
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Payment Successful!',
                                        style: AppTextStyles.titleLarge
                                            .copyWith(
                                              color: AppColor.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Your tickets for $movieName have been booked.',
                                        textAlign: TextAlign.center,
                                        style: AppTextStyles.bodyMedium
                                            .copyWith(
                                              color: AppColor.textSecondary,
                                            ),
                                      ),
                                    ],
                                  ),
                                  actionsAlignment: MainAxisAlignment.center,
                                  actionsOverflowDirection:
                                      VerticalDirection.down,
                                  actions: [
                                    /// "See Ticket Details" Button
                                    SizedBox(
                                      width: double.infinity,
                                      height: 46,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  TicketDetailScreen(
                                                    movieName: movieName,
                                                    moviePoster: moviePoster,
                                                    date: date,
                                                    time: time,
                                                    format: format,
                                                    screen: screen,
                                                    selectedSeats:
                                                        selectedSeats,
                                                    totalAmount: finalAmount,
                                                  ),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColor.red,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          'See Ticket Details',
                                          style: AppTextStyles.titleSmall
                                              .copyWith(
                                                color: AppColor.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),

                                    /// "Back to Home" Button
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(
                                          context,
                                        ).popUntil((route) => route.isFirst);
                                      },
                                      child: Text(
                                        'Back to Home',
                                        style: AppTextStyles.bodyMedium
                                            .copyWith(
                                              color: AppColor.textSecondary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.red,
                    disabledBackgroundColor: AppColor.borderColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: paymentProvider.isProcessing
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: AppColor.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.lock_outline_rounded,
                              color: AppColor.white,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Pay NPR $formattedFinalAmount',
                              style: AppTextStyles.titleMedium.copyWith(
                                color: AppColor.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.chevron_right_rounded,
                              color: AppColor.white,
                              size: 24,
                            ),
                          ],
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

  static String _formatCurrency(double amount) {
    final int value = amount.toInt();
    return value.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}
