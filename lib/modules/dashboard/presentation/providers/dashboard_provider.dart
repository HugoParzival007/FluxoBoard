import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../transactions/presentation/providers/transaction_provider.dart';

final dashboardSummaryProvider = FutureProvider.autoDispose<DashboardSummary>((ref) async {
  final transactions = await ref.watch(transactionsProvider.future);
  double income = 0;
  double expenses = 0;
  for (final t in transactions) {
    if (t.isIncome) {
      income += t.amount;
    } else if (t.isExpense) {
      expenses += t.amount;
    }
  }
  return DashboardSummary(
    balance: income - expenses,
    totalIncome: income,
    totalExpenses: expenses,
  );
});

class DashboardSummary {
  final double balance;
  final double totalIncome;
  final double totalExpenses;

  const DashboardSummary({
    required this.balance,
    required this.totalIncome,
    required this.totalExpenses,
  });
}
