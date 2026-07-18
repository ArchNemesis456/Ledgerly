import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/transaction_provider.dart';
import '../widgets/transaction_card.dart';
import 'add_transaction_screen.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionListProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: const Text(
          "Transactions",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: transactions.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Text(error.toString()),
        ),
        data: (transactionList) {
          if (transactionList.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_balance_wallet_rounded,
                      size: 90,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "No Transactions Yet",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Start tracking your income and expenses by adding your first transaction.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 32),
                    FilledButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const AddTransactionScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text(
                        "Add Your First Transaction",
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await ref
                  .read(transactionRepositoryProvider)
                  .getTransactions();

              await Future.delayed(
                const Duration(milliseconds: 500),
              );
            },
            child: ListView.builder(
              physics:
                  const AlwaysScrollableScrollPhysics(),
              itemCount: transactionList.length,
              itemBuilder: (context, index) {
                final transaction = transactionList[index];

                return Dismissible(
                  key: ValueKey(transaction.id),
                  direction:
                      DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding:
                        const EdgeInsets.only(right: 20),
                    color: Colors.red,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  confirmDismiss: (_) async {
                    return await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text(
                              "Delete Transaction",
                            ),
                            content: const Text(
                              "Are you sure you want to delete this transaction?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(
                                    context,
                                    false,
                                  );
                                },
                                child: const Text(
                                  "Cancel",
                                ),
                              ),
                              FilledButton(
                                onPressed: () {
                                  Navigator.pop(
                                    context,
                                    true,
                                  );
                                },
                                child: const Text(
                                  "Delete",
                                ),
                              ),
                            ],
                          ),
                        ) ??
                        false;
                  },
                  onDismissed: (_) async {
                    final repository = ref.read(
                      transactionRepositoryProvider,
                    );

                    await repository.deleteTransaction(
                      transaction,
                    );

                    if (context.mounted) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          behavior:
                              SnackBarBehavior.floating,
                          content: Text(
                            "Transaction deleted successfully",
                          ),
                        ),
                      );
                    }
                  },
                  child: TransactionCard(
                    title: transaction.title,
                    amount: transaction.amount,
                    isIncome: transaction.isIncome,
                    date: transaction.date,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              AddTransactionScreen(
                            transaction: transaction,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const AddTransactionScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("Add"),
      ),
    );
  }
}