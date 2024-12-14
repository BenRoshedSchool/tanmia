import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled2/routes/app_routes.dart';
import '../controller/firebase_controller.dart';
import '../controller/listfamily_controller.dart';
import '../layout/listfamily_screen.dart';
import '../shared/constant.dart';

class Almanadeeb_Screen extends StatelessWidget {
  Almanadeeb_Screen({super.key});
  final ListFamilyController listFamilyController = Get.put(ListFamilyController());
  final FirebaseController firebaseController = Get.put(FirebaseController());

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;
    final alshoab = arguments["alshoab"] ?? 'Guest';

    return WillPopScope(
      onWillPop: ()async{
        Get.toNamed(Routes.alshoabScreen);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlueAccent,

          title: Text("المناديب"),
          centerTitle: true,
        ),
        body: Container(
          color: Colors.white10,
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: Constant.getUsersByAlshoab(alshoab),
            builder: (context, snapshot) {
              print("SNAPSHOT ${snapshot}");
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text("No users found."));
              } else {
                final users = snapshot.data!;
                return ListView.separated(
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Get.to(ListFamily_Screen(
                          username: users[index]["value"], // Access the "value" for the name
                          recivefromDeliverablesrRecored: "",
                          shoab:alshoab
                        ));
                      },
                      child: Container(
                        height: 50,
                        color: Colors.grey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          child: Row(
                            children: [

                              Expanded(
                                child: Center(
                                  child: Text(users[index]["value"] ?? ""), // Access the "value" for the name
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 3),
                  itemCount: users.length,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
