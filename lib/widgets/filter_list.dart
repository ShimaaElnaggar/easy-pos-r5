import 'package:easy_pos_r5/models/category_data_model.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../helpers/sql_helper.dart';

class FilterList extends StatefulWidget {
  final int? selectedValue;
  final void Function(int?)? onChanged;


  const FilterList({super.key, this.selectedValue, this.onChanged});

  @override
  State<FilterList> createState() => _FilterListState();
}

class _FilterListState extends State<FilterList> {
  List<CategoryData>? categories;
  bool isLoading = false;
  int? selectedValue; // Added selectedValue state variable

  @override
  void initState() {
    super.initState();
    selectedValue = widget.selectedValue; // Initialize selectedValue
    getCategories();
  }

  @override
  void didUpdateWidget(FilterList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedValue != selectedValue) {
      setState(() {
        selectedValue = widget.selectedValue; // Update selectedValue if it changes externally
      });
    }
  }

  void getCategories() async {
    setState(() {
      isLoading = true;
    });

    try {
      var sqlHelper = GetIt.I.get<SqlHelper>();
      var data = await sqlHelper.db!.query('categories');

      setState(() {
        categories = data
            .map((category) => CategoryData.fromJson(category))
            .toList();
        isLoading = false;
      });

      if (widget.selectedValue != null) {
        setState(() {
          selectedValue = widget.selectedValue;
        });
      }


    } catch (e) {
      setState(() {
        isLoading = false;
        categories = [];
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Error in getting categories: $e",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.filter_list,
        size: 18,
      ),
      onPressed: () async {
        try {
          var dialogueResult = await showDialog(
            context: context,
            builder: (context) => CategoryDialog(
              categories: categories,
              selectedValue: selectedValue,
            ),
          );
          if (dialogueResult != null && dialogueResult is int) {
            setState(() {
              selectedValue = dialogueResult;
            });
            widget.onChanged?.call(dialogueResult);
          }
          print('Result of selecting category: $dialogueResult');
        } catch (e) {
          print("Error in selecting category: $e");
        }
      },
    );
  }
}class CategoryDialog extends StatefulWidget {
  final List<CategoryData>? categories;
  final int? selectedValue;

  const CategoryDialog({super.key, this.categories, this.selectedValue});

  @override
  _CategoryDialogState createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<CategoryDialog> {
  int? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.selectedValue;
  }

  @override
  void didUpdateWidget(CategoryDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedValue != selectedValue) {
      setState(() {
        selectedValue = widget.selectedValue;
      });
    }
  }

  void handleCategorySelection(int? value) {
    setState(() {
      selectedValue = value;
    });

  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Select Category"),
      content: widget.categories == null || widget.categories!.isEmpty
          ? const Text('No Data Found')
          : Column(
        mainAxisSize: MainAxisSize.min,
        children: widget.categories!.map((category) {
          return RadioListTile<int>(
            title: Text(category.name!),
            value: category.id!,
            groupValue: selectedValue,
            onChanged: handleCategorySelection,
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, selectedValue); // Pass the selected value back
          },
          child: const Text("Ok"),
        ),
      ],
    );
  }
}