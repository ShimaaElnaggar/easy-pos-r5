
import 'package:flutter/material.dart';

class CardHeaderItem extends StatelessWidget {
  final String subTitle;
  final String title;
  const CardHeaderItem({
    required this.subTitle,
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Card(
        elevation: 0,
        color: const Color(0xff206ce1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                    color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                subTitle,
                style: const  TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w200,
              ),),
            ],
          ),
        ),
      ),
    );
  }
}