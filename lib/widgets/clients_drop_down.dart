import 'dart:ui';
import 'package:easy_pos_r5/helpers/sql_helper.dart';
import 'package:easy_pos_r5/models/client_data_model.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ClientsDropDown extends StatefulWidget {
  final int? selectedValue;
  final void Function(int?)? onChanged;
  const ClientsDropDown(
      {this.selectedValue, required this.onChanged, super.key});

  @override
  State<ClientsDropDown> createState() => _ClientsDropDownState();
}

class _ClientsDropDownState extends State<ClientsDropDown> {
  List<ClientData>? clients;
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
            "Error in get client : $e",
          ),
        ),
      );
      clients = [];
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return clients == null
        ? const Center(child: CircularProgressIndicator())
        : (clients?.isEmpty ?? false)
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
                      "Select Client ",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    items: [
                      for (var client in clients!)
                        DropdownMenuItem(
                          value: client.id,
                          child: Text(client.name ?? "No Name"),
                        )
                    ],
                    onChanged: widget.onChanged,
                  ),
                ),
              );
  }
}
