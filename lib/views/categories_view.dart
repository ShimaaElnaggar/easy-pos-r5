import 'package:data_table_2/data_table_2.dart';
import 'package:easy_pos_r5/helpers/sql_helper.dart';
import 'package:easy_pos_r5/views/category_operations_view.dart';
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
      appBar: AppBar(
        title: const Text(
          "Categories",
          style: TextStyle(fontSize: 22),
        ),
        actions: [
          IconButton(
            onPressed: () async{
              var  result = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CategoryOperationsView()),);
              if ( result ?? false) {
                getCategories(); // Refresh categories list
              }
            },

            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: PaginatedDataTable2(
        renderEmptyRowsInTheEnd: false,
        // minWidth: 600, // to be scrollable
        isHorizontalScrollBarVisible: true,
        border: TableBorder.all(),
        wrapInCard: false,
        headingRowColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
        headingTextStyle: const TextStyle(color: Colors.white, fontSize: 18),
        rowsPerPage: 15,
        columnSpacing: 20,
        horizontalMargin: 20,
        empty: const Center(child: Text("No Data Found!")),
        columns: const [
          DataColumn(label: Text("Id")),
          DataColumn(label: Text("Name")),
          DataColumn(label: Text("Description")),
        ],
        source: MyDataTableSource(categoriesList: categories),
      ),
    );
  }
}

class MyDataTableSource extends DataTableSource {
  List<CategoryData>? categoriesList;
  MyDataTableSource({required this.categoriesList});
  @override
  DataRow? getRow(int index) {
    return DataRow2(cells: [
      DataCell(Text("${categoriesList?[index].id}")),
      DataCell(Text("${categoriesList?[index].name}")),
      DataCell(Text("${categoriesList?[index].description}")),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => categoriesList?.length ?? 0;

  @override
  int get selectedRowCount => 0;
}
