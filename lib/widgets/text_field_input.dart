import 'package:expense_tracker_flutter/utils/colors.dart';
import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  final String error;
  final Function(String, String) onBlur;
  final String name;

  const TextFieldInput({
    super.key,
    required this.textEditingController,
    this.isPass = false,
    required this.hintText,
    required this.textInputType,
    required this.error,
    required this.onBlur,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        onBlur(textEditingController.text, name);
      }
    });

    return Container(
      alignment: Alignment.center,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: error.isNotEmpty ? error : hintText,
                labelStyle: TextStyle(
                  color: error.isNotEmpty ? lightWarnColor : primaryColor,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: inputBorderColor),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: lightWarnColor),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: lightWarnColor),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              controller: textEditingController,
              keyboardType: textInputType,
              obscureText: isPass,
              focusNode: focusNode,
            ),
          ],
        ),
      ),
    );
  }
}
