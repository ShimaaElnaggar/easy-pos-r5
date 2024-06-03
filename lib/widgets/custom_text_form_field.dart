import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final String label;
  final TextEditingController controller;
  final IconButton? suffixIcon;
  final String? Function(String?)? validator;

  const CustomTextFormField(
      {this.suffixIcon,
      required this.textInputAction,
      required this.keyboardType,
      required this.label,
      required this.controller,
      required this.validator,
      super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autocorrect: true,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        labelText: label,
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).primaryColor, width: 2),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
      ),
      validator: validator,
    );
  }
}
