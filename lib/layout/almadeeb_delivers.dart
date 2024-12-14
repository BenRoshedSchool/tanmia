import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:untitled2/layout/my_deliveries_screen.dart';

import '../controller/firebase_controller.dart';
import '../routes/app_routes.dart';
import 'deliverablesـrecored.dart';

class AlManadeebDelivers extends StatelessWidget {
  AlManadeebDelivers({super.key});
  final FirebaseController firebaseController = Get.find<FirebaseController>();
  String f = "كشوفات تسليم";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,

        title: Text("المناديب"),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: StreamBuilder <List<Map<String, dynamic>>>(
            stream: firebaseController.getUsersToAdminAccountStream("usersInfo"),
            builder: (context , snapshot){

              return  ListView.separated(
                  itemBuilder: (context , index) {
                   Map<String , dynamic> users =  snapshot.data![index+1];
                   if(users != null){
                     return InkWell(
                       onTap:()  {
                         Get.to(MyDeliveries_Screen(userName: "${users["user_name"]}",));

                       },
                       child: Container(
                         color: Colors.greenAccent,
                         child: Text("${users["user_name"]}" , style: TextStyle(fontSize: 25),),
                       ),
                     );

                   }
                  },
                  separatorBuilder: (context , index) => Container(height: 3,),
                  itemCount: snapshot.data!.length-1);
            },

          ),
        ),
      ),
    );
  }
}
