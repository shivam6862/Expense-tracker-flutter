import 'package:expense_tracker_flutter/screens/add_expense_screen.dart';
import 'package:expense_tracker_flutter/screens/home_expense_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker_flutter/screens/profile_screen.dart';

const sizeOfMobile = 768.0;
const sizeOfTablet = 1024.0;
const sizeOfDesktop = 1440.0;
const sizeOfLargeDesktop = 1920.0;

const webScreenSize = 600;
const githubImage = "https://avatars.githubusercontent.com/u/115404926?v=4";

List<Widget> homeScreenItems = [
  HomeExpenseScreen(uid: FirebaseAuth.instance.currentUser!.uid),
  const Text('Search'),
  const AddExpenseScreen(),
  const Text("Analytics"),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];

Map<String, IconData> categoryIcons = {
  'Food': Icons.fastfood,
  'Transport': Icons.directions_bus,
  'Shopping': Icons.shopping_cart,
  'Health': Icons.local_hospital,
  'Entertainment': Icons.movie,
  'Others': Icons.category,
};

List<String> categories = categoryIcons.keys.toList();
