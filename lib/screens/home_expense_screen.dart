import 'package:expense_tracker_flutter/screens/add_expense_screen.dart';
import 'package:expense_tracker_flutter/screens/update_expense_screen.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker_flutter/resources/expense_methods.dart';
import 'package:expense_tracker_flutter/utils/utils.dart';
import 'package:expense_tracker_flutter/widgets/expense_item.dart';

class HomeExpenseScreen extends StatefulWidget {
  final String uid;
  const HomeExpenseScreen({super.key, required this.uid});

  @override
  State<HomeExpenseScreen> createState() => _HomeExpenseScreenState();
}

class _HomeExpenseScreenState extends State<HomeExpenseScreen> {
  List<Map<String, dynamic>> expenses = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      expenses = await ExpenseMethods().getExpenses();
      setState(() {});
    } catch (e) {
      if (mounted) {
        showSnackBar(
          context,
          e.toString(),
        );
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  void deleteExpense(String id) async {
    try {
      await ExpenseMethods().deleteExpense(id);
      getData();
    } catch (e) {
      if (mounted) {
        showSnackBar(
          context,
          e.toString(),
        );
      }
    }
  }

  void editExpense(String id) {
    final expense = expenses.firstWhere((element) => element['id'] == id);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateExpenseScreen(
          id: id,
          expense: expense,
        ),
      ),
    ).then((_) {
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Expenses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddExpenseScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : expenses.isEmpty
              ? const Center(
                  child: Text('No expenses found'),
                )
              : ListView.builder(
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    final expense = expenses[index];
                    return ExpenseItem(
                      title: expense['title'],
                      description: expense['description'],
                      amount: expense['amount'],
                      date: expense['date'],
                      category: expense['category'],
                      userId: widget.uid,
                      id: expense['id'],
                      onDelete: deleteExpense,
                      onEdit: editExpense,
                    );
                  },
                ),
    );
  }
}
