import 'package:flutter/foundation.dart';
import '../Model/payment_model.dart';

class PaymentProvider extends ChangeNotifier {
  PaymentMethodType _selectedMethod = PaymentMethodType.esewa;
  String _promoCode = '';
  double _discount = 0.0;
  String? _promoMessage;
  bool _isPromoApplied = false;
  bool _isProcessing = false;

  PaymentMethodType get selectedMethod => _selectedMethod;
  String get promoCode => _promoCode;
  double get discount => _discount;
  String? get promoMessage => _promoMessage;
  bool get isPromoApplied => _isPromoApplied;
  bool get isProcessing => _isProcessing;

  void selectPaymentMethod(PaymentMethodType method) {
    if (_selectedMethod != method) {
      _selectedMethod = method;
      notifyListeners();
    }
  }

  void setPromoCode(String code) {
    _promoCode = code;
  }

  String? applyPromoCode(String code) {
    final trimmed = code.trim().toUpperCase();
    if (trimmed.isEmpty) {
      _promoMessage = 'Please enter a promo code';
      _isPromoApplied = false;
      _discount = 0.0;
      notifyListeners();
      return _promoMessage;
    }

    if (trimmed == 'IMAX100' || trimmed == 'PROMO50' || trimmed == 'OFFER10') {
      _discount = 100.0;
      _isPromoApplied = true;
      _promoMessage = 'Promo code applied successfully!';
      notifyListeners();
      return null;
    } else {
      _discount = 0.0;
      _isPromoApplied = false;
      _promoMessage = 'Invalid promo code';
      notifyListeners();
      return _promoMessage;
    }
  }

  void resetPromo() {
    _promoCode = '';
    _discount = 0.0;
    _isPromoApplied = false;
    _promoMessage = null;
    notifyListeners();
  }

  Future<bool> processPayment() async {
    _isProcessing = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    _isProcessing = false;
    notifyListeners();
    return true;
  }
}
