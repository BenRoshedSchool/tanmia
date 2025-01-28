import 'dart:async';
import 'dart:isolate';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/modles/children_Info.dart';
import 'package:untitled2/modles/users.dart';
import 'package:untitled2/shared/constant.dart';

import '../data_base/appdatabase.dart';
import '../modles/users_info.dart';
import '../modles/users_info_for_local.dart'; // Corrected path

class FirebaseController extends GetxController {
 // final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
 // final StreamController<List<UserInfo>> itemsController = StreamController<List<UserInfo>>();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  late AppDatabase database ;


  late String UserName = "error";
   String f = "كشوفات تسليم";
 bool isFound = false;
 int totalFamily=0;
 int y=0;
 bool connectionInternent = true;
  StreamSubscription<ConnectivityResult>? connectivitySubscription;
@override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    stopListeningToConnectivity();
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();

    startListeningToConnectivity();
    saveLoginState();
  //  _fetchData();
  }



  Future<String> loginUsers(String userName, int pass) async {

    bool isFound = false;

    // Use a QuerySnapshot to get the data once rather than listening continuously
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("usersInfo").get();

      try{
        for (var doc in snapshot.docs) {

          Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;

          // Access fields from the document
          String username = userData['user_name'];
          int password = userData['pass'];
          print(username);
          print(password);

          // Check if the username and password match
          if (username.contains(userName)  && password == pass) {
            UserName = username;
            update();
            print(UserName);
            return username; // Return the matching username
          }
        }

      }catch(error){
        return error.toString();

      }

      return "error";
// Return error if no user is found
  }

  void saveLoginState() async {
  String? user = await  Constant.getUser();
  UserName = user!;
  update();
  }



  // Function to add data to Firebase Realtime Database
  Future<void> addUser(String userName , String document , Map<dynamic, dynamic> userData , BuildContext context) async {
  try {
  await _dbRef.child("$userName/$document").set(userData);

  print("User data added successfully!");
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text("فشل في عملية الإضافة "),
      ),
    );
  print("Failed to add data: $e");
  }
  }


  // اضافة كشف تسليم
  Future<void> addRecord(String userName , String document , Map<String, dynamic> userData , BuildContext context) async {
    try {
      String f = "كشوفات تسليم";
      await _dbRef.child("$f/$userName/$document").set(userData);

      print("User data added successfully!");
    } catch (e) {
      print("Failed to add data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("$e ${userName}"),
        ),
      );
    }
  }
  Future<void> addRecipients(String userName , String document ,   Map<dynamic, dynamic> userData , BuildContext context) async {
    Map<String, dynamic> tempArray = {};

    print("Maps  ${userData}");
    try {
      String f = "كشوفات تسليم";
      int count=0;
      userData.forEach((key, value) {
        value['receiving_status'] = 'لم يتم الاستلام'; // Add new key and value

        tempArray[key] = value; // Add modified value to tempArray
count++;
update();
      });

      print("TempArray  ${tempArray}");
      await _dbRef.child("$f/$userName/$document/recipients").set(tempArray);

      print("User data added successfully!");
    } catch (e) {
      print("Failed to add data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("$e ${userName}"),
        ),
      );
    }
  }


  Future<List<UserInfo>>  getDataFromDatabase(String userName, int latLimit, int newLimit, int originDataLength) async {
    try {
      DatabaseReference ref = _dbRef.child(userName); // Path in the database
      DatabaseEvent event = await ref.once();
      print("DATA DATA :  ${event.snapshot.value}");

      List<UserInfo> userInfoList = [];
      List<UserInfo> tempList = [];

      if (event.snapshot.value != null) {
        // Check if data is a list or map
        if (event.snapshot.value is List) {
          List<dynamic> dataList = event.snapshot.value as List;

          // Loop over list and parse each item to UserInfo if it's a map
          for (var value in dataList) {
            if (value is Map) {
              UserInfo userInfo = UserInfo.fromJson(Map<String, dynamic>.from(value));
              userInfoList.add(userInfo);
            }
          }
        } else if (event.snapshot.value is Map) {
          Map<String, dynamic> dataMap = Map<String, dynamic>.from(event.snapshot.value as Map);

          // Loop over map values and parse each item to UserInfo
          dataMap.forEach((key, value) {
            if (value is Map) {
              UserInfo userInfo = UserInfo.fromJson(Map<String, dynamic>.from(value));
              userInfoList.add(userInfo);
            }
          });
        } else {
          print('Unexpected data format');
          return [];
        }

        // Populate tempList based on latLimit and newLimit
        if (userInfoList.length <= latLimit + newLimit) {
          for (int i = latLimit; i < userInfoList.length; i++) {
            tempList.add(userInfoList[i]);
            print("I < USER.LENGTH");
          }

          int newAndLat = newLimit + latLimit;
          for (int t = 0; t < newAndLat - userInfoList.length; t++) {
            tempList.add(userInfoList[t]);
            print("I < newAndLat-userInfoList.length");
          }
        } else {
          for (int i = latLimit; i < latLimit + newLimit; i++) {
            print("I > LAT+NEWLIMT");
            tempList.add(userInfoList[i]);
          }
        }

        print("LENGTH of userInfoList: ${userInfoList.length}");
        return tempList; // Return the List containing limited entries
      } else {
        if (kDebugMode) {
          print('No data available');
        }
        return []; // Return empty list if no data
      }
    } catch (e) {
      print('Error retrieving data: $e');
      return []; // Return empty list in case of error
    }
  }


  Stream<Map<dynamic, dynamic>> getDataStream(String nodeName) {
    DatabaseReference ref = FirebaseDatabase.instance.reference().child(nodeName);

    // Listen to the data stream from the specified node
    return ref.onValue.map((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        // Check if the value is a Map or List
        if (event.snapshot.value is Map<dynamic, dynamic>) {
          // If it's a Map, cast it directly
          Map<dynamic, dynamic> dataMap = event.snapshot.value as Map<dynamic, dynamic>;
          return Map<String, dynamic>.from(dataMap);
        } else if (event.snapshot.value is List) {
          // If it's a List, handle it by converting it to a Map
          List<dynamic> dataList = event.snapshot.value as List<dynamic>;
          Map<dynamic, dynamic> dataMap = {
            for (int i = 0; i < dataList.length; i++) i.toString(): dataList[i],
          };
          return dataMap;
        }
      }
      return {}; // Return an empty map if no data
    });
  }


  /// Method to get data from a specific node as a list of maps
  /// Method to get data from a specific path as a list of maps
  Stream<List<Map<String, dynamic>>> getDataListStream(String path) {
    return _dbRef.child(path).onValue.map((event) {
      final dataSnapshot = event.snapshot;
      final data = dataSnapshot.value;

      if (data is Map<dynamic, dynamic>) {
        // If data is a Map, convert it to a list of maps
        return data.entries.map((entry) {
          return {
            "id": entry.key,
            ...(entry.value as Map<dynamic, dynamic>?)?.map((key, value) => MapEntry(key.toString(), value)) ?? {}
          };
        }).toList();
      } else if (data is List<dynamic>) {
        // If data is a List, cast it directly to List<Map<String, dynamic>>
        return data
            .whereType<Map<dynamic, dynamic>>() // Filter null elements
            .map((map) => map.map((key, value) => MapEntry(key.toString(), value)))
            .toList();
      } else {
        // Return empty list if data is null or in an unexpected format
        return [];
      }
    });
  }


  Future<void>  deleteData(String path) async {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref(path);

      // Remove data at the specified path
      await ref.remove();
      } catch (e) {
      print("Failed to delete data: $e");
    }
  }


  Future<void> updateReceivingStatus(
       String documentPath, Map<dynamic, dynamic> updatedData, BuildContext context) async {

    try {

      print("$documentPath");
      await _dbRef.child("$documentPath").set(updatedData);
      print("Receiving status updated successfully!");
    } catch (e) {
      print("Failed to update receiving status: $e");
    }
  }

  // Future<String> checkUserIsFound(int id1, int id2) async {
  //   // Create a Completer to handle async operation
  //   Completer<String> completer = Completer();
  //
  //   // Fetch all users from the database
  //   final List<Map<String, dynamic>> users = await getUsersToAdminAccountFuture("usersInfo");
  //
  //
  //   print("Stream event received: $users"); // Debug the fetched users list
  //
  //   // Iterate over each user
  //   for (String user in Constant.manadeebList) {
  //     print("Processing user: $user"); // Debugging each user being processed
  //
  //     // Skip admin
  //     if (user != "admin") {
  //       try {
  //         // Fetch data stream for the specific user
  //         await for (var event in getDataListStream(user)) {
  //           for (var userData in event) {
  //             if (id1 == userData["id1"] && id2 == userData["id2"]) {
  //               print("Match found: ${userData["shelter"]}"); // Debug match found
  //               if (!completer.isCompleted) {
  //                 completer.complete(userData["shelter"]);
  //                 return completer.future; // Return early on match
  //               }
  //             }
  //           }
  //         }
  //       } catch (e) {
  //         print("Error processing user ${user}: $e"); // Handle potential errors
  //       }
  //     }
  //   }
  //
  //   // Return a default value if no match is found, with a timeout
  //   return completer.future.timeout(Duration(seconds: 10), onTimeout: () {
  //     print("Timeout reached with no match found."); // Debug timeout
  //     return ""; // Return empty string if no result is found within 10 seconds
  //   });
  // }

  Future<String> checkUserIsFound(int id1, int id2) async {
    // List<String> manadeebList = Constant.manadeebList;
    Completer<String> completer = Completer();
      final List<Map<String, dynamic>> users = await getUsersToAdminAccountFuture("usersInfo");


    for (Map<String, dynamic> user in users) {
      getDataListStream(user["user_name"]).listen((event) {
        for (Map<String, dynamic> users in event) {
          if (id1.toString().contains(users["id1"].toString()) && id2.toString().contains(users["id2"].toString()) ) {
            print("id1 user: ${users["id1"]}");
            print("id1 user: ${users["name1"]}");
            print("shelter : ${users["shelter"]}");

            if (!completer.isCompleted) {
              completer.complete(users["shelter"]);
            }
          }
        }
      });
    }

    // Wait for the completer to complete with the result, or return empty string if no match is found
    return completer.future.timeout(Duration(seconds: 10), onTimeout: () {
      return "";
    });
  }
  Stream<List<Map<String, dynamic>>> getUsersToAdminAccountStream(String path) {
    return firestore.collection(path).snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
    });
  }

  Future<List<Map<String, dynamic>>> getUsersToAdminAccountFuture(String path) async {
    return firestore.collection(path).get().then((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
    });
  }


  Stream<Map<String, dynamic>> getUsersToAdminAccountStream2(String collectionPath, String documentPath) {
    return firestore
        .collection(collectionPath)
        .doc(documentPath)
        .snapshots()
        .map((documentSnapshot) {
      return documentSnapshot.data() !=null ? documentSnapshot.data() as Map<String, dynamic> : {};
    });
  }


  Stream<String> getUsersToAdminAccountStream3(
      String collectionPath, String documentPath, String key) {
    return firestore
        .collection(collectionPath)
        .doc(documentPath)
        .snapshots()
        .map((documentSnapshot) {
      final data = documentSnapshot.data() as Map<String, dynamic>?;
      if (data != null && data.containsKey(key)) {
        return data[key]?.toString() ?? ''; // Return the key's value as a string
      }
      return ''; // Return an empty string if key is not found or data is null
    });
  }



  Future<List<UserInfo>>  getUsersAsFuture(String userName) async {
    try {
      DatabaseReference ref = _dbRef.child(userName); // Path in the database
      DatabaseEvent event = await ref.once();

      List<UserInfo> userInfoList = [];

      if (event.snapshot.value != null) {
        // Check if data is a list or map
        if (event.snapshot.value is List) {
          List<dynamic> dataList = event.snapshot.value as List;

          // Loop over list and parse each item to UserInfo if it's a map
          for (var value in dataList) {
            if (value is Map) {
              UserInfo userInfo = UserInfo.fromJson(Map<String, dynamic>.from(value));
              userInfoList.add(userInfo);
            }
          }
        } else if (event.snapshot.value is Map) {
          Map<String, dynamic> dataMap = Map<String, dynamic>.from(event.snapshot.value as Map);

          // Loop over map values and parse each item to UserInfo
          dataMap.forEach((key, value) {
            if (value is Map) {
              UserInfo userInfo = UserInfo.fromJson(Map<String, dynamic>.from(value));
              userInfoList.add(userInfo);
            }
          });
        } else {
          print('Unexpected data format');
          return [];
        }



        return userInfoList; // Return the List containing limited entries
      } else {
        print('No data available');
        return []; // Return empty list if no data
      }
    } catch (e) {
      print('Error retrieving data: $e');
      return []; // Return empty list in case of error
    }
  }

  // تعديل اسم المندوب في الكشف الآصلي و كشف التسليمات
  Future<void> changeShelter(String shelterPath, String newPass, String newName, BuildContext context) async {
    try {
      List<String> list =  await Constant.getKeyAlmadobFromShoab(shelterPath);

      DatabaseReference ref = FirebaseDatabase.instance.reference();

      DatabaseReference ref2 = ref.child(shelterPath);

      print("shelterPath    ${shelterPath}");
      Map<dynamic, dynamic> dataMap;
      // جلب بيانات المندوب القديم ليتم تعدبل shelter
      ref2.once().then((value) async {
        if (value.snapshot.value != null) {
          // Check if the value is a Map or List
          if (value.snapshot.value is Map<dynamic, dynamic>) {
            // If it's a Map, cast it directly
            Map<dynamic, dynamic> dataMap = value.snapshot.value as Map<dynamic, dynamic>;
            print("data Map   :  ${dataMap}");
          } else if (value.snapshot.value is List) {
            // If it's a List, handle it by converting it to a Map
            List<dynamic> dataList = value.snapshot.value as List<dynamic>;
            dataMap = {
              for (int i = 0; i < dataList.length; i++) i.toString(): dataList[i],
            };
            dataMap.forEach((key, value) async {
              dataMap[key]["shelter"] = newName;
            });

            // اضافة المندوب  الجديد
            try {
              await ref.child("$newName").set(dataMap);

              print("User data added successfully!");
            } catch (e) {
              print("Failed to add data: $e");
            }

            // حذف المندوب  القدبم
            await ref.child("$shelterPath").remove();

          }
        }
        return {};
      });

      // تحديث بيانات الأطفال
      DatabaseEvent childEvent = await ref.child("childrens/shelter/$shelterPath").once();
      DataSnapshot childSnapshot = childEvent.snapshot; // استخراج DataSnapshot من DatabaseEvent
      if (childSnapshot.value != null && childSnapshot.value is Map) {
        Map<String, dynamic> childrenData = Map<String, dynamic>.from(childSnapshot.value as Map);
        childrenData.forEach((key, value) {
          value["shelter"] = newName;
        });

        await ref.child("childrens/shelter/$newName").set(childrenData);
        await ref.child("childrens/shelter/$shelterPath").remove();
        print("تم تحديث بيانات الأطفال بنجاح.");
      }

      // تحديث Firestore
      await FirebaseFirestore.instance.collection("usersInfo").doc(shelterPath).delete();
      await FirebaseFirestore.instance.collection("usersInfo").doc(newName).set({
        "user_name": newName,
        "pass": int.parse(newPass),
      });

      // تحديث Firestore
      try {
        // Reference to the Firestore document
        DocumentReference documentRef = FirebaseFirestore.instance.collection("man").doc(list[1]);

        // Use the update() method to update the field with the new value
        await documentRef.update({
          list[0]: newName,  // The field to update and the new value
        });
        print("Field updated successfully.");
      } catch (e) {
        print("Error updating field: $e");
      }

     int? lat = await getLat(shelterPath);

      await deleteData("lat/${shelterPath}");
      await saveLat(newName, lat!, context);
      // عرض رسالة نجاح
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text("تم التعديل بنجاح"),
          ),
        );
      }
    } catch (e) {
      print("خطأ أثناء العملية: $e");
    }
  }


  Future<List<UserInfo>> getUsersInfoAsFuture(String userName) async {
    DatabaseReference ref = _dbRef.child(userName);
    DatabaseEvent event = await ref.once();
    print("DATA DATA :  ${event.snapshot.value}");

    List<UserInfo> userInfoList = [];

    if (event.snapshot.value != null) {
      if (event.snapshot.value is List) {
        List<dynamic> dataList = event.snapshot.value as List;

        for (var value in dataList) {
          if (value is Map) {
            UserInfo userInfo = UserInfo.fromJson(Map<String, dynamic>.from(value));
            userInfoList.add(userInfo);
          }
        }
        return userInfoList; // Return here for List data type
      } else if (event.snapshot.value is Map) {
        Map<String, dynamic> dataMap = Map<String, dynamic>.from(event.snapshot.value as Map);

        dataMap.forEach((key, value) {
          if (value is Map) {
            UserInfo userInfo = UserInfo.fromJson(Map<String, dynamic>.from(value));
            userInfoList.add(userInfo);
          }
        });
        return userInfoList; // Return here for Map data type
      } else {
        print('Unexpected data format');
      }
    }
    return []; // Final return if no valid data was found
  }

  // Method to retrieve data list as a Future
  Future<Map<dynamic, dynamic>> getDataOnce(String nodeName) async {
    DatabaseReference ref = FirebaseDatabase.instance.reference().child(nodeName);

    try {
      DataSnapshot snapshot = await ref.get();

      if (snapshot.value != null) {
        // If the data is already a Map, return it directly
        if (snapshot.value is Map) {
          return snapshot.value as Map<dynamic, dynamic>;
        }
        // If it's a List, convert it to a Map
        else if (snapshot.value is List) {
          List<dynamic> dataList = snapshot.value as List<dynamic>;
          return {
            for (int i = 0; i < dataList.length; i++) i.toString(): dataList[i],
          };
        }
      }
    } catch (e) {
      print("Error fetching data: $e");
    }

    return {}; // Return an empty map if no data or an error occurs
  }

  void startListeningToConnectivity() {
    connectivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
        if (result == ConnectivityResult.none) {
          connectionInternent = false;
          update();
        } else {
          connectionInternent = true;
          update();
        }

    });
  }

  void stopListeningToConnectivity() {
    connectivitySubscription?.cancel();
  }





  Future<void> saveDatainLocalDataBase() async {

    final List<Map<String, dynamic>> users = await getUsersToAdminAccountFuture("usersInfo");

    for(Map<String, dynamic> user in users){
      await getDataListStream(user["user_name"]).listen((event) {
        print("saveData base ${event.length}");

        for(Map<dynamic , dynamic> mapUser in event){
          UserInfo userInfo = UserInfo.fromJson(mapUser);

          try{
            database.personDao.insertUserInfoForlocal(
                UserInfoForlocal(
                    id1: int.parse(userInfo.id1.toString()),
                    id2: int.parse(userInfo.id2.toString()),
                    name1: userInfo.name1.toString(),
                    name2: userInfo.name2.toString(),
                    notes: userInfo.notes.toString(),
                    numberOfFamily: int.parse(userInfo.numberOfFamily.toString()),
                    originalResidence: userInfo.originalResidence.toString(),
                    primery_key: userInfo.primery_key.toString(),
                    residenceStatus: userInfo.residenceStatus.toString(),
                    shelter: userInfo.shelter.toString(),
                    status: userInfo.status.toString(),
                    mobile: int.parse(userInfo.mobile.toString())));
          }catch(error){
            print("ERROR    : ${error}");
          }

          print(userInfo.name1);
        }
      });

    }
  }

  Stream<List<Map<String, dynamic>>> getFamily(String user) {
    return database.personDao.getUsersFamily(user).map((event) {
      return event.map((userInfoForLocal) {
        return {
          'id1': userInfoForLocal.id1,
          'id2': userInfoForLocal.id2,
          'name1': userInfoForLocal.name1,
          'name2': userInfoForLocal.name2,
          'notes': userInfoForLocal.notes,
          'number_of_family': userInfoForLocal.numberOfFamily,
          'original_residence': userInfoForLocal.originalResidence,
          'primery_key': userInfoForLocal.primery_key,
          'residence_status': userInfoForLocal.residenceStatus,
          'shelter': userInfoForLocal.shelter,
          'status': userInfoForLocal.status,
          'mobile': userInfoForLocal.mobile,
        };
      }).toList();
    });
  }


  // Function to add data to Firebase Realtime Database
  Future<void>  addnotificationFromUserToAdmin(Map<dynamic, dynamic> userData , BuildContext context , String idNotification) async {
    try {
      await _dbRef.child("notification/admin/notificationData/${idNotification}").set(userData);

      print("User data added successfully!");
    } catch (e) {
      print("Failed to add data: $e");
    }
  }


  // Function to add data to Firebase Realtime Database
  Future<void> addNumberOfNotificationFromUserToAdmin( Map<dynamic , dynamic> numOfNotification) async {
    try {

      await _dbRef.child("notification/admin/numberOfNotification").set(numOfNotification);
      //
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     backgroundColor: Colors.green,
      //     content: Text("تمت الإضافة بنجاج"),
      //   ),
      // );
    } catch (e) {
      print("Failed to add data: $e");
    }
  }


  Stream<Map<dynamic, dynamic>> getNotificationNumber() {
    DatabaseReference ref = FirebaseDatabase.instance.reference().child("notification/admin/numberOfNotification");

    // Listen to the data stream from the specified node
    return ref.onValue.map((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        // Check if the value is a Map or List
        if (event.snapshot.value is Map<dynamic, dynamic>) {
          // If it's a Map, cast it directly
          Map<dynamic, dynamic> dataMap = event.snapshot.value as Map<dynamic, dynamic>;
          return Map<String, dynamic>.from(dataMap);
        } else if (event.snapshot.value is List) {
          // If it's a List, handle it by converting it to a Map
          List<dynamic> dataList = event.snapshot.value as List<dynamic>;
          Map<dynamic, dynamic> dataMap = {
            for (int i = 0; i < dataList.length; i++) i.toString(): dataList[i],
          };
          return dataMap;
        }
      }
      return {}; // Return an empty map if no data
    });
  }




  /// Method to get data from a specific path as a list of maps
  Stream<List<Map<String, dynamic>>> getAdminNotification() {
    return _dbRef.child("notification/admin/notificationData").onValue.map((event) {
      final dataSnapshot = event.snapshot;
      final data = dataSnapshot.value;

      print("dataa ${data}");
      if (data is Map<dynamic, dynamic>) {
        // If data is a Map, convert it to a list of maps
        return data.entries.map((entry) {
          return {
            "id": entry.key,
            ...(entry.value as Map<dynamic, dynamic>?)?.map((key, value) => MapEntry(key.toString(), value)) ?? {}
          };
        }).toList();
      } else if (data is List<dynamic>) {
        // If data is a List, cast it directly to List<Map<String, dynamic>>
        return data
            .whereType<Map<dynamic, dynamic>>() // Filter null elements
            .map((map) => map.map((key, value) => MapEntry(key.toString(), value)))
            .toList();
      } else {
        // Return empty list if data is null or in an unexpected format
        return [];
      }
    });
  }


  // Function to add data to Firebase Realtime Database
  Future<void> addnotificationFromUserToUser(Map<dynamic, dynamic> userData , BuildContext context , String idNotification , String reciverShelter)  async {
    try {
      await _dbRef.child("notification/shelter/${reciverShelter}/${idNotification}").set(userData);

      print("User data added successfully!");
    } catch (e) {
      print("Failed to add data: $e");
    }
  }


  // Function to add data to Firebase Realtime Database
  Future<void> addNumberOfNotificationFromUserToUser( Map<dynamic , dynamic> numOfNotification ,  String userName) async {
    try {

      await _dbRef.child("notification/shelter/${userName}/numberOfNotification").set(numOfNotification);
      //
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     backgroundColor: Colors.green,
      //     content: Text("تمت الإضافة بنجاج"),
      //   ),
      // );
    } catch (e) {
      print("Failed to add data: $e");
    }
  }


  Stream<List<Map<String, dynamic>>> getUserNotification(String userName) {
    return _dbRef.child("notification/shelter/${userName}").onValue.map((event) {
      final dataSnapshot = event.snapshot;
      final data = dataSnapshot.value;

      print("dataa ${data}");
      if (data is Map<dynamic, dynamic>) {
        // If data is a Map, convert it to a list of maps
        return data.entries.map((entry) {
          return {
            "id": entry.key,
            ...(entry.value as Map<dynamic, dynamic>?)?.map((key, value) => MapEntry(key.toString(), value)) ?? {}
          };
        }).toList();
      } else if (data is List<dynamic>) {
        // If data is a List, cast it directly to List<Map<String, dynamic>>
        return data
            .whereType<Map<dynamic, dynamic>>() // Filter null elements
            .map((map) => map.map((key, value) => MapEntry(key.toString(), value)))
            .toList();
      } else {
        // Return empty list if data is null or in an unexpected format
        return [];
      }
    });
  }

  Stream<Map<dynamic, dynamic>> getUserNotificationNumber(String userName) {
    DatabaseReference ref = FirebaseDatabase.instance.reference().child("notification/shelter/${userName}/numberOfNotification");

    // Listen to the data stream from the specified node
    return ref.onValue.map((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        // Check if the value is a Map or List
        if (event.snapshot.value is Map<dynamic, dynamic>) {
          // If it's a Map, cast it directly
          Map<dynamic, dynamic> dataMap = event.snapshot.value as Map<dynamic, dynamic>;
          return Map<String, dynamic>.from(dataMap);
        } else if (event.snapshot.value is List) {
          // If it's a List, handle it by converting it to a Map
          List<dynamic> dataList = event.snapshot.value as List<dynamic>;
          Map<dynamic, dynamic> dataMap = {
            for (int i = 0; i < dataList.length; i++) i.toString(): dataList[i],
          };
          return dataMap;
        }
      }
      return {}; // Return an empty map if no data
    });
  }


  // Function to add data to Firebase Realtime Database
  Future<void> updateStatusRecive(String status , BuildContext context , int idNotification , String reciverShelter)  async {
    try {
      await _dbRef.child("notification/shelter/${reciverShelter}/${idNotification}/status").set(status);

      print("User data added successfully!");
    } catch (e) {
      print("Failed to add data: $e");
    }
  }

  // Function to add data to Firebase Realtime Database
  Future<void> addChildren(Map<dynamic, dynamic> childrenInfoMap , BuildContext context , String username , int idParent)  async {
    try {
      await _dbRef.child("childrens/shelter/${username}/${idParent}").set(childrenInfoMap);

      print("User data added successfully!");
    } catch (e) {
      print("Failed to add data: $e");
    }
  }


  Future<String> checkChildrenIsFound(int id1) async {

    final List<Map<String, dynamic>> users = await getUsersToAdminAccountFuture("usersInfo");

    // List<String> manadeebList = Constant.manadeebList;
    Completer<String> completer = Completer();

    for (Map<String , dynamic> user in users) {
      getDataListStream("childrens/shelter/${user["user_name"]}").listen((event) {

        for (Map<String, dynamic> users in event) {

          if (id1.toString().contains(users["parentId"].toString() ) ) {


            if (!completer.isCompleted) {
              completer.complete(users["shelter"]);
            }
          }
        }
      });
    }

    // Wait for the completer to complete with the result, or return empty string if no match is found
    return completer.future.timeout(Duration(seconds: 10), onTimeout: () {
      return "";
    });
  }



  Future<String> checkChildrenparentIsSigned(int id1 , String userName) async {
    Completer<String> completer = Completer();

      getDataListStream(userName).listen((event) {

        for (Map<String, dynamic> users in event) {

          if (id1.toString().contains(users["id1"].toString())  ) {


            if (!completer.isCompleted) {
              completer.complete(users["shelter"]);
            }
          }
        }
      });


    // Wait for the completer to complete with the result, or return empty string if no match is found
    return completer.future.timeout(Duration(seconds: 10), onTimeout: () {
      return "";
    });
  }

  // Function to add data to Firebase Realtime Database
  Future<void> addChildren2(Map<dynamic, dynamic> childrenInfoMap , BuildContext context , String username , int idParent , String idDocument)  async {
    try {
      await _dbRef.child("childrens/shelter/${username}/${idParent}/listChildren/${idDocument}").set(childrenInfoMap);

      print("User data added successfully!");
    } catch (e) {
      print("Failed to add data: $e");
    }
  }

  Future<List<ChildrenInfo>>  getChildrenAsFuture(String userName) async {
    try {
      DatabaseReference ref = _dbRef.child(userName); // Path in the database
      DatabaseEvent event = await ref.once();
      print("DATA DATA :  ${event.snapshot.value}");

      List<ChildrenInfo> childrenInfoList = [];

      if (event.snapshot.value != null) {
        // Check if data is a list or map
        if (event.snapshot.value is List) {
          List<dynamic> dataList = event.snapshot.value as List;

          // Loop over list and parse each item to UserInfo if it's a map
          for (var value in dataList) {
            if (value is Map) {
              ChildrenInfo childrenInfo = ChildrenInfo.fromJson(Map<String, dynamic>.from(value));
              childrenInfoList.add(childrenInfo);
            }
          }
        } else if (event.snapshot.value is Map) {
          Map<String, dynamic> dataMap = Map<String, dynamic>.from(event.snapshot.value as Map);

          // Loop over map values and parse each item to UserInfo
          dataMap.forEach((key, value) {
            if (value is Map) {
              ChildrenInfo childrenInfo = ChildrenInfo.fromJson(Map<String, dynamic>.from(value));
              childrenInfoList.add(childrenInfo);
            }
          });
        } else {
          print('Unexpected data format');
          return [];
        }



        return childrenInfoList; // Return the List containing limited entries
      } else {
        print('No data available');
        return []; // Return empty list if no data
      }
    } catch (e) {
      print('Error retrieving data: $e');
      return []; // Return empty list in case of error
    }
  }

  Stream<List<Map<String, dynamic>>> getDataListStream2(String path) {
    return _dbRef.child(path).onValue.map((event) {
      final dataSnapshot = event.snapshot;
      final data = dataSnapshot.value;

      try {
        if (data is Map<dynamic, dynamic>) {
          // If data is a Map, convert it to a list of maps
          return data.entries.map((entry) {
            return {
              "id": entry.key,
              ...(entry.value as Map<dynamic, dynamic>?)?.map((key, value) => MapEntry(key.toString(), value)) ?? {}
            };
          }).toList();
        } else if (data is List<dynamic>) {
          // If data is a List, cast it directly to List<Map<String, dynamic>>
          return data
              .whereType<Map<dynamic, dynamic>>() // Filter null elements
              .map((map) => map.map((key, value) => MapEntry(key.toString(), value)))
              .toList();
        } else {
          // Unexpected data format
          print("Unexpected data format: $data");
          return [];
        }
      } catch (e) {
        print("Error processing data: $e");
        return [];
      }
    });
  }

  // Function to add data to Firebase Realtime Database
  Future<void> saveLat(String userName , int lat, BuildContext context) async {
    try {
      await _dbRef.child("lat/$userName").set(lat);
      print("User data added successfully!");
    } catch (e) {
      print("Failed to add data: $e");
    }
  }

  // Function to get data from Firebase Realtime Database
  Future<int?> getLat(String userName) async {
    try {
      final snapshot = await _dbRef.child("lat/$userName").get();
      if (snapshot.exists) {
        int lat = snapshot.value as int;
        print("Retrieved latitude: $lat");
        return lat;
      } else {
        print("No data found for user: $userName");
        return null;
      }
    } catch (e) {
      print("Failed to retrieve data: $e");
      return null;
    }
  }

  Future<Map<dynamic, dynamic>> getDataOnce2(String path) async {
    try {
      final ref = FirebaseDatabase.instance.ref(path);
      final snapshot = await ref.get();

      if (snapshot.exists) {
        // Check if the data is a List and convert it to a Map if needed
        if (snapshot.value is List) {
          List dataList = snapshot.value as List;

          // Convert the List to a Map, excluding null values
          Map<dynamic, dynamic> dataMap = {};
          for (var i = 0; i < dataList.length; i++) {
            if (dataList[i] != null) {
              dataMap[i] = dataList[i];
            }
          }
          return dataMap;
        }

        // Return directly if it's already a Map
        return snapshot.value as Map<dynamic, dynamic>;
      } else {
        throw Exception("No data found at the path: $path");
      }
    } catch (e) {
      throw Exception("Failed to fetch data: $e");
    }
  }

  /// تعديل صلاحية الاستبدال للمناديب
  Future<void> updateBooleanField(String collection, String documentId, String fieldName, bool newValue) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      DocumentReference docRef = _firestore.collection(collection).doc(documentId);

      // Update the field with the new boolean value
      await docRef.update({
        fieldName: newValue,
      });
      print("Field '$fieldName' updated to $newValue.");
    } catch (e) {
      print("Error updating boolean field: $e");
    }
  }


  // ارجاع قيمة الاستبدال لفتح الصلاحية او غيره
  Future<bool> getFieldValue(String collection, String documentId, String fieldName) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      DocumentReference docRef = _firestore.collection(collection).doc(documentId);

      // Get the document snapshot
      DocumentSnapshot docSnapshot = await docRef.get();

      // Check if the document exists
      if (docSnapshot.exists) {
        // Retrieve the value of the field
        bool fieldValue = docSnapshot.get(fieldName);

        // Print the field value
        print("The value of '$fieldName' is: $fieldValue");

        return fieldValue;
      } else {
        print("Document does not exist.");
        return false;  // Return false if document doesn't exist
      }
    } catch (e) {
      print("Error retrieving field value: $e");
      return false;  // Return false in case of error
    }
  }


}