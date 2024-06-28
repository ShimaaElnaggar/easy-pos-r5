import 'package:animate_do/animate_do.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:easy_pos_r5/helpers/sql_helper.dart';
import 'package:easy_pos_r5/models/client_data_model.dart';
import 'package:easy_pos_r5/views/Clients%20Operations/clients_operations.dart';
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
  int sortColumnIndex = 0;
  bool sortValue = true;
  @override
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

  void sort(Comparable? Function(ClientData client) getField, int columnIndex,
      bool ascending) {
    clients?.sort((a, b) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffafafa),
      appBar: CustomAppbar(
        title: 'Clients',
        actions: [
          IconButton(
            onPressed: () async {
              var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ClientsOperations()));
              if (result ?? false) {
                getClients(); // Refresh categories list
              }
            },
            icon: const Icon(Icons.add),
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
                sortColumnIndex: sortColumnIndex,
                sortAscending: sortValue,
                columns: [
                  DataColumn(
                    label: const Center(child: Text("Id")),
                    onSort: (columnIndex, ascending) {
                      sort((client) => client.id!, columnIndex, ascending);
                    },
                  ),
                  DataColumn(
                    label: const Center(child: Text("Name")),
                    onSort: (columnIndex, ascending) {
                      sort((client) => client.name!, columnIndex, ascending);
                    },
                  ),
                  DataColumn(
                    label: const Center(child: Text("phone")),
                    onSort: (columnIndex, ascending) {
                      sort((client) => client.phone!, columnIndex, ascending);
                    },
                  ),
                  DataColumn(
                    label: const Center(child: Text("Address")),
                    onSort: (columnIndex, ascending) {
                      sort((client) => client.address!, columnIndex, ascending);
                    },
                  ),
                  const DataColumn(label: Center(child: Text("Actions"))),
                ],
                source: ClientsTableSource(
                    clientsList: clients,
                    onDelete: (clientData) {
                      onDeleteRow(clientData.id!);
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
    );
  }

  Future<void> searchProcess(String query) async {
    var sqlHelper = GetIt.I.get<SqlHelper>();
    var result = await sqlHelper.db!.rawQuery("""
               SELECT * FROM clients
               WHERE name LIKE '%$query%';
              """);
    setState(() {
      clients = result
          .map((map) => ClientData(
                name: map['name'] as String,
        id: map['id'] as int,
        phone: map['phone'] as String,
        address: map['name'] as String,
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
    return DataRow2(cells: [
      DataCell(Center(child: Text("${clientsList?[index].id}"))),
      DataCell(Center(child: Text("${clientsList?[index].name}"))),
      DataCell(Center(child: Text("${clientsList?[index].phone}"))),
      DataCell(Center(child: Text("${clientsList?[index].address}"))),
      DataCell(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  onUpdate(clientsList![index]);
                },
                icon: const Icon(
                  Icons.edit,
                  color: Color(0xff0157DB),
                )),
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
