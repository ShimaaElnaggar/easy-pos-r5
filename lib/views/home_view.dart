import 'package:easy_pos_r5/helpers/sql_helper.dart';
import 'package:easy_pos_r5/models/exchange_rate_model.dart';
import 'package:easy_pos_r5/views/all_sales_view.dart';
import 'package:easy_pos_r5/views/categories_view.dart';
import 'package:easy_pos_r5/views/clients_view.dart';
import 'package:easy_pos_r5/views/products_view.dart';
import 'package:easy_pos_r5/views/sales_ops_view.dart';
import 'package:easy_pos_r5/widgets/card_header_item.dart';
import 'package:easy_pos_r5/widgets/grid_view_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomeView extends StatefulWidget {
  final ExchangeRate? exchangeRate;
  const HomeView({this.exchangeRate, super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isLoading = true;
  bool isTableInitialized = false;
  List<ExchangeRate>? exchangeRates;

  @override
  void initState() {
    initTables();
    super.initState();
  }

  void initTables() async {
    var sqlHelper = GetIt.I.get<SqlHelper>();
    isTableInitialized = await sqlHelper.createTables();
    isLoading = false;
    setState(() {
    });

    await insertRate();
    getExchangeRate();
  }

  void getExchangeRate() async {
    try {
      var sqlHelper = GetIt.I.get<SqlHelper>();
      var data = await sqlHelper.db!.query('exchangeRate');

      if (data.isNotEmpty) {
        exchangeRates = [];
        for (var rate in data) {
          exchangeRates!.add(ExchangeRate.fromJson(rate));
        }
      } else {
        exchangeRates = [];
      }
    } catch (e) {
      print("Error in get Exchange Rates : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Error in get Exchange Rates : $e",
          ),
        ),
      );
      exchangeRates = [];
    }
    setState(() {});
  }

  double calculateTodaySales() {
    return 1000.0;
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
                  height: kIsWeb
                      ? MediaQuery.of(context).size.height / 3 + 82
                      : MediaQuery.of(context).size.height / 3 + 18,
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
                        if (exchangeRates != null && exchangeRates!.isNotEmpty)
                          CardHeaderItem(
                            title: "Exchange Rate",
                            subTitle: '1'
                                ' '
                                '${exchangeRates![0].currencyFrom.toString()}'
                                ' '
                                '='
                                ' '
                                ' ${exchangeRates![0].rate.toString()}'
                                ' '
                                '${exchangeRates![0].currencyTo.toString()}',
                          ),
                        if (exchangeRates == null || exchangeRates!.isEmpty)
                          const SizedBox(
                            height: 24,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        CardHeaderItem(
                          title: "Today's sales",
                          subTitle: calculateTodaySales().toString(),
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
                    onTab: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AllSales(),
                      ));
                    },
                  ),
                  GridViewItem(
                    iconData: Icons.inventory_2,
                    color: Colors.pink,
                    title: "Products",
                    onTab: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProductsView()));
                    },
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
                    onTab: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SalesOpsView(),
                      ));
                    },
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

  Future<void> insertRate() async {
    try {
      var sqlHelper = GetIt.I.get<SqlHelper>();
      await sqlHelper.db!.insert(
          'exchangeRate', {
        'currencyFrom': 'USD',
        'currencyTo': 'EGP',
        'rate': 47.71,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("exchangeRate added Successfully"),
        ),
      );
    } catch (e) {
      print("Error in creating ExchangeRate : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Error in creating ExchangeRate : $e",
          ),
        ),
      );
    }
  }
}
