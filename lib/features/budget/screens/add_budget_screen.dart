import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../database/database.dart';
import '../providers/budget_provider.dart';

class AddBudgetScreen extends ConsumerStatefulWidget {
  const AddBudgetScreen({super.key, this.budget});
  final Budget? budget;

  @override
  ConsumerState<AddBudgetScreen> createState() => _AddBudgetScreenState();
}

class _AddBudgetScreenState extends ConsumerState<AddBudgetScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _limit;
  late String _category;
  late DateTime _start;
  late DateTime _end;

  @override
  void initState() {
    super.initState();
    final budget = widget.budget;
    _name = TextEditingController(text: budget?.name ?? '');
    _limit = TextEditingController(
      text: budget?.limitAmount.toStringAsFixed(0) ?? '',
    );
    _category = budget?.category ?? 'General';
    _start = budget?.startDate ?? DateTime.now();
    _end = budget?.endDate ?? DateTime.now().add(const Duration(days: 30));
  }

  @override
  void dispose() {
    _name.dispose();
    _limit.dispose();
    super.dispose();
  }

  Future<void> _pickDate(bool start) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: start ? _start : _end,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (selected != null) {
      setState(() {
        if (start) {
          _start = selected;
        } else {
          _end = selected;
        }
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _end.isBefore(_start)) return;
    final repository = ref.read(budgetRepositoryProvider);
    final limit = double.parse(_limit.text.trim());
    final existing = widget.budget;
    if (existing == null) {
      await repository.addBudget(
        BudgetsCompanion.insert(
          name: _name.text.trim(),
          category: Value(_category),
          limitAmount: limit,
          startDate: _start,
          endDate: _end,
        ),
      );
    } else {
      await repository.updateBudget(
        existing.copyWith(
          name: _name.text.trim(),
          category: _category,
          limitAmount: limit,
          startDate: _start,
          endDate: _end,
        ),
      );
    }
    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    final approved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete budget?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (approved == true && widget.budget != null) {
      await ref.read(budgetRepositoryProvider).deleteBudget(widget.budget!);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(widget.budget == null ? 'Create budget' : 'Edit budget'),
      actions: [
        if (widget.budget != null)
          IconButton(
            onPressed: _delete,
            icon: const Icon(Icons.delete_outline),
          ),
      ],
    ),
    body: SafeArea(
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Budget name'),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Enter a budget name'
                  : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(labelText: 'Category'),
              items:
                  const [
                        'General',
                        'Food',
                        'Transport',
                        'Shopping',
                        'Bills',
                        'Entertainment',
                        'Health',
                      ]
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
              onChanged: (value) => setState(() => _category = value!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _limit,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Budget limit',
                prefixText: '₹ ',
              ),
              validator: (value) =>
                  double.tryParse(value ?? '') == null ||
                      double.parse(value!) <= 0
                  ? 'Enter a valid limit'
                  : null,
            ),
            const SizedBox(height: 16),
            _DateTile(
              label: 'Start date',
              value: _start,
              onTap: () => _pickDate(true),
            ),
            _DateTile(
              label: 'End date',
              value: _end,
              onTap: () => _pickDate(false),
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: _save,
              child: Text(
                widget.budget == null ? 'Save budget' : 'Update budget',
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _DateTile extends StatelessWidget {
  const _DateTile({
    required this.label,
    required this.value,
    required this.onTap,
  });
  final String label;
  final DateTime value;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(label),
    subtitle: Text(MaterialLocalizations.of(context).formatMediumDate(value)),
    trailing: const Icon(Icons.calendar_today_outlined),
    onTap: onTap,
  );
}
