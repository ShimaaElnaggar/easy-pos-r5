import 'package:easy_pos_r5/helpers/sql_helper.dart';
import 'package:easy_pos_r5/models/order_item_model.dart';
import 'package:easy_pos_r5/models/order_model.dart';
import 'package:easy_pos_r5/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';


class StaticsView extends StatefulWidget {

  const StaticsView({ super.key});

  @override
  State<StaticsView> createState() => _StaticsViewState();
}

class _StaticsViewState extends State<StaticsView> {
  List<OrderItem>? productItems;
  List<Order>? orders;
  String selectedFilter = 'Last Week';

  @override
  void initState() {
    getProductItems();
    getOrders();
    super.initState();
  }
  void getProductItems() async {
    try {
      var sqlHelper = GetIt.I.get<SqlHelper>();
      var data = await sqlHelper.db!.rawQuery("""
    select I.* ,P.name ,P.image ,P.price
    from orderProductItems I
    inner join products P
    on I.productId = P.id
    inner join orders O
    on I.orderId = O.id
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


  @override
  Widget build(BuildContext context) {
    double totalSales = 0;

    if (orders != null) {
      for (var order in orders!) {
        totalSales += order.paidPrice ?? 0;
      }
    }
    return Scaffold(
      appBar: const CustomAppbar(title: "Statics"),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(10.0),
            //   child: Container(
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(5),
            //       border: Border.all(color: Colors.grey),
            //     ),
            //     child: Container(
            //       padding: EdgeInsets.symmetric(horizontal: 10),
            //       child: DropdownButton<String>(
            //         value: selectedFilter,
            //         onChanged: (String? newValue) {
            //           setState(() {
            //             selectedFilter = newValue!;
            //             getOrders();
            //           });
            //         },
            //         items: generateDropdownItems(),
            //       ),
            //     ),
            //   ),
            // ),
            Container(
              padding: const EdgeInsets.all(10),
              height: 60,
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Sales : ',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                  Text(
                    ' ${totalSales} EGP',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Products Sold",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 20,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: productItems?.length ?? 0,
              itemBuilder: (context, index) {

                var item = productItems?[index];

                return ListTile(
                  leading: Card(
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    child: Image.network(
                      item?.product?.image ?? '',
                      fit: BoxFit.cover,
                      scale: 0.6,
                    ),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item?.product?.name ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Text(
                            'Sold: ${item?.productCount ?? ''}',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Text(
                            ' Total: ${(item?.productCount ?? 0) * (item?.product?.price ?? 0)}',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
