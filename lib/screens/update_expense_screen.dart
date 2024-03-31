import 'package:expense_tracker_flutter/resources/expense_methods.dart';
import 'package:expense_tracker_flutter/utils/colors.dart';
import 'package:expense_tracker_flutter/utils/global_variable.dart';
import 'package:expense_tracker_flutter/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UpdateExpenseScreen extends StatefulWidget {
  final String id;
  final Map<String, dynamic> expense;

  const UpdateExpenseScreen(
      {super.key, required this.id, required this.expense});

  @override
  State<UpdateExpenseScreen> createState() => _UpdateExpenseScreenState();
}

class _UpdateExpenseScreenState extends State<UpdateExpenseScreen> {
  final Map<String, TextEditingController> _controllers = {
    'title': TextEditingController(),
    'description': TextEditingController(),
    'amount': TextEditingController(),
    'date': TextEditingController(),
  };

  bool _isLoading = false;
  String dropdownCategoryValue = 'Food';

  @override
  void initState() {
    super.initState();
    _controllers['title']!.text = widget.expense['title'];
    _controllers['description']!.text = widget.expense['description'];
    _controllers['amount']!.text = widget.expense['amount'];
    _controllers['date']!.text = widget.expense['date'];
    dropdownCategoryValue = widget.expense['category'];
  }

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

  void updateExpense() async {
    if (!isFormValid) {
      showSnackBar(context, 'Please fill all the fields.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String response = await ExpenseMethods().updateExpense(
      id: widget.id,
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
        showSnackBar(context, 'Expense updated successfully.');
        Navigator.pop(context);
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
        title: const Text('Update Expense'),
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
              keyboardType: TextInputType.number,
              style: const TextStyle(
                color: blackColor,
              ),
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
            TextField(
              controller: _controllers['date'],
              decoration: const InputDecoration(
                labelText: 'Date',
              ),
              readOnly: true,
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2015, 8),
                  lastDate: DateTime(2101),
                );
                if (picked != null) {
                  _controllers['date']!.text =
                      DateFormat('yyyy-MM-dd').format(picked);
                }
              },
            ),
            const SizedBox(height: 36),
            CupertinoButton(
              onPressed: updateExpense,
              color: primaryColor,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Update Expense'),
            ),
          ],
        ),
      ),
    );
  }
}
