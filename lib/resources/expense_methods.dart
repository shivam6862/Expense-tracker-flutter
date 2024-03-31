import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expense_tracker_flutter/models/expense.dart' as model;
import 'package:uuid/uuid.dart';

class ExpenseMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> addExpense({
    required String title,
    required String description,
    required String amount,
    required String category,
    required String date,
  }) async {
    String res = "Some error Occurred";
    User currentUser = _auth.currentUser!;
    String userId = currentUser.uid;
    String id = const Uuid().v1();

    try {
      model.Expense expense = model.Expense(
        title: title,
        description: description,
        amount: amount,
        category: category,
        date: date,
        userId: userId,
        id: id,
      );
      await _firestore.collection('expenses').doc(id).set(expense.toJson());
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<List<Map<String, dynamic>>> getExpenses() {
    User currentUser = _auth.currentUser!;
    String userId = currentUser.uid;

    try {
      return _firestore
          .collection('expenses')
          .where('userId', isEqualTo: userId)
          .get()
          .then((QuerySnapshot querySnapshot) {
        List<Map<String, dynamic>> expenses = [];
        for (var doc in querySnapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          expenses.add(data);
        }
        expenses.sort((a, b) {
          return DateTime.parse(a['date']).compareTo(DateTime.parse(b['date']));
        });
        return expenses;
      });
    } catch (e) {
      return Future.value([]);
    }
  }

  Future<String> deleteExpense(String id) async {
    String res = "Some error Occurred";
    try {
      await _firestore.collection('expenses').doc(id).delete();
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> updateExpense({
    required String title,
    required String description,
    required String amount,
    required String category,
    required String date,
    required String id,
  }) async {
    String res = "Some error Occurred";
    try {
      model.Expense expense = model.Expense(
        title: title,
        description: description,
        amount: amount,
        category: category,
        date: date,
        userId: _auth.currentUser!.uid,
        id: id,
      );
      await _firestore.collection('expenses').doc(id).update(expense.toJson());
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<List<Map<String, dynamic>>> searchExpenses(String search) {
    User currentUser = _auth.currentUser!;
    String userId = currentUser.uid;

    search = search[0].toUpperCase() + search.substring(1);

    try {
      return _firestore
          .collection('expenses')
          .where('userId', isEqualTo: userId)
          .where('category', isEqualTo: search)
          .get()
          .then((QuerySnapshot querySnapshot) {
        List<Map<String, dynamic>> expenses = [];
        for (var doc in querySnapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          expenses.add(data);
        }
        expenses.sort((a, b) {
          return DateTime.parse(a['date']).compareTo(DateTime.parse(b['date']));
        });
        return expenses;
      });
    } catch (e) {
      return Future.value([]);
    }
  }

  Future<Map<String, double>> getExpensesByCategory() async {
    User currentUser = FirebaseAuth.instance.currentUser!;
    String userId = currentUser.uid;
    Map<String, double> expensesByCategory = {};

    try {
      await FirebaseFirestore.instance
          .collection('expenses')
          .where('userId', isEqualTo: userId)
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          if (expensesByCategory.containsKey(data['category'])) {
            expensesByCategory[data['category']] =
                expensesByCategory[data['category']]! +
                    double.parse(data['amount']);
          } else {
            expensesByCategory[data['category']] = double.parse(data['amount']);
          }
        }
      });
    } catch (e) {
      return {};
    }
    return expensesByCategory;
  }

  Future<Map<String, double>> getExpensesByDate() async {
    User currentUser = FirebaseAuth.instance.currentUser!;
    String userId = currentUser.uid;
    Map<String, double> expensesByDay = {};

    try {
      await FirebaseFirestore.instance
          .collection('expenses')
          .where('userId', isEqualTo: userId)
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          if (expensesByDay.containsKey(data['date'])) {
            expensesByDay[data['date']] =
                expensesByDay[data['date']]! + double.parse(data['amount']);
          } else {
            expensesByDay[data['date']] = double.parse(data['amount']);
          }
        }
      });
    } catch (e) {
      return {};
    }
    expensesByDay = Map.fromEntries(
      expensesByDay.entries.toList()
        ..sort((e1, e2) =>
            DateTime.parse(e1.key).compareTo(DateTime.parse(e2.key))),
    );
    return expensesByDay;
  }
}
