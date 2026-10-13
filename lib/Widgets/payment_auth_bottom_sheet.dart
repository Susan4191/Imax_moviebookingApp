import 'package:flutter/material.dart';
import '../Model/payment_model.dart';
import '../utils/app_color.dart';
import '../utils/app_text_style.dart';
import '../utils/app_toast.dart';

class PaymentAuthBottomSheet extends StatefulWidget {
  const PaymentAuthBottomSheet({
    super.key,
    required this.methodType,
    required this.amount,
  });

  final PaymentMethodType methodType;
  final double amount;

  @override
  State<PaymentAuthBottomSheet> createState() => _PaymentAuthBottomSheetState();
}

class _PaymentAuthBottomSheetState extends State<PaymentAuthBottomSheet> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _otpController = TextEditingController(
    text: '1234',
  );

  bool _isObscure = true;
  bool _isOtpStep = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  String get _gatewayName {
    switch (widget.methodType) {
      case PaymentMethodType.esewa:
        return 'eSewa';
      case PaymentMethodType.khalti:
        return 'Khalti';
      case PaymentMethodType.card:
        return 'Credit / Debit Card';
      case PaymentMethodType.moreOptions:
        return 'Bank Gateway';
    }
  }

  Color get _gatewayColor {
    switch (widget.methodType) {
      case PaymentMethodType.esewa:
        return const Color(0xFF60BB46);
      case PaymentMethodType.khalti:
        return const Color(0xFF5C2D91);
      case PaymentMethodType.card:
        return AppColor.blue;
      case PaymentMethodType.moreOptions:
        return AppColor.red;
    }
  }

  void _handleGetOtp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your account email/phone and password';
      });
      return;
    }

    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 1200));

    if (mounted) {
      setState(() {
        _isLoading = false;
        _isOtpStep = true;
      });
    }
  }

  void _handleVerifyAndPay() async {
    final otp = _otpController.text.trim();

    if (otp.length < 4) {
      setState(() {
        _errorMessage = 'Please enter a valid 4-digit OTP';
      });
      return;
    }

    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedAmount = widget.amount.toInt().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 20,
        left: 20,
        right: 20,
      ),
      decoration: const BoxDecoration(
        color: AppColor.cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Drag handle bar
            Center(
              child: Container(
                width: 45,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColor.borderColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 18),

            /// Header with Gateway Name & Logo Badge
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _gatewayColor.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _gatewayColor, width: 1.5),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _gatewayName[0],
                    style: AppTextStyles.titleMedium.copyWith(
                      color: _gatewayColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$_gatewayName Checkout',
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColor.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Amount to Pay: NPR $formattedAmount',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColor.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                IconButton(
                  onPressed: () => Navigator.pop(context, false),
                  icon: const Icon(Icons.close_rounded, color: AppColor.grey),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: AppColor.borderColor),
            const SizedBox(height: 16),

            /// Error message banner if any
            if (_errorMessage != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColor.red.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColor.red.withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: AppColor.red,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColor.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            /// Content based on current step
            if (!_isOtpStep) ...[
              /// Step 1: Email / Username & Password Form
              Text(
                'Enter $_gatewayName Account Details',
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColor.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),

              /// Email / Phone input
              TextField(
                controller: _emailController,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColor.white),
                decoration: InputDecoration(
                  labelText: 'Email or Mobile Number',
                  labelStyle: AppTextStyles.bodyMedium.copyWith(
                    color: AppColor.textSecondary,
                  ),
                  prefixIcon: const Icon(
                    Icons.person_outline,
                    color: AppColor.grey,
                  ),
                  filled: true,
                  fillColor: AppColor.surfaceColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColor.borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColor.borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColor.red),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              /// Password / PIN input
              TextField(
                controller: _passwordController,
                obscureText: _isObscure,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColor.white),
                decoration: InputDecoration(
                  labelText: 'Password / MPIN',
                  labelStyle: AppTextStyles.bodyMedium.copyWith(
                    color: AppColor.textSecondary,
                  ),
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: AppColor.grey,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColor.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),
                  filled: true,
                  fillColor: AppColor.surfaceColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColor.borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColor.borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColor.red),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              /// "Get OTP" Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleGetOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: AppColor.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Get OTP',
                          style: AppTextStyles.titleSmall.copyWith(
                            color: AppColor.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ] else ...[
              /// Step 2: OTP Verification Form
              Row(
                children: [
                  const Icon(
                    Icons.mark_email_read_outlined,
                    color: AppColor.green,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'OTP Verification',
                    style: AppTextStyles.titleSmall.copyWith(
                      color: AppColor.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Enter 4-digit code sent to ${_emailController.text}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColor.textSecondary,
                ),
              ),
              const SizedBox(height: 18),

              /// OTP Input Field
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                textAlign: TextAlign.center,
                style: AppTextStyles.headingMedium.copyWith(
                  color: AppColor.white,
                  letterSpacing: 12,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: '0000',
                  hintStyle: AppTextStyles.headingMedium.copyWith(
                    color: AppColor.textMuted,
                    letterSpacing: 12,
                  ),
                  filled: true,
                  fillColor: AppColor.surfaceColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColor.borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColor.green),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isOtpStep = false;
                        _errorMessage = null;
                      });
                    },
                    child: Text(
                      'Change Credentials',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColor.textSecondary,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      AppToast.showSuccess('Resent OTP: 1234');
                    },
                    child: Text(
                      'Resend OTP',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColor.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              /// "Verify & Complete Payment" Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleVerifyAndPay,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: AppColor.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Verify & Complete Payment',
                          style: AppTextStyles.titleSmall.copyWith(
                            color: AppColor.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
