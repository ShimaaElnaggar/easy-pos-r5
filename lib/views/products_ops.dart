import 'package:easy_pos_r5/helpers/sql_helper.dart';
import 'package:easy_pos_r5/models/product.dart';
import 'package:easy_pos_r5/widgets/categories_drop_down.dart';
import 'package:easy_pos_r5/widgets/custom_appbar.dart';
import 'package:easy_pos_r5/widgets/custom_elevated_button.dart';
import 'package:easy_pos_r5/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

class ProductsOps extends StatefulWidget {
  final Product? product;
  const ProductsOps({this.product, super.key});

  @override
  State<ProductsOps> createState() => _ProductsOpsState();
}

class _ProductsOpsState extends State<ProductsOps> {
  TextEditingController? nameController;
  TextEditingController? descController;
  TextEditingController? priceController;
  TextEditingController? stockController;
  TextEditingController? imageController;
  var formKey = GlobalKey<FormState>();
  bool isAvailable = false;
  int? selectedId;
  @override
  void initState() {
    initialData();
    super.initState();
  }

  void initialData() {
    nameController = TextEditingController(text: widget.product?.name);
    descController = TextEditingController(text: widget.product?.description);
    priceController =
        TextEditingController(text: '${widget.product?.price ?? ''}');
    stockController =
        TextEditingController(text: '${widget.product?.stock ?? ''}');
    imageController = TextEditingController(text: widget.product?.image);
    isAvailable = widget.product?.isAvailable ?? false;
    selectedId = widget.product?.categoryId;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffafafa),
      appBar: CustomAppbar(
        title: widget.product == null ? "Add New" : "Update",
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              CustomTextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                label: "Name",
                controller: nameController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return " Name is required";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                label: "Description",
                controller: descController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Description is required";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      label: "Price",
                      controller: priceController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "price is required";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: CustomTextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      label: "stock",
                      controller: stockController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "stock is required";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                label: "Image Url",
                controller: imageController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Image Url is required";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Switch(
                      value: isAvailable,
                      onChanged: (value) {
                        setState(() {
                          isAvailable = value;
                        });
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("Is Available"),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              CategoriesDropDown(
                  selectedValue: selectedId,
                  onChanged: (categoryId) {
                    setState(() {
                      selectedId = categoryId;
                    });
                  }),
              const SizedBox(
                height: 20,
              ),
              CustomElevatedButton(
                onPressed: () async {
                  await onSubmit();
                },
                title: "Submit",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onSubmit() async {
    try {
      if (formKey.currentState!.validate()) {
        var sqlHelper = GetIt.I.get<SqlHelper>();
        if (widget.product == null) {
          await sqlHelper.db!.insert('products', {
            'name': nameController?.text,
            'description': descController?.text,
            'image': imageController?.text,
            'price': priceController?.text,
            'stock': stockController?.text,
            'isAvailable': isAvailable ? 1 : 0,
            'categoryId': selectedId,
          });
        } else {
          await sqlHelper.db!.update(
            'products',
            {
              'name': nameController?.text,
              'description': descController?.text,
              'image': imageController?.text,
              'price': priceController?.text,
              'stock': stockController?.text,
              'isAvailable': isAvailable ? 1 : 0,
              'categoryId': selectedId,
            },
            where: "id=?",
            whereArgs: [widget.product?.id],
          );
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              widget.product == null
                  ? "Product added Successfully"
                  : "Product updated Successfully",
            ),
          ),
        );
        Navigator.pop(context, true); //refresh categories page
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Error in creating product : $e",
          ),
        ),
      );
      print(e);
    }
  }
}
