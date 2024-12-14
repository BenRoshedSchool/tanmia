import 'dart:async';
import 'dart:isolate';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/controller/firebase_controller.dart';
import 'package:untitled2/layout/listfamily_screen.dart';

import '../modles/users_info.dart'; // Corrected path

class ListFamilyController extends GetxController {

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  final StreamController<List<UserInfo>> itemsController = StreamController<List<UserInfo>>();
  StreamController<double> progressController = StreamController<double>();

  List<UserInfo>? items;
  int t=0;
  bool isLoadingFile = false;
  bool dialogAddChildren=false;
  @override
  void onInit() {
    super.onInit();
  }

  void fetchData(String user) async {


    // Listen for changes on the Firebasede
    _databaseReference.child(user).onValue.listen((event) {
      final snapshot = event.snapshot;
      Map<dynamic, dynamic> dataMap = event.snapshot.value as Map<dynamic, dynamic>;
      t = dataMap.length;
      update();
      if (snapshot.value != null) {
        // Send the raw data to the isolate for processing

        final data = snapshot.value;


        _processDataInIsolate(data);
      } else {

        itemsController.add([]); // No data found
      }
    });
  }

  void _processDataInIsolate(dynamic data) async {


    // Create a new isolate to process data
    final receivePort = ReceivePort();

    await Isolate.spawn(_dataProcessor, receivePort.sendPort);

    // Send data to the isolate
    final sendPort = await receivePort.first as SendPort;
    final responsePort = ReceivePort();

    // Send the data and a response port to the isolate
    sendPort.send([data, responsePort.sendPort]);

    // Listen for the response
    responsePort.listen((items) {

      itemsController.add(items); // Add items to the stream
    });


  }

  // Function that runs in a separate isolate
  static void _dataProcessor(SendPort sendPort) {
    final port = ReceivePort();
    sendPort.send(port.sendPort);

    port.listen((message) {
      // Check if message is null or doesn't have the expected structure
      if (message == null || message.isEmpty || message[0] == null) {
        print("Error: Received message is null or empty.");
        return; // Exit the function if the message is invalid
      }

      dynamic data = message[0]; // Keep as dynamic initially
      final responsePort = message[1] as SendPort;

      List<UserInfo> items = [];

      // Check if the data is a Map, and convert it to a List
      if (data is Map) {
        data = data.values.toList(); // Convert map to list of its values
      }

      if (data is List) {
        print(data.length);
        for (var value in data) {
          // Check if value is null before accessing its fields
          if (value == null) {
            print("Error: Value is null");
            continue; // Skip this iteration if value is null
          }

          // Safely retrieve and parse values, handling null cases
          int id1 = _parseInt(value['id1']);
          int id2 = _parseInt(value['id2']);
          int mobileNo = _parseInt(value['mobile']);
          String name1 = (value['name1'] != null) ? value['name1'].toString() : '';
          String primaryKey = (value['primery_key'] != null) ? value['primery_key'].toString() : '';
          String name2 = (value['name2'] != null) ? value['name2'].toString() : '';
          String notes = (value['notes'] != null) ? value['notes'].toString() : 'null';
          int numberOfFamily = _parseInt(value['number_of_family']);
          String originalResidence = (value['original_residence'] != null) ? value['original_residence'].toString() : '';
          String residenceStatus = (value['residence_status'] != null) ? value['residence_status'].toString().trim() : '';
          String shelter = (value['shelter'] != null) ? value['shelter'].toString() : '';
          String status = (value['status'] != null) ? value['status'].toString() : '';

          items.add(UserInfo(
            id1: id1,
            id2: id2,
            name1: name1,
            name2: name2,
            notes: notes,
            numberOfFamily: numberOfFamily,
            originalResidence: originalResidence,
            primery_key: primaryKey,
            residenceStatus: residenceStatus,
            shelter: shelter,
            status: status,
            mobile: mobileNo,
          ));
        }
      }

      // Send the processed items back to the main isolate
      responsePort.send(items);
    });
  }

// Helper function to safely parse integers
  static int _parseInt(dynamic value) {
    if (value is int) {
      return value;
    } else if (value is String) {
      return int.tryParse(value) ?? 0; // If it's a string, try parsing to int, return 0 if parsing fails
    } else {
      return 0; // Default to 0 if value is neither int nor string
    }
  }

  // Dispose of the stream controller when done
  @override
  void onClose() {
    itemsController.close();
    super.onClose();
  }

void getTotalFamily(String user){

    _databaseReference.child(user).onValue.listen((event) {
      t= event.snapshot.children.length;
      update();
     print("LENGTH   $t");

    });

}

void onStatrtExportToExcel(){

    if(isLoadingFile == true){
      isLoadingFile = false;
      update();
    }else{
      isLoadingFile = true;
      update();
    }
print(isLoadingFile);
}

void changeDialogAddChildren(bool change){
    dialogAddChildren=change;
    update();
}
}
