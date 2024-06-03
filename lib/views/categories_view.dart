
import 'package:flutter/material.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({super.key});

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:AppBar(
        title: const Text("Categories",style: TextStyle(fontSize: 20),),
        actions: [
          IconButton(
              onPressed: (){},
              icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
