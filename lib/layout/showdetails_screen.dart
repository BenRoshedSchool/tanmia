import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled2/controller/listfamily_controller.dart';
import 'package:untitled2/layout/listfamily_screen.dart';
import 'package:untitled2/layout/users_home_screen.dart';
import '../controller/firebase_controller.dart';
import '../modles/children_Info.dart';
import '../routes/app_routes.dart';
import '../shared/constant.dart';
import '../widgets/elevation_button.dart';

class ShowDetails_Screen extends StatelessWidget {
  final FirebaseController firebaseController = Get.find<FirebaseController>();
  final ListFamilyController listFamilyController = Get.find<ListFamilyController>();

  @override
  Widget build(BuildContext context) {
    // Retrieve arguments
    final arguments = Get.arguments as Map<String, dynamic>;
    final usersInfo = arguments['UsersInfo'] ?? 'Guest';


    String name1 = usersInfo.name1;
    String name2 = usersInfo.name2;
    int id1 = usersInfo.id1;
    int id2 = usersInfo.id2;
    int phone = usersInfo.mobile;
    int numFamily = usersInfo.numberOfFamily;
    String lastHouse = usersInfo.originalResidence;
    String residenceStatus = usersInfo.residenceStatus;
    String status = usersInfo.status;
    String note = usersInfo.notes;
    String shelter = usersInfo.shelter;
    return WillPopScope(
      onWillPop: ()async{

        if(firebaseController.UserName == "admin"){
          Get.to(ListFamily_Screen(username: shelter,));
        }else{
          Get.to(UsersHome_Screen());

        }
        return true;

      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlueAccent,

          title: Text(usersInfo.name1),
          centerTitle: true,
        ),

        body: Container(
          color: Colors.white10,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "الاسم : " ,
                        style: TextStyle(fontSize: 20),
                      ) ,
                      SizedBox(width: 15) ,

                      Text(name1 ,
                        style: TextStyle(fontSize: 18),

                      ),
                    ],
                  ),

                  SizedBox(height: 10,),


                  Row(
                    children: [
                      Text("هوية الزوج :"
                 , style: TextStyle(fontSize: 20),) ,
                      SizedBox(width: 15) ,
                      Text(id1.toString() ,
                        style: TextStyle(fontSize: 18),

                      ),                  ],
                  ) ,


                  SizedBox(height: 10,),


                  status == "متزوج/ة" ? Row(
                    children: [
                      Text("اسم الزوجة : " , style: TextStyle(fontSize: 20)) ,
                      SizedBox(width: 15) ,
                      Text(name2 ,
                        style: TextStyle(fontSize: 18),

                      ),                  ],
                  ) : SizedBox(),


                  SizedBox(height: 10,),

                  status == "متزوج/ة" ?  Row(
                    children: [
                      Text("هوبة الزوجة : ", style: TextStyle(fontSize: 20)) ,
                      SizedBox(width: 15) ,
                      Text(id2.toString(),
                        style: TextStyle(fontSize: 18),

                      ),                  ],
                  ) : SizedBox(),

                  SizedBox(height: 10,),


                  Row(
                    children: [
                      Text("رقم الجوال : ", style: TextStyle(fontSize: 20)) ,
                      SizedBox(width: 15) ,
                      InkWell(
                        onTap: (){
                          Constant.makePhoneCall(phone.toString());
                        },
                        child: Text("$phone" ,
                          style: TextStyle(fontSize: 18),

                        ),
                      ),                  ],
                  ),

                  SizedBox(height: 10,),


                  Row(
                    children: [
                      Text("عدد أفراد الأسرة : ", style: TextStyle(fontSize: 20)) ,
                      SizedBox(width: 15) ,
                      Text(numFamily.toString() ,
                        style: TextStyle(fontSize: 18),

                      ),                  ],
                  ),

                  SizedBox(height: 10,),


                  Row(
                    children: [
                      Text("السكن السابق : ", style: TextStyle(fontSize: 20)) ,
                      SizedBox(width: 15) ,
                      Text(lastHouse ,
                        style: TextStyle(fontSize: 18),

                      ),                  ],
                  ),

                  SizedBox(height: 10,),

                  Row(
                    children: [
                      Text("حالة الاقامة : ", style: TextStyle(fontSize: 20)) ,
                      SizedBox(width: 15) ,
                      Text(residenceStatus,
                        style: TextStyle(fontSize: 18),

                      ),                  ],
                  ),

                  SizedBox(height: 10,),


                  Row(
                    children: [
                      Text("الحالة الاجتماعية : ", style: TextStyle(fontSize: 20)) ,
                      SizedBox(width: 15) ,
                      Text(status ,
                        style: TextStyle(fontSize: 18),

                      ),                  ],
                  ),

                  SizedBox(height: 10,),

                  Row(
                    children: [
                      Container(child: Text("الملاحظات : ", style: TextStyle(fontSize: 20))) ,
                      SizedBox(width: 15) ,
                      Text( note ,
                        style: TextStyle(fontSize: 18),

                      ),                  ],
                  ),
                  SizedBox(height: 25,),

                status=="آنسة" || status=="أعزب كبير في السن" ? SizedBox() :Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.3, // ضبط الارتفاع النسبي
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200, // لون الخلفية
                      borderRadius: BorderRadius.circular(10), // زوايا مستديرة
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3), // اتجاه الظل
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [

                        StreamBuilder<List<Map<String, dynamic>>>(
                          stream: firebaseController.getDataListStream(
                              "childrens/shelter/${shelter}/${id1.toString()}/listChildren"),
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
                              return const Center(child: Text('لا يوجد بيانات' ,style: TextStyle(fontWeight: FontWeight.bold , fontSize: 18),));
                            }

                            // Reverse the list
                            final reversedItems = items.reversed.toList();

                            return ListView.builder(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              itemCount: reversedItems.length,
                              itemBuilder: (context, index) {
                                final listChildren = reversedItems[index];
                                return Container(
                                  padding: EdgeInsets.only(top: 20),
                                  margin: const EdgeInsets.only(top: 20, left: 10, right: 10,),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child:  ListTile(
                                title: Text(
                                " الاسم ${listChildren["name"]} \n العمر  ${listChildren["eage"]}",
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                "تاريخ الميلاد : ${listChildren["bdate"]}",
                                style: const TextStyle(color: Colors.grey),
                                ),
                                trailing: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                  String chil = "childrens";
                                  String shel = "shelter";
                                  String list="listChildren";

                                    Constant.showDeleteConfirmationDialog(context, () async {


                                    await  firebaseController.deleteData("${chil}/${shel}/${shelter}/${id1}/${list}/${listChildren["primeryKey"]}");


                                    });
                                  },
                                ),
                                ),

                                );
                              },
                            );

                          },
                        ),
                        Container(
                          width: double.infinity,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.green.shade200, // لون الخلفية
                            borderRadius: BorderRadius.circular(10), // زوايا مستديرة
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3), // اتجاه الظل
                              ),
                            ],
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(right:5 ),
                              child: Row(
                                children: [
                                  Text("الأطقال من عمر يوم الى 12 سنة" , style: TextStyle(fontSize: 16 , fontWeight: FontWeight.bold),),
                                  Expanded(child: SizedBox(width: 2,)),

                                  IconButton(
                                      onPressed: (){
                                        _showDialog(context, shelter , id1.toString() , name1);
                                      }, icon: Icon(Icons.add , size: 30,color: Colors.black,))
                                ],
                              ),
                            ),),
                        ),

                      ],
                    ),
                  ),




                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Elevation_Button(backColor: Colors.blueAccent,
                          inputText: "تعديل",
                          function: () async {

                            bool isCheck = await   Constant.checkInternetConnection();
                            if(isCheck && Platform.isAndroid){
                              Get.toNamed(Routes.editFamily, arguments: {"UsersInfo":usersInfo});

                            }else
                            if(kIsWeb){
                              Get.toNamed(Routes.editFamily, arguments: {"UsersInfo":usersInfo});

                            }else{
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("عليك الاتصال بشبكة الانترنت"), backgroundColor: Colors.red),
                              );
                            }
                            },
                          widthButtton: MediaQuery.of(context).size.width * 0.25) ,

                    ],
                  ),
                ],
              ),
            ),
          ),

        ),
      ),
    );
  }


  void _showDialog(BuildContext context, String userName , String id1 , String name1 ) {
    final TextEditingController childtNameController = TextEditingController();
    final TextEditingController eageController = TextEditingController();
    final TextEditingController idController = TextEditingController();
    final TextEditingController birthDateController = TextEditingController();
    final _formKey = GlobalKey<FormState>();


    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: (){
            listFamilyController.changeDialogAddChildren(false);
           Get.back();

          },
          child: GetBuilder<ListFamilyController>(
            builder: (controller) => AlertDialog(
              title: Text('إضافة طفل جديد'),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey, // Assign a global key to the form
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // Child Name Input
                      TextFormField(
                        controller: childtNameController,
                        decoration: InputDecoration(labelText: 'أدخل اسم الطفل'),
                        validator: (value) {
                          if (value == null || value.isEmpty ||  value.length < 11) {
                            return '  يرجى إدخال اسم الطفل رباعي';
                          }
                          return null;
                        },
                      ),
                      // Child ID Input
                      TextFormField(
                        controller: idController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'أدخل هوية الطفل'),
                        validator: (value) {
                          if (value == null || value.isEmpty || int.parse(value!) > 9999999999 || int.parse(value!) < 1111111) {
                            return 'يرجى إدخال هوية الطفل';
                          }
                          return null;
                        },
                      ),
                      // Age Input
                      TextFormField(
                        controller: eageController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(labelText: 'أدخل العمر مثال 3 (سنوات - شهور - أيام ) '),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال عمر الطفل';
                          }



                          return null;
                        },
                      ),
                      // Birthdate Input
                      TextFormField(
                        controller: birthDateController,
                        readOnly: true,
                        onTap: () {
                          _selectDate(context, birthDateController);
                        },
                        decoration: InputDecoration(
                          labelText: 'تاريخ الميلاد',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () {
                              _selectDate(context, birthDateController);
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى اختيار تاريخ الميلاد';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                // Cancel Button
                if (!controller.dialogAddChildren)
                  TextButton(
                    child: Text('إلغاء'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                // Submit Button
                controller.dialogAddChildren
                    ? Center(child: CircularProgressIndicator())
                    : TextButton(
                  child: Text('تم'),
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      // Form is invalid
                      return;
                    }

                    try {
                      controller.changeDialogAddChildren(true);

                      int key = DateTime.now().millisecondsSinceEpoch;
                      String result = await firebaseController.checkChildrenIsFound(int.parse(id1));
                      String result2 = await firebaseController.checkChildrenparentIsSigned(int.parse(id1), userName);

                      if (result2 == userName) {
                        int idChildren = DateTime.now().millisecondsSinceEpoch;
                        List<Children> listOfChildren = [
                          Children(
                            name: childtNameController.text,
                            id: idController.text,
                            primeryKey: (key + 1).toString(),
                            bdate: birthDateController.text,
                            eage: eageController.text,
                          ),
                        ];

                        Children child = listOfChildren[0];

                        firebaseController.addChildren2(
                          child.toJson(),
                          context,
                          userName,
                          int.parse(id1),
                          (key + 1).toString(),
                        );
                        Get.back();
                        // Show success message
                        Get.snackbar("نجاح", "تم حفظ البيانات بنجاح!");
                        listFamilyController.changeDialogAddChildren(false);

                      } else {
                        controller.changeDialogAddChildren(false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.redAccent,
                            content: Text("للأسف ولي آمر الطفل غير مسجل "),
                          ),
                        );
                        Get.back();
                      }
                    } catch (e) {
                      print(e.toString());
                      controller.changeDialogAddChildren(false);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      controller.text = "${picked.day.toString()}/${picked.month.toString()}/${picked.year.toString()}"; // Format the date as you like
    }
  }

}
