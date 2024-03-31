import 'package:expense_tracker_flutter/resources/expense_methods.dart';
import 'package:expense_tracker_flutter/utils/colors.dart';
import 'package:expense_tracker_flutter/utils/global_variable.dart';
import 'package:expense_tracker_flutter/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final Map<String, TextEditingController> _controllers = {
    'title': TextEditingController(),
    'description': TextEditingController(),
    'amount': TextEditingController(),
    'date': TextEditingController(),
  };

  bool _isLoading = false;
  String dropdownCategoryValue = 'Food';

  @override
  void dispose() {
    super.dispose();
    _controllers.forEach((key, value) {
      value.dispose();
    });
  }

  bool get isFormValid {
    return _controllers.values
        .every((controller) => controller.text.isNotEmpty);
  }

  void addExpense() async {
    if (!isFormValid) {
      showSnackBar(context, 'Please fill all the fields.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String response = await ExpenseMethods().addExpense(
      title: _controllers['title']!.text,
      description: _controllers['description']!.text,
      amount: _controllers['amount']!.text,
      category: dropdownCategoryValue,
      date: _controllers['date']!.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (response == 'success') {
      if (mounted) {
        showSnackBar(context, 'Expense added successfully.');
      }
    } else {
      if (mounted) {
        showSnackBar(context, response);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
        backgroundColor: whiteColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controllers['title'],
              decoration: const InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(
                  color: darkColor,
                ),
              ),
              style: const TextStyle(
                color: blackColor,
              ),
              keyboardType: TextInputType.text,
              cursorColor: darkColor,
            ),
            TextField(
              controller: _controllers['description'],
              decoration: const InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(
                  color: darkColor,
                ),
              ),
              style: const TextStyle(
                color: blackColor,
              ),
              keyboardType: TextInputType.text,
              cursorColor: darkColor,
              maxLines: 3,
              minLines: 1,
            ),
            TextField(
              controller: _controllers['amount'],
              decoration: const InputDecoration(
                labelText: 'Amount',
                labelStyle: TextStyle(
                  color: darkColor,
                ),
              ),
              style: const TextStyle(
                color: blackColor,
              ),
              keyboardType: TextInputType.text,
              cursorColor: darkColor,
            ),
            const SizedBox(height: 12),
            DropdownButton<String>(
              isExpanded: true,
              value: dropdownCategoryValue,
              iconSize: 24,
              elevation: 16,
              style: const TextStyle(color: darkColor),
              underline: Container(
                height: 2,
                color: darkColor,
                width: double.infinity,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownCategoryValue = newValue!;
                });
              },
              items: categories.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children: <Widget>[
                      Icon(categoryIcons[value]),
                      const SizedBox(width: 10),
                      Text(
                        value,
                        style: const TextStyle(
                          color: darkColor,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: blackColor,
                    width: 1.0,
                  ),
                ),
              ),
              child: TextButton(
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      _controllers['date']?.text =
                          DateFormat('yyyy-MM-dd').format(picked);
                    });
                  }
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(0),
                  backgroundColor: whiteColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _controllers['date']!.text.isEmpty
                        ? 'Select Date (yyyy-MM-dd)'
                        : _controllers['date']?.text ?? '',
                    style: const TextStyle(color: blackColor),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 36),
            CupertinoButton(
              onPressed: addExpense,
              color: primaryColor,
              child: _isLoading
                  ? const CupertinoActivityIndicator()
                  : const Text('Add Expense'),
            ),
          ],
        ),
      ),
    );
  }
}
