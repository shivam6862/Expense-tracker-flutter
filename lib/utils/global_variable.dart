import 'package:expense_tracker_flutter/screens/add_expense_screen.dart';
import 'package:expense_tracker_flutter/screens/analytics_expense_screen.dart';
import 'package:expense_tracker_flutter/screens/home_expense_screen.dart';
import 'package:expense_tracker_flutter/screens/search_expense_screen.dart';
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
  SearchExpenseScreen(uid: FirebaseAuth.instance.currentUser!.uid),
  const AddExpenseScreen(),
  AnalyticsExpenseScreen(uid: FirebaseAuth.instance.currentUser!.uid),
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

List<Color> colors = [
  const Color(0xFF581845),
  const Color(0xFF00D2D3),
  const Color(0xFFFFC300),
  const Color(0xFFC70039),
  const Color(0xFF1287A5),
  const Color(0xFF900C3F),
  const Color(0xFFFF5733),
  const Color(0xFFDAF7A6),
  const Color(0xFFF4D03F),
];
