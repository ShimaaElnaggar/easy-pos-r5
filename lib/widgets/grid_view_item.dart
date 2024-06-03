
import 'package:flutter/material.dart';

class GridViewItem extends StatelessWidget {
  final String title;
  final Color color;
  final IconData iconData;
  final void Function()? onTab;
  const GridViewItem({
    required this.iconData,
    required this.color,
    required this.title,
    required this.onTab,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTab,
      child: Card(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: CircleAvatar(
                backgroundColor: color.withOpacity(0.3),
                radius: 30,
                child: Icon(iconData,color: color,),
              ),
            ),
            Text(title,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
