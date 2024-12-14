import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:untitled2/layout/users_home_screen.dart';
import 'package:untitled2/routes/app_routes.dart';

import '../controller/firebase_controller.dart';
import '../shared/constant.dart';
import 'login_screen.dart';

class Splash_Screen extends StatefulWidget {
  const Splash_Screen({super.key});

  @override
  State<Splash_Screen> createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {
  FirebaseController firebaseController = Get.put(FirebaseController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(const Duration(seconds: 2),() async {
String? user = await Constant.getUser();
      print("String ${user}");
      if(user == null  ||  user!.isEmpty){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> Login_Screen()));

      }else
        if(user == "admin"){

            Get.toNamed(Routes.adminHomeScreen);
          }else{
          Get.toNamed("/usershome_screen");

        }
        }

    );
  }
  @override
  Widget build(BuildContext context) {

    return  Container(
      color: Colors.greenAccent,
      child: Center(
          child: Image.asset("assets/images/logo.png" , width: MediaQuery.of(context).size.width * 0.5, height: MediaQuery.of(context).size.height * 0.3,),
          ),
    );
  }
}

