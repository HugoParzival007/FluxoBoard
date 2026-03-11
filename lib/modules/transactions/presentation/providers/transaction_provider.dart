import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/transaction_repository.dart';
import '../../domain/entities/transaction.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepository();
});

final transactionsProvider = FutureProvider.autoDispose<List<Transaction>>((ref) async {
  final repo = ref.watch(transactionRepositoryProvider);
  return repo.getTransactions();
});

final transactionsByMonthProvider = FutureProvider.autoDispose.family<List<Transaction>, DateTime>((ref, date) async {
  final repo = ref.watch(transactionRepositoryProvider);
  final start = DateTime(date.year, date.month, 1);
  final end = DateTime(date.year, date.month + 1, 0);
  return repo.getTransactions(startDate: start, endDate: end);
});
