import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_flutter/resources/auth_methods.dart';
import 'package:expense_tracker_flutter/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker_flutter/utils/colors.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
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
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      userData = userSnap.data()!;
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

  String capitalize(String text) {
    if (text.isEmpty) {
      return text;
    }
    return text[0].toUpperCase() + text.substring(1);
  }

  void openEditProfileDialog() {
    final Map<String, TextEditingController> controllers = {
      'username': TextEditingController(),
      'about': TextEditingController(),
    };

    controllers['username']!.text = userData['username'];
    controllers['about']!.text = userData['about'];

    void updateProfile() async {
      final String username = controllers['username']!.text;
      final String about = controllers['about']!.text;
      final String email = userData['email'];
      final String photoUrl = userData['photoUrl'];

      if (username.isNotEmpty && about.isNotEmpty) {
        String res = await AuthMethods().updateProfile(
          username: username,
          about: about,
          email: email,
          photoUrl: photoUrl,
        );

        if (res == 'success') {
          setState(() {
            userData['username'] = username;
            userData['about'] = about;
          });
          if (mounted) {
            showSnackBar(
              context,
              'Profile Updated Successfully',
            );
            Navigator.of(context).pop();
          }
        }
      } else {
        showSnackBar(
          context,
          'Please fill all the fields',
        );
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Edit Profile'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: whiteColor,
          shadowColor: whiteColor,
          surfaceTintColor: whiteColor,
          children: [
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: const TextStyle(
                    color: darkColor,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: darkColor),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                controller: controllers['username'],
                keyboardType: TextInputType.text,
                cursorColor: darkColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'About',
                  labelStyle: const TextStyle(
                    color: darkColor,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: darkColor),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                controller: controllers['about'],
                keyboardType: TextInputType.text,
                cursorColor: darkColor,
                maxLines: 3,
                minLines: 1,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: updateProfile,
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Update'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: bgPrimary,
              title: Text(capitalize(userData['username']),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
              centerTitle: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: openEditProfileDialog,
                ),
              ],
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: primaryColor,
                            backgroundImage: NetworkImage(
                              userData['photoUrl'],
                            ),
                            radius: 50,
                          )
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 15,
                        ),
                        child: Text(
                          userData['email'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 6,
                        ),
                        child: Text(
                          userData['about'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                await AuthMethods().signOut(context);
              },
              child: const Icon(Icons.logout),
            ),
          );
  }
}
