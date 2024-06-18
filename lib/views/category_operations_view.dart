import 'package:easy_pos_r5/helpers/sql_helper.dart';
import 'package:easy_pos_r5/models/category_data_model.dart';
import 'package:easy_pos_r5/widgets/custom_appbar.dart';
import 'package:easy_pos_r5/widgets/custom_elevated_button.dart';
import 'package:easy_pos_r5/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class CategoryOperationsView extends StatefulWidget {
  final CategoryData? categoryData;
  const CategoryOperationsView({this.categoryData, super.key});

  @override
  State<CategoryOperationsView> createState() => _CategoryOperationsViewState();
}

class _CategoryOperationsViewState extends State<CategoryOperationsView> {
  TextEditingController? nameController;
  TextEditingController? descController;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    nameController =
        TextEditingController(text: widget.categoryData?.name);
    descController =
        TextEditingController(text: widget.categoryData?.description);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffafafa),
      appBar: CustomAppbar(
        title: widget.categoryData == null ? "Add New Category" : "Update Category",
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              CustomTextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                label: "Name",
                controller: nameController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Name is required";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                textInputAction: TextInputAction.done,
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
        if (widget.categoryData == null) {
          await sqlHelper.db!.insert(
            'categories',
            {
              'name': nameController!.text,
              'description': descController!.text,
            },
          );
        } else {
          await sqlHelper.db!.update(
            'categories',
            {
              'name': nameController?.text,
              'description': descController?.text,
            },
            where: "id=?",
            whereArgs: [widget.categoryData?.id],
          );
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              widget.categoryData == null
                  ? "Category added Successfully"
                  : "Category Updated Successfully",
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
            "Error in creating Category : $e",
          ),
        ),
      );
    }
  }
}
