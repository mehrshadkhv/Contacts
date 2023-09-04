import 'package:contacts/screens/add_edit_screens.dart';
import 'package:flutter/material.dart';
import '../utils/network.dart';
import 'package:contacts/utils/responsive.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    Network.checkInternet(context);
    Future.delayed(const Duration(seconds: 3)).then((value){
      if (Network.isConnected) {
        Network.getData().then((value)async{
         await Future.delayed(const Duration(seconds: 3));
         setState(() {});
        });
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          elevation: 0,
          title: Text("دفترچه تلفن آنلاین" ,
          style: TextStyle(fontSize: ScreenUtil(context).screenWidth < 1000 ? 16 : ScreenUtil(context).screenWidth * 0.013 ),),
          centerTitle: true,
          leading: const Icon(Icons.import_contacts_sharp),
          actions: [
            IconButton(onPressed: (){
               Network.checkInternet(context);
               Future.delayed(const Duration(seconds: 3)).then((value){
               if (Network.isConnected) {
                Network.getData().then((value)async{
                 await Future.delayed(const Duration(seconds: 3));
                 setState(() {});
                });
                }else{
                  Network.showInternetError(context);
                }
              });
            }, icon: const Icon(Icons.refresh),),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.redAccent,
          elevation: 0,
          onPressed: (){
            AddEditScreens.id = 0;
            AddEditScreens.nameController.text = '';
            AddEditScreens.phoneController.text = '';
            Navigator.push(context, 
            MaterialPageRoute(
              builder: (context) => const AddEditScreens()),).then((value){
               Network.getData().then((value)async{
                await Future.delayed(const Duration(seconds: 5));
                setState(() {});
               });
              });
          },
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
         itemCount: Network.contacts.length,
         itemBuilder: (context , index){
          return  ListTile(
            onLongPress: ()async{
              Network.deleteContact(Network.contacts[index].id.toString());
              await Future.delayed(const Duration(seconds: 3));
              setState(() {});
              },
            leading: CircleAvatar(
              backgroundColor: Colors.redAccent,
              child: Text((index+1).toString() , style: TextStyle(
                color: Colors.white,
                fontSize: ScreenUtil(context).screenWidth < 1000 ? 16 : ScreenUtil(context).screenWidth * 0.012),),
            ),
            trailing: IconButton(
              onPressed: (){
                 AddEditScreens.id = Network.contacts[index].id;
                 AddEditScreens.nameController.text = Network.contacts[index].fullname;
                 AddEditScreens.phoneController.text = Network.contacts[index].phone;
                 Navigator.push(context, 
                 MaterialPageRoute(
                 builder: (context) => const AddEditScreens()),).then((value){
                 Network.getData().then((value)async{
                 await Future.delayed(const Duration(seconds: 5));
                 setState(() {});
                 });
                 });
              },
              icon: const Icon(Icons.edit),
            ),
            title: Text(Network.contacts[index].fullname ,
            style: TextStyle(fontSize: ScreenUtil(context).screenWidth < 1000 ? 16 : ScreenUtil(context).screenWidth * 0.012),),
            subtitle: Text(Network.contacts[index].phone ,
            style: TextStyle(fontSize: ScreenUtil(context).screenWidth < 1000 ? 16 : ScreenUtil(context).screenWidth * 0.01),),
          );
         },),
      ),
    );
  }
}
