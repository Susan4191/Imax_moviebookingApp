enum PaymentMethodType { esewa, khalti, card, moreOptions }

class PaymentMethodModel {
  final String id;
  final String title;
  final String subtitle;
  final PaymentMethodType type;

  PaymentMethodModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
  });
}
