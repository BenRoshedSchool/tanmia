

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/controller/delivers_controller.dart';
import 'package:untitled2/layout/listfamily_screen.dart';
import 'package:untitled2/modles/record_recpients.dart';
import 'package:untitled2/modles/recored_reciving.dart';
import 'package:untitled2/modles/users_info.dart';
import '../controller/firebase_controller.dart';
import '../controller/localdatabase_controller.dart';
import '../routes/app_routes.dart';
import '../shared/constant.dart';
import 'showdetails_screen.dart';

class DeliverablesrRecored extends StatefulWidget {
  final String keys;
  final String title;
  final String user;

  DeliverablesrRecored({this.keys = "", this.title = "" , this.user=""});

  @override
  _DeliverablesrRecoredState createState() => _DeliverablesrRecoredState();
}

class _DeliverablesrRecoredState extends State<DeliverablesrRecored> {
  FirebaseController firebaseController = Get.put(FirebaseController());
  DeliversController deliversController = Get.put(DeliversController());
  LocalDataBaseController localDataBaseController = Get.put(LocalDataBaseController());



  String f = "كشوفات تسليم";
  String h = "recipients";
  bool clicked = false;

  // Controller for the search field
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();

    // Listen for changes in the search field
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text;
      });
    });

    // localDataBaseController.database.personDao.getRecoredRecpients(widget.keys).listen((event) {
    //
    //
    //   for(RecoredRecpients recoredRecpients in event){
    //     print("PRIMERY Reciving ${recoredRecpients.name1}");
    //
    //   }
    //
    //
    // });


  }

  @override
  void dispose() {
    searchController.dispose(); // Dispose of the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.user);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,

        title: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(widget.title),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.white10,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'بحث...',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),

              (firebaseController.UserName == "admin")?
              Expanded(
                child: StreamBuilder<List<Map<dynamic, dynamic>>>(
                  stream: firebaseController.getDataListStream("كشوفات تسليم/${widget.user}/${widget.keys}/recipients"),
                  builder: (context, snapshot) {
                    print("كشوفات تسليم/${widget.user}/${widget.keys}");

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData && snapshot.data != null) {
                      // Filter the data based on the search query
                      List<Map<dynamic, dynamic>> filteredList = snapshot.data!
                          .where((record) {
                        final name = record["name1"].toString().toLowerCase();
                        final id = record["id1"].toString().toLowerCase();
                        final query = searchQuery.toLowerCase();
                        return name.contains(query) || id.contains(query);
                      })
                          .toList();

                      if (filteredList.isEmpty) {
                        return Center(child: Text('No results found for "$searchQuery"'));
                      }

                      return ListView.separated(
                        itemBuilder: (context, index) {
                          Map<dynamic, dynamic> map = filteredList[index];

                          return InkWell(
                            onTap: () {
                              // Handle tap
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                color: Color.fromRGBO(195, 206, 231, 1.0),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              child: Row(
                                children: [
                                  Container(
                                    height: 100,
                                    child: Center(child: Text("${index + 1}")),
                                    decoration: BoxDecoration(
                                      color: Colors.greenAccent,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(15),
                                        bottomRight: Radius.circular(15),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.25,
                                        child: Text(
                                          map!["name1"],
                                          style: TextStyle(fontSize: 16),
                                          maxLines: 3,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(map!["status"], style: TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                  Expanded(child: SizedBox(width: 20)),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(map!["id1"].toString(), style: TextStyle(fontSize: 16)),
                                      SizedBox(height: 10),
                                      Text(map!["mobile"].toString(), style: TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                  Expanded(child: SizedBox(width: 10)),
                                  GetBuilder<DeliversController>(
                                    builder: (deliversController) {
                                      return Column(
                                        children: [
                                          Container(
                                            height: 40,
                                            width: MediaQuery.of(context).size.width * 0.3,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(7)),
                                              color: map!['receiving_status'] == "تم التسليم"
                                                  ? Colors.green
                                                  : Colors.redAccent,
                                            ),
                                            child: InkWell(
                                              onTap: () async {
                                                // Handle update status
                                              },
                                              child: Center(
                                                child: Text(map!['receiving_status']),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 15),
                                          ElevatedButton(
                                            onPressed: () async {
                                              Map<String,dynamic> maps = map as Map<String,dynamic>;
                                              bool isCheck = await   Constant.checkInternetConnection();
                                              if(isCheck){
                                                if(map!["receiving_status"] != "تم التسليم"){



                                                  Get.to(ListFamily_Screen(username: widget.user,keys: widget.keys, map: map,recivefromDeliverablesrRecored: "DeliverablesrRecored",));
                                                }else{
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      backgroundColor: Colors.redAccent,
                                                      content: Text("لا يمكنك الاستبدال تم التسليم "),
                                                    ),
                                                  );
                                                }
                                              }else{
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text("عليك الاتصال بشبكة الانترنت"), backgroundColor: Colors.red),
                                                );
                                              }
                                              },
                                            child: Text("استبدال"),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => Container(height: 3),
                        itemCount: filteredList.length,
                      );
                    } else {
                      return Center(child: Text('No data found'));
                    }
                  },
                ),
              )
              :

              Expanded(
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: localDataBaseController.getRecoredRecpients(widget.keys),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData && snapshot.data != null) {
                      // Filter the data based on the search query
                      List<Map<String, dynamic>> filteredList = snapshot.data!
                          .where((record) {
                        final name = record["name1"].toString().toLowerCase();
                        final id = record["id1"].toString().toLowerCase();
                        final query = searchQuery.toLowerCase();
                        return name.contains(query) || id.contains(query);
                      })
                          .toList();

                      if (filteredList.isEmpty) {
                        return Center(child: Text('No results found for "$searchQuery"'));
                      }

                      return ListView.separated(
                        itemBuilder: (context, index) {
                          Map<String, dynamic> map = filteredList[index];

                          return InkWell(
                            onTap: () {
                              // Handle tap
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                color: Color.fromRGBO(195, 206, 231, 1.0),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              child: Row(
                                children: [
                                  Container(
                                    height: 100,
                                    child: Center(child: Text("${index + 1}")),
                                    decoration: BoxDecoration(
                                      color: Colors.greenAccent,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(15),
                                        bottomRight: Radius.circular(15),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.25,
                                        child: Text(
                                          map!["name1"],
                                          style: TextStyle(fontSize: 16),
                                          maxLines: 3,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(map!["status"], style: TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                  Expanded(child: SizedBox(width: 20)),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(map!["id1"].toString(), style: TextStyle(fontSize: 16)),
                                      SizedBox(height: 10),
                                      Text(map!["mobile"].toString(), style: TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                  Expanded(child: SizedBox(width: 10)),
                                  GetBuilder<DeliversController>(
                                    builder: (deliversController) {
                                      return Column(
                                        children: [
                                          Container(
                                            height: 40,
                                            width: MediaQuery.of(context).size.width * 0.3,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(7)),
                                              color: map!['receiving_status'] == "تم التسليم"
                                                  ? Colors.green
                                                  : Colors.redAccent,
                                            ),
                                            child: InkWell(
                                              onTap: () async {
                                                RecoredRecpients recoredRecpi=    RecoredRecpients.fromJson(map);
                                                print("ReciveStatus ${recoredRecpi.receiving_status}");
                                                if(recoredRecpi.receiving_status == "لم يتم الاستلام"){
                                                  localDataBaseController.changeRecoredRec(true);

                                                  // تعديل حالة الاستلام في التخزين المحلي

                                                  localDataBaseController.database.personDao.updateReceivingStatus(recoredRecpi.primery_key!, "تم التسليم");
                                                  map["receiving_status"] = "تم التسليم";

                                                  firebaseController.updateReceivingStatus(
                                                    "كشوفات تسليم/${firebaseController.UserName}/${widget.keys}/recipients/${map["primery_key"]}",map,context,);
                                                  deliversController.updateRecived(widget.user);

                                                }else{

                                                  localDataBaseController.changeRecoredRec(false);


                                                  // تعديل حالة الاستلام في التخزين المحلي
                                                  map["receiving_status"] = "لم يتم الاستلام";

                                                  localDataBaseController.database.personDao.updateReceivingStatus(recoredRecpi.primery_key!, "لم يتم الاستلام");

                                                  firebaseController.updateReceivingStatus(
                                                    "كشوفات تسليم/${firebaseController.UserName}/${widget.keys}/recipients/${map["primery_key"]}",map,context,);
                                                  deliversController.updateRecived(widget.user);
                                                }
                                              },
                                              child: Center(
                                                child: Text(map!['receiving_status']),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 15),
                                          ElevatedButton(
                                            onPressed: () async {
                                              bool isCheck = await   Constant.checkInternetConnection();
                                              if(isCheck){
                                                if(map!["receiving_status"] != "تم التسليم"){


                                                  Get.to(ListFamily_Screen(username: widget.user,keys: widget.keys, map: map,recivefromDeliverablesrRecored: "DeliverablesrRecored",));
                                                }else{
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      backgroundColor: Colors.redAccent,
                                                      content: Text("لا يمكنك الاستبدال تم التسليم "),
                                                    ),
                                                  );
                                                }
                                              }else{
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text("عليك الاتصال بشبكة الانترنت"), backgroundColor: Colors.red),
                                                );
                                              }
                                              },
                                            child: Text("استبدال"),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => Container(height: 3),
                        itemCount: filteredList.length,
                      );
                    } else {
                      return Center(child: Text('No data found'));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
