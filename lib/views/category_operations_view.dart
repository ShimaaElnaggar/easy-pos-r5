
import 'package:easy_pos_r5/widgets/custom_elevated_button.dart';
import 'package:easy_pos_r5/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';


class CategoryOperationsView extends StatefulWidget {
  const CategoryOperationsView({super.key});

  @override
  State<CategoryOperationsView> createState() => _CategoryOperationsViewState();
}

class _CategoryOperationsViewState extends State<CategoryOperationsView> {
  TextEditingController categoryNameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New"),
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
                label: "Category Name",
                controller: categoryNameController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Category Name is required";
                  } else {
                    return null;
                  }
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
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              CustomElevatedButton(
                onPressed: onSubmit,
                title: "Submit",
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onSubmit() {

  }
}
