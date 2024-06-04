import 'package:easy_pos_r5/helpers/sql_helper.dart';
import 'package:easy_pos_r5/views/categories_view.dart';
import 'package:easy_pos_r5/views/clients_view.dart';
import 'package:easy_pos_r5/widgets/card_header_item.dart';
import 'package:easy_pos_r5/widgets/grid_view_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isLoading = true;
  bool isTableInitialized = false;
  @override
  void initState() {
    initTables();
    super.initState();
  }

  void initTables() async {
    var sqlHelper = GetIt.I.get<SqlHelper>();
    isTableInitialized = await sqlHelper.createTables();
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffafafa),
      drawer: const Drawer(),
      appBar: AppBar(),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height:
                  kIsWeb? MediaQuery.of(context).size.height / 3 + 65 :
                  MediaQuery.of(context).size.height / 3 + 18,
                  color: Theme.of(context).primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Easy Pos",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Transform.scale(
                                scale: 0.5,
                                child: isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : CircleAvatar(
                                        radius: 10,
                                        backgroundColor: isTableInitialized
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        const CardHeaderItem(
                          title: "Exchange rate",
                          subTitle: "1 USD = 50 Egp",
                        ),
                        const CardHeaderItem(
                          title: "Today's sales",
                          subTitle: "1000 EGP",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                children: [
                  GridViewItem(
                    iconData: Icons.calculate,
                    color: Colors.orange,
                    title: "All Sales",
                    onTab: () {},
                  ),
                  GridViewItem(
                    iconData: Icons.inventory_2,
                    color: Colors.pink,
                    title: "Products",
                    onTab: () {},
                  ),
                  GridViewItem(
                    iconData: Icons.groups,
                    color: Colors.lightBlue,
                    title: "Clients",
                    onTab: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ClientsView(),
                      ));
                    },
                  ),
                  GridViewItem(
                    iconData: Icons.point_of_sale,
                    color: Colors.green,
                    title: "New Sale",
                    onTab: () {},
                  ),
                  GridViewItem(
                    iconData: Icons.category,
                    color: Colors.yellow,
                    title: "Categories",
                    onTab: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const CategoriesView(),
                      ));
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
