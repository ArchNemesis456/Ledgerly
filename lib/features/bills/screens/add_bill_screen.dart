import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../database/database.dart';
import '../providers/bill_provider.dart';

class AddBillScreen extends ConsumerStatefulWidget {
  const AddBillScreen({super.key, this.bill});
  final Bill? bill;
  @override
  ConsumerState<AddBillScreen> createState() => _AddBillScreenState();
}

class _AddBillScreenState extends ConsumerState<AddBillScreen> {
  final _key = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _amount;
  late DateTime _dueDate;
  late int _reminderDays;
  @override
  void initState() {
    super.initState();
    final bill = widget.bill;
    _title = TextEditingController(text: bill?.title ?? '');
    _amount = TextEditingController(
      text: bill?.amount.toStringAsFixed(0) ?? '',
    );
    _dueDate = bill?.dueDate ?? DateTime.now();
    _reminderDays = bill?.reminderDays ?? 3;
  }

  @override
  void dispose() {
    _title.dispose();
    _amount.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  Future<void> _save() async {
    if (!_key.currentState!.validate()) return;
    final repository = ref.read(billRepositoryProvider);
    final bill = widget.bill;
    if (bill == null) {
      await repository.addBill(
        BillsCompanion.insert(
          title: _title.text.trim(),
          amount: double.parse(_amount.text),
          dueDate: _dueDate,
          reminderDays: drift.Value(_reminderDays),
        ),
      );
    } else {
      await repository.updateBill(
        bill.copyWith(
          title: _title.text.trim(),
          amount: double.parse(_amount.text),
          dueDate: _dueDate,
          reminderDays: _reminderDays,
        ),
      );
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.bill == null ? 'Add bill' : 'Edit bill')),
    body: Form(
      key: _key,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextFormField(
            controller: _title,
            decoration: const InputDecoration(labelText: 'Bill name'),
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Enter a bill name' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _amount,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Amount',
              prefixText: '₹ ',
            ),
            validator: (v) =>
                double.tryParse(v ?? '') == null || double.parse(v!) <= 0
                ? 'Enter a valid amount'
                : null,
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Due date'),
            subtitle: Text(
              MaterialLocalizations.of(context).formatMediumDate(_dueDate),
            ),
            trailing: const Icon(Icons.calendar_today_outlined),
            onTap: _pickDate,
          ),
          DropdownButtonFormField<int>(
            initialValue: _reminderDays,
            decoration: const InputDecoration(labelText: 'Remind me'),
            items: const [1, 3, 7, 14]
                .map(
                  (days) => DropdownMenuItem(
                    value: days,
                    child: Text('$days days before'),
                  ),
                )
                .toList(),
            onChanged: (value) => setState(() => _reminderDays = value!),
          ),
          const SizedBox(height: 28),
          FilledButton(
            onPressed: _save,
            child: Text(widget.bill == null ? 'Save bill' : 'Update bill'),
          ),
        ],
      ),
    ),
  );
}
