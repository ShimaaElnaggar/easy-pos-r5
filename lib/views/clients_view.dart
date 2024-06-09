
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
      body: Container(),
    );
  }
}
