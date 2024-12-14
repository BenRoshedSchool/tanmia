
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled2/shared/constant.dart';
import '../controller/firebase_controller.dart';
import '../controller/listfamily_controller.dart';
import '../controller/login_controller.dart';
import '../routes/app_routes.dart';
import '../widgets/elevation_button.dart';
import '../widgets/text_filed.dart';
import 'admin_home_screen.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';


class Login_Screen extends StatelessWidget {
   Login_Screen({super.key});
  // final DatabaseReference database = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    LoginController controller = Get.put(LoginController());

    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          // Call SystemNavigator.pop() to exit the app
          SystemNavigator.pop();
          return false; // Return false to prevent the default back navigation behavior
        },
        child: Container(
          color: Colors.greenAccent,
          child: Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 15, vertical: 15),
            child: Center(
              child: SingleChildScrollView(
                child: GetBuilder<LoginController>(
                  builder: (controller){

                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          children: [

                            Image.asset(
                              "assets/images/logo.png",
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height * 0.3,
                            ),

                            SizedBox(height: 30),
                            Text_Filed(
                              hintText: "اسم المستخدم",
                              widthTextFiled: MediaQuery.of(context).size.width,
                              textEditingController: controller.userController,

                            ),
                            SizedBox(height: 25),
                            Text_Filed(
                              hintText: "كلمة المرور",
                              widthTextFiled: MediaQuery.of(context).size.width,
                              textEditingController: controller.passController,
                              textInputType: TextInputType.number,
                            ),
                            SizedBox(height: 25),
                            Elevation_Button(
                              function: () async {
                                controller.setIsLogin(true);
                                bool internet = await Constant.checkInternetConnection();

                                if (internet) {
                                  try {
                                    // Authenticate user
                                    String check = await controller.firebaseController.loginUsers(
                                      controller.userController.value.text,
                                      int.parse(controller.passController.value.text),
                                    );

                                    print("Check result: $check");

                                    // Handle admin case
                                    if (check == "admin") {
                                      Constant.saveUser("admin");
                                      Get.toNamed("/admin_home");
                                      return; // Exit early for admin
                                    }

                                    // Loop through "shoab" and validate users
                                    for (String sho in Constant.shoab) {
                                      print("Processing shoab: $sho");

                                      List<Map<String, dynamic>> manadeeb = await Constant.getUsersByAlshoab(sho);


                                      if (manadeeb.isEmpty) {
                                        print("No users found for shoab: $sho");
                                        continue; // Skip if no users in shoab
                                      }

                                      for (Map<String, dynamic> map in manadeeb) {
                                        if (check == map["value"]) {
                                          print("User authenticated: ${map["value"]}");
                                          Constant.saveUser(map["value"]);
                                          Get.toNamed("/usershome_screen");
                                          return; // Exit early when user is authenticated
                                        }
                                      }
                                    }

                                    // Handle "error" or invalid user case
                                    if (check == "error") {
                                      print("Invalid credentials provided.");
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          backgroundColor: Colors.redAccent,
                                          content: Text("يرجى التأكد من صحة البيانات"),
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    print("Error during login: $e");
                                  } finally {
                                    controller.setIsLogin(false); // Reset login status on failure or success
                                  }
                                } else {
                                  controller.setIsLogin(false);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Colors.redAccent,
                                      content: Text("يرجى التأكد من اتصالك بالشبكة"),
                                    ),
                                  );
                                }
                              },
                              backColor: Colors.blueAccent,
                              inputText: "تسجيل الدخول",
                              widthButtton: MediaQuery.of(context).size.width,
                            )
                          ],
                        ),

                        controller.isLogin ?  CircularProgressIndicator():SizedBox()
                      ],
                    );
                  },

                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
