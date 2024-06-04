
import 'package:easy_pos_r5/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class ClientsView extends StatefulWidget {
  const ClientsView({super.key});

  @override
  State<ClientsView> createState() => _ClientsViewState();
}

class _ClientsViewState extends State<ClientsView> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Color(0xfffafafa),
      appBar: CustomAppbar(
        title: 'Clients',
        actions: [
          IconButton(
              onPressed: (){},
              icon: Icon(Icons.add),
          )
        ],
      ),
    );
  }
}
