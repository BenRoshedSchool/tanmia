import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:untitled2/controller/firebase_controller.dart';
import 'package:untitled2/shared/constant.dart';
class PercentageController extends GetxController{
  FirebaseController firebaseController = FirebaseController();
  List<Map<String , dynamic>> mapManadeebLength=[];
  int totalFamily=0;
  int zuhairLength=0;
  int totalFamilyABUBaker=0;
  int totalFamilyTaiba=0;
  int waredToZawaida=0;
  double percentPerFamily=0.0;
  int totalAlTorod=0;


  TextEditingController waredController = TextEditingController();
  TextEditingController managerPercent = TextEditingController();
  TextEditingController bassatcontrooler = TextEditingController();
  TextEditingController ayashlengthControiller = TextEditingController();
  TextEditingController zuhairNassarController = TextEditingController();
  TextEditingController ebrahhemZaqoutController = TextEditingController();
  TextEditingController ebrahhemZaqoutController2 = TextEditingController();
  TextEditingController muhammedAlhamidyController = TextEditingController();
  TextEditingController muhammedNamrotyController = TextEditingController();
  TextEditingController khalilController = TextEditingController();
  TextEditingController muhamedQashlanController = TextEditingController();
  TextEditingController assadAidController = TextEditingController();
  TextEditingController ahmedSultanController = TextEditingController();
  TextEditingController ahmedSuirehController = TextEditingController();
  TextEditingController mezydController = TextEditingController();
  TextEditingController abedNatatController = TextEditingController();
  TextEditingController amroSalemController = TextEditingController();
  TextEditingController abuRashedController = TextEditingController();
  TextEditingController muhammedAltabanController = TextEditingController();
  TextEditingController salmanAltabanController = TextEditingController();
  TextEditingController shadyController = TextEditingController();
  TextEditingController aliController = TextEditingController();
  TextEditingController mazenController = TextEditingController();
  TextEditingController muhammedQuranController = TextEditingController();
  TextEditingController muhannadSammahaController = TextEditingController();



 @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
   await getNumberOfFamily();

    print("mapManadeebLength  ${mapManadeebLength}");


    putTheFamilyNumberInAlmanadeb();
  }


  Future<void> getNumberOfFamily() async {

    for(String sho in Constant.shoab){

     List<Map<String , dynamic>> manadeeb = await Constant.getUsersByAlshoab(sho);

     for(Map<String , dynamic> user in manadeeb){


     int len =  await getLength(user["value"]);
       totalFamily+=len;
       mapManadeebLength.add({
         "name": user["value"] ,
         "length": len.toString() ,
         "sho" : sho ,
         "keyName": user["key"]
       });
       update();
     }
    }

  }

  Future<int> getLength(String user) async {
    var data = await firebaseController.getUsersAsFuture(user);
    return data.length;
  }

  void putTheFamilyNumberInAlmanadeb(){
    for(Map<String  , dynamic> data in mapManadeebLength){
      if(data["sho"] == "حي أبو بكر و الرحمة"){

        print ( "data ${data["sho"]}  ${data["keyName"]}");
        switch(data["keyName"]){
          case "name1":
           zuhairLength+=int.parse(data["length"]);
           totalFamilyABUBaker+=int.parse(data["length"]);
            update();
            break;
          case "name2":
            zuhairLength+=int.parse(data["length"]);
            totalFamilyABUBaker+=int.parse(data["length"]);

            update();

            break;
          case "name3":
            zuhairLength+=int.parse(data["length"]);
            totalFamilyABUBaker+=int.parse(data["length"]);

            update();

            break;
          case "name4":
            // zuhairNassarController.text = data["length"];
            zuhairLength+=int.parse(data["length"]);
            totalFamilyABUBaker+=int.parse(data["length"]);

            update();

            break;
          case "name5":
            ebrahhemZaqoutController.text = data["length"];
            totalFamilyABUBaker+=int.parse(data["length"]);

            update();

            break;
          case "name6":
            ebrahhemZaqoutController2.text = data["length"];
            totalFamilyABUBaker+=int.parse(data["length"]);

            update();

            break;
          case "name7":
            zuhairLength+=int.parse(data["length"]);
            totalFamilyABUBaker+=int.parse(data["length"]);


            update();
            break;
          case "name8":
            zuhairLength+=int.parse(data["length"]);
            totalFamilyABUBaker+=int.parse(data["length"]);

            update();

            break;
          case "name9":
            muhammedAlhamidyController.text = data["length"];
            totalFamilyABUBaker+=int.parse(data["length"]);

            update();

            break;
          case "name10":
            zuhairLength+=int.parse(data["length"]);
            totalFamilyABUBaker+=int.parse(data["length"]);

            update();

            break;

        }

      }
      else
        if(data["sho"] == "حي أبو عبيدة"){
          switch(data["keyName"]){
            case "name1":
              muhammedNamrotyController.text=data["length"].toString();
              update();
              break;
          }
        }
        else
          if(data["sho"] == "حي الأنصار الغربية"){
            switch(data["keyName"]){
              case "name1":
                muhamedQashlanController.text=data["length"].toString();
                update();
                break;
              case "name2":
                assadAidController.text=data["length"].toString();
                update();
                break;
            }

          }
          else
          if(data["sho"] == "حي الأنصار الشرقية"){

            print("ansar  ${data["length"]}");
            print("ansar  ${data["length"]}");
            switch(data["keyName"]){
              case "name1":
                ahmedSultanController.text=data["length"].toString();
                update();
                break;
              case "name2":
                mezydController.text=data["length"].toString();
                update();
                break;
            }
          }
          else
          if(data["sho"] == "حي الفاروق"){
            switch(data["keyName"]){
              case "name1":
                khalilController.text=data["length"].toString();
                update();
                break;
            }
          }
           else
          if(data["sho"] == "حي السوارحة"){
            switch(data["keyName"]){
              case "name1":
                bassatcontrooler.text=data["length"].toString();
                update();
                break;
            }
          }
          else
          if(data["sho"] == "حي طيبة"){
            switch(data["keyName"]) {
              case "name1":
                totalFamilyTaiba += int.parse(data["length"]);
                update();
                break;
              case "name2":
                totalFamilyTaiba += int.parse(data["length"]);
                update();

                break;
              case "name3":
                totalFamilyTaiba += int.parse(data["length"]);
                update();

                break;
              case "name4":
                totalFamilyTaiba += int.parse(data["length"]);
                update();

                break;
              case "name5":
                totalFamilyTaiba += int.parse(data["length"]);
                update();

                break;
              case "name6":
                totalFamilyTaiba += int.parse(data["length"]);
                update();

                break;

            }
          }
          else
            {}



    }

    zuhairNassarController.text = zuhairLength.toString();
    ayashlengthControiller.text = totalFamilyTaiba.toString();

    update();

    print("zuhair  ${zuhairLength}");

  }

  void editTotalFamilyAfterChangeByTextField() {
    totalFamily =
        safeParseInt(bassatcontrooler.text) +
            safeParseInt(muhamedQashlanController.text) +
            safeParseInt(assadAidController.text) +
            safeParseInt(ahmedSultanController.text) +
            safeParseInt(mezydController.text) +
            safeParseInt(abedNatatController.text) +
            safeParseInt(abuRashedController.text) +
            safeParseInt(amroSalemController.text) +
            safeParseInt(muhammedAltabanController.text) +
            safeParseInt(zuhairNassarController.text) +
            safeParseInt(ebrahhemZaqoutController.text) +
            safeParseInt(ebrahhemZaqoutController2.text) +
            safeParseInt(salmanAltabanController.text) +
            safeParseInt(shadyController.text) +
            safeParseInt(muhammedAlhamidyController.text) +
            safeParseInt(ayashlengthControiller.text) +
            safeParseInt(muhammedNamrotyController.text);

    update();
  }

  /// Helper function to safely parse integers.
  int safeParseInt(String? value) {
    return int.tryParse(value ?? '') ?? 0; // Returns 0 if parsing fails
  }




  void onBackPressedSetTotal(){
    totalFamily=0;
    totalFamilyTaiba=0;
    totalFamilyABUBaker=0;
    zuhairLength=0;
    ayashlengthControiller.clear();
    shadyController.clear();
    zuhairNassarController.clear();
    abedNatatController.clear();
    abuRashedController.clear();
    salmanAltabanController.clear();
    ebrahhemZaqoutController.clear();
    amroSalemController.clear();
    update();
  }


  void calculateMangePercent(){
   managerPercent.text = (safeParseInt(waredController.text.toString()) * 0.1).round().toString();
   update();
  }


  void calculateWaredToAlzawaida(){
   waredToZawaida = safeParseInt(waredController.text.toString()) - safeParseInt(managerPercent.text.toString());
   update();
 }

  void calculateWaredToAlzawaidaOnChangeMangerPercent(){
    waredToZawaida = safeParseInt(waredController.text.toString()) - safeParseInt(managerPercent.text.toString());
    update();
  }


  void calculatePercentPerFamily(){
   percentPerFamily = waredToZawaida / totalFamily;
  }

  void sumAlTorod(){

   totalAlTorod =
       ( (((percentPerFamily * safeParseInt(mezydController.text.toString())))) +
   (((percentPerFamily * safeParseInt(ahmedSultanController.text.toString())))) +
   (((percentPerFamily * safeParseInt(ayashlengthControiller.text.toString())))) +
   (((percentPerFamily * safeParseInt(zuhairNassarController.text.toString())))) +
   (((percentPerFamily * safeParseInt(muhamedQashlanController.text.toString())))) +
   (((percentPerFamily * safeParseInt(muhammedNamrotyController.text.toString())))) +
   (((percentPerFamily * safeParseInt(assadAidController.text.toString())))) +
   (((percentPerFamily * safeParseInt(khalilController.text.toString())))) +
   (((percentPerFamily * safeParseInt(bassatcontrooler.text.toString())))) +
   (((percentPerFamily * safeParseInt(ebrahhemZaqoutController.text.toString())))) +
   (((percentPerFamily * safeParseInt(ebrahhemZaqoutController2.text.toString())))) +
   (((percentPerFamily * safeParseInt(muhammedAlhamidyController.text.toString()))))).round() ;
   update();
  }

}