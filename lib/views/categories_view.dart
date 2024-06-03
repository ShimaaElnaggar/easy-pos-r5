
import 'package:data_table_2/data_table_2.dart';
import 'package:easy_pos_r5/views/category_operations_view.dart';
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
      backgroundColor: const Color(0xfffafafa),
      appBar:AppBar(
        title: const Text("Categories",style: TextStyle(fontSize: 22),),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const CategoryOperationsView()));
              },
              icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: PaginatedDataTable2(
        renderEmptyRowsInTheEnd: false,
        minWidth: 600, // to be scrollable
        isHorizontalScrollBarVisible: true,
        border: TableBorder.all(),
        wrapInCard:false,
       headingRowColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
       headingTextStyle: const TextStyle(color: Colors.white,fontSize: 18),
       rowsPerPage: 15,
          columnSpacing: 20,
          horizontalMargin: 20,
          columns: const[
             DataColumn(label: Text("Category")),
             DataColumn(label: Text("Description")),
             DataColumn(label: Text("Actions")),
          ],
          source: MyDataTableSource(),
      ),
    );
  }
}
class MyDataTableSource extends DataTableSource{
  @override
  DataRow? getRow(int index) {
    return DataRow2(
        cells:[
         DataCell(Text("Category $index")),
          DataCell(Text("Description $index")),
          DataCell(Text("Actions $index")),
        ]
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override

  int get rowCount => 25;

  @override

  int get selectedRowCount => 0;

}
