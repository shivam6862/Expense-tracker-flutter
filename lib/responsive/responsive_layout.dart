import 'package:flutter/material.dart';
import 'package:expense_tracker_flutter/providers/user_provider.dart';
import 'package:expense_tracker_flutter/utils/global_variable.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const ResponsiveLayout({
    Key? key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  }) : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= sizeOfTablet) {
          return widget.desktop;
        } else if (constraints.maxWidth >= sizeOfMobile) {
          return widget.tablet;
        } else {
          return widget.mobile;
        }
      },
    );
  }
}
