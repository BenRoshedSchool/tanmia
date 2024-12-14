import 'dart:async';
import 'dart:io' show Directory, File, Platform;
import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:untitled2/layout/almanadeeb_screen.dart';
import 'package:untitled2/layout/deliverables%D9%80recored.dart';
import 'package:untitled2/modles/record_recpients.dart';
import 'package:untitled2/modles/users_info.dart';
import 'package:untitled2/routes/app_routes.dart';
import 'package:untitled2/shared/constant.dart';
import '../controller/firebase_controller.dart';
import '../controller/localdatabase_controller.dart';




class MyDeliveries_Screen extends StatefulWidget {
 final String? userName;

  MyDeliveries_Screen({this.userName});

  @override
  _MyDeliveries_Screen createState() => _MyDeliveries_Screen();
}

class _MyDeliveries_Screen extends State<MyDeliveries_Screen> {
  FirebaseController firebaseController = Get.put(FirebaseController());
  final LocalDataBaseController  localDataBaseController= Get.put(LocalDataBaseController());

  String f = "كشوفات تسليم";
  String h = "recipients";
  String searchQuery = ''; // Variable to store search query
  String username="";
  static const MethodChannel _channel = MethodChannel('flutter.baseflow.com/permissions/methods');
  @override
  Widget build(BuildContext context) {



    // globalUserName = username;
    return WillPopScope(
      onWillPop: ()async{
        if(firebaseController.UserName != "admin"){
          SystemNavigator.pop();
        }else{
          Navigator.pop(context);
        }
        return true;
      },
      child: Scaffold(

        body: SafeArea(
          child: Container(
            color: Colors.white10,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value; // Update search query
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'بحث...',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),


                  firebaseController.UserName == "admin"?
                  Expanded(
                    child: StreamBuilder<Map<dynamic, dynamic>>(
                      stream: firebaseController.getDataStream("كشوفات تسليم/${widget.userName}"),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none) {
                          return Center(
                            child: Text("لا يوجد اتصال بالانترنت"),
                          );
                        } else if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                          return Center(
                            child: Text("لا يوجد كشوفات قم بإنشاء كشف تسلبم جديد"),
                          );
                        } else {
                          Map<dynamic, dynamic> data = snapshot.data!;

                          // Filter the data based on the search query
                          final filteredData = data.entries.where((entry) {
                            final value = entry.value;

                            // Check if value is a Map, as we expect, before accessing keys
                            if (value is Map) {
                              return value["title"].toString().contains(searchQuery) ||
                                  value["type_of_parcels"].toString().contains(searchQuery) ||
                                  value["date"].toString().contains(searchQuery);
                            } else {
                              print("Unexpected data type: ${value.runtimeType}");
                              return false; // Skip entries that are not maps
                            }
                          }).toList();

                          return ListView.separated(
                            itemBuilder: (context, index) {
                              String key = filteredData[index].key;
                              Map<dynamic, dynamic> value = filteredData[index].value as Map<dynamic, dynamic>;

                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DeliverablesrRecored(
                                        keys: value["primery_key"],
                                        title: value["title"],
                                        user: widget.userName!,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                    color: Color.fromRGBO(195, 206, 231, 1.0),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context).size.width * 0.3,
                                            child: Text(
                                              value["title"] ?? "",
                                              overflow: TextOverflow.clip,
                                              style: TextStyle(fontSize: 16),
                                              maxLines: 2,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Container(
                                            width: MediaQuery.of(context).size.width * 0.3,
                                            child: Text(
                                              "نوع الطرد: ${value["type_of_parcels"] ?? ""}",
                                              overflow: TextOverflow.clip,
                                              maxLines: 3,
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Expanded(child: SizedBox(width: 20)),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              width: MediaQuery.of(context).size.width * 0.25,
                                              child: Text("التاريخ: ${value["date"] ?? ""}", style: TextStyle(fontSize: 16))),
                                          SizedBox(height: 10),
                                          Text("عدد الطرود: ${value["number_of_parcels"] ?? 0}", style: TextStyle(fontSize: 16)),
                                        ],
                                      ),
                                      Expanded(child: SizedBox(width: 10)),
                                      Column(
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              bool internet = await Constant.checkInternetConnection();
                                              if(kIsWeb && !Platform.isAndroid){
                                              // await  ConstantWeb.exportToExcelForWeb_MyDelivers(value, firebaseController, widget.userName! , f, h);
                                              }
                                              else
                                              if(internet && Platform.isAndroid){
                                                exportToExcelFromFirebase(value);
                                              }
                                              else
                                                {
                                                  Get.snackbar("خطأ", "عليك الاتصال بشبكة الانترنت");
                                                }
                                            },
                                            child: Container(
                                              height: 40,
                                              width: 90,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(7)),
                                                color: Colors.green,
                                              ),
                                              child: Center(child: Text("تصدير الي اكسل")),
                                            ),
                                          ),
                                          SizedBox(height: 7),
                                          InkWell(
                                            onTap: () async {
                                              int? t = await Constant.getLateNum(firebaseController.UserName);
                                              if (t != null) {
                                                print(t);
                                              } else {
                                                print("القيمة null");
                                              }
                                            },
                                            child: InkWell(
                                              onTap: () async {

                                                Constant.showDeleteConfirmationDialog(context, () async {


                                                  await firebaseController.deleteData("$f/${widget.userName}/${value["primery_key"]}");


                                                });
                                              },
                                              child: Container(
                                                height: 40,
                                                width: 60,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(7)),
                                                  color: Colors.redAccent,
                                                ),
                                                child: Center(child: Text("حذف")),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => Container(height: 3),
                            itemCount: filteredData.length,
                          );
                        }
                      },
                    ),
                  )
                  :
                  Expanded(
                    child: StreamBuilder<Map<dynamic, dynamic>>(
                      stream: localDataBaseController.getRecordRecivingAsMapStreamFromLocal(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none) {
                          return Center(
                            child: Text("لا يوجد اتصال بالانترنت"),
                          );
                        } else if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                          return Center(
                            child: Text("لا يوجد كشوفات قم بإنشاء كشف تسلبم جديد"),
                          );
                        } else {
                          Map<dynamic, dynamic> data = snapshot.data!;

                          // Filter the data based on the search query
                          final filteredData = data.entries.where((entry) {
                            final value = entry.value;

                            // Check if value is a Map, as we expect, before accessing keys
                            if (value is Map) {
                              return value["title"].toString().contains(searchQuery) ||
                                  value["type_of_parcels"].toString().contains(searchQuery) ||
                                  value["date"].toString().contains(searchQuery);
                            } else {
                              print("Unexpected data type: ${value.runtimeType}");
                              return false; // Skip entries that are not maps
                            }
                          }).toList();

                          return ListView.separated(
                            itemBuilder: (context, index) {
                              String key = filteredData[index].key;
                              Map<dynamic, dynamic> value = filteredData[index].value as Map<dynamic, dynamic>;

                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DeliverablesrRecored(
                                        keys: value["documentId"],
                                        title: value["title"],
                                        user: firebaseController.UserName,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                    color: Color.fromRGBO(195, 206, 231, 1.0),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context).size.width * 0.3,
                                            child: Text(
                                              value["title"] ?? "",
                                              overflow: TextOverflow.clip,
                                              style: TextStyle(fontSize: 16),
                                              maxLines: 2,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Container(
                                            width: MediaQuery.of(context).size.width * 0.3,
                                            child: Text(
                                              "نوع الطرد: ${value["type_of_parcels"] ?? ""}",
                                              overflow: TextOverflow.clip,
                                              maxLines: 3,
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Expanded(child: SizedBox(width: 20)),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              width: MediaQuery.of(context).size.width * 0.25,
                                              child: Text("التاريخ: ${value["date"] ?? ""}", style: TextStyle(fontSize: 16))),
                                          SizedBox(height: 10),
                                          Text("عدد الطرود: ${value["number_of_parcels"] ?? 0}", style: TextStyle(fontSize: 16)),
                                        ],
                                      ),
                                      Expanded(child: SizedBox(width: 10)),
                                      Column(
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              if(kIsWeb && !Platform.isAndroid){

                                                // await ConstantWeb.exportToExcelForWeb_MyDelivers(value, firebaseController, widget.userName! , f, h , context);
                                              }else{
                                                exportToExcel(value ,context);


                                              }                                        },
                                            child: Container(
                                              height: 40,
                                              width: 90,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(7)),
                                                color: Colors.green,
                                              ),
                                              child: Center(child: Text("تصدير الي اكسل")),
                                            ),
                                          ),
                                          SizedBox(height: 7),
                                          InkWell(
                                            onTap: () async {
                                              int? t = await Constant.getLateNum(firebaseController.UserName);
                                              if (t != null) {
                                                print(t);
                                              } else {
                                                print("القيمة null");
                                              }
                                            },
                                            child: GetBuilder<LocalDataBaseController>(
                                              builder: (controller) => InkWell(
                                                onTap: () async {
                                                  StreamSubscription? subscription;
                                                  try {
                                                    // Handle data deletion
                                                    if (!controller.changesInRecoredRecipients && firebaseController.UserName != "admin") {
                                                      localDataBaseController.deleteRecoredReciving(value["documentId"]);
                                                      await firebaseController.deleteData("$f/${firebaseController.UserName}/${value["documentId"]}");

                                                      int? lat = await Constant.getLateNum(firebaseController.UserName);
                                                      print("lat  ${lat!}");

                                                      print("change2 ${controller.changesInRecoredRecipients}");

                                                      if (lat != null && value["number_of_parcels"] != "0" && controller.changesInRecoredRecipients == false) {
                                                        try {
                                                          int numberOfParcels = int.parse(value["number_of_parcels"].toString());
                                                          int newLat = lat - numberOfParcels;
                                                          if(newLat < 0){
                                                            Constant.saveLat(0, firebaseController.UserName);

                                                            if (mounted) {
                                                              firebaseController.saveLat(firebaseController.UserName, 0 , context);
                                                            }
                                                          }else{
                                                            Constant.saveLat(newLat, firebaseController.UserName);

                                                            if (mounted) {
                                                              firebaseController.saveLat(firebaseController.UserName, newLat, context);
                                                            }
                                                          }

                                                        } catch (e) {
                                                          print("Error parsing number_of_parcels: $e");
                                                        }
                                                      }
                                                    } else {
                                                      controller.deleteRecoredReciving(value["documentId"]);
                                                      await firebaseController.deleteData("$f/${firebaseController.UserName}/${value["documentId"]}");
                                                    }
                                                  } finally {
                                                    // Ensure subscription cleanup
                                                    subscription?.cancel();
                                                  }
                                                },
                                                child: Container(
                                                  height: 40,
                                                  width: 60,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(7)),
                                                    color: Colors.redAccent,
                                                  ),
                                                  child: Center(child: Text("حذف")),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => Container(height: 3),
                            itemCount: filteredData.length,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }




  Future<void> exportToExcel(dynamic value, BuildContext context) async {
    // Initialize Excel and sheet
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];

    // Add header row
    sheetObject.appendRow([
      'الرقم',
      'الحالة الإجتماعية',
      'هوية الزوج',
      'اسم الزوج',
      'هوية الزوجة',
      'اسم الزوجة',
      'عدد الأفراد',
      'جوال',
      'السكن الأصلي',
      'حالة الاستلام',
      'المندوب',
      'الملاحظات',
    ]);

    try {
      // Fetch the data
      List<RecoredRecpients> recipientsList = await localDataBaseController
          .database
          .personDao
          .getRecoredRecpients(value["documentId"])
          .first; // Ensure the stream resolves to a single value

      // Populate Excel rows with data
      for (int i = 0; i < recipientsList.length; i++) {
        sheetObject.appendRow([
          i + 1,
          recipientsList[i].status,
          recipientsList[i].id1,
          recipientsList[i].name1,
          recipientsList[i].id2,
          recipientsList[i].name2,
          recipientsList[i].numberOfFamily,
          recipientsList[i].mobile,
          recipientsList[i].originalResidence,
          recipientsList[i].receiving_status,
          recipientsList[i].shelter,
          recipientsList[i].notes,
        ]);
      }

      // Request storage permission
      if (await Permission.storage.request().isGranted ||
          await Permission.manageExternalStorage.request().isGranted) {
        // Define file path
        final title = value["title"];
        final directory = Directory('/storage/emulated/0/Download');
        if (!directory.existsSync()) {
          directory.createSync(recursive: true);
        }
        final filePath = "${directory.path}/$title.xlsx";

        // Save the file
        final file = File(filePath);
        await file.writeAsBytes(excel.encode()!);

        // Notify the user of success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("تم الحفظ في مجلد التنزيلات: $filePath"), backgroundColor: Colors.blueGrey),
        );
      } else {
        // Fallback to app-specific directory
        final appDir = await getExternalStorageDirectory();
        final fallbackPath = "${appDir!.path}/${value["title"]}.xlsx";
        final file = File(fallbackPath);
        await file.writeAsBytes(excel.encode()!);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("لم يتم منح الإذن. تم الحفظ في هذا المسار: $fallbackPath"),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      // Handle errors
      print("Error during export: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("حدث خطأ أثناء التصدير: $e"), backgroundColor: Colors.red),
      );
    }
  }


  // Future<void> exportToExcel(dynamic value) async {
  //
  //   // Request storage permission
  //   var excel = Excel.createExcel();
  //   Sheet sheetObject = excel['Sheet1'];
  //   List<UserInfo> usersList = [];
  //   // Adding header row
  //   // Adding header row
  //   sheetObject.appendRow([
  //     'الرقم', 'الحالة الإجتماعية', 'هوية الزوج', 'اسم الزوج',
  //     'هوية الزوجة', 'اسم الزوجة', 'عدد الأفراد', 'جوال',
  //     'السكن الأصلي', 'حالة الاستلام', 'المندوب', 'الملاحظات'
  //   ]);
  //
  //   localDataBaseController.database.personDao.getRecoredRecpients(value["documentId"]).listen((event) {
  //
  //     List<RecoredRecpients> list =  event;
  //
  //     // Populate Excel cells with user data
  //     for (int i = 0; i < list.length; i++) {
  //       sheetObject.appendRow([
  //         i + 1,
  //         list[i].status,
  //         list[i].id1,
  //         list[i].name1,
  //         list[i].id2,
  //         list[i].name2,
  //         list[i].numberOfFamily,
  //         list[i].mobile,
  //         list[i].originalResidence,
  //         list[i].receiving_status,
  //         list[i].shelter,
  //         list[i].notes,
  //       ]);
  //
  //
  //
  //     }
  //   });
  //
  //   // Get the application documents directory
  //   final title = value["title"];
  //   final directory = await getExternalStorageDirectory();
  //   final path = "${directory!.path}/$title.xlsx";
  //   // Create and save the file
  //   final file = File(path); // Corrected File instantiation
  //   // file.createSync(recursive: true);
  //   file.writeAsBytesSync(excel.encode()!); // Encode data and write to file
  //   print(file.path);
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text("تم الحفظ في هذا المسار $path.xlsx") , backgroundColor: Colors.blueGrey,),
  //   );
  //
  // }

  Future<void> exportToExcelFromFirebase(dynamic value) async {

    // Request storage permission
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];
    List<UserInfo> usersList = [];
    // Adding header row
    // Adding header row
    sheetObject.appendRow([
      'الرقم', 'الحالة الإجتماعية', 'هوية الزوج', 'اسم الزوج',
      'هوية الزوجة', 'اسم الزوجة', 'عدد الأفراد', 'جوال',
      'السكن الأصلي', 'حالة الاستلام', 'المندوب', 'الملاحظات'
    ]);

    try{
      List<UserInfo> list = await  firebaseController.getUsersAsFuture('/$f/${widget.userName}/${value["primery_key"]}/$h');

      // Populate Excel cells with user data
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
          list[i].receiving_status,
          list[i].shelter,
          list[i].notes,
        ]);



      }

      // Request storage permission
      if (await Permission.storage.request().isGranted ||
          await Permission.manageExternalStorage.request().isGranted) {
        // Define file path
        final title = value["title"];
        final directory = Directory('/storage/emulated/0/Download');
        if (!directory.existsSync()) {
          directory.createSync(recursive: true);
        }
        final filePath = "${directory.path}/$title.xlsx";

        // Save the file
        final file = File(filePath);
        await file.writeAsBytes(excel.encode()!);

        // Notify the user of success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("تم الحفظ في مجلد التنزيلات: $filePath"), backgroundColor: Colors.blueGrey),
        );
      } else {
        // Fallback to app-specific directory
        final appDir = await getExternalStorageDirectory();
        final fallbackPath = "${appDir!.path}/${value["title"]}.xlsx";
        final file = File(fallbackPath);
        await file.writeAsBytes(excel.encode()!);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("لم يتم منح الإذن. تم الحفظ في هذا المسار: $fallbackPath"),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("حدث خطأ أثناء التصدير: $e"), backgroundColor: Colors.red),
      );
    }


  }



}
