import 'dart:ui';

import 'package:easy_pos_r5/helpers/sql_helper.dart';
import 'package:easy_pos_r5/models/category_data_model.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class CategoriesDropDown extends StatefulWidget {
  final int? selectedValue;
  final void Function(int?)? onChanged;
  const CategoriesDropDown(
      {this.selectedValue, required this.onChanged, super.key});

  @override
  State<CategoriesDropDown> createState() => _CategoriesDropDownState();
}

class _CategoriesDropDownState extends State<CategoriesDropDown> {
  List<CategoryData>? categories; // null == loading
  @override
  void initState() {
    getCategories();
    super.initState();
  }

  void getCategories() async {
    try {
      var sqlHelper = GetIt.I.get<SqlHelper>();
      var data = await sqlHelper.db!.query('categories');

      if (data.isNotEmpty) {
        categories = [];
        for (var category in data) {
          categories!.add(CategoryData.fromJson(category));
        }
      } else {
        categories = [];
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Error in get category : $e",
          ),
        ),
      );
      categories = [];
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return categories == null
        ? const Center(child: CircularProgressIndicator())
        : (categories?.isEmpty ?? false)
            ? const Text("No Data Found")
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.black),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: DropdownButton(
                    isExpanded: true,
                    underline: const SizedBox(),
                    value: widget.selectedValue,
                    hint: const Text(
                      "Select Category",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    items: [
                      for (var category in categories!)
                        DropdownMenuItem(
                          value: category.id,
                          child: Text(category.name ?? "No Name"),
                        )
                    ],
                    onChanged: widget.onChanged,
                  ),
                ),
              );
  }
}
