import 'package:get/get.dart';
class AddFamilyController extends GetxController{

  String initialRadioValueStatus = "متزوج/ة";
String residence_status = "نازح";
  bool saveEdit = false;
  bool dialogAddFamily=false;


  void changeValueRadioGroup(String value){
    initialRadioValueStatus = value;
update();
  }

    void changeValueRadioGroupForResidence_status(String value){
      residence_status = value;
    update();
  }

  // حفظ التغييرات
  void saveEditMode(){
    saveEdit = true;
    update();

  }

  void changeDialogAddFamily(bool change){
    dialogAddFamily=change;
    update();
  }
}