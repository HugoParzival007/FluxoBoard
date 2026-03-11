import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/transaction.dart';

class TransactionRepository {
  TransactionRepository();

  SupabaseClient? get _client =>
      Supabase.instance.isInitialized ? Supabase.instance.client : null;

  String? get _userId => _client?.auth.currentUser?.id;

  Future<List<Transaction>> getTransactions({
    DateTime? startDate,
    DateTime? endDate,
    String? type,
    int limit = 100,
  }) async {
    if (_client == null || _userId == null) return [];

    var query = _client!.from('transactions').select().eq('user_id', _userId!);

    if (startDate != null) {
      query = query.gte('transaction_date', startDate.toIso8601String().split('T').first);
    }
    if (endDate != null) {
      query = query.lte('transaction_date', endDate.toIso8601String().split('T').first);
    }
    if (type != null && type.isNotEmpty) {
      query = query.eq('type', type);
    }

    final data = await query.order('transaction_date', ascending: false).limit(limit);
    final list = data as List<dynamic>;
    return list.map((e) => _fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<Transaction?> getById(String id) async {
    if (_client == null || _userId == null) return null;
    final data = await _client!
        .from('transactions')
        .select()
        .eq('id', id)
        .eq('user_id', _userId!)
        .maybeSingle();
    return data != null ? _fromMap(data) : null;
  }

  Future<Transaction> create({
    required String description,
    required double amount,
    required String type,
    String? categoryId,
    String? accountId,
    String? paymentMethodId,
    String? notes,
    DateTime? transactionDate,
    String status = 'paid',
  }) async {
    if (_client == null || _userId == null) {
      throw Exception('Usuário não autenticado');
    }

    final data = {
      'user_id': _userId,
      'description': description,
      'amount': amount,
      'type': type,
      'status': status,
      'transaction_date': (transactionDate ?? DateTime.now()).toIso8601String().split('T').first,
      'category_id': categoryId,
      'account_id': accountId,
      'payment_method_id': paymentMethodId,
      'notes': notes,
    };

    final result = await _client!.from('transactions').insert(data).select().single();
    return _fromMap(result);
  }

  Future<void> update(
    String id, {
    String? description,
    double? amount,
    String? type,
    String? categoryId,
    String? accountId,
    String? paymentMethodId,
    String? notes,
    DateTime? transactionDate,
    String? status,
  }) async {
    if (_client == null || _userId == null) return;

    final data = <String, dynamic>{
      'updated_at': DateTime.now().toIso8601String(),
    };
    if (description != null) data['description'] = description;
    if (amount != null) data['amount'] = amount;
    if (type != null) data['type'] = type;
    if (categoryId != null) data['category_id'] = categoryId;
    if (accountId != null) data['account_id'] = accountId;
    if (paymentMethodId != null) data['payment_method_id'] = paymentMethodId;
    if (notes != null) data['notes'] = notes;
    if (transactionDate != null) data['transaction_date'] = transactionDate.toIso8601String().split('T').first;
    if (status != null) data['status'] = status;

    await _client!
        .from('transactions')
        .update(data)
        .eq('id', id)
        .eq('user_id', _userId!);
  }

  Future<void> delete(String id) async {
    if (_client == null || _userId == null) return;
    await _client!
        .from('transactions')
        .update({'deleted_at': DateTime.now().toIso8601String()})
        .eq('id', id)
        .eq('user_id', _userId!);
  }

  Transaction _fromMap(Map<String, dynamic> m) {
    return Transaction(
      id: m['id'] as String,
      userId: m['user_id'] as String,
      accountId: m['account_id'] as String?,
      categoryId: m['category_id'] as String?,
      paymentMethodId: m['payment_method_id'] as String?,
      description: m['description'] as String,
      notes: m['notes'] as String?,
      amount: (m['amount'] as num).toDouble(),
      type: m['type'] as String,
      status: m['status'] as String? ?? 'paid',
      transactionDate: DateTime.parse(m['transaction_date'] as String),
      dueDate: m['due_date'] != null ? DateTime.parse(m['due_date'] as String) : null,
      competencyDate: m['competency_date'] != null ? DateTime.parse(m['competency_date'] as String) : null,
      createdAt: DateTime.parse(m['created_at'] as String),
      updatedAt: DateTime.parse(m['updated_at'] as String),
      deletedAt: m['deleted_at'] != null ? DateTime.parse(m['deleted_at'] as String) : null,
    );
  }
}
