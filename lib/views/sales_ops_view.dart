import 'package:easy_pos_r5/helpers/sql_helper.dart';
import 'package:easy_pos_r5/models/order_item_model.dart';
import 'package:easy_pos_r5/models/order_model.dart';
import 'package:easy_pos_r5/models/product.dart';
import 'package:easy_pos_r5/widgets/clients_drop_down.dart';
import 'package:easy_pos_r5/widgets/custom_appbar.dart';
import 'package:easy_pos_r5/widgets/custom_elevated_button.dart';
import 'package:easy_pos_r5/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class SalesOpsView extends StatefulWidget {
  final Order? order;
  const SalesOpsView({this.order, super.key});

  @override
  State<SalesOpsView> createState() => _SalesOpsViewState();
}

class _SalesOpsViewState extends State<SalesOpsView> {
  String? orderLabel;
  int? selectedID;
  double paidPrice =0;
  List<Product>? products;
  List<OrderItem> selectedOrderItem = [];
  GlobalKey formKey = GlobalKey<FormState>();
  TextEditingController? discountController;
  @override
  void initState() {
    initView();
    getProducts();
    super.initState();
  }

  void initView() {
    orderLabel = widget.order == null
        ? '#OR${DateTime.now().millisecondsSinceEpoch}'
        : widget.order?.id.toString();
    selectedID = widget.order?.clientId;
    discountController =
        TextEditingController(text: '${widget.order?.discount ?? ''}');

  }

  void getProducts() async {
    try {
      var sqlHelper = GetIt.I.get<SqlHelper>();
      var data = await sqlHelper.db!.rawQuery("""
      select P.* ,C.name as categoryName,C.description as categoryDesc 
      from products P
      inner join categories C
      where P.categoryId = C.id
      """);

      if (data.isNotEmpty) {
        products = [];
        for (var item in data) {
          products!.add(Product.fromJson(item));
        }
      } else {
        products = [];
      }
    } catch (e) {
      print('Error In get data $e');
      products = [];
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffafafa),
      appBar: CustomAppbar(
          title: widget.order == null ? "Add New Sale " : "Update Sale"),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    ClientsDropDown(
                        selectedValue: selectedID,
                        onChanged: (clientId) {
                          setState(() {
                            selectedID = clientId;
                          });
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    Card(
                      color: const Color(0xfff5f5f5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IntrinsicWidth(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 16,
                              ),
                              Text(
                                'Label : $orderLabel',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              for (var orderItem in selectedOrderItem)
                                ListTile(
                                  leading: Image.network(
                                      orderItem.product?.image ?? ''),
                                  title: Text(orderItem.product?.name ?? ''),
                                  trailing: Container(
                                    height: 25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: const Color(0xfffafafa),
                                        border: Border.all(
                                          color: Colors.grey,
                                        )),
                                    child: Center(
                                      child: Text(
                                        '${orderItem.productCount}X',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                    ),
                                  ),
                                ),
                              const SizedBox(
                                height: 20,
                              ),
                              CustomElevatedButton(
                                onPressed: () {
                                  onAddProduct();
                                },
                                title: 'Add Products',
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Divider(
                                  color: Colors.grey,
                                  thickness: 1,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total Price : ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    '$calculateTotalPrice',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Divider(
                                  color: Colors.grey,
                                  thickness: 1,
                                ),
                              ),

                              const SizedBox(
                                height: 20,
                              ),
                               CustomTextFormField(
                                label: 'Add discount',
                                controller: discountController,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.done,
                                onChanged: (value) {
                                  setState(() {
                                    double discount = double.tryParse(value) ?? 0;
                                    paidPrice = calculateTotalPrice -
                                        (calculateTotalPrice * discount / 100) ;
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                height: 50,
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                  color: const Color(0xfff1f5ff),
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: Theme.of(context).primaryColor,
                                      width: 2),
                                ),
                                child: Text(
                                  'Paid Price : ${widget.order?.discount == 0 ? calculateTotalPrice :paidPrice}',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CustomElevatedButton(
                onPressed: selectedOrderItem.isEmpty
                    ? null
                    : () async {
                        await onSetOrder();
                      },
                title: 'Add Order',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onAddProduct() async {
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, dialogueSetState) {
            return Dialog(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 15),
                child: (products?.isEmpty ?? false)
                    ? const Center(
                        child: Text("No data found"),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Products',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextFormField(
                            onChanged: (value) async {
                              var sqlHelper = GetIt.I.get<SqlHelper>();
                              var result = await sqlHelper.db!.rawQuery("""
                                  SELECT * FROM products
                                  WHERE name LIKE '%$value% OR price LIKE '%$value%' ;
                                   """);

                              print('values:$result');
                            },
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.text,
                            prefixIcon: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.search,
                                )),
                            label: "Search",
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: ListView(
                              children: [
                                for (var product in products!)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: ListTile(
                                      leading: Image.network(
                                          product.image ?? 'No Image'),
                                      title: Text(product.name ?? 'No Name'),
                                      subtitle: getOrderItem(product.id!) ==
                                              null
                                          ? null
                                          : Row(
                                              children: [
                                                IconButton(
                                                    onPressed: getOrderItem(
                                                                    product
                                                                        .id!) !=
                                                                null &&
                                                            getOrderItem(product
                                                                        .id!)
                                                                    ?.productCount ==
                                                                1
                                                        ? null
                                                        : () {
                                                            var orderItem =
                                                                getOrderItem(
                                                                    product
                                                                        .id!);
                                                            orderItem
                                                                    ?.productCount =
                                                                (orderItem.productCount ??
                                                                        0) -
                                                                    1;
                                                            dialogueSetState(
                                                                () {});
                                                          },
                                                    icon: const Icon(
                                                        Icons.remove)),
                                                Text(getOrderItem(product.id!)!
                                                    .productCount
                                                    .toString()),
                                                IconButton(
                                                    onPressed: () {
                                                      var orderItem =
                                                          getOrderItem(
                                                              product.id!);

                                                      if ((orderItem
                                                                  ?.productCount ??
                                                              0) <
                                                          (product.stock ??
                                                              0)) {
                                                        orderItem
                                                                ?.productCount =
                                                            (orderItem.productCount ??
                                                                    0) +
                                                                1;
                                                      }

                                                      dialogueSetState(() {});
                                                    },
                                                    icon:
                                                        const Icon(Icons.add)),
                                              ],
                                            ),
                                      trailing: getOrderItem(product.id!) ==
                                              null
                                          ? IconButton(
                                              onPressed: () {
                                                onAddItem(product);
                                                dialogueSetState(() {});
                                              },
                                              icon: const Icon(Icons.add))
                                          : IconButton(
                                              onPressed: () {
                                                onDeleteItem(product.id!);
                                                dialogueSetState(() {});
                                              },
                                              icon: const Icon(Icons.delete),
                                            ),
                                    ),
                                  ),

                              ],
                            ),
                          ),
                          CustomElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            title: 'Back',
                          ),
                        ],
                      ),
              ),
            );
          },
        );
      },
    );
    setState(() {});
  }

  OrderItem? getOrderItem(int productId) {
    for (var item in selectedOrderItem) {
      if (item.productId == productId) {
        return item;
      }
    }
    return null;
  }

  void onAddItem(Product product) {
    selectedOrderItem.add(
        OrderItem(productId: product.id, productCount: 1, product: product));
  }

  void onDeleteItem(int productId) {
    for (var i = 0; i < (selectedOrderItem.length); i++) {
      if (selectedOrderItem[i].productId == productId) {
        selectedOrderItem.removeAt(i);
        break;
      }
    }
  }

  double get calculateTotalPrice {
    double total = 0;

    for (var orderItem in selectedOrderItem) {
      total = total +
          ((orderItem.productCount ?? 0) * (orderItem.product?.price ?? 0));
    }

    return total;
  }

  double calculatePaidPrice(Order order) {
    if (order.discount != 0.0) {
      return order.totalPrice??0 - (order.totalPrice??0 * order.discount! /100);
    } else {
      return order.totalPrice??0;
    }
  }
  Future<void> onSetOrder() async {
    try {
      var sqlHelper = GetIt.I.get<SqlHelper>();
      var discount = double.tryParse(discountController?.text ?? '0') ?? 0;
      var orderId = await sqlHelper.db!.insert('orders', {
        'label': orderLabel,
        'totalPrice': calculateTotalPrice,
        'discount': discount,
        'paidPrice': paidPrice,
        'clientId': selectedID,
      });

      var batch = sqlHelper.db!.batch();
      for (var orderItem in selectedOrderItem) {
        batch.insert('orderProductItems', {
          'orderId': orderId,
          'productId': orderItem.productId,
          'productCount': orderItem.productCount ?? 0,
        });
      }

      await batch.commit();

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Order Set Successfully')));
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('Error In Create Order : $e')));
    }
  }
}
