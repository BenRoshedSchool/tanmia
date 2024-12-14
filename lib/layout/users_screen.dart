import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:untitled2/shared/constant.dart';

import '../controller/firebase_controller.dart';

class UsersScreen extends StatelessWidget {
   UsersScreen({super.key});
  final FirebaseController firebaseController = Get.put(FirebaseController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,

        title: Text("المستخدمين"),
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
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return Center(child: CircularProgressIndicator(),);
                    }else
                      if(snapshot.connectionState == ConnectionState.none){
                        return Center(child: Text("لا يوجد اتصال بالانترنت  !!!"),);
                      }else
                        if(snapshot != null){
                          Map<String , dynamic> users =  snapshot.data![index];
                          if(users != null){
                            return Container(
                              color: Colors.greenAccent,
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      Text("اسم المستخدم : ${users["user_name"]}") ,
                                      Text(" كلمة المرور:  ${users["pass"]}") ,

                                    ],
                                  ),
                                  Expanded(child: SizedBox()),
                                  Column(
                                    children: [
                                      IconButton(onPressed: () async {

                                         _showDialog(context, users["user_name"]);
                                      },
                                          icon: Icon(Icons.edit))
                                    ],
                                  )
                                ],
                              ),
                            );

                          }
                        }

                  },
                  separatorBuilder: (context , index) => Container(height: 3,),
                  itemCount: snapshot.data!.length);
            },

          ),
        ),
      ),
    );
  }


   Future<void> _showDialog(BuildContext context , String userName) async {
     final TextEditingController firstNameController = TextEditingController();
     final TextEditingController pass = TextEditingController();


     showDialog(
       context: context,
       builder: (BuildContext context) {
         return AlertDialog(
           title: Text('تغيير المندوب'),
           content: SingleChildScrollView(
             child: Column(
               mainAxisSize: MainAxisSize.min,
               children: <Widget>[
                 TextField(
                   controller: firstNameController,
                   decoration: InputDecoration(labelText: 'أدخل اسم المندوب الحديد'),
                 ),

                 TextField(
                   controller: pass,
                   decoration: InputDecoration(labelText: 'كلمة المرور'),
                 ),
               ],
             ),
           ),
           actions: <Widget>[
             TextButton(
               child: Text('إلغاء'),
               onPressed: () {
                 Navigator.of(context).pop();
               },
             ),
             TextButton(
               child: Text('تم'),
               onPressed: () async {
                 try {
                   if (firstNameController.text.isEmpty && pass.text.isEmpty) {
                     ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(
                         content: Text('الرجاء ادخال البيانات '),
                         backgroundColor: Colors.deepOrangeAccent,
                       ),
                     );
                     return;
                   }
                   await firebaseController.changeShelter(userName  , pass.text ,  firstNameController.text , context);



                   Navigator.of(context).pop();
                 } catch (e) {
                   print("An error occurred: $e");
                   ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(
                       content: Text('حدث خطأ. الرجاء المحاولة مرة أخرى.'),
                       backgroundColor: Colors.redAccent,
                     ),
                   );
                 }
               },
             ),
           ],
         );
       },
     );
   }

}
