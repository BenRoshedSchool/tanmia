import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled2/modles/record_recpients.dart';
import 'package:untitled2/modles/recored_reciving.dart';
import 'package:untitled2/modles/users_info.dart';
import 'package:untitled2/modles/users_info_for_local.dart';
import 'package:untitled2/shared/constant.dart';
import '../data_base/appdatabase.dart';
import 'firebase_controller.dart';
class LocalDataBaseController extends GetxController {

  String f = "كشوفات تسليم";
  String h = "recipients";
  late final AppDatabase database;
  bool changesInRecoredRecipients = false;

  final FirebaseController firebaseController = Get.put(FirebaseController());
  final Completer<void> _readyCompleter = Completer<void>();

  Future<void> initializeDatabase() async {

      database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();

    _readyCompleter.complete(); // Signal that initialization is complete
  }

  Future<void> get ready => _readyCompleter.future;

  @override
  Future<void> onInit() async {
    super.onInit();
    await initializeDatabase();
    await saveDatainLocalDataBase();
    await saveAndRefreshRecoredRecivingAndRecpients(Get.context!);
     getLatFromFireBase();
  }

  // حفظ بيانات المستخدمين في المحلي
  Future<void> saveDatainLocalDataBase() async {
    // فحص وجود الانترنت
    bool isCheck = await Constant.checkInternetConnection();

    if (isCheck == true) {
      List<UserInfo> list = await firebaseController.getUsersAsFuture(
          firebaseController.UserName);
      List<UserInfoForlocal> listUsersForLocal = await database.personDao
          .getUsersFamilyAsFuture(firebaseController.UserName);

      if (list.length > listUsersForLocal.length) {
        await firebaseController.getDataListStream(firebaseController.UserName)
            .listen((event) {
          for (Map<dynamic, dynamic> mapUser in event) {
            UserInfo userInfo = UserInfo.fromJson(mapUser);

            try {
              database.personDao.insertUserInfoForlocal(
                  UserInfoForlocal(
                      id1: int.parse(userInfo.id1.toString()),
                      id2: int.parse(userInfo.id2.toString()),
                      name1: userInfo.name1.toString(),
                      name2: userInfo.name2.toString(),
                      notes: userInfo.notes.toString(),
                      numberOfFamily: int.parse(
                          userInfo.numberOfFamily.toString()),
                      originalResidence: userInfo.originalResidence.toString(),
                      primery_key: userInfo.primery_key.toString(),
                      residenceStatus: userInfo.residenceStatus.toString(),
                      shelter: userInfo.shelter.toString(),
                      status: userInfo.status.toString(),
                      mobile: int.parse(userInfo.mobile.toString())));
            } catch (error) {
              print("ERROR 2   : ${error}");
            }

            print(userInfo.name1);
          }
        });
      }
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

  Future<void> saveAndRefreshRecoredRecivingAndRecpients(BuildContext context) async {
    // Check for internet connection
    bool isCheck = await Constant.checkInternetConnection();

    int firebaseLength = 0;
    int localLength = 0;
    List<RecoredReciving> recoredRecivingLocal = [];
    Map<dynamic, dynamic> maapFIREBASE = {};
    List<String> documentUnmatchedinFirebase = [];

    print(isCheck);
    if (isCheck) {
      // Use futures to fetch Firebase and local data
      try {
        // Fetch Firebase data
        var firebaseData = await firebaseController
            .getDataStream('/$f/${firebaseController.UserName}')
            .first;
        firebaseLength = firebaseData.length;
        maapFIREBASE.addAll(firebaseData);
        print("Firebase length: $firebaseLength");

        // Fetch local database data
        var localData = await database.personDao
            .getRecordReciving(firebaseController.UserName)
            .first;
        recoredRecivingLocal = localData;
        localLength = localData.length;
        print("Local length: $localLength");

        // Proceed with logic
        if (localLength > firebaseLength) {
          for (RecoredReciving recoredReciving in recoredRecivingLocal) {
            if (!maapFIREBASE.containsKey(recoredReciving.documentId)) {
              documentUnmatchedinFirebase.add(recoredReciving.documentId!);
            }
          }

          // Add unmatched records to Firebase
          for (String key in documentUnmatchedinFirebase) {
            for (RecoredReciving recoredReciving in recoredRecivingLocal) {
              if (recoredReciving.documentId == key) {
                Map<String, dynamic> map = {
                  "title": recoredReciving.title,
                  "number_of_parcels": recoredReciving.numberOfParcel,
                  "type_of_parcels": recoredReciving.typeOfCells,
                  "date": recoredReciving.date,
                  "primery_key": recoredReciving.documentId,
                  "recipients": { },
                };

                // Save record in Firebase
                await firebaseController.addRecord(
                    firebaseController.UserName, key, map, context);

                // Fetch recipients for the record
                var recipients = await database.personDao
                    .getRecoredRecpients(recoredReciving.documentId!)
                    .first;

                Map<String, dynamic> recipientMap = {};

                for (RecoredRecpients recoredRecp in recipients) {
                  Map<String, dynamic> mapRecord = recoredRecp.toJson();
                  // Add to recipient map (keyed by primary key or recipient ID)
                  recipientMap[mapRecord["primery_key"]] = {
                    ...mapRecord,
                    "receiving_status": "لم يتم الاستلام", // Ensure this key exists
                  };
                  await firebaseController.addRecipients(
                      firebaseController.UserName,
                      key,
                      recipientMap,
                      context);
                }


              }
            }
          }
        } else {
          print("ERROR3");
          print("${f}/${firebaseController.UserName}");

          // Sync data from Firebase to local
          for (var key in maapFIREBASE.keys) {
            var event = maapFIREBASE[key];
            String? date = event["date"] ?? "";
            String? title = event["title"] ?? "";
            String? typeOfCells = event["type_of_parcels"] ?? "";
            String numberOfParcel = event["number_of_parcels"] ?? "0";
            String documentId = event["primery_key"] ?? "";

            try {
              // Insert into local database
              database.personDao.insertRecordReciving(
                RecoredReciving(
                  date: date!,
                  title: title!,
                  typeOfCells: typeOfCells ?? "Unknown",
                  numberOfParcel: numberOfParcel.toString(),
                  documentId: documentId,
                  shelter: firebaseController.UserName,
                ),
              );

              // Fetch recipients from Firebase and insert into local database
              var recipientData = await firebaseController
                  .getDataStream('/$f/${firebaseController.UserName}/${documentId}/$h')
                  .first;

              for (var recpEvent in recipientData.values) {
                database.personDao.insertRecoredRecpients(
                  RecoredRecpients(
                    documentId: documentId ?? "",
                    id1: recpEvent["id1"]  ?? 0,
                    id2: recpEvent["id2"] ?? 0,
                    name1: recpEvent["name1"] ?? "",
                    name2: recpEvent["name2"] ?? "",
                    notes: recpEvent["notes"] ?? "",
                    numberOfFamily: recpEvent["number_of_family"] ?? 0,
                    originalResidence: recpEvent["original_residence"] ?? "",
                    primery_key: recpEvent["primery_key"] ?? "",
                    residenceStatus: recpEvent["residence_status"] ?? "",
                    shelter: recpEvent["shelter"] ?? "",
                    status: recpEvent["status"] ?? "",
                    mobile: recpEvent["mobile"] ?? 0,
                    receiving_status: recpEvent["receiving_status"] ?? "",
                  ),
                );
              }
            } catch (e) {
              print("Error processing record: $e");
            }
          }
        }
      } catch (e) {
        print("Error fetching data: $e");
      }
    } else {
      print("No internet connection.");
    }
  }


  Stream<Map<dynamic, dynamic>> getRecordRecivingAsMapStreamFromLocal() {
    final StreamController<Map<dynamic, dynamic>> controller = StreamController<Map<dynamic, dynamic>>();

    controller.onCancel = () {
      controller.close();
    };

    // Listen to the stream of RecoredReciving objects
    database.personDao.getRecordReciving(firebaseController.UserName).listen(
          (event) {
        // Create a map where each entry is keyed by documentId
        Map<dynamic, dynamic> recordMap = {};

        for (RecoredReciving recoredReciving in event) {
          recordMap[recoredReciving.documentId] = {
            "title": recoredReciving.title,
            "number_of_parcels": recoredReciving.numberOfParcel,
            "type_of_parcels": recoredReciving.typeOfCells,
            "date": recoredReciving.date,
            "documentId": recoredReciving.documentId,
          };

          print("RecoredReciving   ${recoredReciving.date}");
        }

        // Emit the map containing all records
        controller.add(recordMap);
      },
      onError: (error) {
        controller.addError(error);
      },

    );

    return controller.stream;
  }

  void deleteRecoredReciving(String primeryKey) async{
    await database.personDao.deleteRecoredReciving(primeryKey);
  }

  Stream<List<Map<String, dynamic>>> getRecoredRecpients(String primeryKey) {
    final StreamController<List<Map<String, dynamic>>> controller = StreamController<List<Map<String, dynamic>>>();

    // Handle cleanup when the controller is canceled
    controller.onCancel = () {
      controller.close();
    };

    // Listen to the database for changes
    database.personDao.getRecoredRecpients(primeryKey).listen(
          (event) {
        // Accumulate each record's data in a list of maps
        List<Map<String, dynamic>> recordList = event.map((recoredRecpients) => {
          'id1': recoredRecpients.id1,
          'id2': recoredRecpients.id2,
          'name1': recoredRecpients.name1,
          'name2': recoredRecpients.name2,
          'notes': recoredRecpients.notes,
          'number_of_family': recoredRecpients.numberOfFamily,
          'original_residence': recoredRecpients.originalResidence,
          'primery_key': recoredRecpients.primery_key,
          'residence_status': recoredRecpients.residenceStatus,
          'shelter': recoredRecpients.shelter,
          'status': recoredRecpients.status,
          'mobile': recoredRecpients.mobile,
          'receiving_status': recoredRecpients.receiving_status,
          'documentId': recoredRecpients.documentId,
        }).toList();

        // Emit the list of maps to the stream
        controller.add(recordList);
      },
      onError: (error) {
        controller.addError(error);
      },
      onDone: () {
        if (!controller.isClosed) {
          controller.close();
        }
      },
    );

    return controller.stream;
  }

  void getLatFromFireBase()async{

    if(firebaseController.UserName != "admin"){
      int? latFire = await firebaseController.getLat(firebaseController.UserName) ?? 0;
      int? localLate = await Constant.getLateNum(firebaseController.UserName) ?? 0;

      print("fire1  ${latFire}");
      print("local1  ${localLate}");

      if(localLate > latFire){
        firebaseController.saveLat(firebaseController.UserName, localLate, Get.context!);

      }
      else
        if( localLate < latFire ){
          Constant.saveLat(latFire, firebaseController.UserName);
        }
        else{

        }
      int? localLate2 = await Constant.getLateNum(firebaseController.UserName);

      print("fire2  ${latFire}");
      print("local2  ${localLate2}");
    }

  }

  void changeRecoredRec(bool isChange){
    print("change ${isChange}");
    changesInRecoredRecipients= isChange;
    update();

  }

}