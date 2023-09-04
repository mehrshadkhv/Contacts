import 'dart:convert';
import 'dart:io';

import 'package:contacts/screens/home_screen.dart';
import 'package:contacts/utils/responsive.dart';
import 'package:contacts/widgets/my_button_widget.dart';
import 'package:contacts/widgets/my_textfiled_widget.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LicenseScreen extends StatelessWidget {
  LicenseScreen({super.key});

  Future getDeviceId()async{
   var deviceInfo = DeviceInfoPlugin();
   if (Platform.isIOS) {
     var iosDeviceInfo = await deviceInfo.iosInfo;
     return iosDeviceInfo.identifierForVendor;
   }else{
     var androidDeviceInfo = await deviceInfo.androidInfo;
     return androidDeviceInfo.id;
   }
  }

  void showSuccessDialog(BuildContext context){
   CoolAlert.show(
    context: context,
    type: CoolAlertType.success,
    width: 100,
    title: 'موفق',
    confirmBtnText: 'باشه',
    confirmBtnTextStyle: const TextStyle(fontSize: 16,color: Colors.white),
    confirmBtnColor: Colors.redAccent,
    text: '! کد با موفقیت کپی شد ',
    );
  }
 
  final TextEditingController systemCodeController = TextEditingController();
  final TextEditingController activeCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    getDeviceId().then((value){
      systemCodeController.text = value ?? '';
    });
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.redAccent,
          elevation: 0,
          title: Text('فعال سازی', 
          style: TextStyle(
            fontSize: ScreenUtil(context).screenWidth < 1000 ? 16 : ScreenUtil(context).screenWidth * 0.013),),
          centerTitle: true,
          leading: const Icon(Icons.import_contacts_sharp),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: (){
                  Clipboard.setData(ClipboardData(text: systemCodeController.text));
                  showSuccessDialog(context);
                },
                child: MyTextField(
                  isEnabled: false,
                  errorText: '',
                  controller: systemCodeController,
                  hintText: 'کد سیستم',
                  type: TextInputType.text,),
              ),
              MyTextField(
                errorText: '',
                controller: activeCodeController,
                hintText: 'کد فعال سازی',
                type: TextInputType.text,),
                const SizedBox(height: 20,),
                ButtonWidget(onPressed: ()async{
                  var bytes1 = utf8.encode(systemCodeController.text);
                  var digest1 = sha512256.convert(bytes1);
                  print(digest1);
                  if (activeCodeController.text == digest1.toString()) {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('isActive', true);
                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()));
                  }else{

                  }
                }, text: 'فعال سازی'),
             ],
          ),
        ),
    );
  }
}