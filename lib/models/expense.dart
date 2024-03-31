import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final String title;
  final String description;
  final String amount;
  final String date;
  final String category;
  final String userId;
  final String id;

  const Expense({
    required this.title,
    required this.description,
    required this.amount,
    required this.date,
    required this.category,
    required this.userId,
    required this.id,
  });

  static Expense fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Expense(
      title: snapshot["title"],
      description: snapshot["description"],
      amount: snapshot["amount"],
      date: snapshot["date"],
      category: snapshot["category"],
      userId: snapshot["userId"],
      id: snapshot["id"],
    );
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "amount": amount,
        "date": date,
        "category": category,
        "userId": userId,
        "id": id,
      };
}
