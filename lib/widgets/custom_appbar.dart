import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
 final List<Widget>? actions;
  const CustomAppbar(
      {required this.title, required this.actions, super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title:  Text(
        title,
        style: const TextStyle(fontSize: 22),
      ),
      actions: actions,
    );
  }

  @override

  Size get preferredSize => throw UnimplementedError();
}
