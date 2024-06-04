
import 'package:easy_pos_r5/widgets/custom_appbar.dart';
import 'package:easy_pos_r5/widgets/custom_elevated_button.dart';
import 'package:easy_pos_r5/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class ClientsOperations extends StatefulWidget {
  const ClientsOperations({super.key});

  @override
  State<ClientsOperations> createState() => _ClientsOperationsState();
}

class _ClientsOperationsState extends State<ClientsOperations> {
  var clientNameController =TextEditingController();
  var emailController =TextEditingController();
  var phoneController =TextEditingController();
  var addressController =TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "New Client"),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CustomTextFormField(
              controller: clientNameController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                label:"Client Name",
              validator: (value){
                if (value!.isEmpty) {
                  return "Description is required";
                }
                return null;
              },
            ),
            const SizedBox(height: 20,),
            CustomTextFormField(
              controller: emailController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              label:"Email",
              validator: (value){
                if (value!.isEmpty) {
                  return "Description is required";
                }
                return null;
              },
            ),
            const SizedBox(height: 20,),
            CustomTextFormField(
              controller: phoneController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.phone,
              label:"Phone",
              validator: (value){
                if (value!.isEmpty) {
                  return "Description is required";
                }
                return null;
              },
            ),
            const SizedBox(height: 20,),
            CustomTextFormField(
              controller: addressController,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              label:"Address",
              validator: (value){
                if (value!.isEmpty) {
                  return "Description is required";
                }
                return null;
              },
            ),
            const SizedBox(height: 20,),
            CustomElevatedButton(onPressed: (){}, title: "Submit"),
          ],
        ),
      ),
    );
  }
}
