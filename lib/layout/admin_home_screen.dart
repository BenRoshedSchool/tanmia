import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:untitled2/controller/admin_home_controller.dart';
import 'package:untitled2/layout/admin_notification.dart';
import 'package:untitled2/layout/almadeeb_delivers.dart';
import 'package:untitled2/layout/percentage_screen.dart';
import 'package:untitled2/layout/users_screen.dart';
import 'package:untitled2/modles/users_info.dart';

import '../controller/firebase_controller.dart';
import '../controller/localdatabase_controller.dart';
import '../controller/login_controller.dart';
import '../controller/percentage-controller.dart';
import '../routes/app_routes.dart';
import '../shared/constant.dart';
import '../widgets/elevation_button.dart';

class Admin_Home_Screen extends StatefulWidget {
  const Admin_Home_Screen({super.key});

  @override
  State<Admin_Home_Screen> createState() => _Admin_Home_ScreenState();
}

class _Admin_Home_ScreenState extends State<Admin_Home_Screen> {

  final FirebaseController firebaseController = Get.put(FirebaseController());
  final AdminHomeController adminHomeController = Get.put(AdminHomeController());
  PercentageController percentageController = Get.put(PercentageController());
  final LocalDataBaseController  localDataBaseController= Get.put(LocalDataBaseController());
  final LoginController loginController = Get.put(LoginController());


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("initi");
    

  }

  @override
  Widget build(BuildContext context) {
    print("build");

    return WillPopScope(
      onWillPop: ()async{

        SystemNavigator.pop();

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlueAccent,

          title: Text("Mahmoud Nassar"),
          centerTitle: true,
          leading: InkWell(
              onTap: (){
                Constant.saveUser("");
                Get.offAllNamed(Routes.loginScreen);
                loginController.setIsLogin(false);
              },
              child: Icon(Icons.logout)),
          actions: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                IconButton(onPressed: (){

                  Get.to(AdminNotification());
                  firebaseController.addNumberOfNotificationFromUserToAdmin(
                      {"notificationNumber":0});
                },
                    icon: Icon(Icons.notifications_active_outlined , size: 35,)),

                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 10,
                    child: Obx(() => Text("${adminHomeController.numOfNoti}")),
                  ),
                )
              ],
            )
          ],
        ),
        body: Container(
          color:Colors.white10,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Elevation_Button(
                      function: (){
                        Get.toNamed(Routes.alshoabScreen);
                      },
                      backColor: Colors.indigo,
                      inputText: "الأحياء" ,
                      widthButtton: MediaQuery.of(context).size.width,) ,
                    SizedBox( height: 25,) ,
                    Elevation_Button(
                      function: (){},
                      backColor: Colors.indigo,
                      inputText: "الايواءات" ,
                      widthButtton: MediaQuery.of(context).size.width,) ,

                    SizedBox( height: 25,) ,
                    Elevation_Button(
                      function: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> UsersScreen()));
                      },
                      backColor: Colors.indigo,
                      inputText: "المستخدمين",
                      widthButtton: MediaQuery.of(context).size.width,) ,

                    SizedBox( height: 25,) ,
                    Elevation_Button(
                      function: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> AlManadeebDelivers()));
                      },
                      backColor: Colors.indigo,
                      inputText: "التسليمات",
                      widthButtton: MediaQuery.of(context).size.width,) ,


                    SizedBox( height: 25,) ,
                    Elevation_Button(
                      function: () async {
                        SystemChrome.setPreferredOrientations([
                          DeviceOrientation.landscapeLeft,
                        ]
                        );

                        Navigator.push(context, MaterialPageRoute(builder: (context)=> PercentageScreen()));

                      },
                      backColor: Colors.indigo,
                      inputText: "انشاء كشف النسية",
                      widthButtton: MediaQuery.of(context).size.width,) ,


                    SizedBox( height: 25,) ,
                    Elevation_Button(
                      function: () async {
                       _showDialog(context);
                      },
                      backColor: Colors.indigo,
                      inputText: "انشاء تسليمات للمناديب",
                      widthButtton: MediaQuery.of(context).size.width,) ,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    final TextEditingController firstNameController = TextEditingController();
    final TextEditingController secondNameController = TextEditingController();
    final TextEditingController yearController = TextEditingController();
    final TextEditingController birthDateController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: (){
            adminHomeController.changeDialogAddRecivingRecored(false);
            Get.back();
          },
          child: GetBuilder<AdminHomeController>(
            builder:(controller)=> AlertDialog(
              title: Text('إنشاء كشف تسليم'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: firstNameController,
                      decoration: InputDecoration(labelText: 'أدخل عنوان للكشف'),
                    ),
                    TextField(
                      controller: secondNameController,
                      decoration: InputDecoration(labelText: 'أدخل نوع الطرود التي سوف يتم تسليمها'),
                    ),
                    TextField(
                      controller: birthDateController,
                      readOnly: true,
                      onTap: () {
                        _selectDate(context, birthDateController);
                      },
                      decoration: InputDecoration(
                        labelText: 'تاريخ التسليم',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () {
                            _selectDate(context, birthDateController);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                controller.dialogAddRecivingRecored ? SizedBox():
                TextButton(
                  child: Text('إلغاء'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
               controller.dialogAddRecivingRecored? Center(child: CircularProgressIndicator(),):
               TextButton(
                  child: Text('تم'),
                  onPressed: () async {
                    controller.changeDialogAddRecivingRecored(true);
                    try {
                      if (firstNameController.text.isEmpty ||
                          secondNameController.text.isEmpty ||
                          birthDateController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('الرجاء ادخال جميع الحقول'),
                            backgroundColor: Colors.deepOrangeAccent,
                          ),
                        );
                        controller.changeDialogAddRecivingRecored(false);
                        return;
                      }

                      String title = firstNameController.text;
                      String type = secondNameController.text;
                      String birthDate = birthDateController.text;

                      final List<Map<String, dynamic>> users = await firebaseController.getUsersToAdminAccountFuture("usersInfo");


                      for (Map<String, dynamic> userName in users) {
                        int key = DateTime.now().millisecondsSinceEpoch;
                        Map<String, dynamic> record = {
                          "title": title,
                          "type_of_parcels": type,
                          "date": birthDate,
                          "primery_key": key.toString(),
                          "recipients": {}, // Set to empty initially
                        };

                        if(userName["user_name"] != "admin" ){
                          await firebaseController.addRecord(userName["user_name"], key.toString(), record, context);

                          // Retrieve data once and add all recipients at once
                          Map<dynamic, dynamic> eventData = await firebaseController.getDataOnce(userName["user_name"]);
                          Map<String, dynamic> recipientData = {};

                          eventData.forEach((key, value) {
                            Map<String, dynamic> map = Map<String, dynamic>.from(value);
                            map['receiving_status'] = 'لم يتم الاستلام';
                            recipientData[key.toString()] = map; // Use key as identifier
                          });

                          await firebaseController.addRecipients(userName["user_name"], key.toString(), recipientData, context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.green,
                              content: Text("تم انشاء الكشف بنجاح"),
                            ),
                          );
                          print(userName["user_name"]);

                        }

                      }

                      controller.changeDialogAddRecivingRecored(false);
                      Navigator.of(context).pop();


                    } catch (e) {
                      print("An error occurred: $e");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('حدث خطأ. الرجاء المحاولة مرة أخرى.'),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                      controller.changeDialogAddRecivingRecored(false);

                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      controller.text = "${picked.day.toString()}/${picked.month.toString()}/${picked.year.toString()}"; // Format the date as you like
    }
  }


}
