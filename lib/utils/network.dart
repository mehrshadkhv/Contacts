import 'dart:convert' as convert;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/contact.dart';

class Network{
  static Uri url = Uri.parse('https://retoolapi.dev/ZpII7V/contacts');
  static Uri urlwhithId(String id){
    Uri url = Uri.parse('https://retoolapi.dev/ZpII7V/contacts/$id');
    return url;
  }
  static List<Contact> contacts = [];

  //! check internet
  static bool isConnected = false;
  static Future<bool> checkInternet(BuildContext context) async{
   Connectivity().onConnectivityChanged.listen((status) { 
    if (status == ConnectivityResult.wifi || status == ConnectivityResult.mobile) {
      isConnected = true;
    }else{
      showInternetError(context);
      isConnected = false;
      
    }
    print(Network.isConnected);
   });
   return isConnected;
  }

  //* show Internet Error
  static void showInternetError(BuildContext context){
    CoolAlert.show(
    context: context,
    type: CoolAlertType.error,
    width: 100,
    title: 'خطا',
    text: '! شما به اینترنت متصل نیستید',
    confirmBtnText: 'باشه',
    confirmBtnTextStyle: const TextStyle(fontSize: 16,color: Colors.white),
    confirmBtnColor: Colors.redAccent,);
  }
  

  //! Get data
  static getData() async{
    contacts.clear();
    await http.get(Network.url).then((response){
      if(response.statusCode == 200){
        List jsonDecode = convert.jsonDecode(response.body);
        for (var json in jsonDecode) {
          contacts.add(Contact.fromJson(json));
        }
      }
    });
  }
  //* post data
  static void postData({required String phone, required String fullname}) async{
    Contact contact = Contact(phone: phone, fullname: fullname);
    await http.post(Network.url,body: contact.toJson()).then((response) {
     print(response.body);
    });
  }

  //! put Data
  static void putData({required String phone, required String fullname, required String id,}) async{
    Contact contact = Contact(phone: phone, fullname: fullname);
    await http.put(urlwhithId(id),body: contact.toJson()).then((response) {
      print(response.body);
    });
  }
  //! Delete Contact
 static void deleteContact(String id){
    http.delete(Network.urlwhithId(id)).then((value) {
      getData();
    });
 }
}