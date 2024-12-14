import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled2/modles/users_info.dart';
import 'package:untitled2/modles/users_info_for_local.dart';
import 'package:untitled2/shared/constant.dart';

import '../data_base/appdatabase.dart';
import 'firebase_controller.dart';
class LoginController extends GetxController{

  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final FirebaseController firebaseController = Get.put(FirebaseController());
  bool isLogin=false;

@override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();

  }

  void setIsLogin(bool isLogined){
  isLogin=isLogined;
  update();
  }



}