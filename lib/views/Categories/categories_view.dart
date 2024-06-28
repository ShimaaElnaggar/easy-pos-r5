import 'package:animate_do/animate_do.dart';
import 'package:easy_pos_r5/helpers/sql_helper.dart';
import 'package:easy_pos_r5/views/categories%20Operations/category_operations_view.dart';
import 'package:easy_pos_r5/widgets/custom_appbar.dart';
import 'package:easy_pos_r5/widgets/custom_data_table.dart';
import 'package:easy_pos_r5/widgets/custom_text_form_field.dart';
import 'package:easy_pos_r5/widgets/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../models/category_data_model.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({super.key});

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  List<CategoryData>? categories; // null == loading
  bool sortValue = true;
  int sortColumnIndex = 0;
  int? selectedCategory;
  List<int> selectedCategoryIds = [];

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
        setState(() {
          categories =
              data.map((category) => CategoryData.fromJson(category)).toList();
        });
      } else {
        setState(() {
          categories = [];
        });
      }
    } catch (e) {
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
    return Scaffold(
      backgroundColor: const Color(0xfffafafa),
      appBar: CustomAppbar(title: "Categories", actions: [
        IconButton(
          onPressed: () async {
            var result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CategoryOperationsView()),
            );
            if (result ?? false) {
              getCategories(); // Refresh categories list
            }
          },
          icon: const Icon(Icons.add),
        ),
      ]),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            searchAndFilters(context),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: CustomDataTable(
                sortColumnIndex: sortColumnIndex,
                sortAscending: sortValue,
                columns: [
                  DataColumn(
                    label: const Center(child: Text("Id")),
                    onSort: (columnIndex, ascending) {
                      sort((category) => category.id!, columnIndex, ascending);
                    },
                  ),
                  DataColumn(
                    label: const Center(child: Text("Name")),
                    onSort: (columnIndex, ascending) {
                      sort(
                          (category) => category.name!, columnIndex, ascending);
                    },
                  ),
                  DataColumn(
                    label: const Center(child: Text("Description")),
                    onSort: (columnIndex, ascending) {
                      sort((category) => category.description!, columnIndex,
                          ascending);
                    },
                  ),
                  const DataColumn(label: Center(child: Text("Actions"))),
                ],
                source: CategoriesTableSource(
                  selectedCategories: selectedCategoryIds,
                    categoriesList: categories,
                    onDelete: (categoryData) {
                      onDeleteRow(categoryData.id!);
                    },
                    onUpdate: (categoryData) async {
                      var result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategoryOperationsView(
                                  categoryData: categoryData,
                                )),
                      );
                      if (result ?? false) {
                        getCategories();
                      }
                    },),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row searchAndFilters(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomTextFormField(
            onChanged: (value) async {
              await searchProcess(value);
            },
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.text,
            prefixIcon: IconButton(
                onPressed: () {},
                icon: FadeInLeft(
                  child: Icon(
                    Icons.search,
                    color: Theme.of(context).primaryColor,
                  ),
                )),
            label: "Search",
          ),
        ),
        FilterList(
          selectedValue: selectedCategory,
          onChanged: (value) async {
            setState(() {
              if (selectedCategoryIds.contains(value)) {
                selectedCategoryIds.remove(value); // Deselect the category if already selected
              } else {
                selectedCategoryIds = [value!]; // Select the category
              }
              selectedCategory = value; // Update the selected category
            });
          },
        ),
      ],
    );
  }

  Future<void> searchProcess(String query) async {
    var sqlHelper = GetIt.I.get<SqlHelper>();
    var result = await sqlHelper.db!.rawQuery("""
    SELECT * FROM Categories
    WHERE name LIKE '%$query%' OR description LIKE '%$query%';
  """);
    setState(() {
      categories = result
          .map((map) => CategoryData(
                name: map['name'] as String,
                description: map["description"] as String,
                id: map['id'] as int,
              ))
          .toList();
    });
  }

  Future<void> onDeleteRow(int id) async {
    try {
      var dialogueResult = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Delete Category"),
              content:
                  const Text("Are you sure you want to delete this category?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text("Delete"),
                ),
              ],
            );
          });
      if (dialogueResult ?? false) {
        var sqlHelper = GetIt.I.get<SqlHelper>();
        var result = await sqlHelper.db!
            .delete('categories', where: 'id =?', whereArgs: [id]);
        if (result > 0) {
          getCategories();
          print("Row deleted Successfully!");
        }
      }
    } catch (e) {
      print("Error in deleting row : $e");
    }
  }

  void sort(Comparable? Function(CategoryData category) getField,
      int columnIndex, bool ascending) {
    categories?.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue!, bValue!)
          : Comparable.compare(bValue!, aValue!);
    });
    setState(() {
      sortColumnIndex = columnIndex;
      sortValue = ascending;
    });
  }
}

class CategoriesTableSource extends DataTableSource {
  List<CategoryData>? categoriesList;
  void Function(CategoryData) onDelete;
  void Function(CategoryData) onUpdate;
  List<int> selectedCategories; // Updated to a list of selected category IDs

  CategoriesTableSource({
    required this.categoriesList,
    required this.onDelete,
    required this.onUpdate,
    required this.selectedCategories,
  });

  @override
  DataRow? getRow(int index) {
    final category = categoriesList![index];

    if (selectedCategories.isNotEmpty &&
        !selectedCategories.contains(category.id)) {
      return null;
    }

    return DataRow(cells: [
      DataCell(Center(child: Text("${category.id}"))),
      DataCell(Center(child: Text("${category.name}"))),
      DataCell(Center(child: Text("${category.description}"))),
      DataCell(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                onUpdate(category);
              },
              icon: const Icon(
                Icons.edit,
                color: Color(0xff0157DB),
              ),
            ),
            IconButton(
              onPressed: () async {
                onDelete(category);
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount {
    if (selectedCategories.isNotEmpty) {
      return categoriesList!
          .where((category) => selectedCategories.contains(category.id))
          .length;
    }

    return categoriesList?.length ?? 0;
  }


  @override
  int get selectedRowCount => selectedCategories.length;
}
