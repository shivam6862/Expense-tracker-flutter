import 'package:expense_tracker_flutter/utils/colors.dart';
import 'package:expense_tracker_flutter/utils/global_variable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseItem extends StatelessWidget {
  final String title;
  final String description;
  final String amount;
  final String date;
  final String category;
  final String userId;
  final String id;
  final Function(String) onDelete;
  final Function(String) onEdit;

  const ExpenseItem({
    super.key,
    required this.title,
    required this.description,
    required this.amount,
    required this.date,
    required this.category,
    required this.userId,
    required this.id,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description),
            const SizedBox(height: 8.0),
            Text(
              'Amount: ₹$amount',
              style: const TextStyle(
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Date: ${DateFormat.yMMMd().format(
                DateTime.parse(date),
              )}',
              style: const TextStyle(
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: <Widget>[
                Icon(categoryIcons[category]),
                const SizedBox(width: 10),
                Text(
                  category,
                  style: const TextStyle(
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: ListTile(
                  title: const Text('Edit'),
                  onTap: () {
                    onEdit(id);
                  },
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  title: const Text('Delete'),
                  onTap: () {
                    onDelete(id);
                    Navigator.pop(context);
                  },
                ),
              ),
            ];
          },
        ),
      ),
    );
  }
}
