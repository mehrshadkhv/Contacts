import 'package:contacts/screens/home_screen.dart';
import 'package:contacts/screens/license_screen.dart';
import 'package:flutter/material.dart';
import 'package:contacts/utils/network.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main(){
  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});
 
  @override
  State<MyApp> createState() => _MyAppState();
}

Future isActive()async{
 SharedPreferences prefs = await SharedPreferences.getInstance();
 return prefs.getBool('isActive') ?? false;
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    Network.checkInternet(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "دفترچه تلفن آنلاین",
      theme: ThemeData(fontFamily: "iransans"),
      home: FutureBuilder(future: isActive(),builder: (context,snapshot){
        if (snapshot.data == true) {
          return const HomeScreen();
        }else{
          return LicenseScreen();
        }
      }),
    ) ;
  }
}

