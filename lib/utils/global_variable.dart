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
  const Text('Home'),
  const Text('Search'),
  const Text("Add"),
  const Text("Notification"),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
