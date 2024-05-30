
import 'package:flutter/material.dart';

class RowHeader extends StatelessWidget {
  const RowHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          "Easy Pos",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight:FontWeight.w800,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Transform.scale(
              scale: 0.5,
              child: const CircularProgressIndicator(color: Colors.white,)),
        )
      ],
    );
  }
}