import 'package:expense_tracker_flutter/resources/expense_methods.dart';
import 'package:expense_tracker_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SearchExpenseScreen extends StatefulWidget {
  final String uid;
  const SearchExpenseScreen({super.key, required this.uid});

  @override
  State<SearchExpenseScreen> createState() => _SearchExpenseScreenState();
}

class _SearchExpenseScreenState extends State<SearchExpenseScreen> {
  List<Map<String, dynamic>> expenses = [];
  bool isLoading = false;
  String search = '';

  @override
  void initState() {
    super.initState();
  }

  void searchExpenses(value) async {
    if (value == "") {
      return;
    }

    setState(() {
      isLoading = true;
    });

    final List<Map<String, dynamic>> allExpenses =
        await ExpenseMethods().searchExpenses(value);

    setState(() {
      isLoading = false;
      expenses = allExpenses;
      search = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Expense'),
        backgroundColor: whiteColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                searchExpenses(value);
              },
              decoration: const InputDecoration(
                hintText: 'Search By Category',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: expenses.isEmpty
                ? const Center(child: Text('No expenses found'))
                : ListView.builder(
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      final expense = expenses[index];
                      return ListTile(
                        leading: Text(
                          ' ${DateFormat.yMMMd().format(
                            DateTime.parse(expense['date']),
                          )}',
                        ),
                        title: Text(
                          expense['title'],
                          style: const TextStyle(
                            color: primaryColor,
                          ),
                        ),
                        trailing: Text('₹${expense['amount']}'),
                      );
                    },
                  ),
          ),
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
