import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginInputField extends StatelessWidget {
  const LoginInputField({
    super.key,
    required this.controller,
    this.errorText,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String? errorText;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      onSubmitted: onSubmitted,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z-]')),
      ],
      decoration: InputDecoration(
        labelText: 'Login',
        hintText: 'Enter login',
        errorText: errorText,
      ),
    );
  }
}
