// import 'dart:math';
// import 'package:flutter/foundation.dart' as foundation;
// import 'package:flutter/material.dart';
// import 'package:excel/excel.dart';
// import '../controller/firebase_controller.dart';
// import '../controller/listfamily_controller.dart';
// import '../modles/users_info.dart';
// import 'dart:html' as html;
//
// class ConstantWeb {
//   // Utility function to export Excel file
//   // دالة لتصدير البيانات إلى Excel فقط في بيئة الويب
//   static void exportToExcelWeb2(List<int> excelBytes, String filename) {
//     if (foundation.kIsWeb) {
//       final blob = html.Blob([excelBytes], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
//       final url = html.Url.createObjectUrlFromBlob(blob);
//       final anchor = html.AnchorElement(href: url)
//         ..target = '_blank'
//         ..download = filename
//         ..click();
//       html.Url.revokeObjectUrl(url);
//     }
//   }
//   // Export user data to Excel for web
//   static Future<void> exportToExcelWeb(BuildContext context, ListFamilyController listFamilyController, FirebaseController firebaseController, String userName) async {
//     listFamilyController.onStatrtExportToExcel();
//
//     // Create an Excel workbook and a sheet
//     var excel = Excel.createExcel();
//     Sheet sheetObject = excel['Sheet1'];
//
//     // Add header row
//     sheetObject.appendRow([
//       'الرقم', 'الحالة الإجتماعية', 'هوية الزوج', 'اسم الزوج',
//       'هوية الزوجة', 'اسم الزوجة', 'عدد الأفراد', 'جوال',
//       'السكن الأصلي', 'حالة الإقامة', 'المندوب', 'الملاحظات'
//     ]);
//
//     // Fetch user data
//     List<UserInfo> list = await firebaseController.getUsersAsFuture('/${userName}');
//
//     // Populate the sheet with user data
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
//         list[i].residenceStatus,
//         list[i].shelter,
//         list[i].notes,
//       ]);
//     }
//
//     // Encode the Excel file into bytes
//     final excelBytes = excel.encode()!;
//
//     // Export to Excel for Web
//     if (foundation.kIsWeb) {
//       exportToExcelWeb2(excelBytes, "كشف_${userName}.xlsx");
//     }
//
//     // Notify the user
//     listFamilyController.onStatrtExportToExcel();
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("تم تنزيل ملف كشف_${userName}.xlsx"), backgroundColor: Colors.blueGrey),
//     );
//   }
//
//   // Export children data to Excel for web
//   static Future<void> exportChildrenToExcelWeb(BuildContext context, ListFamilyController listFamilyController, FirebaseController firebaseController, String userName) async {
//     listFamilyController.onStatrtExportToExcel();
//
//     var excel = Excel.createExcel();
//     Sheet sheetObject = excel['Sheet1'];
//
//     // Initialize header row
//     List<String> headerRow = [
//       'هوية ولي الأمر', 'اسم ولي الأمر', 'المندوب',
//     ];
//
//     // Collect data
//     List<Map<String, dynamic>> allChildrenData = await firebaseController
//         .getDataListStream('childrens/shelter/${userName}')
//         .first;
//
//     int maxChildren = 0;
//     // Determine maximum number of children
//     for (var event in allChildrenData) {
//       final childrenRaw = event['listChildren'];
//       if (childrenRaw is Map<dynamic, dynamic>) {
//         maxChildren = max(maxChildren, childrenRaw.length);
//       }
//     }
//
//     // Add dynamic headers for children
//     for (int i = 1; i <= maxChildren; i++) {
//       headerRow.addAll([
//         'اسم الطفل $i', 'العمر $i', 'هوية الطفل $i',
//       ]);
//     }
//
//     // Add header to the sheet
//     sheetObject.appendRow(headerRow);
//
//     // Add children data to the sheet
//     for (var event in allChildrenData) {
//       final parentId = event['parentId'] ?? '';
//       final parentName = event['parentName'] ?? '';
//       final shelter = event['shelter'] ?? '';
//       final childrenRaw = event['listChildren'];
//
//       List<String> childrenColumns = [];
//       if (childrenRaw is Map<dynamic, dynamic>) {
//         childrenRaw.forEach((key, child) {
//           if (child is Map) {
//             childrenColumns.add(child['name'] ?? '');
//             childrenColumns.add(child['eage']?.toString() ?? '');
//             childrenColumns.add(child['id'] ?? '');
//           }
//         });
//       }
//
//       while (childrenColumns.length < maxChildren * 3) {
//         childrenColumns.add('');
//       }
//
//       sheetObject.appendRow([
//         parentId, parentName, shelter, ...childrenColumns,
//       ]);
//     }
//
//     final excelBytes = excel.encode()!;
//     if (foundation.kIsWeb) {
//       exportToExcelWeb2(excelBytes, "كشف_أطفال.xlsx");
//     }
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("تم تنزيل ملف كشف_أطفال.xlsx"), backgroundColor: Colors.blueGrey),
//     );
//   }
//
//   // Export additional data to Excel for web (custom case)
//   static Future<void> exportToExcelForWeb_MyDelivers(dynamic value, FirebaseController firebaseController, String userName, String f, String h , BuildContext context) async {
//     var excel = Excel.createExcel();
//     Sheet sheetObject = excel['Sheet1'];
//
//     // Adding header row
//     sheetObject.appendRow([
//       'الرقم', 'الحالة الإجتماعية', 'هوية الزوج', 'اسم الزوج',
//       'هوية الزوجة', 'اسم الزوجة', 'عدد الأفراد', 'جوال',
//       'السكن الأصلي', 'حالة الاستلام', 'المندوب', 'الملاحظات'
//     ]);
//
//     List<UserInfo> list = await firebaseController.getUsersAsFuture(
//       '/$f/${userName}/${value["primery_key"]}/$h',
//     );
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
//     }
//
//     final excelBytes = excel.encode()!;
//     if (foundation.kIsWeb) {
//       exportToExcelWeb2(excelBytes, "${value["title"]}.xlsx");
//     }
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("تم تنزيل ملف ${value["title"]}.xlsx"), backgroundColor: Colors.blueGrey),
//     );
//   }
// }
