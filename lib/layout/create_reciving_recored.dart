import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:untitled2/controller/firebase_controller.dart';
import 'package:untitled2/layout/users_home_screen.dart';
import 'package:untitled2/modles/users_info.dart';
import 'package:untitled2/shared/constant.dart';

import '../controller/add_family_controller.dart';
import '../controller/listfamily_controller.dart';
import '../controller/localdatabase_controller.dart';
import '../controller/user_home_controller.dart';
import '../modles/record_recpients.dart';
import '../modles/recored_reciving.dart';
import '../modles/users_info_for_local.dart';
import '../widgets/elevation_button.dart';
import '../widgets/text_filed.dart';

class CreateRecivingRecored extends StatelessWidget {
  String userName;
  CreateRecivingRecored({required this.userName});
   @override
  Widget build(BuildContext context) {

     final FirebaseController firebaseController = Get.find<FirebaseController>();
     final ListFamilyController listFamilyController = Get.put(ListFamilyController());
     final LocalDataBaseController localDataBaseController = Get.put(LocalDataBaseController());
     final UserHomeController userHomeController = Get.put(UserHomeController());

       final TextEditingController firstNameController = TextEditingController();
       final TextEditingController secondNameController = TextEditingController();
       final TextEditingController yearController = TextEditingController();
       final TextEditingController birthDateController = TextEditingController();
     return WillPopScope(
       onWillPop: ()async{
         SystemNavigator.pop();
         return true;
       },
       child: GetBuilder<UserHomeController>(
           builder: (controller){
             return            AlertDialog(
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
                       controller: yearController,
                       keyboardType: TextInputType.number,
                       decoration: InputDecoration(labelText: 'أدخل عدد الطرود المسلمة'),
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

                 controller.dialogAddRecivingRecored ? Center(child: CircularProgressIndicator(),):
                 TextButton(
                   child: Text('تم'),
                   onPressed: () async {
                     userHomeController.isSavedRecored(true);
                     controller.changeDialogAddRecivingRecored(true);
                     try {

                       // التأكد من صحة البيانات
                       if (firstNameController.text.isEmpty ||
                           secondNameController.text.isEmpty ||
                           yearController.text.isEmpty ||
                           birthDateController.text.isEmpty) {
                         controller.changeDialogAddRecivingRecored(false);

                         ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(
                             content: Text('الرجاء ادخال جميع الحقول'),
                             backgroundColor: Colors.deepOrangeAccent,
                           ),
                         );
                         return;
                       }

                       String title = firstNameController.text;
                       String type = secondNameController.text;
                       String number = yearController.text;
                       String birthDate = birthDateController.text;

                       int key = DateTime.now().millisecondsSinceEpoch;
                       Map<String, dynamic> record = {
                         "title": title,
                         "number_of_parcels": number,
                         "type_of_parcels": type,
                         "date": birthDate,
                         "primery_key": key.toString(),
                         "recipients":{},
                       };

                       // Handle potential null value from Constant.getLateNum()
                       int? lat = await Constant.getLateNum(firebaseController.UserName);
                       print("lats  ${lat}");
                       if (lat == null) {
                         lat = 0; // Provide a default value if null
                       }

                       // فحص وجود الانترنت لحفظ الكشف و المستلمين
                       bool isInternet = await Constant.checkInternetConnection();
                       print("isInternet ${isInternet}");

                       // حفظ عل الانترنت و التخزين الداخلي

                       if(isInternet == true){
                         List<UserInfo>? recipients = await firebaseController.getDataFromDatabase(
                             userName, lat, int.parse(number), listFamilyController.t);

                         print(recipients[0].primery_key);

                         if (recipients != null) {
                           Map<dynamic, dynamic> recipientsMap = {
                             for (int i = 0; i < recipients.length; i++)
                               '${recipients[i].primery_key}': recipients[i].toJson()
                           };


                           // Adding record and recipients to Firebase
                           await firebaseController.addRecord(this.userName, key.toString(), record, context);

                           // الحفظ في التخزين الداخلي
                           localDataBaseController.database.personDao.insertRecordReciving(RecoredReciving(
                               date: birthDate,
                               title: title,
                               typeOfCells: type,
                               numberOfParcel: number,
                               documentId: key.toString(),
                               shelter: firebaseController.UserName) ,
                           );
                           await firebaseController.addRecipients(userName, key.toString(),  recipientsMap, context);


                           // حفظ المستلمين في التخزين الداخلي
                           for(UserInfo users in recipients){

                             try{
                               localDataBaseController.database.personDao.insertRecoredRecpients(
                                   RecoredRecpients(
                                     documentId:key.toString(),
                                     id1: users.id1,
                                     id2: users.id2,
                                     name1: users.name1,
                                     name2: users.name2,
                                     notes: users.notes,
                                     numberOfFamily: users.numberOfFamily,
                                     originalResidence: users.originalResidence,
                                     primery_key: users.primery_key.toString(),
                                     residenceStatus: users.residenceStatus,
                                     shelter: users.shelter,
                                     status: users.status,
                                     mobile: int.parse(users.mobile.toString()),
                                     receiving_status: "لم يتم الاستلام",
                                   )
                               );
                             }catch(e){
                               print("EXEPTIONS  : ${e.toString()}");

                             }
                           }

                           int total = lat + int.parse(number);
                           int threshold = listFamilyController.t; // عدد العوئل

                           if (total >= threshold) {
                             Constant.saveLat(total - threshold , firebaseController.UserName);
                             firebaseController.saveLat(userName, total - threshold , context);
                           } else {
                             int? lat2 = await Constant.getLateNum(firebaseController.UserName);
                             Constant.saveLat((lat2 ?? 0) + int.parse(number) , firebaseController.UserName);
                             firebaseController.saveLat(userName, (lat2 ?? 0) + int.parse(number), context);
                           }
                         } else {
                           print("No recipients found.");
                         }

                         ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(
                             backgroundColor: Colors.green,
                             content: Text("تم انشاء الكشف بنجاح"),
                           ),
                         );
                       }else{

                         // الحفظ في التخزين الداخلي
                         localDataBaseController.database.personDao.insertRecordReciving(RecoredReciving(
                             date: birthDate,
                             title: title,
                             typeOfCells: type,
                             numberOfParcel: number,
                             documentId: key.toString() ,
                             shelter: firebaseController.UserName));

                         // مصفوفة المستلمين
                         List<RecoredRecpients> tempList = [];
                         // جلب ببانات لاستخراج المستلمين
                         localDataBaseController.database.personDao.getUsersFamily(firebaseController.UserName).listen((event) {

                           print("EVENT ${event[0].mobile}");
                           // Populate tempList based on latLimit and newLimit
                           if (event.length <= lat! + int.parse(number.toString())) {
                             for (int i = lat! ; i < event.length; i++) {
                               UserInfoForlocal usersforLocal =  event[i];
                               tempList.add(

                                   RecoredRecpients(
                                     documentId:key.toString(),
                                     id1: usersforLocal.id1,
                                     id2: usersforLocal.id2,
                                     name1: usersforLocal.name1,
                                     name2: usersforLocal.name2,
                                     notes: usersforLocal.notes,
                                     numberOfFamily: usersforLocal.numberOfFamily,
                                     originalResidence: usersforLocal.originalResidence,
                                     primery_key: usersforLocal.primery_key.toString(),
                                     residenceStatus: usersforLocal.residenceStatus,
                                     shelter: usersforLocal.shelter,
                                     status: usersforLocal.status,
                                     mobile: int.parse(usersforLocal.mobile.toString()),
                                     receiving_status: "لم يتم الاستلام",
                                   )
                             );
                               print("I < USER.LENGTH");
                             }

                             int newAndLat = int.parse(number.toString()) + lat;
                             for (int t = 0; t < newAndLat - event.length; t++) {
                               UserInfoForlocal usersforLocal =  event[t];
                               tempList.add(
                                   RecoredRecpients(
                                     documentId:key.toString(),
                                     id1: usersforLocal.id1,
                                     id2: usersforLocal.id2,
                                     name1: usersforLocal.name1,
                                     name2: usersforLocal.name2,
                                     notes: usersforLocal.notes,
                                     numberOfFamily: usersforLocal.numberOfFamily,
                                     originalResidence: usersforLocal.originalResidence,
                                     primery_key: usersforLocal.primery_key.toString(),
                                     residenceStatus: usersforLocal.residenceStatus,
                                     shelter: usersforLocal.shelter,
                                     status: usersforLocal.status,
                                     mobile: int.parse(usersforLocal.mobile.toString()),
                                     receiving_status: "لم يتم الاستلام",
                                   ));
                               print("I < newAndLat-userInfoList.length");
                             }
                           } else {
                             for (int i = lat; i < lat + int.parse(number); i++) {
                               UserInfoForlocal usersforLocal =  event[i];
                               print("I > LAT+NEWLIMT ${usersforLocal.name1}");

                               tempList.add(
                                   RecoredRecpients(
                                     documentId:key.toString(),
                                     id1: usersforLocal.id1,
                                     id2: usersforLocal.id2,
                                     name1: usersforLocal.name1,
                                     name2: usersforLocal.name2,
                                     notes: usersforLocal.notes,
                                     numberOfFamily: usersforLocal.numberOfFamily,
                                     originalResidence: usersforLocal.originalResidence,
                                     primery_key: usersforLocal.primery_key.toString(),
                                     residenceStatus: usersforLocal.residenceStatus,
                                     shelter: usersforLocal.shelter,
                                     status: usersforLocal.status,
                                     mobile: int.parse(usersforLocal.mobile.toString()),
                                     receiving_status: "لم يتم الاستلام",
                                   ));
                               localDataBaseController.database.personDao.insertRecoredRecpients(
                                   RecoredRecpients(
                                     documentId:key.toString(),
                                     id1: usersforLocal.id1,
                                     id2: usersforLocal.id2,
                                     name1: usersforLocal.name1,
                                     name2: usersforLocal.name2,
                                     notes: usersforLocal.notes,
                                     numberOfFamily: usersforLocal.numberOfFamily,
                                     originalResidence: usersforLocal.originalResidence,
                                     primery_key: usersforLocal.primery_key.toString(),
                                     residenceStatus: usersforLocal.residenceStatus,
                                     shelter: usersforLocal.shelter,
                                     status: usersforLocal.status,
                                     mobile: int.parse(usersforLocal.mobile.toString()),
                                     receiving_status: "لم يتم الاستلام",
                                   ));

                             }
                           }

                         });

                         int total = lat + int.parse(number);
                         int threshold = listFamilyController.t; // عدد العوئل

                         if (total >= threshold) {
                           Constant.saveLat(total - threshold , firebaseController.UserName);
                         } else {
                           int? lat2 = await Constant.getLateNum(firebaseController.UserName);
                           Constant.saveLat((lat2 ?? 0) + int.parse(number) , firebaseController.UserName);
                         }

                         // حفظ المستلمين في التخزين الداخلي
                         // for(RecoredRecpients recoredRecipients in tempList){
                         //
                         //   try{
                         //
                         //     print(recoredRecipients.mobile);
                         //     localDataBaseController.database.personDao.insertRecoredRecpients(recoredRecipients);
                         //
                         //   }catch(e){
                         //     print("EERROR : ${e}");
                         //   }
                         //
                         // }



                       }

                       userHomeController.isSavedRecored(false);
                       userHomeController.changeTabs(1);

                       controller.changeDialogAddRecivingRecored(false);
                     } catch (e) {
                       print("An error occurred: $e");
                       ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(
                           content: Text('حدث خطأ. الرجاء المحاولة مرة أخرى.'),
                           backgroundColor: Colors.redAccent,
                         ),
                       );
                       controller.changeDialogAddRecivingRecored(false);
                       Get.back();
                     }
                   },
                 ),
               ],
             );

           }
       ),
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
