import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final String label;
  final TextEditingController? controller ;
  final IconButton? suffixIcon;
  final IconButton? prefixIcon;
  final void Function (String)? onChanged;
  final String? Function(String?)? validator;
  final InputBorder ? border;

  const CustomTextFormField(
      {
        this.suffixIcon,
        this.controller ,
        this.validator,
        this.prefixIcon,
        this.onChanged,
        this.border,
      required this.textInputAction,
      required this.keyboardType,
      required this.label,
      super.key,});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autocorrect: true,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        labelText: label,
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).primaryColor, width: 2),
        ),
        border: border,
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
