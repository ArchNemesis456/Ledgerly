import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;

import '../../../database/database.dart';
import '../providers/savings_goal_provider.dart';

class AddSavingsGoalScreen extends ConsumerStatefulWidget {
  final SavingsGoal? goal;

  const AddSavingsGoalScreen({super.key, this.goal});

  @override
  ConsumerState<AddSavingsGoalScreen> createState() =>
      _AddSavingsGoalScreenState();
}

class _AddSavingsGoalScreenState extends ConsumerState<AddSavingsGoalScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _targetController;
  late final TextEditingController _currentController;

  DateTime? _deadline;

  bool get isEditing => widget.goal != null;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.goal?.name ?? "");

    _targetController = TextEditingController(
      text: widget.goal?.targetAmount.toString() ?? "",
    );

    _currentController = TextEditingController(
      text: widget.goal?.currentAmount.toString() ?? "0",
    );

    _deadline = widget.goal?.deadline;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _targetController.dispose();
    _currentController.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: _deadline ?? DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _deadline = picked;
      });
    }
  }

  Future<void> _saveGoal() async {
    if (!_formKey.currentState!.validate()) return;

    final repository = ref.read(savingsGoalRepositoryProvider);

    if (isEditing) {
      await repository.updateGoal(
        widget.goal!.copyWith(
          name: _nameController.text.trim(),
          targetAmount: double.parse(_targetController.text),
          currentAmount: double.parse(_currentController.text),
          deadline: drift.Value(_deadline),
        ),
      );
    } else {
      await repository.addGoal(
        SavingsGoalsCompanion.insert(
          name: _nameController.text.trim(),
          targetAmount: double.parse(_targetController.text),
          currentAmount: drift.Value(double.parse(_currentController.text)),
          deadline: drift.Value(_deadline),
        ),
      );
    }

    ref.invalidate(savingsGoalsProvider);

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edit Goal" : "Create Savings Goal"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Goal Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter a goal name";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 18),

              TextFormField(
                controller: _targetController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Target Amount",
                  prefixText: "₹ ",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter target amount";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 18),

              TextFormField(
                controller: _currentController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Current Savings",
                  prefixText: "₹ ",
                ),
              ),

              const SizedBox(height: 24),

              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_month),
                title: Text(
                  _deadline == null
                      ? "Select Deadline"
                      : "${_deadline!.day}/${_deadline!.month}/${_deadline!.year}",
                ),
                trailing: FilledButton(
                  onPressed: _pickDeadline,
                  child: const Text("Choose"),
                ),
              ),

              const SizedBox(height: 40),

              FilledButton(
                onPressed: _saveGoal,
                child: Text(isEditing ? "Update Goal" : "Create Goal"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
