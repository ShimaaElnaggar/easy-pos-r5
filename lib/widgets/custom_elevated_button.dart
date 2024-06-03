
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final void Function() ? onPressed;
 final  String title;
   const CustomElevatedButton({required this.onPressed,required this.title,super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
            onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
        ),
      ],
    );
  }
}
