
import 'package:easy_pos_r5/helpers/sql_helper.dart';
import 'package:easy_pos_r5/models/client_data_model.dart';
import 'package:easy_pos_r5/widgets/custom_appbar.dart';
import 'package:easy_pos_r5/widgets/custom_elevated_button.dart';
import 'package:easy_pos_r5/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

class ClientsOperations extends StatefulWidget {
  final ClientData? clientData;
  const ClientsOperations({this.clientData,super.key});

  @override
  State<ClientsOperations> createState() => _ClientsOperationsState();
}

class _ClientsOperationsState extends State<ClientsOperations> {
  TextEditingController? clientNameController ;
  TextEditingController? phoneController;
  TextEditingController? addressController ;
  var formKey = GlobalKey<FormState>();

  void initState() {
    clientNameController =
        TextEditingController(text: widget.clientData?.name);
    phoneController =
        TextEditingController(text: widget.clientData?.phone);
    addressController =
        TextEditingController(text: widget.clientData?.address);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffafafa),
      appBar: CustomAppbar(
          title: widget.clientData == null ? "Add New" : "Update",
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              CustomTextFormField(
                controller: clientNameController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  label:"Name",
                validator: (value){
                  if (value!.isEmpty) {
                    return "Name is required";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20,),
              CustomTextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                controller: phoneController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.phone,
                label:"Phone",
                validator: (value){
                  if (value!.isEmpty) {
                    return "Phone is required";
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
                    return "Address is required";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20,),
              CustomElevatedButton(
                  onPressed: ()async{
                    await onSubmit();
                  },
                fixedSize: const Size(double.maxFinite, 60),
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
        if (widget.clientData == null) {
          await sqlHelper.db!.insert(
            'clients',
            {
              'name': clientNameController!.text,
              'phone': phoneController!.text,
              'address': addressController!.text,
            },
          );
          var data = await sqlHelper.db!.rawQuery('SELECT * FROM clients');
          print('data db:$data');
        } else {
          await sqlHelper.db!.update(
            'clients',
            {
              'name': clientNameController?.text,
              'phone': phoneController?.text,
              'address': addressController?.text,
            },
            where: "id=?",
            whereArgs: [widget.clientData?.id],
          );
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              widget.clientData == null
                  ? "Client added Successfully"
                  : "Client Updated Successfully",
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
              widget.clientData == null
                  ? "Error in adding client: $e"
                  : "Error in updating client: $e",
          ),
        ),
      );
    }
  }
}
