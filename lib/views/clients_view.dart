import 'package:dynamic_table/dynamic_table.dart';
import 'package:easy_pos_r5/views/clients_operations.dart';
import 'package:easy_pos_r5/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class ClientsView extends StatefulWidget {
  const ClientsView({super.key});

  @override
  State<ClientsView> createState() => _ClientsViewState();
}

class _ClientsViewState extends State<ClientsView> {
  int index =4;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffafafa),
      appBar: CustomAppbar(
        title: 'Clients',
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ClientsOperations()));
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: DynamicTable(
        header: const Text("Person Table"),
        rowsPerPage: 5,
        showFirstLastButtons: true,
        availableRowsPerPage: const [
          5,
          10,
          15,
          20,
        ], // rowsPerPage should be in availableRowsPerPage
        columnSpacing: 60,
        showCheckboxColumn: true,
        onRowsPerPageChanged: (value) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Rows Per Page Changed to $value"),
            ),
          );
        },
        rows: [
          DynamicTableDataRow(
            index: 0,
            cells: [
              DynamicTableDataCell(value: "Name"),

            ],
          ),
        ],
        columns: [
          DynamicTableDataColumn(
              label: const Text("Name"),
              onSort: (columnIndex, ascending) {},
              dynamicTableInputType: DynamicTableTextInput()),

        ],
      ),
    );
  }
}
