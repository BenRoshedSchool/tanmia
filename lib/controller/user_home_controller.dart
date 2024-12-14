import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'firebase_controller.dart';

class UserHomeController extends GetxController {
  final FirebaseController firebaseController = Get.put(FirebaseController());

  // Reactive variable to observe changes in notification count
  RxInt numOfNoti = 0.obs;
  bool isSavedRecivingRecored=false;
  int selectedIndex = 2;
  Widget widget=SizedBox();
  bool dialogAddRecivingRecored=false;



  @override
  void onInit() {
    super.onInit();
    getNotificationNumber();

  }


  void getNotificationNumber() {
    // Listening for real-time updates
    firebaseController.getUserNotificationNumber(firebaseController.UserName).listen((event) {
      if (event != null && event["notificationNumber"] != null) {
        numOfNoti.value = event["notificationNumber"];
      }
    });
  }

  void isSavedRecored(bool saved){
    isSavedRecivingRecored = saved;
    update();
  }

  void changeTabs(int numPag){
   switch(numPag){
     case 0:
       widget = Text("  التسجيل للأطفال من يوم إلى 12 سنة");
     case 1:
     widget =  Column(
       children: [
         Row(
           children: [
             Expanded(
               child: Center(
                 child: Text("قائمة التسليمات"),
               ),
             ),
           ],
         ),
       ],
     );

     case 3:
       widget = Text("إنشاء كشف تسليم");
break;
   }
    selectedIndex=numPag;
    update();
  }

  void changeDialogAddRecivingRecored(bool change){
    dialogAddRecivingRecored=change;
    update();
  }

}
