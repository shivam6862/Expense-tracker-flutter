import 'package:flutter/material.dart';
import 'package:expense_tracker_flutter/utils/global_variable.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const ResponsiveLayout({
    Key? key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  }) : super(key: key);

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < sizeOfMobile;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= sizeOfMobile &&
      MediaQuery.of(context).size.width < sizeOfTablet;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= sizeOfTablet;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= sizeOfTablet) {
          return desktop;
        } else if (constraints.maxWidth >= sizeOfMobile) {
          return tablet;
        } else {
          return mobile;
        }
      },
    );
  }
}
