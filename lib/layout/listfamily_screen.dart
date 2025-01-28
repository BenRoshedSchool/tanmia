import 'dart:io' as io; // For mobile
import 'dart:io' show Directory, File, Platform;
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:untitled2/controller/firebase_controller.dart';
import 'package:untitled2/controller/localdatabase_controller.dart';
import 'package:untitled2/modles/record_recpients.dart';
import 'package:untitled2/modles/users_info_for_local.dart';
import 'package:untitled2/shared/constant.dart';
import '../controller/listfamily_controller.dart';
import '../modles/users_info.dart';
import '../routes/app_routes.dart';



class ListFamily_Screen extends StatefulWidget {
  String? username;
  String? keys;
  String? shoab;
  String? recivefromDeliverablesrRecored;
  Map<String , dynamic>? map;
   ListFamily_Screen({this.shoab ,this.username , this.map , this.keys , this.recivefromDeliverablesrRecored});


  @override
  _ListFamily_ScreenState createState() => _ListFamily_ScreenState();
}



class _ListFamily_ScreenState extends State<ListFamily_Screen> {
  final ListFamilyController listFamilyController = Get.put(ListFamilyController());
  final FirebaseController firebaseController = Get.find<FirebaseController>();
  late LocalDataBaseController localDataBaseController;

  String globalUserName = "";
  String _searchQuery = ''; // Search query variable
  String f = "كشوفات تسليم";
  String h = "recipients";

  // التأكدمن أن الاسم غير مكرر في كشف التسليم
  bool isRepeated=false;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb && Platform.isAndroid) {
      // Only initialize localDataBaseController for non-web and Android platforms
      localDataBaseController = Get.put(LocalDataBaseController());
    }

    globalUserName = firebaseController.UserName;
    listFamilyController.getTotalFamily(widget.username!);


    return Scaffold(

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          bool isCheck = await Constant.checkInternetConnection();
          if(isCheck){
            if (Platform.isAndroid ) {
              Get.toNamed(Routes.addFamily, arguments: {"username": widget.username});
            }
            else
            if(kIsWeb){

              Get.toNamed(Routes.addFamily, arguments: {"username": widget.username});

            }
          }else{
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("عليك الاتصال بشبكة الانترنت"), backgroundColor: Colors.red));

          }


        },
      ),
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   // title: Column(
      //   //   children: [
      //   //     Row(
      //   //       children: [
      //   //         Expanded(child: Center(child: Text(firebaseController.UserName))),
      //   //         TextButton(
      //   //           onPressed: () async {
      //   //             bool isCheck = await Constant.checkInternetConnection();
      //   //             if (isCheck) {
      //   //               await exportChildrenToExcel(context);
      //   //             } else {
      //   //               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("عليك الاتصال بشبكة الانترنت"), backgroundColor: Colors.red));
      //   //             }
      //   //           },
      //   //           child: Column(
      //   //             children: [
      //   //               Text(" تنزيل كشف الاطفال", style: TextStyle(color: Colors.white)),
      //   //               Icon(Icons.download, color: Colors.white),
      //   //             ],
      //   //           ),
      //   //         ),
      //   //         TextButton(
      //   //           onPressed: () async {
      //   //             bool isCheck = await Constant.checkInternetConnection();
      //   //             if (isCheck) {
      //   //               await exportToExcel();
      //   //             } else {
      //   //               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("عليك الاتصال بشبكة الانترنت"), backgroundColor: Colors.red));
      //   //             }
      //   //           },
      //   //           child: Column(
      //   //             children: [
      //   //               Text("تنزيل الكشف", style: TextStyle(color: Colors.white)),
      //   //               Icon(Icons.download, color: Colors.white),
      //   //             ],
      //   //           ),
      //   //         ),
      //   //       ],
      //   //     ),
      //   //   ],
      //   // ),
      // ),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            GetBuilder<ListFamilyController>(
              builder: (listFamilyController) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      color: Colors.white54,
                      child: Padding(
                        padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 60),
                        child: Column(
                          children: [
                            firebaseController.UserName == "admin" ?
                            Container(
                              height: 55,
                              color: Colors.blue,
                              child: Row(
                          children: [
                            IconButton(onPressed: (){
                              if(firebaseController.UserName == "admin"){
                                Get.toNamed(Routes.almanadeepScreen, arguments: {"alshoab": widget.shoab});
                              }
                            },icon: Icon(Icons.arrow_back)),
                              Expanded(child: Center(child: Text(firebaseController.UserName))),
                              TextButton(
                                onPressed: () async {
                                  if(await Constant.checkInternetConnection() && Platform.isAndroid){
                                    exportChildrenToExcel(context);
                                  }

                                },
                                child: Column(
                                  children: [
                                    Text(" تنزيل كشف الاطفال", style: TextStyle(color: Colors.white)),
                                    Icon(Icons.download, color: Colors.white),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () async {

                                  if(await Constant.checkInternetConnection() && Platform.isAndroid){
                                    exportToExcel();
                                  }


                                },
                                child: Column(
                                  children: [
                                    Text("تنزيل الكشف", style: TextStyle(color: Colors.white)),
                                    Icon(Icons.download, color: Colors.white),
                                  ],
                                ),
                              ),
                          ],
                        ),
                            )
                        :
                            SizedBox(),
                            PreferredSize(
                              preferredSize: Size.fromHeight(56.0),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                  ),
                                  child: TextField(
                                    onChanged: (query) {
                                      setState(() {
                                        _searchQuery = query.toLowerCase();
                                      });
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'بحث',
                                      prefixIcon: Icon(Icons.search),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: StreamBuilder<List<Map<dynamic, dynamic>>>(
                                stream: firebaseController.getDataListStream(widget.username!),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.none) {
                                    return Center(child: Text("لا يوجد اتصال بالانترنت"));
                                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Center(child: CircularProgressIndicator());
                                  }
                                  if (snapshot.hasError) {
                                    print(snapshot.error);
                                    return Center(child: Text('Error: ${snapshot.error}'));
                                  }

                                  var items = snapshot.data;
                                  if (items == null || items.isEmpty) {
                                    return Center(child: Text('لا يوجد بيانات'));
                                  }

                                  // Filter items based on search query
                                  if (_searchQuery.isNotEmpty) {
                                    items = items.where((item) {
                                      final name = item["name1"]?.toLowerCase() ?? '';
                                      final id1 = item["id1"].toString()?.toLowerCase() ?? '';
                                      return name.contains(_searchQuery) || id1.contains(_searchQuery);
                                    }).toList();
                                  }

                                  return ListView.separated(
                                    itemBuilder: (context, index) {
                                      final user = items![index];

                                      return InkWell(
                                        onTap: () {
                                          Get.toNamed(Routes.showDetails, arguments: {"UsersInfo": UserInfo.fromJson(user)});
                                        },
                                        child: Container(
                                          height: widget.recivefromDeliverablesrRecored == "DeliverablesrRecored" ? 165 : 115,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(15)),
                                            color: Color.fromRGBO(195, 206, 231, 1.0),
                                          ),
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: widget.recivefromDeliverablesrRecored == "DeliverablesrRecored" ? 165 : 115,
                                                child: Center(child: Text("${index + 1}")),
                                                decoration: BoxDecoration(
                                                  color: Colors.greenAccent,
                                                  borderRadius: BorderRadius.only(topRight: Radius.circular(15), bottomRight: Radius.circular(15)),
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: MediaQuery.of(context).size.width * 0.35,
                                                    child: Text(
                                                      user["name1"] ?? "null",
                                                      overflow: TextOverflow.clip,
                                                      maxLines: 3,
                                                      style: TextStyle(fontSize: 16),
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    "جوال : ${user["mobile"] ?? "0"}",
                                                    style: TextStyle(fontSize: 16),
                                                  ),
                                                ],
                                              ),
                                              Expanded(child: SizedBox(width: 10)),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(user["id1"].toString(), style: TextStyle(fontSize: 16)),
                                                  SizedBox(height: 10),
                                                  Container(
                                                    width: MediaQuery.of(context).size.width * 0.25,
                                                    child: Text(user["original_residence"] ?? "فارغ", overflow: TextOverflow.clip, maxLines: 3, style: TextStyle(fontSize: 16)),
                                                  ),
                                                ],
                                              ),
                                              Expanded(child: SizedBox(width: 10)),
                                              Column(
                                                children: [
                                                  Container(
                                                    height: 40,
                                                    width: 60,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.all(Radius.circular(7)),
                                                      color: user["residence_status"] == "نازح" ? Colors.orange : Colors.green,
                                                    ),
                                                    child: Center(child: Text(user["residence_status"] ?? "نازح")),
                                                  ),
                                                  SizedBox(height: 7),
                                                  InkWell(
                                                    onTap: () async {

                                                      Constant.showDeleteConfirmationDialog(context, () async {


                                                        print(widget.username);
                                                        print(user['primery_key']);
                                                        await firebaseController.deleteData("${widget.username}/${user['primery_key']}");
                                                        if (!kIsWeb && Platform.isAndroid) {
                                                          try {
                                                            localDataBaseController.database.personDao.deletePersonById(user['primery_key']);
                                                          } catch (e) {
                                                            print("Error Database: ${e}");
                                                          }
                                                        }

                                                      });

                                                      // setState(() async {
                                                      //
                                                      // });
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
                                                  SizedBox(height: 7),
                                                  widget.recivefromDeliverablesrRecored == "DeliverablesrRecored"
                                                      ? ElevatedButton(
                                                      onPressed: () async {
                                                        showInputDialog(context, widget.keys!, widget.username!, widget.map!, user);
                                                      },
                                                      child: Text("إضافة"))
                                                      : SizedBox(),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) => Divider(height: 3),
                                    itemCount: items.length,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    listFamilyController.isLoadingFile ? CircularProgressIndicator() : SizedBox(),
                  ],
                );
              },
            ),
            GetBuilder<ListFamilyController>(
              builder: (controller) {
                return Container(
                  width: double.infinity,
                  height: 60,
                  color: Colors.green,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "اجمالي عدد الأسر",
                          style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 10),
                        Text(
                          controller.t.toString(),
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }





  void showInputDialog(BuildContext context , String key , String username , Map<dynamic , dynamic> userMap , dynamic user) {
    final TextEditingController _dialogController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    bool isSubmint=false;
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return Stack(
          alignment: Alignment.center,
          children: [

            AlertDialog(
              title: Text("أدخل سبب الاستبدال"),
              content: Form(
                key: _formKey,
                child: TextFormField(
                  controller: _dialogController,
                  decoration: InputDecoration(
                    labelText: "النص",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "يرجى إدخال السبب";
                    }
                    if (value.length < 3) {
                      return "يجب أن يكون النص أطول من حرفين";
                    }
                    return null;
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text("إلغاء"),
                ),

               isSubmint == true ? CircularProgressIndicator() :
               ElevatedButton(
                 onPressed: () async {
                   setState(() {
                     isSubmint=true;
                   });
                   if (_formKey.currentState!.validate()) {
                     ReplaceUsers(key, username, userMap, user);

                     int idNotification = DateTime.now().millisecondsSinceEpoch;
                     Map<dynamic, dynamic> notificationMap = {
                       "oldName": userMap["name1"],
                       "newName": user["name1"],
                       "reason": _dialogController.text.toString(),
                       "date_time": Constant.getCurrentDateTime(),
                       "id": idNotification,
                       "shelter": username
                     };

                     try {
                       // Fetch the current number of notifications
                       var event = await firebaseController.getNotificationNumber().first;
                       int numberNotification = event != null && event["notificationNumber"] != null
                           ? event["notificationNumber"] + 1
                           : 1;

                       // Save the notification
                       await firebaseController.addnotificationFromUserToAdmin(
                         notificationMap,
                         context,
                         idNotification.toString(),
                       );
                       await  firebaseController.addNumberOfNotificationFromUserToAdmin( {"notificationNumber": numberNotification});

                       print("Notification saved successfully: $numberNotification");
                       Get.back();
                       Navigator.of(context).pop(); // Close the dialog
                     } catch (e) {
                       print("Error: $e");
                     }
                   }
                 },
                 child: Text("موافق"),
               ),


              ],
            ),

          ],
        );
      },
    );

  }

  Future<void> ReplaceUsers(String key , String username , Map<dynamic , dynamic> userMap , dynamic user) async {
    try {
      // Convert all necessary fields to String before using them
      String? userPrimeryKey = convertToString(userMap["primery_key"]);
      String? newUserPrimeryKey = convertToString(user["primery_key"]);

      var data = await firebaseController.getDataOnce2(
          "كشوفات تسليم/${username}/${widget.keys}/recipients");

      for (var entry in data.entries) {
        var key = entry.key;
        var value = entry.value;

        if (value is Map) {
          // Check if id1 matches user["id1"]
          if (value["id1"] == user["id1"]) {
            setState(() {
              isRepeated = true;
            });

            // Break out of the loop
            break;
          }
        }
      }


      print( "is repeated    ${isRepeated}");



      if(isRepeated == false){

        //  استبدال المستفيدين و استبدال primery key
        print("userMap primery_key: $userPrimeryKey");
        firebaseController.addUser(username, userPrimeryKey!, user , context);

        // Remove receiving_status from the map
        userMap.remove("receiving_status");

        // Add the new user to Firebase
        print("user primery_key: $newUserPrimeryKey");
        firebaseController.addUser(username, newUserPrimeryKey!, userMap , context);

        // Create a map for Firebase with proper type handling
        Map<dynamic , dynamic> map = {
          "id1": convertToString(user["id1"]),
          "id2": convertToString(user["id2"]),
          "mobile": user["mobile"],
          "name1": user["name1"],
          "name2": user["name2"],
          "notes": user["notes"],
          "number_of_family": user["number_of_family"],
          "original_residence": user["original_residence"],
          "primery_key": newUserPrimeryKey, // Ensure it's a String
          "receiving_status": "لم يتم الاستلام",
          "residence_status": user["residence_status"],
          "shelter": user["shelter"],
          "status": user["status"],
        };

        // Log the map to verify the data
        print("Map to Firebase: $map");

        // Delete old user data from Firebase
        firebaseController.deleteData("/${f}/${username}/${key}/${h}/${userPrimeryKey}");

        // Add new user data to Firebase
        await firebaseController.addUser(f, "${username}/${key}/${h}/${newUserPrimeryKey}", map, context);

        // Android-specific local database updates
        if (Platform.isAndroid) {
          localDataBaseController.database.personDao.deletePersonById(userPrimeryKey);

          // Insert new data into local DB for the first user
          UserInfoForlocal userInfo = UserInfoForlocal(
            id1: user["id1"],
            id2: user["id2"],
            name1: user["name1"],
            name2: user["name2"],
            notes: user["notes"],
            numberOfFamily: user["number_of_family"],
            originalResidence: user["original_residence"],
            primery_key: userPrimeryKey,
            receiving_status: "لم يتم الاستلام",
            residenceStatus: user["residence_status"],
            shelter: user["shelter"],
            status: user["status"],
          );
          localDataBaseController.database.personDao.insertUserInfoForlocal(userInfo);

          // Delete and insert new data for the second user
          localDataBaseController.database.personDao.deletePersonById(newUserPrimeryKey);
          UserInfoForlocal userInfo2 = UserInfoForlocal(
            id1: user["id1"],
            id2: user["id2"],
            name1: userMap["name1"],
            name2: userMap["name2"],
            notes: userMap["notes"],
            numberOfFamily: userMap["number_of_family"],
            originalResidence: userMap["original_residence"],
            primery_key: newUserPrimeryKey,
            receiving_status: "لم يتم الاستلام",
            residenceStatus: userMap["residence_status"],
            shelter: userMap["shelter"],
            status: userMap["status"],
          );
          localDataBaseController.database.personDao.insertUserInfoForlocal(userInfo2);

          // Update the RecoredRecpients table
          RecoredRecpients recoredRecip = RecoredRecpients(
            documentId: key,
            id1: user["id1"],
            id2: user["id2"],
            name1: user["name1"],
            name2: user["name2"],
            notes: user["notes"],
            numberOfFamily: user["number_of_family"],
            originalResidence: user["original_residence"],
            primery_key: userPrimeryKey,
            receiving_status: "لم يتم الاستلام",
            residenceStatus: user["residence_status"],
            shelter: user["shelter"],
            status: user["status"],
          );

          // Update local database with new data
          localDataBaseController.database.personDao.deleteRecoredRecipientsById(userPrimeryKey);
          localDataBaseController.database.personDao.insertRecoredRecpients(recoredRecip);
        }

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text("تمت الإستبدال بنجاح"),
          ),
        );
      }else{
      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("هذا الاسم موجود ضمن الكشف"),
        ),
      );
    }

    } catch (e) {
      print("Error occurred: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("حدث خطأ أثناء الاستبدال"),
        ),
      );
    }
  }




  Future<void> exportChildrenToExcel(BuildContext context) async {
    listFamilyController.onStatrtExportToExcel(); // Start UI feedback
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];

    // Adding header row
    List<String> headerRow = [
      'هوية ولي الأمر', // Parent ID
      'اسم ولي الأمر', // Parent Name
      'المندوب',       // Shelter
    ];

    // Collect data from the stream
    List<Map<String, dynamic>> allChildrenData = await firebaseController
        .getDataListStream('childrens/shelter/${firebaseController.UserName}')
        .first;

    int maxChildren = 0;

    // Determine maximum number of children across all parents
    for (var event in allChildrenData) {
      final childrenRaw = event['listChildren'];
      if (childrenRaw is Map<dynamic, dynamic>) {
        maxChildren = max(maxChildren, childrenRaw.length);
      }
    }

    // Add child-specific headers dynamically
    for (int i = 1; i <= maxChildren; i++) {
      headerRow.addAll([
        'اسم الطفل $i', // Child Name
        'العمر $i',     // Child Age
        'هوية الطفل $i', // Child ID
      ]);
    }

    // Add the header row to the sheet
    sheetObject.appendRow(headerRow);

    // Populate the rows with data
    for (var event in allChildrenData) {
      final parentId = event['parentId'] ?? '';
      final parentName = event['parentName'] ?? '';
      final shelter = event['shelter'] ?? '';
      final childrenRaw = event['listChildren'];

      List<String> childrenColumns = [];

      if (childrenRaw is Map<dynamic, dynamic>) {
        final children = childrenRaw.map((key, value) =>
            MapEntry(key.toString(), value as Map<dynamic, dynamic>));
        children.forEach((key, child) {
          if (child is Map) {
            childrenColumns.add(child['name'] ?? '');
            childrenColumns.add(child['eage']?.toString() ?? '');
            childrenColumns.add(child['id'] ?? '');
          }
        });
      }

      // Fill any missing child columns with empty cells to match the max children
      while (childrenColumns.length < maxChildren * 3) {
        childrenColumns.add('');
      }

      // Append the row to the Excel sheet
      sheetObject.appendRow([
        parentId,       // Parent ID
        parentName,     // Parent Name
        shelter,        // Shelter
        ...childrenColumns, // Child details
      ]);
    }

    // Request storage permission
    if (await Permission.storage.request().isGranted) {
      // Get the Downloads directory
      final downloadsDir = Directory('/storage/emulated/0/Download');
      if (!downloadsDir.existsSync()) {
        downloadsDir.createSync(recursive: true);
      }

      // Save the file
      final filePath = '${downloadsDir.path}/كشف_أطفال.xlsx';
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

  Future<void> exportToExcel() async {
    listFamilyController.onStatrtExportToExcel();
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];

    // Adding header row
    sheetObject.appendRow([
      'الرقم', 'الحالة الإجتماعية', 'هوية الزوج', 'اسم الزوج',
      'هوية الزوجة', 'اسم الزوجة', 'عدد الأفراد', 'جوال',
      'السكن الأصلي', 'حالة الإقامة', 'المندوب', 'الملاحظات'
    ]);

    List<UserInfo> list = await  firebaseController.getUsersAsFuture('/${widget.username}');

    // Use await for to ensure data is fully loaded before proceeding

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
        list[i].residenceStatus,
        list[i].shelter,
        list[i].notes,
      ]);


    }

    // Get the application documents directory


    // Request storage permission
    if (await Permission.storage.request().isGranted) {
      // Get the Downloads directory
      final downloadsDir = Directory('/storage/emulated/0/Download');
      if (!downloadsDir.existsSync()) {
        downloadsDir.createSync(recursive: true);
      }

      // Save the file
      final filePath = '${downloadsDir.path} كشف ${widget.username}.xlsx';
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
  String? convertToString(dynamic value) {
    if (value is String) {
      return value;
    } else if (value is int) {
      return value.toString(); // Convert int to String
    }
    return null;
  }



}
