import 'dart:typed_data';
import 'package:expense_tracker_flutter/resources/auth_methods.dart';
import 'package:expense_tracker_flutter/responsive/responsive_layout.dart';
import 'package:expense_tracker_flutter/responsive/desktop_screen_layout.dart';
import 'package:expense_tracker_flutter/responsive/mobile_screen_layout.dart';
import 'package:expense_tracker_flutter/responsive/tablet_screen_layout.dart';
import 'package:expense_tracker_flutter/screens/signin_screen.dart';
import 'package:expense_tracker_flutter/utils/colors.dart';
import 'package:expense_tracker_flutter/utils/global_variable.dart';
import 'package:expense_tracker_flutter/utils/utils.dart';
import 'package:expense_tracker_flutter/widgets/text_field_input.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final Map<String, TextEditingController> _controllers = {
    'username': TextEditingController(),
    'email': TextEditingController(),
    'password': TextEditingController(),
    'about': TextEditingController(),
  };
  final Map<String, String> _errors = {
    'username': '',
    'email': '',
    'password': '',
    'about': '',
  };
  bool _isLoading = false;
  Uint8List? _image;

  @override
  void dispose() {
    super.dispose();
    _controllers.forEach((key, value) {
      value.dispose();
    });
    _errors.clear();
  }

  bool get isFormValid {
    return _controllers.values
            .every((controller) => controller.text.isNotEmpty) &&
        _errors.values.every((error) => error.isEmpty) &&
        _image != null;
  }

  void signUpUser() async {
    if (!isFormValid) {
      showSnackBar(context, 'Please fill all the fields.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String response = await AuthMethods().signUpUser(
        username: _controllers['username']!.text,
        email: _controllers['email']!.text,
        password: _controllers['password']!.text,
        about: _controllers['about']!.text,
        file: _image!);

    setState(() {
      _isLoading = false;
    });

    if (response == 'success') {
      if (mounted) {
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
      if (mounted) {
        showSnackBar(context, response);
      }
    }
  }

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
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
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                          backgroundColor: iconsColor,
                        )
                      : const CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(githubImage),
                          backgroundColor: iconsColor,
                        ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: 'Enter your username',
                textInputType: TextInputType.text,
                textEditingController: _controllers['username']!,
                error: _errors['username'] ?? '',
                onBlur: (value, key) => handleOnBlur(value, key),
                name: 'username',
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: 'Enter your email',
                textInputType: TextInputType.emailAddress,
                textEditingController: _controllers['email']!,
                error: _errors['email'] ?? '',
                onBlur: (value, key) => handleOnBlur(value, key),
                name: 'email',
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: 'Enter your password',
                textInputType: TextInputType.text,
                textEditingController: _controllers['password']!,
                isPass: true,
                error: _errors['password'] ?? '',
                onBlur: (value, key) => handleOnBlur(value, key),
                name: 'password',
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: 'Enter about yourself',
                textInputType: TextInputType.text,
                textEditingController: _controllers['about']!,
                error: _errors['about'] ?? '',
                onBlur: (value, key) => handleOnBlur(value, key),
                name: 'about',
              ),
              const SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: signUpUser,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    color: primaryColor,
                  ),
                  child: !_isLoading
                      ? const Text(
                          'Sign up',
                        )
                      : const CircularProgressIndicator(
                          color: darkColor,
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
                      'Already have an account?',
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SignInScreen(),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        ' Sign in.',
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
