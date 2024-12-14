import 'dart:io' show Directory, File;
import 'dart:math';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:untitled2/controller/listfamily_controller.dart';
import 'package:untitled2/controller/localdatabase_controller.dart';
import 'package:untitled2/controller/login_controller.dart';
import 'package:untitled2/controller/user_home_controller.dart';
import 'package:untitled2/layout/children_screen.dart';
import 'package:untitled2/layout/create_reciving_recored.dart';
import 'package:untitled2/layout/listfamily_screen.dart';
import 'package:untitled2/layout/my_deliveries_screen.dart';
import 'package:untitled2/layout/user_notification.dart';
import 'package:untitled2/shared/constant.dart';
import '../controller/firebase_controller.dart';
import '../modles/users_info.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import '../routes/app_routes.dart';




class UsersHome_Screen extends StatefulWidget {
  const UsersHome_Screen({super.key});

  @override
  State<UsersHome_Screen> createState() => _UsersHome_ScreenState();
}


class _UsersHome_ScreenState extends State<UsersHome_Screen> with TickerProviderStateMixin {
  final FirebaseController firebaseController = Get.find<FirebaseController>();
  final LoginController loginController = Get.put(LoginController());
  final ListFamilyController listFamilyController = Get.put(ListFamilyController());
  final LocalDataBaseController localDataBaseController = Get.put(LocalDataBaseController());
  final UserHomeController userHomeController = Get.put(UserHomeController());
  final _advancedDrawerController = AdvancedDrawerController();

  String? username;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    username = firebaseController.UserName;
}

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.w600);



  @override
  Widget build(BuildContext context) {

      List<Widget> _widgetOptions = <Widget>[
      ChildrenScreen(userName: username,),
      MyDeliveries_Screen(userName: username ?? 'Guest'),
      ListFamily_Screen(username: firebaseController.UserName,recivefromDeliverablesrRecored: "",),
      CreateRecivingRecored(userName: username!),
    ];
    return WillPopScope(
      onWillPop: ()async{
        SystemNavigator.pop();
        return true;
      },
      child: AdvancedDrawer(
        drawer: SafeArea(
          child: Container(
            child: ListTileTheme(
              textColor: Colors.white,
              iconColor: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: 128.0,
                    height: 128.0,
                    margin: const EdgeInsets.only(
                      top: 24.0,
                      bottom: 64.0,
                    ),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/images/logo.png',
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Get.to(UserNotification());

                      firebaseController.addNumberOfNotificationFromUserToUser(
                          {"notificationNumber":0} , firebaseController.UserName);
                    },
                    leading: Icon(Icons.notifications_active_outlined),
                    title: Text('الاشعارات'),
                  ),

                  ListTile(
                    onTap: () {


                      Constant.saveUser("");
                      SystemNavigator.pop();
                      loginController.setIsLogin(false);

                    },
                    leading: Icon(Icons.logout),
                    title: Text('تسجيل خروج'),
                  ),

                  Spacer(),
                  DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white54,
                    ),
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 16.0,
                      ),
                      child: Text('Terms of Service | Privacy Policy'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
            backdrop: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
            gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blueGrey, Colors.blueGrey.withOpacity(0.2)],
      ),
      ),
      ),
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      // openScale: 1.0,
      disabledGestures: false,
      childDecoration: const BoxDecoration(

      borderRadius: const BorderRadius.all(Radius.circular(16)
      ),

      ),
          child:    GetBuilder<UserHomeController>(
            builder: (controler)=>Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.lightBlueAccent,
                title: controler.selectedIndex == 2 ?  Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Center(child: Text(firebaseController.UserName))),
                        TextButton(
                          onPressed: () async {
                            bool isCheck = await Constant.checkInternetConnection();
                            if (isCheck) {
                              await exportChildrenToExcel(context);
                            } else {
                              Get.snackbar("خطأ", "عليك الاتصال بشبكة الانترنت");
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
                            bool isCheck = await Constant.checkInternetConnection();
                            if (isCheck) {
                              await exportToExcel(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("عليك الاتصال بشبكة الانترنت"), backgroundColor: Colors.red));
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
                  ],
                )
                    :
                controler.widget,
                leading: IconButton(
                  onPressed: _handleMenuButtonPressed,
                  icon: ValueListenableBuilder<AdvancedDrawerValue>(
                    valueListenable: _advancedDrawerController,
                    builder: (_, value, __) {
                      return AnimatedSwitcher(
                        duration: Duration(milliseconds: 250),
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Icon(
                              value.visible ? Icons.clear : Icons.menu,
                              key: ValueKey<bool>(value.visible),
                              size: 40,
                            ),
                            CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.red,
                              child: Obx(() => Text("${userHomeController.numOfNoti}")),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              body:  GetBuilder<UserHomeController>(
                  builder:(controller)=> Center(
                    child: _widgetOptions.elementAt(controller.selectedIndex),
                  ),
                ),
                bottomNavigationBar: GetBuilder<UserHomeController>(
                  builder: (controller)=>Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 20,
                          color: Colors.black.withOpacity(.1),
                        )
                      ],
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                        child: GNav(
                          rippleColor: Colors.grey[300]!,
                          hoverColor: Colors.grey[100]!,
                          gap: 8,
                          activeColor: Colors.black,
                          iconSize: 24,
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          duration: Duration(milliseconds: 400),
                          tabBackgroundColor: Colors.blue[100]!,
                          color: Colors.black,
                          tabs: [
                            GButton(
                              icon: LineIcons.child,
                              text: 'اضافة الأطفال',
                            ),
                            GButton(
                              icon: LineIcons.checkCircle,
                              text: 'تسليماتي',
                            ),
                            GButton(
                              icon: Icons.family_restroom,
                              text: 'كشف العائلات',
                            ),
                            GButton(
                              icon: Icons.chrome_reader_mode_outlined,
                              text: 'انشاء كشف',
                            ),
                          ],
                          selectedIndex: controller.selectedIndex,
                          onTabChange: (index) {
                            controller.changeTabs(index);
                          },
                        ),
                      ),
                    ),
                  ),

                ),

            ),
          ),


      ),
    );


  }
  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
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

    // Request storage permissions
    if (await Permission.storage.request().isGranted ||
        await Permission.manageExternalStorage.request().isGranted) {
      try {
        // Define the file path in the Downloads directory
        final directory = Directory('/storage/emulated/0/Download');
        if (!directory.existsSync()) {
          directory.createSync(recursive: true);
        }
        final filePath = '${directory.path}/كشف_أطفال.xlsx';

        // Save the file
        final file = File(filePath);
        await file.writeAsBytes(excel.encode()!);

        // Notify the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("تم الحفظ في مجلد التنزيلات: $filePath"), backgroundColor: Colors.blueGrey),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("حدث خطأ أثناء التصدير: $e"), backgroundColor: Colors.red),
        );

      }
    } else {


      // If there's an error, fallback to app-specific directory
      final appDir = await getExternalStorageDirectory();
      final fallbackFilePath = '${appDir!.path}/كشف_أطفال.xlsx';

      final file = File(fallbackFilePath);
      await file.writeAsBytes(excel.encode()!);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("تعذر الحفظ في التنزيلات. تم الحفظ في: $fallbackFilePath"),
          backgroundColor: Colors.orange,
        ),
      );


    }

    listFamilyController.onStatrtExportToExcel(); // Start UI feedback

  }



  Future<void> exportToExcel(BuildContext context) async {
    listFamilyController.onStatrtExportToExcel(); // Start UI feedback

    // Create a new Excel file
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];

    // Adding header row
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
      'حالة الإقامة',
      'المندوب',
      'الملاحظات'
    ]);

    try {
      // Fetch user data
      List<UserInfo> list = await firebaseController.getUsersAsFuture('/${username}');

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

      // Request storage permissions
      if (await Permission.storage.request().isGranted ||
          await Permission.manageExternalStorage.request().isGranted) {
        // Define the file name and path
        final title = "كشف_${username}";
        final directory = Directory('/storage/emulated/0/Download');
        if (!directory.existsSync()) {
          directory.createSync(recursive: true);
        }
        final filePath = "${directory.path}/$title.xlsx";

        // Save the file
        final file = File(filePath);
        await file.writeAsBytes(excel.encode()!);

        // Notify the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("تم الحفظ في مجلد التنزيلات: $filePath"), backgroundColor: Colors.blueGrey),
        );
      } else {
        // Fallback to app-specific directory if permissions are denied
        final appDir = await getExternalStorageDirectory();
        final fallbackPath = "${appDir!.path}/كشف_${username}.xlsx";
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

      // Handle errors gracefully
      print("Error during Excel export: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("حدث خطأ أثناء التصدير: $e"), backgroundColor: Colors.red),
      );
    } finally {
    }

    listFamilyController.onStatrtExportToExcel(); // Start UI feedback

  }


  // Future<void> exportToExcelWeb() async {
  //   listFamilyController.onStatrtExportToExcel();
  //
  //   // Create an Excel workbook and a sheet
  //   var excel = Excel.createExcel();
  //   Sheet sheetObject = excel['Sheet1'];
  //
  //   // Add header row
  //   sheetObject.appendRow([
  //     'الرقم', 'الحالة الإجتماعية', 'هوية الزوج', 'اسم الزوج',
  //     'هوية الزوجة', 'اسم الزوجة', 'عدد الأفراد', 'جوال',
  //     'السكن الأصلي', 'حالة الإقامة', 'المندوب', 'الملاحظات'
  //   ]);
  //
  //   // Fetch user data
  //   List<UserInfo> list = await firebaseController.getUsersAsFuture('/${username}');
  //
  //   // Populate the sheet with user data
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
  //   }
  //
  //   // Encode the Excel file into bytes
  //   final excelBytes = excel.encode()!;
  //
  //   // Create a Blob from the encoded bytes
  //   final blob = html.Blob([excelBytes], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
  //
  //   // Generate a download URL for the Blob
  //   final url = html.Url.createObjectUrlFromBlob(blob);
  //
  //   // Create an anchor element to trigger the download
  //   final anchor = html.AnchorElement(href: url)
  //     ..target = 'blank'
  //     ..download = "كشف_${username}.xlsx"
  //     ..click(); // Simulate a click to download the file
  //
  //   // Revoke the Blob URL to free up memory
  //   html.Url.revokeObjectUrl(url);
  //
  //   // Notify the user
  //   listFamilyController.onStatrtExportToExcel();
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text("تم تنزيل ملف كشف_${username}.xlsx"), backgroundColor: Colors.blueGrey),
  //   );
  //
  //   print("File downloaded: كشف_${username}.xlsx");
  // }
  //
  //
  //
  // Future<void> exportChildrenToExcelWeb(BuildContext context) async {
  //   listFamilyController.onStatrtExportToExcel(); // Start UI feedback
  //   var excel = Excel.createExcel();
  //   Sheet sheetObject = excel['Sheet1'];
  //
  //   // Adding header row
  //   sheetObject.appendRow([
  //     'هوية ولي الأمر', // Parent ID
  //     'اسم ولي الأمر', // Parent Name
  //     'الأطفال',       // Children
  //     'المندوب',       // Shelter
  //   ]);
  //
  //   // Collect data from the stream
  //   List<Map<String, dynamic>> allChildrenData = await firebaseController
  //       .getDataListStream('childrens/shelter/${firebaseController.UserName}')
  //       .first;
  //
  //   for (var event in allChildrenData) {
  //     print("Processing event: $event");
  //
  //     // Flatten and parse the children data
  //     final childrenRaw = event['listChildren'];
  //     String childrenInfo = '';
  //
  //     if (childrenRaw is Map<dynamic, dynamic>) {
  //       // Convert to Map<String, dynamic> and process
  //       final children = childrenRaw.map((key, value) =>
  //           MapEntry(key.toString(), value as Map<dynamic, dynamic>));
  //       children.forEach((key, child) {
  //         if (child is Map) {
  //           childrenInfo +=
  //           '${child['name']} (${child['eage']} ), الهوية: ${child['id']}\n';
  //         }
  //       });
  //     }
  //
  //     // Append the row to the Excel sheet
  //     sheetObject.appendRow([
  //       event['parentId'] ?? '', // Parent ID
  //       event['parentName'] ?? '', // Parent Name
  //       childrenInfo, // Flattened children information
  //       event['shelter'] ?? '', // Shelter
  //     ]);
  //   }
  //
  //   // Encode the Excel file into bytes
  //   final excelBytes = excel.encode()!;
  //
  //   // Create a Blob from the encoded bytes
  //   final blob = html.Blob([excelBytes], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
  //
  //   // Generate a download URL for the Blob
  //   final url = html.Url.createObjectUrlFromBlob(blob);
  //
  //   // Create an anchor element to trigger the download
  //   final anchor = html.AnchorElement(href: url)
  //     ..target = 'blank'
  //     ..download = "كشف_أطفال.xlsx"
  //     ..click(); // Simulate a click to download the file
  //
  //   // Revoke the Blob URL to free up memory
  //   html.Url.revokeObjectUrl(url);
  //
  //   // Notify the user
  //   listFamilyController.onStatrtExportToExcel(); // End UI feedback
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text("تم تنزيل ملف كشف_أطفال.xlsx"), backgroundColor: Colors.blueGrey),
  //   );
  //
  //   print("File downloaded: كشف_أطفال.xlsx");
  // }


}





