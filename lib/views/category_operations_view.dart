
import 'package:flutter/material.dart';

class CategoryOperationsView extends StatefulWidget {
  const CategoryOperationsView({super.key});

  @override
  State<CategoryOperationsView> createState() => _CategoryOperationsViewState();
}

class _CategoryOperationsViewState extends State<CategoryOperationsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New"),
      ),
    );
  }
}
