import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controller/firebase_controller.dart';

class AdminNotification extends StatefulWidget {
  const AdminNotification({super.key});

  @override
  State<AdminNotification> createState() => _AdminNotificationState();
}

class _AdminNotificationState extends State<AdminNotification> {
  // Sample data
  final FirebaseController firebaseController = Get.find<FirebaseController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,

        title: const Text("الإشعارات"),
        centerTitle: true,
      ),
        body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: firebaseController.getAdminNotification(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.none) {
              return const Center(
                child: Text("لا يوجد اتصال بالانترنت"),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            var items = snapshot.data;
            if (items == null || items.isEmpty) {
              return const Center(child: Text('No data found.'));
            }

            // Reverse the list
            final reversedItems = items.reversed.toList();

            return ListView.builder(
              itemCount: reversedItems.length,
              itemBuilder: (context, index) {
                final notificationMap = reversedItems[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: const Icon(Icons.notifications),
                    title: Text(
                      "تم استبدال ${notificationMap["oldName"]} ب ${notificationMap["newName"]} \n من قبل ${notificationMap["shelter"]}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "وقت و تاريخ الاستبدال: ${notificationMap["date_time"]}",
                    ),
                  ),
                );
              },
            );
          },
        )
    );
  }
}
