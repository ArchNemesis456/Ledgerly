import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../database/database.dart';
import '../providers/recurring_provider.dart';

class AddRecurringScreen extends ConsumerStatefulWidget {
  const AddRecurringScreen({
    super.key,
    this.transaction,
  });

  final RecurringTransaction? transaction;

  @override
  ConsumerState<AddRecurringScreen> createState() =>
      _AddRecurringScreenState();
}

class _AddRecurringScreenState
    extends ConsumerState<AddRecurringScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  late final TextEditingController _categoryController;
  late final TextEditingController _accountIdController;

  late bool _isIncome;
  late bool _isActive;
  late String _interval;

  late DateTime _startDate;
  DateTime? _endDate;

  bool get isEditing => widget.transaction != null;

  @override
  void initState() {
    super.initState();

    final transaction = widget.transaction;

    _titleController = TextEditingController(
      text: transaction?.title ?? '',
    );

    _amountController = TextEditingController(
      text: transaction?.amount.toString() ?? '',
    );

    _categoryController = TextEditingController(
      text: transaction?.category ?? '',
    );

    _accountIdController = TextEditingController(
      text: transaction?.accountId.toString() ?? '',
    );

    _isIncome = transaction?.isIncome ?? false;
    _isActive = transaction?.isActive ?? true;
    _interval = transaction?.interval ?? 'monthly';

    _startDate = transaction?.startDate ?? DateTime.now();
    _endDate = transaction?.endDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _categoryController.dispose();
    _accountIdController.dispose();
    super.dispose();
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    setState(() {
      _startDate = picked;
    });
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate,
      firstDate: _startDate,
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    setState(() {
      _endDate = picked;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final amount = double.tryParse(
      _amountController.text.trim(),
    );

    final accountId = int.tryParse(
      _accountIdController.text.trim(),
    );

    if (amount == null || accountId == null) {
      return;
    }

    final repository = ref.read(recurringRepositoryProvider);

    if (isEditing) {
      final updated = widget.transaction!.copyWith(
        title: _titleController.text.trim(),
        amount: amount,
        category: _categoryController.text.trim(),
        accountId: accountId,
        isIncome: _isIncome,
        interval: _interval,
        startDate: _startDate,
        endDate: drift.Value(_endDate),
        isActive: _isActive,
      );

      await repository.update(updated);
    } else {
      final companion = RecurringTransactionsCompanion.insert(
        title: _titleController.text.trim(),
        amount: amount,
        category: _categoryController.text.trim(),
        accountId: accountId,
        isIncome: drift.Value(_isIncome),
        interval: _interval,
        startDate: _startDate,
        endDate: drift.Value(_endDate),
        isActive: drift.Value(_isActive),
      );

      await repository.add(companion);
    }

    if (!mounted) return;

    Navigator.pop(context);
  }

  Future<void> _delete() async {
    final transaction = widget.transaction;

    if (transaction == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Delete recurring transaction?',
          ),
          content: const Text(
            'This recurring transaction will be permanently deleted.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    await ref
        .read(recurringRepositoryProvider)
        .delete(transaction);

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing
              ? 'Edit Recurring Transaction'
              : 'Add Recurring Transaction',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _titleController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Title',
                prefixIcon: Icon(Icons.repeat),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter a title';
                }

                return null;
              },
            ),

            const SizedBox(height: 18),

            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: '₹ ',
              ),
              validator: (value) {
                final amount = double.tryParse(
                  value?.trim() ?? '',
                );

                if (amount == null || amount <= 0) {
                  return 'Enter a valid amount';
                }

                return null;
              },
            ),

            const SizedBox(height: 18),

            TextFormField(
              controller: _categoryController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Category',
                prefixIcon: Icon(
                  Icons.category_outlined,
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter a category';
                }

                return null;
              },
            ),

            const SizedBox(height: 18),

            TextFormField(
              controller: _accountIdController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Account ID',
                prefixIcon: Icon(
                  Icons.account_balance_wallet_outlined,
                ),
              ),
              validator: (value) {
                final id = int.tryParse(
                  value?.trim() ?? '',
                );

                if (id == null || id <= 0) {
                  return 'Enter a valid account ID';
                }

                return null;
              },
            ),

            const SizedBox(height: 22),

            DropdownButtonFormField<String>(
              initialValue: _interval,
              decoration: const InputDecoration(
                labelText: 'Repeat',
                prefixIcon: Icon(
                  Icons.event_repeat,
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'daily',
                  child: Text('Daily'),
                ),
                DropdownMenuItem(
                  value: 'weekly',
                  child: Text('Weekly'),
                ),
                DropdownMenuItem(
                  value: 'monthly',
                  child: Text('Monthly'),
                ),
                DropdownMenuItem(
                  value: 'yearly',
                  child: Text('Yearly'),
                ),
              ],
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  _interval = value;
                });
              },
            ),

            const SizedBox(height: 12),

            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Income'),
              subtitle: const Text(
                'Turn on if this recurring transaction is income.',
              ),
              value: _isIncome,
              onChanged: (value) {
                setState(() {
                  _isIncome = value;
                });
              },
            ),

            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Active'),
              subtitle: const Text(
                'Inactive transactions will be paused.',
              ),
              value: _isActive,
              onChanged: (value) {
                setState(() {
                  _isActive = value;
                });
              },
            ),

            const SizedBox(height: 8),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.calendar_today,
              ),
              title: const Text('Start Date'),
              subtitle: Text(
                MaterialLocalizations.of(context)
                    .formatMediumDate(_startDate),
              ),
              trailing: OutlinedButton(
                onPressed: _pickStartDate,
                child: const Text('Change'),
              ),
            ),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.event_busy,
              ),
              title: const Text('End Date'),
              subtitle: Text(
                _endDate == null
                    ? 'No end date'
                    : MaterialLocalizations.of(context)
                        .formatMediumDate(_endDate!),
              ),
              trailing: OutlinedButton(
                onPressed: _pickEndDate,
                child: const Text('Choose'),
              ),
            ),

            const SizedBox(height: 30),

            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: Text(
                isEditing
                    ? 'Update Transaction'
                    : 'Create Recurring Transaction',
              ),
            ),

            if (isEditing) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _delete,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
                icon: const Icon(
                  Icons.delete_outline,
                ),
                label: const Text('Delete'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}