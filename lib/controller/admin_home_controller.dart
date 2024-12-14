import 'package:get/get.dart';
import 'firebase_controller.dart';

class AdminHomeController extends GetxController {
  final FirebaseController firebaseController = Get.put(FirebaseController());

  // Reactive variable to observe changes in notification count
  RxInt numOfNoti = 0.obs;
  bool dialogAddRecivingRecored=false;

  @override
  void onInit() {
    super.onInit();
    getNotificationNumber();
  }

  void getNotificationNumber() {
    // Listening for real-time updates
    firebaseController.getNotificationNumber().listen((event) {
      if (event != null && event["notificationNumber"] != null) {
        numOfNoti.value = event["notificationNumber"];
      }
    });
  }


  void changeDialogAddRecivingRecored(bool change){
    dialogAddRecivingRecored=change;
    update();
  }
}
