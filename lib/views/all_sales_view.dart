import 'package:easy_pos_r5/helpers/sql_helper.dart';
import 'package:easy_pos_r5/models/order_item_model.dart';
import 'package:easy_pos_r5/models/order_model.dart';
import 'package:easy_pos_r5/views/statics_view.dart';
import 'package:easy_pos_r5/widgets/custom_appbar.dart';
import 'package:easy_pos_r5/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';


class AllSales extends StatefulWidget {

  const AllSales({super.key});

  @override
  State<AllSales> createState() => _AllSalesState();
}

class _AllSalesState extends State<AllSales> {
  List<Order>? orders;
  List<OrderItem>? productItems;
  bool? isPaid = true;
  double minPrice = 0.0;
  double maxPrice = double.infinity;
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
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: (orders?.isEmpty ?? true)
            ? const Center(
                child: Text("No data found"),
              )
            : Column(
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
                                          '${orders?[index].createdAtDate ?? 0}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          'Total : ${orders?[index].totalPrice ?? ''}',
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
                                              Text(" Receipt : ${orders?[index].createdAtTime ?? '' } ",
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
                                            thickness: 2,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              for (var item
                                                  in productItems ?? [])
                                                if (item.orderId ==
                                                    orders![index].id)
                                                  Column(
                                                    children: [
                                                      ListTile(
                                                        leading: Image.network(
                                                          item?.product
                                                                  ?.image ??
                                                              '',
                                                          fit: BoxFit.cover,
                                                          scale: 2,
                                                        ),
                                                        title: Column(
                                                          children: [
                                                            Text(
                                                              item.product
                                                                      ?.name ??
                                                                  '',
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                              orders?[index]
                                                                      .label ??
                                                                  '',
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                '${item.productCount} * ${item.product?.price}',
                                                                style:
                                                                    const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w200,
                                                                ),
                                                              ),
                                                              Text(
                                                                ' Total : ${item.productCount * item.product?.price}',
                                                                style:
                                                                    const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w200,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const Padding(
                                                            padding:
                                                                EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        50),
                                                            child: Divider(
                                                              color:
                                                                  Colors.grey,
                                                              thickness: 1,
                                                            ),
                                                          ),
                                                        ],
                                                      ),

                                                    ],
                                                  ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                  'Total Price : ${orders?[index].totalPrice ?? 0}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w200,
                                                  )),
                                              const SizedBox(
                                                height: 10,
                                              ),
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
                                                '${orders?[index].paymentStatus}',
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: CustomTextFormField(
              prefixIcon: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search,
                  color: Colors.blue, // Use the desired color here
                ),
              ),
              onChanged: (value) async {
                await filterOrders(value);
              },
              label: 'Search',
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 90,
            child: CustomTextFormField(
              label: 'Min Price',
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  minPrice = double.tryParse(value) ?? 0.0;
                });
                filterOrders('');
              },
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 90,
            child: CustomTextFormField(
              label: 'Max Price',
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  maxPrice = double.tryParse(value) ?? double.infinity;
                });
                filterOrders('');
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> filterOrders(String query) async {
    try {
      var sqlHelper = GetIt.I.get<SqlHelper>();
      final List<Map<String, dynamic>> maps = await sqlHelper.db!.rawQuery("""
     SELECT * FROM orders
               WHERE (label LIKE '%$query%' OR paidPrice LIKE '%$query%')
               AND paidPrice >= $minPrice AND paidPrice <= $maxPrice;
  """);

      setState(() {
        orders = maps.map((map) => Order.fromJson(map)).toList();
      });
    } catch (e) {
      print('Error filtering orders: $e');
    }
  }

  Future<void> onDeleteRow(int id) async {
    try {
      var dialogResult = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Delete Order'),
              content:
                  const Text('Are you sure you want to delete this order?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('Delete'),
                ),
              ],
            );
          });

      if (dialogResult ?? false) {
        var sqlHelper = GetIt.I.get<SqlHelper>();
        var result = await sqlHelper.db!.delete(
          'orders',
          where: 'id =?',
          whereArgs: [id],
        );
        if (result > 0) {
          getOrders();
        }
      }
      // if (dialogResult ?? false) {
      //   var sqlHelper = GetIt.I.get<SqlHelper>();
      //   var result = await sqlHelper.db!.delete(
      //     'orderProductItems',
      //     where: 'id =?',
      //     whereArgs: [id],
      //   );
      //   if (result > 0) {
      //     getProductItems();
      //   }
      // }
    } catch (e) {
      print('Error In delete data $e');
    }
  }
}
