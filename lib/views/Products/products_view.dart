import 'package:animate_do/animate_do.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:easy_pos_r5/helpers/sql_helper.dart';
import 'package:easy_pos_r5/models/product.dart';
import 'package:easy_pos_r5/views/Products%20Operations/products_ops.dart';
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
  List<Product>? products;
  double minPrice = 0.0;
  double maxPrice = double.infinity;
  bool sortValue = true;
  int sortColumnIndex = 0;
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

  void sort(Comparable? Function(Product product) getField, int columnIndex,
      bool ascending) {
    products?.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue!, bValue!)
          : Comparable.compare(bValue!, aValue!);
    });
    setState(() {
      sortColumnIndex = columnIndex;
      sortValue = ascending;
    });
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
            searchAndFilter(context),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: CustomDataTable(
                sortColumnIndex: sortColumnIndex,
                sortAscending: sortValue,
                minWidth: 1500,
                columns: [
                  DataColumn(
                    label: const Center(child: Text("Id")),
                    onSort: (columnIndex, ascending) {
                      sort((product) => product.id!, columnIndex, ascending);
                    },
                  ),
                  DataColumn(
                    label: const Center(child: Text("Name")),
                    onSort: (columnIndex, ascending) {
                      sort((product) => product.name!, columnIndex, ascending);
                    },
                  ),
                  DataColumn(
                    label: const Center(child: Text("Description")),
                    onSort: (columnIndex, ascending) {
                      sort((product) => product.description!, columnIndex,
                          ascending);
                    },
                  ),
                  DataColumn(
                    label: const Center(child: Text("Price")),
                    onSort: (columnIndex, ascending) {
                      sort((product) => product.price!, columnIndex, ascending);
                    },
                  ),
                  DataColumn(
                    label: const Center(child: Text("Stock")),
                    onSort: (columnIndex, ascending) {
                      sort((product) => product.stock!, columnIndex, ascending);
                    },
                  ),
                  DataColumn(
                    label: const Center(child: Text("Is Available")),
                    onSort: (columnIndex, ascending) {
                      sort((product) => product.isAvailable! ? 1 : 0,
                          columnIndex, ascending);
                    },
                  ),
                  const DataColumn(label: Center(child: Text("Image"))),
                  DataColumn(
                    label: const Center(child: Text("Category Id")),
                    onSort: (columnIndex, ascending) {
                      sort((product) => product.categoryId!, columnIndex,
                          ascending);
                    },
                  ),
                  DataColumn(
                    label: const Center(child: Text("Category Name")),
                    onSort: (columnIndex, ascending) {
                      sort((product) => product.categoryName!, columnIndex,
                          ascending);
                    },
                  ),
                  DataColumn(
                    label: const Center(child: Text("Category Description")),
                    onSort: (columnIndex, ascending) {
                      sort((product) => product.categoryDesc!, columnIndex,
                          ascending);
                    },
                  ),
                  const DataColumn(label: Center(child: Text("Actions"))),
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

  Row searchAndFilter(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomTextFormField(
            onChanged: (value) async {
              await searchProcess(value);
            },
            textInputAction: TextInputAction.done,
            prefixIcon: IconButton(
                onPressed: () {},
                icon: FadeInLeft(
                  child: Icon(
                    Icons.search,
                    color: Theme.of(context).primaryColor,
                  ),
                )),
            label: "Search",
          ),
        ),
        // const SizedBox(width: 10),
        // SizedBox(
        //   width: 90,
        //   child: CustomTextFormField(
        //     label: 'Min Price',
        //     keyboardType: TextInputType.number,
        //     onChanged: (value) {
        //       setState(() {
        //         minPrice = double.tryParse(value) ?? 0.0;
        //       });
        //       searchProcess('');
        //     },
        //   ),
        // ),
        // const SizedBox(width: 10),
        // SizedBox(
        //   width: 90,
        //   child: CustomTextFormField(
        //     label: 'Max Price',
        //     keyboardType: TextInputType.number,
        //     onChanged: (value) {
        //       setState(() {
        //         maxPrice = double.tryParse(value) ?? double.infinity;
        //       });
        //       searchProcess('');
        //     },
        //   ),
        // ),
      ],
    );
  }

  Future<void> searchProcess(String query) async {
    var sqlHelper = GetIt.I.get<SqlHelper>();
    var result = await sqlHelper.db!.rawQuery("""
               SELECT * FROM products
               WHERE name LIKE '%$query%' OR description LIKE '%$query%' OR price LIKE '%$query%'
              """);
    setState(() {
      products = result
          .map((map) => Product(
                name: map['name'] as String,
                description: map["description"] as String,
                price: map["price"] as double,
                id: map['id'] as int,
                image: map['image'] as String,
                isAvailable: map['isAvailable'] == 1 ? true : false,
                stock: map['stock'] as int,
                categoryDesc: map['categoryDesc'] as String,
                categoryId: map['categoryId'] as int,
                categoryName: map['categoryName'] as String,
              ))
          .toList();
    });
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
      DataCell(Center(child: Text("${productsList?[index].id}"))),
      DataCell(Center(child: Text("${productsList?[index].name}"))),
      DataCell(Center(child: Text("${productsList?[index].description}"))),
      DataCell(Center(child: Text("${productsList?[index].price}"))),
      DataCell(Center(child: Text("${productsList?[index].stock}"))),
      DataCell(Center(child: Text("${productsList?[index].isAvailable}"))),
      DataCell(Center(
          child: Image.network(
        "${productsList?[index].image}",
        fit: BoxFit.contain,
      ))),
      DataCell(Center(child: Text("${productsList?[index].categoryId}"))),
      DataCell(Center(child: Text("${productsList?[index].categoryName}"))),
      DataCell(Center(child: Text("${productsList?[index].categoryDesc}"))),
      DataCell(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  onUpdate(productsList![index]);
                },
                icon: const Icon(
                  Icons.edit,
                  color: Color(0xff0157DB),
                )),
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
