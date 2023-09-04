import 'package:contacts/utils/network.dart';
import 'package:contacts/widgets/my_button_widget.dart';
import 'package:contacts/widgets/my_textfiled_widget.dart';
import 'package:flutter/material.dart';
import 'package:contacts/utils/responsive.dart';

class AddEditScreens extends StatefulWidget {
  static TextEditingController nameController = TextEditingController();
  static TextEditingController phoneController = TextEditingController();
  static int id = 0;
  const AddEditScreens({super.key});

  @override
  State<AddEditScreens> createState() => _AddEditScreensState();
}

class _AddEditScreensState extends State<AddEditScreens> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
        appBar:  AppBar(
          backgroundColor: Colors.redAccent,
          elevation: 0,
          title: Text(AddEditScreens.id == 0 ? 'مخاطب جدید' : 'ویرایش مخاطب',
          style: TextStyle(
            fontSize: ScreenUtil(context).screenWidth < 1000 ? 16 : ScreenUtil(context).screenWidth * 0.013),),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              MyTextField(
            errorText: 'لطفا نام را وارد کنید',
            controller: AddEditScreens.nameController,
            hintText: "نام",
            type: TextInputType.name,),
              MyTextField(
                errorText: 'لطفا شماره را وارد کنید',
                controller: AddEditScreens.phoneController,
                hintText: "شماره",
                type: TextInputType.phone,),
              const SizedBox(height: 20,),
              ButtonWidget(onPressed: (){
                if(formKey.currentState!.validate()){
                  Network.checkInternet(context);
                  Future.delayed(const Duration(seconds: 3)).then((value){
                    if (Network.isConnected) {
                      if (AddEditScreens.id == 0) {
                        Network.postData(
                          phone: AddEditScreens.phoneController.text,
                          fullname: AddEditScreens.nameController.text);
                      }else{
                        Network.putData(phone: AddEditScreens.phoneController.text,
                        fullname: AddEditScreens.nameController.text,
                        id: AddEditScreens.id.toString());
                      }
                      Navigator.pop(context);
                    }else{
                      Network.showInternetError(context);
                    }
                  });
                }   
              }, text: AddEditScreens.id == 0 ? 'اضافه کردن' : 'ویرایش کردن'),
            ],
          ),
        ),
      ),
    );
  }
}
