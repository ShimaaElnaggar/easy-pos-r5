import 'package:easy_pos_r5/helpers/sql_helper.dart';
import 'package:easy_pos_r5/models/exchange_rate_model.dart';
import 'package:easy_pos_r5/models/order_model.dart';
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
import 'package:intl/intl.dart';

class HomeView extends StatefulWidget {
  const HomeView({ super.key});
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isLoading = true;
  bool isTableInitialized = false;
  List<ExchangeRate>? exchangeRates;
  List<Order>? orders;
  double totalSales = 0;
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
    getOrders();
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

  void getOrders() async {
    try {
      var sqlHelper = GetIt.I.get<SqlHelper>();
      var data = await sqlHelper.db!.rawQuery("""
      select O.* ,C.name as clientName,C.phone as clientPhone,C.address as clientAddress 
      from orders O
      inner join clients C
      where O.clientId = C.id
    """);

      if (data.isNotEmpty) {
        orders = [];
        for (var item in data) {
          orders!.add(Order.fromJson(item));
        }
        calculateTodaySales(); // Recalculate totalSales after adding orders
      } else {
        orders = [];
      }
    } catch (e) {
      print('Error In get data $e');
      orders = [];
    }
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
                      ? MediaQuery.of(context).size.height / 3 + 85
                      : MediaQuery.of(context).size.height / 3 + 19,
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
                          height: 10,
                        ),
                        if (exchangeRates != null && exchangeRates!.isNotEmpty)
                          CardHeaderItem(
                            title: "Exchange Rate",
                            subTitle: isLoading ?
                            'Calculating...' : '1'
                                ' '
                                '${exchangeRates![0].currencyFrom.toString()}'
                                ' '
                                '='
                                ' '
                                ' ${exchangeRates![0].rate.toString()}'
                                ' '
                                '${exchangeRates![0].currencyTo.toString()}',
                          ),
                        const SizedBox(
                            height: 5,

                          ),
                        CardHeaderItem(
                          title: "Today's Sales",
                          subTitle: isLoading ?
                          'Calculating...' :
                          (orders != null ? totalSales.toString() : 'No orders available'),
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

  Future<void> calculateTodaySales() async {
    DateTime now = DateTime.now();
    String currentDate = DateFormat('dd-MM-yyyy').format(now);
    var sqlHelper = GetIt.I.get<SqlHelper>();
    var result = await sqlHelper.db!.query(
      'orders',
      columns: ['paidPrice'],
      where: 'createdAtDate = ?',
      whereArgs: [currentDate],
    );

    double totalSales = 0;

    for (var row in result) {
      totalSales += row['paidPrice'] as double;
    }

    setState(() {
      this.totalSales = totalSales;
      print('Rebuilding widget with totalSales: $totalSales');
    });
  }
}
