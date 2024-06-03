import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  const CustomElevatedButton(
      {required this.onPressed, required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        fixedSize: const Size(double.maxFinite, 60),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }
}
