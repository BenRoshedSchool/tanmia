import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
class DeliversController extends GetxController{

bool isRecived = false;

Future<void> updateRecived(String userName) async {

  if(isRecived == false){
     isRecived = true;
    update();
  }else{
    isRecived=false;

    update();
  }

}




}