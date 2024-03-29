import 'package:expense_tracker_flutter/resources/auth_methods.dart';
import 'package:expense_tracker_flutter/responsive/desktop_screen_layout.dart';
import 'package:expense_tracker_flutter/responsive/mobile_screen_layout.dart';
import 'package:expense_tracker_flutter/responsive/responsive_layout.dart';
import 'package:expense_tracker_flutter/responsive/tablet_screen_layout.dart';
import 'package:expense_tracker_flutter/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:expense_tracker_flutter/screens/signup_screen.dart';
import 'package:expense_tracker_flutter/utils/colors.dart';
import 'package:expense_tracker_flutter/utils/global_variable.dart';
import 'package:expense_tracker_flutter/widgets/text_field_input.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final Map<String, TextEditingController> _controllers = {
    'email': TextEditingController(),
    'password': TextEditingController(),
  };
  final Map<String, String> _errors = {
    'email': '',
    'password': '',
  };
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _controllers.forEach((key, value) {
      value.dispose();
    });
    _errors.clear();
  }

  void signInUser() async {
    setState(() {
      _isLoading = true;
    });

    String response = await AuthMethods().loginUser(
        email: _controllers['email']!.text,
        password: _controllers['password']!.text);

    setState(() {
      _isLoading = false;
    });

    if (response == 'success') {
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ResponsiveLayout(
              mobile: MobileScreenLayout(),
              tablet: TabletScreenLayout(),
              desktop: DesktopScreenLayout(),
            ),
          ),
        );
      }
    } else {
      if (context.mounted) {
        showSnackBar(context, response);
      }
    }
  }

  void handleOnBlur(value, key) {
    if (value.isEmpty) {
      setState(() {
        _errors[key] = 'The $key is required.';
      });
    } else {
      setState(() {
        _errors[key] = '';
      });
    }
  }

  bool get isFormValid {
    return _controllers.values
            .every((controller) => controller.text.isNotEmpty) &&
        _errors.values.every((error) => error.isEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: MediaQuery.of(context).size.width > webScreenSize
              ? EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 3)
              : const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 2,
                child: Container(),
              ),
              SvgPicture.asset(
                'assets/logo.svg',
                color: primaryColor,
                height: 64,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                  hintText: 'Enter your email',
                  textInputType: TextInputType.emailAddress,
                  textEditingController: _controllers['email']!,
                  error: _errors['email']!,
                  onBlur: (value, key) => handleOnBlur(value, key),
                  name: 'email'),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                  hintText: 'Enter your password',
                  textInputType: TextInputType.text,
                  textEditingController: _controllers['password']!,
                  isPass: true,
                  error: _errors['password']!,
                  onBlur: (value, key) => handleOnBlur(value, key),
                  name: 'password'),
              const SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: isFormValid ? signInUser : null,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    color: darkIconsColor,
                  ),
                  child: !_isLoading
                      ? const Text(
                          'Sign in',
                        )
                      : const CircularProgressIndicator(
                          color: darkColor,
                          strokeWidth: 3,
                        ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Flexible(
                flex: 2,
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      'Dont have an account?',
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SignupScreen())),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        ' Signup.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
