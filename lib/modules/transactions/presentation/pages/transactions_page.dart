import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../domain/entities/transaction.dart';
import '../providers/transaction_provider.dart';

class TransactionsPage extends ConsumerWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Lançamentos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push(AppRoutes.transactionForm),
          ),
        ],
      ),
      body: transactionsAsync.when(
        data: (transactions) {
          if (transactions.isEmpty) {
            return EmptyState(
              icon: Icons.receipt_long_outlined,
              title: 'Nenhum lançamento',
              subtitle: 'Adicione receitas e despesas para acompanhar',
              action: FilledButton.icon(
                onPressed: () => context.push(AppRoutes.transactionForm),
                icon: const Icon(Icons.add),
                label: const Text('Novo lançamento'),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.refresh(transactionsProvider.future),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final t = transactions[index];
                return _TransactionCard(transaction: t);
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => EmptyState(
          icon: Icons.error_outline,
          title: 'Erro ao carregar',
          subtitle: e.toString(),
          action: FilledButton(
            onPressed: () => ref.refresh(transactionsProvider),
            child: const Text('Tentar novamente'),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.transactionForm),
        icon: const Icon(Icons.add),
        label: const Text('Novo'),
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final Transaction transaction;

  const _TransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.isIncome;
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isIncome
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.errorContainer,
          child: Icon(
            isIncome ? Icons.arrow_downward : Icons.arrow_upward,
            color: isIncome
                ? Theme.of(context).colorScheme.onPrimaryContainer
                : Theme.of(context).colorScheme.onErrorContainer,
          ),
        ),
        title: Text(transaction.description),
        subtitle: Text(
          DateFormat('dd/MM/yyyy').format(transaction.transactionDate),
        ),
        trailing: Text(
          '${isIncome ? '+' : '-'} ${formatter.format(transaction.amount)}',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isIncome
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.error,
          ),
        ),
      ),
    );
  }
}
