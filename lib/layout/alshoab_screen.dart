
import 'dart:io' show Directory, File, Platform;
import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:untitled2/controller/listfamily_controller.dart';

import '../controller/firebase_controller.dart';
import '../modles/users_info.dart';
import '../routes/app_routes.dart';
import '../shared/constant.dart';

class Alshoab_Screen extends StatelessWidget {
   Alshoab_Screen({super.key});
  final FirebaseController firebaseController = Get.find<FirebaseController>();
   final ListFamilyController listFamilyController = Get.put(ListFamilyController());


   @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        Get.toNamed(Routes.adminHomeScreen);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlueAccent,

          title:Text("الشعب"),
          centerTitle: true,
        ),
        body: GetBuilder<ListFamilyController>(
          builder: (listFamilyController){
            return  Stack(
              alignment: Alignment.center,
              children: [
                Container(
                    color: Colors.white10,
                    child: ListView.separated(
                        itemBuilder: (context , index) => InkWell(
                          onTap: (){
                            Get.toNamed(Routes.almanadeepScreen , arguments: {"alshoab": Constant.shoab[index]});
                          },
                          child: Container(
                            child: Container(
                              height: 50,
                              color: Colors.grey,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10 , vertical: 10),
                                child: Row(
                                  children: [
                                    Text(Constant.shoab[index]) ,
                                    Expanded(child: SizedBox(width: 25,)) ,
                                    InkWell(
                                        onTap: () async {
                                          if(await Constant.checkInternetConnection() && Platform.isAndroid){
                                          exportToExcel(context, Constant.shoab[index]);
                                          }
                                        },
                                        child: Icon(Icons.file_download))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        separatorBuilder: (context , index) => Container(height: 3, ),
                        itemCount: Constant.shoab.length)
                ),
                listFamilyController.isLoadingFile ?
              CircularProgressIndicator() : SizedBox(),

              ],
            );
          },

        ) ,
      ),
    );
  }


  Future<void> exportToExcel(BuildContext context , String alshoab) async {

     listFamilyController.onStatrtExportToExcel();

    // Request storage permission
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];
    List<UserInfo> usersList = [];
    // Adding header row
    sheetObject.appendRow(['الرقم', 'الحالة الإجتماعية' , 'هوية الزوج', 'اسم الزوج', 'هوية الزوجة', 'اسم الزوجة','عدد الأفراد' , 'جوال' , 'السكن الأصلي' ,'حالة الإقامة' ,
      'المندوب' , 'الملاحظات']);
    // List<Map<String , dynamic>> usersInAlshoabList = await Constant.getUsersByAlshoab(alshoab);
    // for(String user in usersInAlshoabList){
    //   List<UserInfo> list = await  firebaseController.getUsersAsFuture(user);
    //   for (int i = 0; i < list.length; i++) {
    //     sheetObject.appendRow([
    //       i + 1,
    //       list[i].status,
    //       list[i].id1,
    //       list[i].name1,
    //       list[i].id2,
    //       list[i].name2,
    //       list[i].numberOfFamily,
    //       list[i].mobile,
    //       list[i].originalResidence,
    //       list[i].residenceStatus,
    //       list[i].shelter,
    //       list[i].notes,
    //     ]);
    //
    //
    //   }
    //
    //
    // }

     List<Map<String , dynamic>> usersInAlshoabList = await Constant.getUsersByAlshoab(alshoab);
     for(int i=0 ; i< usersInAlshoabList.length ; i++){

       List<UserInfo> list = await  firebaseController.getUsersAsFuture(usersInAlshoabList[i]["value"]);
       for (int i = 0; i < list.length; i++) {
         sheetObject.appendRow([
           i + 1,
           list[i].status,
           list[i].id1,
           list[i].name1,
           list[i].id2,
           list[i].name2,
           list[i].numberOfFamily,
           list[i].mobile,
           list[i].originalResidence,
           list[i].residenceStatus,
           list[i].shelter,
           list[i].notes,
         ]);


       }


     }



     // Request storage permission
     if (await Permission.storage.request().isGranted) {
       // Get the Downloads directory
       final downloadsDir = Directory('/storage/emulated/0/Download');
       if (!downloadsDir.existsSync()) {
         downloadsDir.createSync(recursive: true);
       }
       final title = " كشف ${alshoab}";


       // Save the file
       final filePath = '${downloadsDir.path}/$title.xlsx';
       final file = File(filePath);
       file.writeAsBytesSync(excel.encode()!);
       print("File saved at $filePath");

       // Notify the user
       listFamilyController.onStatrtExportToExcel(); // End UI feedback
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text("تم الحفظ في مجلد التنزيلات: $filePath"), backgroundColor: Colors.blueGrey),
       );
     } else {
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text("لم يتم منح إذن التخزين"), backgroundColor: Colors.red),
       );
     }

  }

}
