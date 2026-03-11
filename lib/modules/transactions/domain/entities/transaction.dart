/// Entidade de transação conforme documentação (seção 16.6)
class Transaction {
  final String id;
  final String userId;
  final String? accountId;
  final String? categoryId;
  final String? paymentMethodId;
  final String description;
  final String? notes;
  final double amount;
  final String type; // 'income' | 'expense' | 'transfer'
  final String status; // 'paid' | 'pending' | 'received' | 'scheduled' | 'cancelled'
  final DateTime transactionDate;
  final DateTime? dueDate;
  final DateTime? competencyDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  const Transaction({
    required this.id,
    required this.userId,
    this.accountId,
    this.categoryId,
    this.paymentMethodId,
    required this.description,
    this.notes,
    required this.amount,
    required this.type,
    this.status = 'paid',
    required this.transactionDate,
    this.dueDate,
    this.competencyDate,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  bool get isIncome => type == 'income';
  bool get isExpense => type == 'expense';
}
