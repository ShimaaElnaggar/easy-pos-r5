import 'package:easy_pos_r5/helpers/sql_helper.dart';
import 'package:easy_pos_r5/models/order_item_model.dart';
import 'package:easy_pos_r5/models/order_model.dart';
import 'package:easy_pos_r5/views/statics_view.dart';
import 'package:easy_pos_r5/widgets/custom_appbar.dart';
import 'package:easy_pos_r5/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class AllSales extends StatefulWidget {
  const AllSales({super.key});

  @override
  State<AllSales> createState() => _AllSalesState();
}

class _AllSalesState extends State<AllSales> {
  List<Order>? orders;
  List<OrderItem>? productItems;
  String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  String formattedTime = DateFormat('h:mm a').format(DateTime.now());
  bool? isPaid = true;
  @override
  void initState() {
    getOrders();
    getProductItems();
    super.initState();
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
      } else {
        orders = [];
      }
    } catch (e) {
      print('Error In get data $e');
      orders = [];
    }
    setState(() {});
  }

  void getProductItems() async {
    try {
      var sqlHelper = GetIt.I.get<SqlHelper>();
      var data = await sqlHelper.db!.rawQuery("""
      select I.* ,P.name ,P. image ,P.price
      from orderProductItems I
      inner join products P
      where I.productId = P.id
      """);

      if (data.isNotEmpty) {
        productItems = [];
        for (var item in data) {
          productItems!.add(OrderItem.fromJson(item));
        }
      } else {
        productItems = [];
      }
    } catch (e) {
      print('Error In get data $e');
      productItems = [];
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: const CustomAppbar(title: "All Sales"),
      floatingActionButton: SizedBox(
        height: 50,
        width: 150,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const StaticsView()));
          },
          child: const Text('Show Product Sold'),
        ),
      ),
      body: (orders?.isEmpty ?? true)
          ? const Center(
              child: Text("No data found"),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  search(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: orders?.length ?? 0,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Card(
                                  color: const Color(0xffffea9f),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          formattedDate,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          'Total : ${orders?[index].totalPrice ?? 0}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w100),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: double.maxFinite,
                                child: Card(
                                  color: Colors.white,
                                  surfaceTintColor: Colors.white,
                                  child: IntrinsicWidth(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Receipt : $formattedTime ",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600)),
                                              popMenuButton(context, index),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.account_circle_outlined,
                                                color: Colors.grey,
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                orders?[index].clientName ?? '',
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Divider(
                                            color: Colors.grey,
                                            thickness: 1,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${productItems?[index].product?.name}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                orders?[index].label ?? '',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w200,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    '${productItems?[index].productCount} * ${productItems?[index].product?.price}',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w200,
                                                    ),
                                                  ),
                                                  Text(
                                                    ' Total : ${orders?[index].totalPrice ?? 0}',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w200,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Divider(
                                            color: Colors.grey,
                                            thickness: 1,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                      'Discount : ${orders?[index].discount ?? 0}',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w200,
                                                      )),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                  'Paid Price : ${orders?[index].paidPrice ?? 0}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                  )),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                '$isPaid',
                                                style: const TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  PopupMenuButton<String> popMenuButton(BuildContext context, int index) {
    return PopupMenuButton<String>(
      iconColor: Theme.of(context).primaryColor,
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem<String>(
            value: 'delete',
            child: Text('Delete'),
          ),
          const PopupMenuItem<String>(
            value: 'update',
            child: Text('Update'),
          ),
        ];
      },
      onSelected: (String value) {
        switch (value) {
          case 'delete':
            onDeleteRow(orders?[index].id ?? 0);
            break;
          case 'update':
            // Handle update action
            break;
          case 'show':
            // Handle show action
            break;
          default:
            // Handle other cases
            break;
        }
      },
    );
  }

  Padding search() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: CustomTextFormField(
        onChanged: (value) async {
          var sqlHelper = GetIt.I.get<SqlHelper>();
          await sqlHelper.db!.rawQuery("""
              SELECT * FROM orders
              WHERE label LIKE '%$value%';
                 """);
        },
        label: 'Search',
      ),
    );
  }

  Future<void> onDeleteRow(int id) async {
    try {
      var dialogueResult = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Delete Item"),
              content: const Text("Are you sure you want to delete this Item?"),
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
            .delete('orders', where: 'id =?', whereArgs: [id]);
        if (result > 0) {
          getOrders();
          print("Row deleted Successfully!");
        }
      }
    } catch (e) {
      print("Error in deleting row : $e");
    }
  }
}
