import 'package:data_table_2/data_table_2.dart';
import 'package:easy_pos_r5/helpers/sql_helper.dart';
import 'package:easy_pos_r5/models/product.dart';
import 'package:easy_pos_r5/views/products_ops.dart';
import 'package:easy_pos_r5/widgets/custom_appbar.dart';
import 'package:easy_pos_r5/widgets/custom_data_table.dart';
import 'package:easy_pos_r5/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ProductsView extends StatefulWidget {
  const ProductsView({super.key});

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  List<Product>? products; // null == loading
  @override
  void initState() {
    getProducts();
    super.initState();
  }

  void getProducts() async {
    try {
      var sqlHelper = GetIt.I.get<SqlHelper>();
      var data = await sqlHelper.db!.rawQuery("""
      SELECT P.*,C.name as categoryName,C.description as categoryDesc FROM products P
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Error in get product : $e",
          ),
        ),
      );
      print("Error in get product : $e");
      products = [];
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffafafa),
      appBar: CustomAppbar(title: "Products", actions: [
        IconButton(
          onPressed: () async {
            var result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProductsOps()),
            );
            if (result ?? false) {
              getProducts(); // Refresh categories list
            }
          },
          icon: const Icon(Icons.add),
        ),
      ]),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CustomTextFormField(
              onChanged: (value) async {
                var sqlHelper = GetIt.I.get<SqlHelper>();
                var result = await sqlHelper.db!.rawQuery("""
                 SELECT * FROM categories
                 WHERE name LIKE '%$value%' OR description LIKE '%$value%' OR description LIKE '%$value%';
                """);
                print('values:$result');
              },
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              prefixIcon: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.search,
                    color: Theme.of(context).primaryColor,
                  )),
              label: "Search",
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: CustomDataTable(
                minWidth: 1500,
                columns: const [
                  DataColumn(label: Text("Id")),
                  DataColumn(label: Text("Name")),
                  DataColumn(label: Text("Description")),
                  DataColumn(label: Text("Price")),
                  DataColumn(label: Text("Stock")),
                  DataColumn(label: Text("Is Available")),
                  DataColumn(label: Center(child: Text("Image"))),
                  DataColumn(label: Text("Category Id")),
                  DataColumn(label: Text("Category Name")),
                  DataColumn(label: Text("Category Description")),
                  DataColumn(label: Center(child: Text("Actions"))),
                ],
                source: ProductsTableSource(
                    productsList: products,
                    onDelete: (product) {
                      onDeleteRow(product.id!);
                    },
                    onUpdate: (product) async {
                      var result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductsOps(
                                  product: product,
                                )),
                      );
                      if (result ?? false) {
                        getProducts(); // Refresh categories list
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onDeleteRow(int id) async {
    try {
      var dialogueResult = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Delete Product"),
              content:
                  const Text("Are you sure you want to delete this Product?"),
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
            .delete('products', where: 'id =?', whereArgs: [id]);
        if (result > 0) {
          getProducts();
          print("Row deleted Successfully!");
        }
      }
    } catch (e) {
      print("Error in deleting row : $e");
    }
  }
}

class ProductsTableSource extends DataTableSource {
  List<Product>? productsList;
  void Function(Product) onDelete;
  void Function(Product) onUpdate;
  ProductsTableSource(
      {required this.productsList,
      required this.onDelete,
      required this.onUpdate});
  @override
  DataRow? getRow(int index) {
    return DataRow2(cells: [
      DataCell(Text("${productsList?[index].id}")),
      DataCell(Text("${productsList?[index].name}")),
      DataCell(Text("${productsList?[index].description}")),
      DataCell(Text("${productsList?[index].price}")),
      DataCell(Text("${productsList?[index].stock}")),
      DataCell(Text("${productsList?[index].isAvailable}")),
      DataCell(Center(
          child: Image.network(
        "${productsList?[index].image}",
        fit: BoxFit.contain,
      ))),
      DataCell(Text("${productsList?[index].categoryId}")),
      DataCell(Text("${productsList?[index].categoryName}")),
      DataCell(Text("${productsList?[index].categoryDesc}")),
      DataCell(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  onUpdate(productsList![index]);
                },
                icon: const Icon(Icons.edit)),
            IconButton(
                onPressed: () async {
                  onDelete(productsList![index]);
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                )),
          ],
        ),
      ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => productsList?.length ?? 0;

  @override
  int get selectedRowCount => 0;
}
