/// Entidade de forma de pagamento conforme documentação (seção 16.4)
class PaymentMethod {
  final String id;
  final String userId;
  final String name;
  final String kind; // 'instant_payment' | 'card' | 'cash' | etc
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PaymentMethod({
    required this.id,
    required this.userId,
    required this.name,
    required this.kind,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });
}
