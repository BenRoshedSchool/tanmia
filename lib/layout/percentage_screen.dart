import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:untitled2/controller/percentage-controller.dart';
import 'package:untitled2/layout/admin_home_screen.dart';
import 'package:untitled2/routes/app_routes.dart';
import '../controller/firebase_controller.dart';
import '../shared/constant.dart';

class PercentageScreen extends StatefulWidget {
  const PercentageScreen({super.key});

  @override
  State<PercentageScreen> createState() => _PercentageScreen();
}

class _PercentageScreen extends State<PercentageScreen> {
  FirebaseController firebaseController = Get.find<FirebaseController>();
  PercentageController percentageController = Get.find<PercentageController>();
  TextEditingController titleController = TextEditingController();

  Map<String, int?> userLengths = {};
  int totalFamily=0;
  bool managerPercentChange=false;
  final GlobalKey _globalKey = GlobalKey();
  List<String> manadeb=[];

  // Detect the orientation using MediaQuery

  @override
  void initState() {
    super.initState();

    // getShelter().then((value) {
    //   _initializeData(); // Call an asynchronous method without awaiting
    //   _initializeLengths(); // Any synchronous initialization
    // });


  }

  // Future<void> _initializeData() async {
  //   final List<Map<String, dynamic>> users = await firebaseController.getUsersToAdminAccountFuture("usersInfo");
  //   for (Map<String, dynamic> user in users) {
  //     getFamilyNumber(user["user_name"]);
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    //
    // totalFamily =  _safeParse(zuhairNassarController.text)+
    //     _safeParse(abedNatatController.text) +
    //     _safeParse(abuRashedController.text) +
    //     _safeParse(shadyController.text) +
    //     _safeParse(amroSalemController.text) +
    //     _safeParse(ahmedSultanController.text) +
    //     _safeParse(assadAidController.text) +
    //     _safeParse(ebrahhemZaqoutController.text) +
    //     _safeParse(salmanAltabanController.text) +
    //     _safeParse(bassatcontrooler.text) +
    //     _safeParse(khalilController.text) +
    //     _safeParse(muhammedNamrotyController.text) +
    //     _safeParse(muhammedAlhamidyController.text) +
    //     _safeParse(muhamedQashlanController.text) +
    //     _safeParse(mazenController.text) +
    //     _safeParse(mezydController.text) +
    //     _safeParse(ebrahhemZaqoutController2.text) +
    //     _safeParse(muhannadSammahaController.text) +
    //     _safeParse(muhammedQuranController.text) +
    //     _safeParse(ahmedSuirehController.text) +
    //     _safeParse(aliController.text)+
    //     _safeParse(ayashlengthControiller.text)+
    //     _safeParse(muhammedAltabanController.text);

    return  WillPopScope(
      onWillPop: () async{

        percentageController.onBackPressedSetTotal();
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);

        Get.offAllNamed(Routes.adminHomeScreen);

        // Navigator.push(context, MaterialPageRoute(builder: (context)=> Admin_Home_Screen()));
        return true;
      },
      child: Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
              child:  Column(
                children: [
                  RepaintBoundary(
                    key: _globalKey,
                    child: Container(
                      height: kIsWeb ? MediaQuery.of(context).size.height : 900,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black,
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              children: [

                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Container(
                                      color: Colors.blue,
                                      child: Center(child: Text("المنطقة" , style: TextStyle(fontSize: 20),)),
                                    ),
                                  ),
                                ) ,
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Container(
                                      color: Colors.blue,
                                      child: Center(child: Text("المناديب" , style: TextStyle(fontSize: 20),)),
                                    ),
                                  ),
                                ) ,
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Container(
                                      color: Colors.blue,
                                      child: Center(child: Text("عدد العائلات" , style: TextStyle(fontSize: 20),)),
                                    ),
                                  ),
                                ) ,

                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Container(
                                      color: Colors.blue,
                                      child: Center(child: Text("النسبة" , style: TextStyle(fontSize: 20),)),
                                    ),
                                  ),
                                ) ,
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Container(
                                      color: Colors.blue,
                                      child: Center(child: Text("عدد الطرود" , style: TextStyle(fontSize: 20),)),
                                    ),
                                  ),
                                ) ,

                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Container(
                                      color: Colors.redAccent,
                                      child: Center(child: Text("إجمالي الوارد" , style: TextStyle(fontSize: 20),)),
                                    ),
                                  ),
                                ) ,
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Container(
                                      color: Colors.white,
                                      child: Center(
                                          child: TextField(
                                            onChanged: (v){
                                              percentageController.calculateMangePercent();
                                              percentageController.calculateWaredToAlzawaida();
                                              percentageController.calculatePercentPerFamily();
                                              percentageController.sumAlTorod();
                                            },
                                            controller: percentageController.waredController,
                                            textAlign: TextAlign.center,
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(),
                                          )),
                                    ),
                                  ),
                                ) ,

                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Container(
                                      color: Colors.redAccent,
                                      child: Center(child: Text("النسبة الإدارية" , style: TextStyle(fontSize: 20),)),
                                    ),
                                  ),
                                ) ,
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Container(
                                      color: Colors.white,
                                      child: Center(
                                          child: TextField(
                                            onChanged: (v){
                                              percentageController.calculateWaredToAlzawaidaOnChangeMangerPercent();
                                              percentageController.calculatePercentPerFamily();

                                            },
                                            controller: percentageController.managerPercent,
                                            textAlign: TextAlign.center,
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(),
                                          )),
                                    ),
                                  ),
                                ) ,

                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Container(
                                      color: Colors.redAccent,
                                      child: Center(child: Text("وارد للزوايدة" , style: TextStyle(fontSize: 20),)),
                                    ),
                                  ),
                                ) ,
                                GetBuilder<PercentageController>(
                                  builder:(controller)=> Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Container(
                                        color: Colors.white,
                                        child: Center(child: Text(controller.waredToZawaida.toString(), style: TextStyle(fontSize: 20),)),
                                      ),
                                    ),
                                  ),
                                ) ,

                              ],
                            ),
                          ),

                          //السوارحة
              GetBuilder<PercentageController>(
                builder:(controller)=> Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Container(
                            color: Colors.lightGreenAccent,
                            child: Center(child: Text("السوارحة" , style: TextStyle(fontSize: 20),)),
                          ),
                        ),
                      ) ,

                      StreamBuilder<String>(
                        stream: firebaseController.getUsersToAdminAccountStream3("man", "saoar", "name1"),
                        builder: (context, snapshot) {
                          print("SNAPSHOT ${snapshot}");
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Container(
                                  color: Colors.deepOrangeAccent,
                                  child:
                                  Center(child: CircularProgressIndicator()),
                                ),
                              ),
                            ) ;

                          } else if (snapshot.hasError) {
                            return Center(child: Text("Error: ${snapshot.error}"));
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(child: Text("No users found."));
                          } else {
                            final users = snapshot.data!;
                            return  Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Container(
                                  color: Colors.deepOrangeAccent,
                                  child: Center(child: Text(users, style: TextStyle(fontSize: 20),)),
                                ),
                              ),
                            ) ;


                        }
                        },
                      ),



                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Container(
                            color: Colors.white,
                            child: Center(
                                child: TextField(
                                  onChanged:(v){
                                    controller.editTotalFamilyAfterChangeByTextField();
                                  },
                                  controller: controller.bassatcontrooler,
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(),
                                )),
                          ),
                        ),
                      ) ,
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Container(
                            color: Colors.white,
                            child: Center(
                                child: TextField(
                                  onChanged: (v){
                                    controller.editTotalFamilyAfterChangeByTextField();

                                  },

                                  controller: controller.bassatcontrooler,
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(),
                                )),
                          ),
                        ),
                      ) ,
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Container(
                            color: Colors.white,
                            child: Center(child: Text(
                              "${(((controller.percentPerFamily * controller.safeParseInt(controller.bassatcontrooler.text.toString()))/controller.waredToZawaida)*100).toStringAsFixed(2)}"
                              , style: TextStyle(fontSize: 20),)),
                          ),
                        ),
                      ) ,
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Container(
                            color: Colors.white,
                            child: Center(child: Text(
                              "${(controller.percentPerFamily * controller.safeParseInt(controller.bassatcontrooler.text.toString())).round()}"
                              , style: TextStyle(fontSize: 20),)),
                          ),
                        ),
                      ) ,

                    ],
                  ),
                ),
              ),

                          //طيبة
                          GetBuilder<PercentageController>(
                            builder:(controller)=> Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Container(
                                        color: Colors.lightGreenAccent,
                                        child: Center(child: Text("طيبة" , style: TextStyle(fontSize: 20),)),
                                      ),
                                    ),
                                  ) ,


                                  StreamBuilder<String>(
                                    stream: firebaseController.getUsersToAdminAccountStream3("man", "taib", "name1"),
                                    builder: (context, snapshot) {
                                      print("SNAPSHOT ${snapshot}");
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                              color: Colors.deepOrangeAccent,
                                              child:
                                              Center(child: CircularProgressIndicator()),
                                            ),
                                          ),
                                        ) ;

                                      } else if (snapshot.hasError) {
                                        return Center(child: Text("Error: ${snapshot.error}"));
                                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                        return Center(child: Text("No users found."));
                                      } else {
                                        final users = snapshot.data!;
                                        return  Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                              color: Colors.deepOrangeAccent,
                                              child: Center(child: Text(users, style: TextStyle(fontSize: 20),)),
                                            ),
                                          ),
                                        ) ;


                                      }
                                    },
                                  ),

                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Container(
                                        color: Colors.white,
                                        child: Center(
                                            child: TextField(
                                              onChanged: (v){
                                                controller.editTotalFamilyAfterChangeByTextField();

                                              },
                                              controller: controller.ayashlengthControiller,
                                              textAlign: TextAlign.center,
                                              keyboardType: TextInputType.number,
                                              style: TextStyle(),
                                            )),
                                      ),
                                    ),
                                  ) ,
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Container(
                                        color: Colors.white,
                                        child: Center(
                                            child: TextField(
                                              controller: controller.ayashlengthControiller,
                                              onChanged: (v){
                                                controller.editTotalFamilyAfterChangeByTextField();

                                              },
                                              textAlign: TextAlign.center,
                                              keyboardType: TextInputType.number,
                                              style: TextStyle(),
                                            )),
                                      ),
                                    ),
                                  ) ,

                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Container(
                                        color: Colors.white,
                                        child: Center(child: Text(
                                          "${(((controller.percentPerFamily * controller.totalFamilyTaiba)/controller.waredToZawaida)*100).toStringAsFixed(2)}"
                                          , style: TextStyle(fontSize: 20),)),
                                      ),
                                    ),
                                  ) ,
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Container(
                                        color: Colors.white,
                                        child: Center(child: Text(
                                          "${(controller.percentPerFamily * controller.safeParseInt(controller.ayashlengthControiller .text.toString())).round()}"
                                          , style: TextStyle(fontSize: 20),)),
                                      ),
                                    ),
                                  ) ,

                                ],
                              ),
                            ),
                          ),

                          // أبو بكر
                          GetBuilder<PercentageController>(
                            builder:(controller) =>Expanded(
                              flex: 4,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Container(
                                        color: Colors.lightGreenAccent,
                                        child: Center(child: Text("أبو بكر" , style: TextStyle(fontSize: 20),)),
                                      ),
                                    ),
                                  ) ,

                                  Expanded(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                              color: Colors.white,
                                              child: Center(child: Text("أبو بكر" , style: TextStyle(fontSize: 20),)),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                              color: Colors.white,
                                              child: Center(child: Text(" الرواد" , style: TextStyle(fontSize: 20),)),
                                            ),
                                          ),
                                        ),

                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                              color: Colors.white,
                                              child: Center(child: Text("الرحمة" , style: TextStyle(fontSize: 20),)),
                                            ),
                                          ),
                                        ),

                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                              color: Colors.white,
                                              child: Center(child: Text("فقها" , style: TextStyle(fontSize: 20),)),
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ) ,


                                  Expanded(
                                    child: Column(
                                      children: [

                                        StreamBuilder<String>(
                                          stream: firebaseController.getUsersToAdminAccountStream3("man", "baker", "name4"),
                                          builder: (context, snapshot) {
                                            print("SNAPSHOT ${snapshot}");
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(1.0),
                                                  child: Container(
                                                    color: Colors.deepOrangeAccent,
                                                    child:
                                                    Center(child: CircularProgressIndicator()),
                                                  ),
                                                ),
                                              ) ;

                                            } else if (snapshot.hasError) {
                                              return Center(child: Text("Error: ${snapshot.error}"));
                                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                              return Center(child: Text("No users found."));
                                            } else {
                                              final users = snapshot.data!;
                                              return  Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(1.0),
                                                  child: Container(
                                                    color: Colors.deepOrangeAccent,
                                                    child: Center(child: Text(users, style: TextStyle(fontSize: 20),)),
                                                  ),
                                                ),
                                              ) ;


                                            }
                                          },
                                        ),
                                        StreamBuilder<String>(
                                          stream: firebaseController.getUsersToAdminAccountStream3("man", "baker", "name6"),
                                          builder: (context, snapshot) {
                                            print("SNAPSHOT ${snapshot}");
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(1.0),
                                                  child: Container(
                                                    color: Colors.deepOrangeAccent,
                                                    child:
                                                    Center(child: CircularProgressIndicator()),
                                                  ),
                                                ),
                                              ) ;

                                            } else if (snapshot.hasError) {
                                              return Center(child: Text("Error: ${snapshot.error}"));
                                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                              return Center(child: Text("No users found."));
                                            } else {
                                              final users = snapshot.data!;
                                              return  Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(1.0),
                                                  child: Container(
                                                    color: Colors.deepOrangeAccent,
                                                    child: Center(child: Text(users, style: TextStyle(fontSize: 20),)),
                                                  ),
                                                ),
                                              ) ;


                                            }
                                          },
                                        ),

                                        StreamBuilder<String>(
                                          stream: firebaseController.getUsersToAdminAccountStream3("man", "baker", "name5"),
                                          builder: (context, snapshot) {
                                            print("SNAPSHOT ${snapshot}");
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(1.0),
                                                  child: Container(
                                                    color: Colors.deepOrangeAccent,
                                                    child:
                                                    Center(child: CircularProgressIndicator()),
                                                  ),
                                                ),
                                              ) ;

                                            } else if (snapshot.hasError) {
                                              return Center(child: Text("Error: ${snapshot.error}"));
                                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                              return Center(child: Text("No users found."));
                                            } else {
                                              final users = snapshot.data!;
                                              return  Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(1.0),
                                                  child: Container(
                                                    color: Colors.deepOrangeAccent,
                                                    child: Center(child: Text(users, style: TextStyle(fontSize: 20),)),
                                                  ),
                                                ),
                                              ) ;


                                            }
                                          },
                                        ),

                                        StreamBuilder<String>(
                                          stream: firebaseController.getUsersToAdminAccountStream3("man", "baker", "name9"),
                                          builder: (context, snapshot) {
                                            print("SNAPSHOT ${snapshot}");
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(1.0),
                                                  child: Container(
                                                    color: Colors.deepOrangeAccent,
                                                    child:
                                                    Center(child: CircularProgressIndicator()),
                                                  ),
                                                ),
                                              ) ;

                                            } else if (snapshot.hasError) {
                                              return Center(child: Text("Error: ${snapshot.error}"));
                                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                              return Center(child: Text("No users found."));
                                            } else {
                                              final users = snapshot.data!;
                                              return  Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(1.0),
                                                  child: Container(
                                                    color: Colors.deepOrangeAccent,
                                                    child: Center(child: Text(users, style: TextStyle(fontSize: 20),)),
                                                  ),
                                                ),
                                              ) ;


                                            }
                                          },
                                        ),

                                      ],
                                    ),
                                  ) ,
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Container(
                                        color: Colors.white,
                                        child:Center(
                                          child: Text(
                                            controller.totalFamilyABUBaker.toString(),
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ) ,

                                  Expanded(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                              color: Colors.white,
                                              child: Center(
                                                  child: TextField(
                                                    onChanged:(v){
                                                      setState(() {

                                                      });
                                                    },
                                                    controller: controller.zuhairNassarController,
                                                    textAlign: TextAlign.center,
                                                    keyboardType: TextInputType.number,
                                                    style: TextStyle(),
                                                  )),
                                            ),
                                          ),
                                        ) ,
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                              color: Colors.white,
                                              child: Center(
                                                  child: TextField(
                                                    onChanged: (v){
                                                      controller.editTotalFamilyAfterChangeByTextField();

                                                    },
                                                    controller: controller.ebrahhemZaqoutController2,
                                                    textAlign: TextAlign.center,
                                                    keyboardType: TextInputType.number,
                                                    style: TextStyle(),
                                                  )),
                                            ),
                                          ),
                                        ) ,
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                              color: Colors.white,
                                              child: Center(
                                                  child: TextField(
                                                    onChanged: (v){
                                                      controller.editTotalFamilyAfterChangeByTextField();

                                                    },
                                                    controller: controller.ebrahhemZaqoutController,
                                                    textAlign: TextAlign.center,
                                                    keyboardType: TextInputType.number,
                                                    style: TextStyle(),
                                                  )),
                                            ),
                                          ),
                                        ) ,
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                              color: Colors.white,
                                              child: Center(
                                                  child: TextField(
                                                    onChanged: (v){
                                                      controller.editTotalFamilyAfterChangeByTextField();

                                                    },
                                                    controller: controller.muhammedAlhamidyController,
                                                    textAlign: TextAlign.center,
                                                    keyboardType: TextInputType.number,
                                                    style: TextStyle(),
                                                  )),
                                            ),
                                          ),
                                        ) ,


                                      ],
                                    ),
                                  ) ,
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                              color: Colors.white,
                                              child: Center(child: Text(
                                                "${(((controller.percentPerFamily * controller.safeParseInt(controller.zuhairNassarController.text.toString()))/controller.waredToZawaida)*100).toStringAsFixed(2)}"
                                                , style: TextStyle(fontSize: 20),)),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                              color: Colors.white,
                                              child: Center(child: Text(
                                                "${(((controller.percentPerFamily * controller.safeParseInt(controller.ebrahhemZaqoutController2.text.toString()))/controller.waredToZawaida)*100).toStringAsFixed(2)}"
                                                , style: TextStyle(fontSize: 20),)),
                                            ),
                                          ),
                                        ),

                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                              color: Colors.white,
                                              child: Center(child: Text(
                                                "${(((controller.percentPerFamily * controller.safeParseInt(controller.ebrahhemZaqoutController.text.toString()))/controller.waredToZawaida)*100).toStringAsFixed(2)}"
                                                , style: TextStyle(fontSize: 20),)),
                                            ),
                                          ),
                                        ),

                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                              color: Colors.white,
                                              child: Center(child: Text(
                                                "${(((controller.percentPerFamily * controller.safeParseInt(controller.muhammedAlhamidyController.text.toString()))/controller.waredToZawaida)*100).toStringAsFixed(2)}"
                                                , style: TextStyle(fontSize: 20),)),
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ) ,
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                              color: Colors.white,
                                              child: Center(child: Text(
                                                "${(controller.percentPerFamily * controller.safeParseInt(controller.zuhairNassarController.text.toString())).round()}"
                                                , style: TextStyle(fontSize: 20),)),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                              color: Colors.white,
                                              child: Center(child: Text(
                                                "${(controller.percentPerFamily * controller.safeParseInt(controller.ebrahhemZaqoutController2.text.toString())).round()}"
                                                , style: TextStyle(fontSize: 20),)),
                                            ),
                                          ),
                                        ),

                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                              color: Colors.white,
                                              child: Center(child: Text(
                                                "${(controller.percentPerFamily * controller.safeParseInt(controller.ebrahhemZaqoutController.text.toString())).round()}"
                                                , style: TextStyle(fontSize: 20),)),
                                            ),
                                          ),
                                        ),

                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                              color: Colors.white,
                                              child: Center(child: Text(
                                                "${(controller.percentPerFamily * controller.safeParseInt(controller.muhammedAlhamidyController.text.toString())).round()}"
                                                , style: TextStyle(fontSize: 20),)),
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ) ,


                                ],
                              ),
                            ),
                          ),

                          // أبو عبيدة
                          GetBuilder<PercentageController>(
                            builder:(controller)=> Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Container(
                                        color: Colors.lightGreenAccent,
                                        child: Center(child: Text("أبو عبيدة" , style: TextStyle(fontSize: 20),)),
                                      ),
                                    ),
                                  ) ,
                                  StreamBuilder<String>(
                                    stream: firebaseController.getUsersToAdminAccountStream3("man", "ubaida", "name1"),
                                    builder: (context, snapshot) {
                                      print("SNAPSHOT ${snapshot}");
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                              color: Colors.deepOrangeAccent,
                                              child:
                                              Center(child: CircularProgressIndicator()),
                                            ),
                                          ),
                                        ) ;

                                      } else if (snapshot.hasError) {
                                        return Center(child: Text("Error: ${snapshot.error}"));
                                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                        return Center(child: Text("No users found."));
                                      } else {
                                        final users = snapshot.data!;
                                        return  Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                              color: Colors.deepOrangeAccent,
                                              child: Center(child: Text(users, style: TextStyle(fontSize: 20),)),
                                            ),
                                          ),
                                        ) ;


                                      }
                                    },
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Container(
                                        color: Colors.white,
                                        child: Center(
                                            child: TextField(
                                              onChanged: (v){
                                                controller.editTotalFamilyAfterChangeByTextField();

                                              },
                                              controller: controller.muhammedNamrotyController,
                                              textAlign: TextAlign.center,
                                              keyboardType: TextInputType.number,
                                              style: TextStyle(),
                                            )),
                                      ),
                                    ),
                                  ) ,
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Container(
                                        color: Colors.white,
                                        child: Center(child: Text("${controller.muhammedNamrotyController.text }" , style: TextStyle(fontSize: 20),)),
                                      ),
                                    ),
                                  ) ,
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Container(
                                        color: Colors.white,
                                        child: Center(child: Text(
                                          "${(((controller.percentPerFamily * controller.safeParseInt(controller.muhammedNamrotyController.text.toString()))/controller.waredToZawaida)*100).toStringAsFixed(2)}"
                                          , style: TextStyle(fontSize: 20),)),
                                      ),
                                    ),
                                  ) ,
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Container(
                                          color: Colors.white,
                                          child: Center(child: Text(
                                            "${(controller.percentPerFamily * controller.safeParseInt(controller.muhammedNamrotyController.text.toString())).round()}"
                                            , style: TextStyle(fontSize: 20),)),
                                      ),
                                    ),
                                  ) ,

                                ],
                              ),
                            ),
                          ),

                          // الفاروق
                          GetBuilder<PercentageController>(
                            builder:(controller)=> Expanded  (
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Container(
                                        color: Colors.lightGreenAccent,
                                        child: Center(child: Text("الفاروق" , style: TextStyle(fontSize: 20),)),
                                      ),
                                    ),
                                  ) ,
                                  StreamBuilder<String>(
                                    stream: firebaseController.getUsersToAdminAccountStream3("man", "faro", "name1"),
                                    builder: (context, snapshot) {
                                      print("SNAPSHOT ${snapshot}");
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                              color: Colors.deepOrangeAccent,
                                              child:
                                              Center(child: CircularProgressIndicator()),
                                            ),
                                          ),
                                        ) ;

                                      } else if (snapshot.hasError) {
                                        return Center(child: Text("Error: ${snapshot.error}"));
                                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                        return Center(child: Text("No users found."));
                                      } else {
                                        final users = snapshot.data!;
                                        return  Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                              color: Colors.deepOrangeAccent,
                                              child: Center(child: Text(users, style: TextStyle(fontSize: 20),)),
                                            ),
                                          ),
                                        ) ;


                                      }
                                    },
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Container(
                                        color: Colors.white,
                                        child: Center(
                                            child: TextField(
                                              onChanged: (v){
                                                controller.editTotalFamilyAfterChangeByTextField();

                                              },
                                              controller: controller.khalilController,
                                              textAlign: TextAlign.center,
                                              keyboardType: TextInputType.number,
                                              style: TextStyle(),
                                            )),
                                      ),
                                    ),
                                  ) ,
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Container(
                                        color: Colors.white,
                                        child: Center(child: Text("${controller.khalilController.text}" , style: TextStyle(fontSize: 20),)),
                                      ),
                                    ),
                                  ) ,
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Container(
                                        color: Colors.white,
                                        child: Center(child: Text(
                                          "${(((controller.percentPerFamily * controller.safeParseInt(controller.khalilController.text.toString()))/controller.waredToZawaida)*100).toStringAsFixed(2)}"
                                          , style: TextStyle(fontSize: 20),)),
                                      ),
                                    ),
                                  ) ,
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Container(
                                        color: Colors.white,
                                        child: Center(child: Text(
                                          "${(controller.percentPerFamily * controller.safeParseInt(controller.khalilController.text.toString())).round()}"
                                          , style: TextStyle(fontSize: 20),)),
                                      ),
                                    ),
                                  ) ,

                                ],
                              ),
                            ),
                          ),

                          // الأنصار الغربية
                          GetBuilder<PercentageController>(
                            builder:(controller)=> Expanded(
                              flex: 4,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Container(
                                        color: Colors.lightGreenAccent,
                                        child: Center(child: Text("الأنصار الغربية" , style: TextStyle(fontSize: 20),)),
                                      ),
                                    ),
                                  ) ,

                                  Expanded(
                                    child: Column(
                                      children: [


                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                              color: Colors.white,
                                              child: Center(child: Text("التوحيد" , style: TextStyle(fontSize: 20),)),
                                            ),
                                          ),
                                        ),

                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                              color: Colors.white,
                                              child: Center(child: Text("العيادات" , style: TextStyle(fontSize: 20),)),
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ) ,
                                  Expanded(
                                    child: Column(
                                      children: [


                                        StreamBuilder<String>(
                                          stream: firebaseController.getUsersToAdminAccountStream3("man", "ansa", "name1"),
                                          builder: (context, snapshot) {
                                            print("SNAPSHOT ${snapshot}");
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(1.0),
                                                  child: Container(
                                                    color: Colors.deepOrangeAccent,
                                                    child:
                                                    Center(child: CircularProgressIndicator()),
                                                  ),
                                                ),
                                              ) ;

                                            } else if (snapshot.hasError) {
                                              return Center(child: Text("Error: ${snapshot.error}"));
                                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                              return Center(child: Text("No users found."));
                                            } else {
                                              final users = snapshot.data!;
                                              return  Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(1.0),
                                                  child: Container(
                                                    color: Colors.deepOrangeAccent,
                                                    child: Center(child: Text(users, style: TextStyle(fontSize: 20),)),
                                                  ),
                                                ),
                                              ) ;


                                            }
                                          },
                                        ),

                                        StreamBuilder<String>(
                                          stream: firebaseController.getUsersToAdminAccountStream3("man", "ansa", "name2"),
                                          builder: (context, snapshot) {
                                            print("SNAPSHOT ${snapshot}");
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(1.0),
                                                  child: Container(
                                                    color: Colors.deepOrangeAccent,
                                                    child:
                                                    Center(child: CircularProgressIndicator()),
                                                  ),
                                                ),
                                              ) ;

                                            } else if (snapshot.hasError) {
                                              return Center(child: Text("Error: ${snapshot.error}"));
                                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                              return Center(child: Text("No users found."));
                                            } else {
                                              final users = snapshot.data!;
                                              return  Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(1.0),
                                                  child: Container(
                                                    color: Colors.deepOrangeAccent,
                                                    child: Center(child: Text(users, style: TextStyle(fontSize: 20),)),
                                                  ),
                                                ),
                                              ) ;


                                            }
                                          },
                                        ),

                                      ],
                                    ),
                                  ) ,
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                              color: Colors.white,
                                              child: Center(
                                                  child: TextField(
                                                    onChanged: (v){
                                                      controller.editTotalFamilyAfterChangeByTextField();

                                                    },
                                                    controller: controller.muhamedQashlanController,
                                                    textAlign: TextAlign.center,
                                                    keyboardType: TextInputType.number,
                                                    style: TextStyle(),
                                                  )),
                                            ),
                                          ),
                                        ) ,
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                              color: Colors.white,
                                              child: Center(
                                                  child: TextField(
                                                    onChanged: (v){
                                                      controller.editTotalFamilyAfterChangeByTextField();

                                                    },
                                                    controller: controller.assadAidController,
                                                    textAlign: TextAlign.center,
                                                    keyboardType: TextInputType.number,
                                                    style: TextStyle(),
                                                  )),
                                            ),
                                          ),
                                        ) ,


                                      ],
                                    ),
                                  ) ,
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                              color: Colors.white,
                                              child: Center(child: Text("${controller.muhamedQashlanController.text}" , style: TextStyle(fontSize: 20),)),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                              color: Colors.white,
                                              child: Center(child: Text("${controller.assadAidController.text}" , style: TextStyle(fontSize: 20),)),
                                            ),
                                          ),
                                        ),


                                      ],
                                    ),
                                  ) ,
                                  Expanded(
                                    child: Column(
                                      children: [

                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                              color: Colors.white,
                                              child: Center(child: Text(
                                                "${(((controller.percentPerFamily * controller.safeParseInt(controller.muhamedQashlanController.text.toString()))/controller.waredToZawaida)*100).toStringAsFixed(2)}"
                                                , style: TextStyle(fontSize: 20),)),
                                            ),
                                          ),
                                        ) ,
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                              color: Colors.white,
                                              child: Center(child: Text(
                                                "${(((controller.percentPerFamily * controller.safeParseInt(controller.assadAidController.text.toString()))/controller.waredToZawaida)*100).toStringAsFixed(2)}"
                                                , style: TextStyle(fontSize: 20),)),
                                            ),
                                          ),
                                        ) ,

                                      ],
                                    ),
                                  ) ,
                                  Expanded(
                                    child: Column(
                                      children: [

                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                              color: Colors.white,
                                              child: Center(child: Text(
                                                "${(controller.percentPerFamily * controller.safeParseInt(controller.muhamedQashlanController.text.toString())).round()}"
                                                , style: TextStyle(fontSize: 20),)),
                                            ),
                                          ),
                                        ) ,
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                              color: Colors.white,
                                              child: Center(child: Text(
                                                "${(controller.percentPerFamily * controller.safeParseInt(controller.assadAidController.text.toString())).round()}"
                                                , style: TextStyle(fontSize: 20),)),
                                            ),
                                          ),
                                        ) ,

                                      ],
                                    ),
                                  ) ,


                                ],
                              ),
                            ),
                          ),

                          // الأنصار الشرقية
                          GetBuilder<PercentageController>(
                            builder: (controller)=>Expanded(
                              flex: 4,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Container(
                                        color: Colors.lightGreenAccent,
                                        child: Center(child: Text("الأنصار الشرقية" , style: TextStyle(fontSize: 20),)),
                                      ),
                                    ),
                                  ) ,

                                  Expanded(
                                    child: Column(
                                      children: [


                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                              color: Colors.white,
                                              child: Center(child: Text("الزوايدة" , style: TextStyle(fontSize: 20),)),
                                            ),
                                          ),
                                        ),

                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                              color: Colors.white,
                                              child: Center(child: Text("صلاح الدين" , style: TextStyle(fontSize: 20),)),
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ) ,
                                  Expanded(
                                    child: Column(
                                      children: [


                                        StreamBuilder<String>(
                                          stream: firebaseController.getUsersToAdminAccountStream3("man", "ansa2", "name2"),
                                          builder: (context, snapshot) {
                                            print("SNAPSHOT ${snapshot}");
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(1.0),
                                                  child: Container(
                                                    color: Colors.deepOrangeAccent,
                                                    child:
                                                    Center(child: CircularProgressIndicator()),
                                                  ),
                                                ),
                                              ) ;

                                            } else if (snapshot.hasError) {
                                              return Center(child: Text("Error: ${snapshot.error}"));
                                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                              return Center(child: Text("No users found."));
                                            } else {
                                              final users = snapshot.data!;
                                              return  Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(1.0),
                                                  child: Container(
                                                    color: Colors.deepOrangeAccent,
                                                    child: Center(child: Text(users, style: TextStyle(fontSize: 20),)),
                                                  ),
                                                ),
                                              ) ;


                                            }
                                          },
                                        ),

                                        StreamBuilder<String>(
                                          stream: firebaseController.getUsersToAdminAccountStream3("man", "ansa2", "name1"),
                                          builder: (context, snapshot) {
                                            print("SNAPSHOT ${snapshot}");
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(1.0),
                                                  child: Container(
                                                    color: Colors.deepOrangeAccent,
                                                    child:
                                                    Center(child: CircularProgressIndicator()),
                                                  ),
                                                ),
                                              ) ;

                                            } else if (snapshot.hasError) {
                                              return Center(child: Text("Error: ${snapshot.error}"));
                                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                              return Center(child: Text("No users found."));
                                            } else {
                                              final users = snapshot.data!;
                                              return  Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(1.0),
                                                  child: Container(
                                                    color: Colors.deepOrangeAccent,
                                                    child: Center(child: Text(users, style: TextStyle(fontSize: 20),)),
                                                  ),
                                                ),
                                              ) ;


                                            }
                                          },
                                        ),

                                      ],
                                    ),
                                  ) ,
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                              color: Colors.white,
                                              child: Center(
                                                  child: TextField(
                                                    controller: controller.ahmedSultanController,
                                                    onChanged: (v){
                                                      controller.editTotalFamilyAfterChangeByTextField();

                                                    },
                                                    textAlign: TextAlign.center,
                                                    keyboardType: TextInputType.number,
                                                    style: TextStyle(),
                                                  )),
                                            ),
                                          ),
                                        ) ,
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                              color: Colors.white,
                                              child: Center(
                                                  child: TextField(
                                                    onChanged: (v){
                                                      controller.editTotalFamilyAfterChangeByTextField();

                                                    },
                                                    controller: controller.mezydController,
                                                    textAlign: TextAlign.center,
                                                    keyboardType: TextInputType.number,
                                                    style: TextStyle(),
                                                  )),
                                            ),
                                          ),
                                        ) ,


                                      ],
                                    ),
                                  ) ,
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                              color: Colors.white,
                                              child: Center(child: Text("${controller.ahmedSultanController.text}"  , style: TextStyle(fontSize: 20),)),
                                            ),
                                          ),
                                        ) ,
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                              color: Colors.white,
                                              child: Center(child: Text("${controller.mezydController.text}"  , style: TextStyle(fontSize: 20),)),
                                            ),
                                          ),
                                        ) ,

                                      ],
                                    ),
                                  ) ,
                                  Expanded(
                                    child: Column(
                                      children: [

                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                              color: Colors.white,
                                              child: Center(child: Text(
                                                "${(((controller.percentPerFamily * controller.safeParseInt(controller.mezydController.text.toString()))/controller.waredToZawaida)*100).toStringAsFixed(2)}"
                                                , style: TextStyle(fontSize: 20),)),
                                            ),
                                          ),
                                        ) ,
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                              color: Colors.white,
                                              child: Center(child: Text(
                                                "${(((controller.percentPerFamily * controller.safeParseInt(controller.mezydController.text.toString()))/controller.waredToZawaida)*100).toStringAsFixed(2)}"
                                                , style: TextStyle(fontSize: 20),)),
                                            ),
                                          ),
                                        ) ,

                                      ],
                                    ),
                                  ) ,
                                  Expanded(
                                    child: Column(
                                      children: [

                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                              color: Colors.white,
                                              child: Center(child: Text(
                                                "${(controller.percentPerFamily * controller.safeParseInt(controller.mezydController.text.toString())).round()}"
                                                , style: TextStyle(fontSize: 20),)),
                                            ),
                                          ),
                                        ) ,
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                              color: Colors.white,
                                              child: Center(child: Text(
                                                "${(controller.percentPerFamily * controller.safeParseInt(controller.ahmedSultanController.text.toString())).round()}"
                                                , style: TextStyle(fontSize: 20),)),
                                            ),
                                          ),
                                        ) ,

                                      ],
                                    ),
                                  ) ,


                                ],
                              ),
                            ),
                          ),

                          // المجموع
                          Expanded(
                            child: Row(
                              children: [

                                Expanded(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Container(
                                      color: Colors.lightGreenAccent,
                                      child: Center(child: Text("المجموع" , style: TextStyle(fontSize: 20),)),
                                    ),
                                  ),
                                ) ,
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Container(
                                      color: Colors.redAccent,
                                      child: Center(
                                          child:
                                          GetBuilder<PercentageController>(
                                              builder:(controller)=> Text("${controller.totalFamily}" , style: TextStyle(fontSize: 20),))),
                                    ),
                                  ),
                                ) ,
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Container(
                                      color: Colors.redAccent,
                                      child: Center(child: Text("" , style: TextStyle(fontSize: 20),)),
                                    ),
                                  ),
                                ) ,
                                GetBuilder<PercentageController>(
                                  builder:(controller)=> Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Container(
                                        color: Colors.redAccent,
                                        child: Center(child: Text(controller.totalAlTorod.toString() , style: TextStyle(fontSize: 20),)),
                                      ),
                                    ),
                                  ),
                                ) ,

                              ],
                            ),
                          ),

                          !kIsWeb?   Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 200,
                                color: Colors.white,
                                child: TextField(
                                  controller:titleController ,
                                  decoration: InputDecoration(
                                      hintText: "Title"
                                  ),
                                ),
                              ),
                              ElevatedButton(onPressed: (){
                                _captureAndSaveImage();
                              },
                                  child: Text("Save")),
                            ],
                          ):SizedBox()

                        ],
                      ),
                    ),
                  ),

                ],
              ),


              )),
        ),
      );
    }

  Future<void> _captureAndSaveImage() async {
    // Ensure the widget is rendered completely
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
        var image = await boundary.toImage(pixelRatio: 2.0);
        ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
        Uint8List pngBytes = byteData!.buffer.asUint8List();

        // // Save image to temporary directory
        // final directory = await getExternalStorageDirectory();
        int  y = DateTime.timestamp().year;
        int  m = DateTime.timestamp().month;
        int  d = DateTime.timestamp().day;
        // final filePath = '${directory!.path}${titleController.text} ${d}-${m}-${y}.png';
        // File imgFile = File(filePath);
        // await imgFile.writeAsBytes(pngBytes);
        //
        // print('Image saved to: $filePath');

        // Request storage permission
        if (await Permission.storage.request().isGranted) {
          // Get the Downloads directory
          final downloadsDir = Directory('/storage/emulated/0/Download/');
          if (!downloadsDir.existsSync()) {
            downloadsDir.createSync(recursive: true);
          }

          // Save the file
          final filePath = '${downloadsDir.path}${titleController.text}${d}-${m}-${y}.png';
          final imgFile = File(filePath);
          await imgFile.writeAsBytes(pngBytes);

          // Notify the user
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("تم الحفظ في مجلد التنزيلات: $filePath"), backgroundColor: Colors.blueGrey),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("لم يتم منح إذن التخزين"), backgroundColor: Colors.red),
          );
        }
      } catch (e) {
        print("Error capturing widget: $e");
      }
    });


  }



}

