/// Entidade de conta conforme documentação (seção 16.2)
class Account {
  final String id;
  final String userId;
  final String name;
  final String type; // 'bank' | 'cash' | 'card' | etc
  final double initialBalance;
  final double currentBalance;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Account({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.initialBalance,
    required this.currentBalance,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });
}
