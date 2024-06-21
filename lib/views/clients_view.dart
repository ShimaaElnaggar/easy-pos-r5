
import 'package:data_table_2/data_table_2.dart';
import 'package:easy_pos_r5/helpers/sql_helper.dart';
import 'package:easy_pos_r5/models/client_data_model.dart';
import 'package:easy_pos_r5/views/clients_operations.dart';
import 'package:easy_pos_r5/widgets/custom_appbar.dart';
import 'package:easy_pos_r5/widgets/custom_data_table.dart';
import 'package:easy_pos_r5/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ClientsView extends StatefulWidget {
  const ClientsView({super.key});

  @override
  State<ClientsView> createState() => _ClientsViewState();
}

class _ClientsViewState extends State<ClientsView> {
  List<ClientData>? clients;
  void initState() {
    getClients();
    super.initState();
  }

  void getClients() async {
    try {
      var sqlHelper = GetIt.I.get<SqlHelper>();
      var data = await sqlHelper.db!.query('clients');

      if (data.isNotEmpty) {
        clients = [];
        for (var client in data) {
          clients!.add(ClientData.fromJson(client));
        }
      } else {
        clients = [];
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Error in get clients : $e",
          ),
        ),
      );
      clients = [];
    }
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffafafa),
      appBar: CustomAppbar(
        title: 'Clients',
        actions: [
          IconButton(
            onPressed: () async{
             var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ClientsOperations()));
              if (result ?? false) {
                getClients(); // Refresh categories list
              }
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            search(context),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: CustomDataTable(
                  columns:const [
                    DataColumn(label: Text("Id")),
                    DataColumn(label: Text("Name")),
                    DataColumn(label: Text("phone")),
                    DataColumn(label: Text("Address")),
                    DataColumn(label: Center(child: Text("Actions"))),
                  ],
                source: ClientsTableSource(
                    clientsList: clients,
                    onDelete: (categoryData) {
                      onDeleteRow(categoryData.id!);
                    },
                    onUpdate: (clientData) async {
                      var result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ClientsOperations(
                              clientData: clientData,
                            )),
                      );
                      if (result ?? false) {
                        getClients(); // Refresh categories list
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  CustomTextFormField search(BuildContext context) {
    return CustomTextFormField(
            onChanged: (value) async {
              await filterClients(value);
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
          );
  }

  Future<void> filterClients(String query) async {
    var sqlHelper = GetIt.I.get<SqlHelper>();
    var result = await sqlHelper.db!.rawQuery("""
               SELECT * FROM clients
               WHERE name LIKE '%$query%';
              """);
    setState(() {
      clients = result.map((map) => ClientData(
          name: map['name']as String,
      )).toList();
    });
  }

  Future<void> onDeleteRow(int id) async {
    try {
      var dialogueResult = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Delete Client"),
              content:
              const Text("Are you sure you want to delete this client?"),
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
            .delete('clients', where: 'id =?', whereArgs: [id]);
        if (result > 0) {
          getClients();
          print("Row deleted Successfully!");
        }
      }
    } catch (e) {
      print("Error in deleting row : $e");
    }
  }
}

class ClientsTableSource extends DataTableSource {
  List<ClientData>? clientsList;
  void Function(ClientData) onDelete;
  void Function(ClientData) onUpdate;
  ClientsTableSource(
      {required this.clientsList,
        required this.onDelete,
        required this.onUpdate});
  @override
  DataRow? getRow(int index) {
    return DataRow2(
        cells: [
          DataCell(Text("${clientsList?[index].id}")),
          DataCell(Text("${clientsList?[index].name}")),
          DataCell(Text("${clientsList?[index].phone}")),
          DataCell(Text("${clientsList?[index].address}")),
          DataCell(
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      onUpdate(clientsList![index]);
                    },
                    icon: const Icon(Icons.edit)),
                IconButton(
                    onPressed: () async {
                      onDelete(clientsList![index]);
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
  int get rowCount => clientsList?.length ?? 0;

  @override
  int get selectedRowCount => 0;
}