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
      return Future.error(e.toString());
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
}
