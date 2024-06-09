import 'package:data_table_2/data_table_2.dart';
import 'package:easy_pos_r5/helpers/sql_helper.dart';
import 'package:easy_pos_r5/views/category_operations_view.dart';
import 'package:easy_pos_r5/widgets/custom_appbar.dart';
import 'package:easy_pos_r5/widgets/custom_data_table.dart';
import 'package:easy_pos_r5/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../models/category_data_model.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({super.key});

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
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
            CustomTextFormField(
              onChanged: (value) async {
                var sqlHelper = GetIt.I.get<SqlHelper>();
                var result = await sqlHelper.db!.rawQuery("""
                 SELECT * FROM Categories
                 WHERE name LIKE '%$value%' OR description LIKE '%$value%';
                """);

                print('values:$result');
              },
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              prefixIcon: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.search,
                    color: Theme.of(context).primaryColor,
                  )),
              label: "Search",
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: CustomDataTable(
                columns: const [
                  DataColumn(label: Text("Id")),
                  DataColumn(label: Text("Name")),
                  DataColumn(label: Text("Description")),
                  DataColumn(label: Center(child: Text("Actions"))),
                ],
                source: CategoriesTableSource(
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
                        getCategories(); // Refresh categories list
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
    );
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
}

class CategoriesTableSource extends DataTableSource {
  List<CategoryData>? categoriesList;
  void Function(CategoryData) onDelete;
  void Function(CategoryData) onUpdate;
  CategoriesTableSource(
      {required this.categoriesList,
      required this.onDelete,
      required this.onUpdate});
  @override
  DataRow? getRow(int index) {
    return DataRow2(
        //onSelectChanged: (value){},
        cells: [
          DataCell(Text("${categoriesList?[index].id}")),
          DataCell(Text("${categoriesList?[index].name}")),
          DataCell(Text("${categoriesList?[index].description}")),
          DataCell(
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      onUpdate(categoriesList![index]);
                    },
                    icon: const Icon(Icons.edit)),
                IconButton(
                    onPressed: () async {
                      onDelete(categoriesList![index]);
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    )),
              ],
            ),
          ),
        ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => categoriesList?.length ?? 0;

  @override
  int get selectedRowCount => 0;
}
