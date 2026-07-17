import 'package:flutter/material.dart';

class EmptyTransactions extends StatelessWidget {
  const EmptyTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.receipt_long,
              size: 90,
              color: Colors.grey,
            ),
            SizedBox(height: 20),
            Text(
              "No Transactions Yet",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Tap the + button below to add your first transaction.",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}