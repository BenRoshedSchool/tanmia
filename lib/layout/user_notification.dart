import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controller/firebase_controller.dart';
import '../shared/constant.dart';

class UserNotification extends StatefulWidget {
  const UserNotification({super.key});

  @override
  State<UserNotification> createState() => _UserNotificationState();
}

class _UserNotificationState extends State<UserNotification> {
  // Sample data
  final FirebaseController firebaseController = Get.find<FirebaseController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,

        title: const Text("الإشعارات"),
        centerTitle: true,
      ),
        body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: firebaseController.getUserNotification(firebaseController.UserName),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.none) {
              return const Center(
                child: Text("لا يوجد اتصال بالانترنت"),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            var items = snapshot.data;
            if (items == null || items.isEmpty) {
              return const Center(child: Text('No data found.'));
            }

            // Reverse the list
            final reversedItems = items.reversed.toList();

            return ListView.builder(
              itemCount: reversedItems.length,
              itemBuilder: (context, index) {
                final notificationMap = reversedItems[index];
                print(notificationMap["reciver"]);
                print(notificationMap['status']);
                print(firebaseController.UserName);

                if(notificationMap["reciver"] == firebaseController.UserName && notificationMap['status'] == "ok" ){
                 return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            "تم قبول طلب الحذف من قبل ${notificationMap["sender"]}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "وقت و تاريخ الاستبدال: ${notificationMap["date_time"]}",
                          ),
                        ),


                      ],
                    ),
                  );
                }
                else
                  if(notificationMap['date_time'] == null){
                    return SizedBox();
                  }
                  else
                  {
                                 return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              "تم ارسال طلب حذف من قبل ${notificationMap["sender"]} للشخص ${notificationMap["deletedName"]} يحمل هوية ${notificationMap["idUserDeleted"]}",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "وقت و تاريخ الاستبدال: ${notificationMap["date_time"]}",
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              ElevatedButton(onPressed: () async {

                                int idNotification = DateTime.now().millisecondsSinceEpoch;
                                Map<dynamic, dynamic> notificationMap2 = {
                                  "deletedName": "nameUserDeleted",
                                  "idUserDeleted" : "idUserDeleted",
                                  "date_time": Constant.getCurrentDateTime(),
                                  "id": idNotification,
                                  "status": "ok",
                                  "sender": firebaseController.UserName ,
                                  "reciver" : notificationMap["sender"]
                                };

                                try{
                                  // Fetch the current number of notifications
                                  var event = await firebaseController.getUserNotificationNumber(notificationMap["sender"]).first;
                                  int numberNotification = event != null && event["notificationNumber"] != null
                                      ? event["notificationNumber"] + 1
                                      : 1;
                                  print('wadwdfawf');

                                  await firebaseController.getDataListStream(firebaseController.UserName).listen((event) async {
                                    for (Map<String, dynamic> users in event) {

                                      if (notificationMap["idUserDeleted"].toString() == users["id1"].toString() && notificationMap["id2UserDeleted"].toString() == users["id2"].toString()) {
                                        await firebaseController.deleteData("${firebaseController.UserName}/${users["primery_key"]}");
                                        await firebaseController.addnotificationFromUserToUser(notificationMap2, context, idNotification.toString() , notificationMap["sender"]);
                                        await  firebaseController.addNumberOfNotificationFromUserToUser( {"notificationNumber": numberNotification} , notificationMap["sender"]);
                                        await firebaseController.deleteData("notification/shelter/${firebaseController.UserName}/${notificationMap['id']}");

                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Text("تمت عملية الحذف"),
                                          ),
                                        );

                                      }
                                    }
                                  });

                                }catch(e){

                                }

                              }, child:Text("قبول")) ,
                              SizedBox(width: 10,),
                              ElevatedButton(onPressed: () async {
                                await firebaseController.deleteData("notification/shelter/${firebaseController.UserName}/${notificationMap['id']}");
                              },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red, // Background color
                                  foregroundColor: Colors.white, // Text color
                                  shadowColor: Colors.redAccent, // Shadow color
                                  elevation: 5, // Elevation of the button

                                ),
                                child:Text("الغاء") ,) ,
                            ],)
                        ],
                      ),
                    );

                  }
              },
            );
          },
        )
    );
  }
}
