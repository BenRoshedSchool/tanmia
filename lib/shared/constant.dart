import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/controller/firebase_controller.dart';
import 'package:untitled2/controller/listfamily_controller.dart';
import 'package:untitled2/modles/users_info.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'constant_web.dart';
export 'constant_web.dart' if (dart.library.html) 'constant_mobile.dart';



class Constant{

  static List<String> shoab = ["حي أبو بكر و الرحمة" , "حي أبو عبيدة" , "حي الأنصار الغربية" , "حي الأنصار الشرقية" , "حي الفاروق" , "حي السوارحة" ,  "حي طيبة"];
  static List<String> manadeebList =
    ["عبد نطط" , "عمرو سالم" , "محمد التعبان" ,
    "زهير نصار" , "أحمد أبو سويرح" ,
    "أحمد سلطان" , "أسعد عيد" ,
    "ابراهيم زقوت" , "بسام الخطيب" ,
    "خليل اسعيفان" , "ابراهيم زقوت الرواد" ,
    "سلمان التعبان" , "شادي أبو ركاب" ,
    "علي العرمي" , "محمد القرعان" ,
    "مازن أبو نحل" , "محمد النمروطي" ,
    "محمد الحميدي" , "محمد قشلان" ,
    "مهند أبو سماحة" ,
    "مزيد محمود أبو مزيد" , "مصطفى عياش"  , "أبو راشد",
  ];

  // static List<String> abubakerList = ["عبد نطط" , "عمرو سالم" , "محمد التعبان" ,
  //   "زهير نصار" ,  "ابراهيم زقوت" , "ابراهيم زقوت الرواد" ,
  //   "سلمان التعبان" , "شادي أبو ركاب" ,  "محمد الحميدي" , "أبو راشد"];
  //
  // static List<String> abuubaidaList = ["محمد النمروطي"];
  // static List<String> ansarEastList = ["محمد قشلان" , "أسعد عيد"];
  // static List<String> ansarWeastList = ["أحمد سلطان" , "مزيد محمود أبو مزيد"];
  // static List<String> alfarogList = ["خليل اسعيفان"];
  //   static List<String> taibaList = ["مصطفى عياش" ,     "مهند أبو سماحة" ,
  //   "مازن أبو نحل" , "محمد القرعان" , "علي العرمي" , "أحمد أبو سويرح"];
  // static List<String> alsaoarhaList = ["بسام الخطيب"];

  static void saveUser(String user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print("SAVED $user");
    await prefs.setString('user', user);

  }
  // Method to get user from SharedPreferences
 static Future<String?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user'); // Returns null if the user key does not exist
  }

  static Future<void> saveLat(int num , String userNmae) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('latNum${userNmae}',num );
    print("SAVVVED $num");

  }

 static Future<int?> getLateNum(String userName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? counter = prefs.getInt('latNum${userName}');
    return counter;
  }

  static Future<List<Map<String, dynamic>>> getUsersByAlshoab(String alshoab) async {
    FirebaseController firebaseController = FirebaseController();

    Stream<Map<String, dynamic>>? userStream;

    if (alshoab == "حي أبو بكر و الرحمة") {

      userStream = firebaseController.getUsersToAdminAccountStream2("man", "baker");


    } else if (alshoab == "حي أبو عبيدة") {
      userStream = firebaseController.getUsersToAdminAccountStream2("man", "ubaida");
    } else if (alshoab == "حي الأنصار الغربية") {
      userStream = firebaseController.getUsersToAdminAccountStream2("man", "ansa");
    } else if (alshoab == "حي الأنصار الشرقية") {
      userStream = firebaseController.getUsersToAdminAccountStream2("man", "ansa2");
    } else if (alshoab == "حي الفاروق") {
      userStream = firebaseController.getUsersToAdminAccountStream2("man", "faro");
    } else if (alshoab == "حي السوارحة") {
      userStream = firebaseController.getUsersToAdminAccountStream2("man", "saoar");
    } else if (alshoab == "حي طيبة") {
      userStream = firebaseController.getUsersToAdminAccountStream2("man", "taib");
    } else {
      return [];
    }


    // Collect the data from the stream and convert it into a list
    final Map<String, dynamic> usersMap = await userStream.first;
    return usersMap.entries
        .map((entry) => {"key": entry.key, "value": entry.value})
        .toList();
  }
  static Future<List<String>> getUsersByAlshoab2(String alshoab) async {
    FirebaseController firebaseController = FirebaseController();

    Stream<Map<String, dynamic>>? userStream;

    if (alshoab == "حي أبو بكر و الرحمة") {
      userStream = firebaseController.getUsersToAdminAccountStream2("man", "baker");
    } else if (alshoab == "حي أبو عبيدة") {
      userStream = firebaseController.getUsersToAdminAccountStream2("man", "ubaida");
    } else if (alshoab == "حي الأنصار الغربية") {
      userStream = firebaseController.getUsersToAdminAccountStream2("man", "ansa");
    } else if (alshoab == "حي الأنصار الشرقية") {
      userStream = firebaseController.getUsersToAdminAccountStream2("man", "ansa2");
    } else if (alshoab == "حي الفاروق") {
      userStream = firebaseController.getUsersToAdminAccountStream2("man", "faro");
    } else if (alshoab == "حي السوارحة") {
      userStream = firebaseController.getUsersToAdminAccountStream2("man", "saoar");
    } else if (alshoab == "حي طيبة") {
      userStream = firebaseController.getUsersToAdminAccountStream2("man", "taib");
    } else {
      return [];
    }

    // Collect the data from the stream and convert it into a list of strings
    final Map<String, dynamic> usersMap = await userStream.first;
    return usersMap.values.cast<String>().toList(); // Convert the map values to a list of strings
  }

  static Future<void> saveNumberOffamily(String key , int number) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, number);
  }

  static Future<int?> getNumberOffamily(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  static Future<bool> checkInternetConnection() async {
    // Check network connectivity (Wi-Fi or mobile data)
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      // Check if there is actually internet access by trying to ping a known website
      try {
        final response = await http.get(Uri.parse('https://www.google.com'));

        // If we get a successful response, we have internet access
        if (response.statusCode == 200) {
          return true;
        }
      } catch (e) {
        // If there's an error in making the request, no internet access
        return false;
      }
    }

    // If not connected to Wi-Fi or mobile data, return false
    return false;
  }

  static String getCurrentDateTime() {
    final DateTime now = DateTime.now();
    final String formattedDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    final String formattedTime = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";

    return "$formattedDate $formattedTime";
  }

  Future<bool> requestSmsPermission() async {
    if (await Permission.storage.isGranted) {
      return true;
    }

    var status = await Permission.storage.request();

    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }

    return false;
  }

  static Future<List<String>> getKeyAlmadobFromShoab(String user) async {

    List<String> listResult=[];
    // الحصول علئ key لتعديل المندوب في تقسيم الشعب
    for (String sho in Constant.shoab) {
      // Wait for the asynchronous operation to finish
      List<Map<String, dynamic>> value = await Constant.getUsersByAlshoab(sho);

      for (Map<String, dynamic> map in value) {
        if (map.values.toString().contains(user)) {
          String data = map.values.toString();

          // Extract content within parentheses
          final match = RegExp(r'\((.*?)\)').firstMatch(data);

          if (match != null) {
            String content = match.group(1)!; // Extracted content: "name1, أحمد سلطان"

            // Extract the first part before the comma
            String name1 = content.split(',')[0].trim();
            listResult.add(name1);
            switch(sho){

              case "حي أبو بكر و الرحمة":
                listResult.add("baker");
                break;

              case "حي أبو عبيدة":
                listResult.add("ubaida");
                break;

              case "حي الأنصار الغربية":
                listResult.add("ansa");
                break;

              case "حي الأنصار الشرقية":
                listResult.add("ansa2");
                break;

              case "حي الفاروق":
                listResult.add("faro");
                break;

              case "حي السوارحة":
                listResult.add("saoar");
                break;

              case "حي طيبة":
                listResult.add("taib");
                break;
            }

            return listResult;  // Return the extracted name1
          } else {
            print("No parentheses found!");
          }
        }
      }
    }

    return [];  // Return empty string if no match found
  }

  static void showDeleteConfirmationDialog(BuildContext context , Function function) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("تأكيد الحذف"),
          content: Text("هل أنت متأكد من عملية الحذف?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("الغاء"),
            ),
            ElevatedButton(
              onPressed:(){
                function();
                Navigator.of(context).pop(); // Close the dialog

              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text("حذف"),
            ),
          ],
        );
      },
    );
  }

}
