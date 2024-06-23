import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class CustomDataTable extends StatelessWidget {
  final DataTableSource source;
  final List<DataColumn> columns;
  final double minWidth;
  final bool sortAscending;
  final int? sortColumnIndex;
  const CustomDataTable(
      {
        this.minWidth = 600,
        required this.source,
        required this.columns,
        required this.sortAscending,
        required this.sortColumnIndex,
        super.key,
      });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.white),
      ),
      child: PaginatedDataTable2(
        renderEmptyRowsInTheEnd: false,
        minWidth: minWidth, // to be scrollable
        isHorizontalScrollBarVisible: true,
        border: TableBorder.all(),
        wrapInCard: false,
        sortAscending:sortAscending ,
        sortColumnIndex: sortColumnIndex,
        headingRowColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
        headingTextStyle: const TextStyle(color: Colors.white, fontSize: 18),
        rowsPerPage: 15,
        columnSpacing: 20,
        horizontalMargin: 20,
        empty: const Center(child: Text("No Data Found!")),
        columns: columns,
        source: source,
      ),
    );
  }
}
