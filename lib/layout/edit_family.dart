import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/controller/localdatabase_controller.dart';
import 'package:untitled2/modles/users_info.dart';
import 'package:untitled2/modles/users_info_for_local.dart';
import 'package:untitled2/routes/app_routes.dart';

import '../controller/add_family_controller.dart';
import '../controller/firebase_controller.dart';
import '../shared/constant.dart';
import '../widgets/elevation_button.dart';
import '../widgets/text_filed.dart';
import 'package:get/get.dart';

class Edit_Family extends StatelessWidget {
   Edit_Family({super.key});
   // Retrieve arguments

   AddFamilyController controller = Get.put(AddFamilyController());
   TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController id1TextEditingController = TextEditingController();
  TextEditingController name2TextEditingController = TextEditingController();
  TextEditingController id2TextEditingController = TextEditingController();
  TextEditingController mobileTextEditingController = TextEditingController();
  TextEditingController numberOfFamilyTextEditingController = TextEditingController();
  TextEditingController lastHouseTextEditingController = TextEditingController();
  TextEditingController statusTextEditingController = TextEditingController();
  TextEditingController notesTextEditingController = TextEditingController();

   final FirebaseController firebaseController = Get.find<FirebaseController>();
   final LocalDataBaseController  localDataBaseController= Get.put(LocalDataBaseController());


   @override
  Widget build(BuildContext context) {

    final arguments = Get.arguments as Map<String, dynamic>;
    final usersInfo = arguments['UsersInfo'] ?? 'Guest';
    final key = arguments['key'] ?? '';

    if(controller.saveEdit == false){
      nameTextEditingController.text=usersInfo.name1;
      name2TextEditingController.text=usersInfo.name2;
      id1TextEditingController.text=usersInfo.id1.toString();
      id2TextEditingController.text=usersInfo.id2.toString();
      numberOfFamilyTextEditingController.text=usersInfo.numberOfFamily.toString();
      lastHouseTextEditingController.text=usersInfo.originalResidence;
      notesTextEditingController.text=usersInfo.notes;
      mobileTextEditingController.text="0${usersInfo.mobile}";
      controller.changeValueRadioGroup(usersInfo.status);
      controller.changeValueRadioGroupForResidence_status(usersInfo.residenceStatus);
    }


    return WillPopScope(
      onWillPop: () async{

          Get.toNamed(Routes.showDetails , arguments: {"UsersInfo":UserInfo(
              id1: int.parse(id1TextEditingController.text),
              id2: int.parse(id2TextEditingController.text),
              name1: nameTextEditingController.text,
              name2: name2TextEditingController.text,
              notes: notesTextEditingController.text,
              numberOfFamily: int.parse(numberOfFamilyTextEditingController.text),
              originalResidence: lastHouseTextEditingController.text,
              primery_key: usersInfo.primery_key,
              residenceStatus: controller.residence_status,
              shelter: usersInfo.shelter,
              status: controller.initialRadioValueStatus,
              mobile: int.parse(mobileTextEditingController.text))} );


        return true;
      },
      child: WillPopScope(
        onWillPop: ()async{
          controller.changeDialogAddFamily(false);

          return true;

        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.lightBlueAccent,

            title: Text("تعديل"),
            centerTitle: true,
          ),

          body: Directionality(
              textDirection: TextDirection.rtl,
              child: GetBuilder<AddFamilyController>(
                  builder: (controller){
                    return Container(
                      color: Colors.white10,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text("الحالة الاجتماعبة" , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold),),

                              Row(
                                children: [
                                  Expanded(
                                    child: RadioListTile<String>(
                                      title: Text('متزوج/ة'),
                                      value: 'متزوج/ة',
                                      groupValue: controller.initialRadioValueStatus,
                                      onChanged: (String? value) {
                                        controller.changeValueRadioGroup(value!);

                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: RadioListTile<String>(
                                      title: Text('مطلق/ة'),
                                      value: 'مطلق/ة',
                                      groupValue: controller.initialRadioValueStatus,
                                      onChanged: (String? value) {
                                        controller.changeValueRadioGroup(value!);

                                      },
                                    ),
                                  ),

                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: RadioListTile<String>(
                                      title: Text('آنسة'),
                                      value: 'آنسة',
                                      groupValue: controller.initialRadioValueStatus,
                                      onChanged: (String? value) {
                                        controller.changeValueRadioGroup(value!);

                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: RadioListTile<String>(
                                      title: Text('مهجورة'),
                                      value: 'مهجورة',
                                      groupValue: controller.initialRadioValueStatus,
                                      onChanged: (String? value) {
                                        controller.changeValueRadioGroup(value!);

                                      },
                                    ),
                                  ),

                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: RadioListTile<String>(
                                      title: Text('أيتام'),
                                      value: 'أيتام',
                                      groupValue: controller.initialRadioValueStatus,
                                      onChanged: (String? value) {
                                        controller.changeValueRadioGroup(value!);

                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: RadioListTile<String>(
                                      title: Text('أرمل/ة'),
                                      value: 'أرمل/ة',
                                      groupValue: controller.initialRadioValueStatus,
                                      onChanged: (String? value) {
                                        controller.changeValueRadioGroup(value!);

                                      },
                                    ),
                                  ),



                                ],
                              ),

                              Row(
                                children: [
                                  Expanded(
                                    child: RadioListTile<String>(
                                      title: Text('أعزب كبير في السن'),
                                      value: 'أعزب كبير في السن',
                                      groupValue: controller.initialRadioValueStatus,
                                      onChanged: (String? value) {
                                        controller.changeValueRadioGroup(value!);

                                      },
                                    ),
                                  ),



                                ],
                              ),

                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 2,
                                color: Colors.black12,

                              ),


                              Text("حالة الإقامة " , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold),),
                              Row(
                                children: [
                                  Expanded(
                                    child: RadioListTile<String>(
                                      title: Text('نازح'),
                                      value: 'نازح',
                                      groupValue: controller.residence_status,
                                      onChanged: (String? value) {
                                        controller.changeValueRadioGroupForResidence_status(value!);

                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: RadioListTile<String>(
                                      title: Text('مقيم'),
                                      value: 'مقيم',
                                      groupValue: controller.residence_status,
                                      onChanged: (String? value) {
                                        controller.changeValueRadioGroupForResidence_status(value!);

                                      },
                                    ),
                                  ),

                                ],
                              ),

                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 2,
                                color: Colors.black12,

                              ),


                              SizedBox(height: 25,),

                              socilaStatus(controller.initialRadioValueStatus, context),



                              SizedBox(height: 25,),

                              controller.dialogAddFamily ?
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator()
                                ],)
                                  :
                              Row(
                                children: [
                                  Elevation_Button(backColor: Colors.blueAccent,
                                      inputText: "حفظ",
                                      function: () async {

                                    bool inter = await Constant.checkInternetConnection();

                                    if(inter){
                                      controller.changeDialogAddFamily(true);

                                      bool checkData = _validateInput(context);

                                      if(checkData == true){
                                        // unique key
                                        String result = await firebaseController.checkUserIsFound( int.parse(id1TextEditingController.text), int.parse(id2TextEditingController.text));
                                        if(!result.isEmpty && result != usersInfo.shelter){
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              backgroundColor: Colors.redAccent,
                                              content: Text("هذا الاسم مسجل لدا  ${result}"),
                                            ),
                                          );

                                          if(result != usersInfo.shelter){
                                            showdialogToSendRequestDelte(result, usersInfo.shelter, id1TextEditingController.text , id2TextEditingController.text , nameTextEditingController.text, context );

                                          }

                                          controller.changeDialogAddFamily(false);

                                        }
                                        else{
                                          if(controller.initialRadioValueStatus == "متزوج/ة") {
                                            Map<String , dynamic> usersInfoObject= {
                                              'id1': int.parse(id1TextEditingController.text),
                                              'id2': int.parse(id2TextEditingController.text),
                                              'name1': nameTextEditingController.text,
                                              'name2': name2TextEditingController.text,
                                              'notes': notesTextEditingController.text,
                                              'number_of_family': int.parse(numberOfFamilyTextEditingController.text),
                                              'original_residence': lastHouseTextEditingController.text,
                                              'primery_key': usersInfo.primery_key.toString(),
                                              'residence_status': controller.residence_status, // Note: key contains extra space
                                              'shelter': usersInfo.shelter,
                                              'status': controller.initialRadioValueStatus,
                                              'mobile': int.parse(mobileTextEditingController.text),
                                            };

                                            firebaseController.addUser(usersInfo.shelter, "${usersInfo.primery_key}", usersInfoObject , context);
                                            usersInfoObject["receiving_status"]="لم يتم الاستلام";


                                            // التعديل في المحلي
                                            UserInfo usInfo=   UserInfo.fromJson(usersInfoObject);
                                            localDataBaseController.database.personDao.insertUserInfoForlocal(
                                                UserInfoForlocal(
                                                    id1: int.parse(usInfo.id1.toString()),
                                                    id2: int.parse(usInfo.id2.toString()),
                                                    name1: usInfo.name1.toString(),
                                                    name2: usInfo.name2.toString(),
                                                    notes: usInfo.notes.toString(),
                                                    numberOfFamily: int.parse(
                                                        usInfo.numberOfFamily.toString()),
                                                    originalResidence: usInfo.originalResidence.toString(),
                                                    primery_key: usInfo.primery_key.toString(),
                                                    residenceStatus: usInfo.residenceStatus.toString(),
                                                    shelter: usInfo.shelter.toString(),
                                                    status: usInfo.status.toString(),
                                                    mobile: int.parse(usInfo.mobile.toString())));

                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                backgroundColor: Colors.green,
                                                content: Text("تمت الإضافة بنجاج"),
                                              ),
                                            );
                                          }
                                          else
                                          {

                                            Map<String , dynamic> usersInfoObject= {
                                              'id1': int.parse(id1TextEditingController.text),
                                              'id2': null,
                                              'name1': nameTextEditingController.text,
                                              'name2': null,
                                              'notes': notesTextEditingController.text,
                                              'number_of_family': int.parse(numberOfFamilyTextEditingController.text),
                                              'original_residence': lastHouseTextEditingController.text,
                                              'primery_key': usersInfo.primery_key.toString(),
                                              'residence_status': controller.residence_status, // Note: key contains extra space
                                              'shelter': usersInfo.shelter,
                                              'status': controller.initialRadioValueStatus,
                                              'mobile': int.parse(mobileTextEditingController.text),
                                            };

                                            firebaseController.addUser(usersInfo.shelter, "${usersInfo.primery_key}", usersInfoObject , context);

                                            usersInfoObject["receiving_status"]="لم يتم الاستلام";

                                            // التعديل في المحلي
                                            UserInfo usInfo=   UserInfo.fromJson(usersInfoObject);
                                            localDataBaseController.database.personDao.insertUserInfoForlocal(
                                                UserInfoForlocal(
                                                    id1: int.parse(usInfo.id1.toString()),
                                                    id2: int.parse(usInfo.id2.toString()),
                                                    name1: usInfo.name1.toString(),
                                                    name2: usInfo.name2.toString(),
                                                    notes: usInfo.notes.toString(),
                                                    numberOfFamily: int.parse(
                                                        usInfo.numberOfFamily.toString()),
                                                    originalResidence: usInfo.originalResidence.toString(),
                                                    primery_key: usInfo.primery_key.toString(),
                                                    residenceStatus: usInfo.residenceStatus.toString(),
                                                    shelter: usInfo.shelter.toString(),
                                                    status: usInfo.status.toString(),
                                                    mobile: int.parse(usInfo.mobile.toString())));
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                backgroundColor: Colors.green,
                                                content: Text("تمت الإضافة بنجاج"),
                                              ),
                                            );

                                          }
                                        }

                                      }else{
                                        controller.changeDialogAddFamily(false);
                                      }

                                      Get.offNamed(Routes.showDetails , arguments: {"UsersInfo":UserInfo(
                                          id1: int.parse(id1TextEditingController.text),
                                          id2: int.parse(id2TextEditingController.text),
                                          name1: nameTextEditingController.text,
                                          name2: name2TextEditingController.text,
                                          notes: notesTextEditingController.text,
                                          numberOfFamily: int.parse(numberOfFamilyTextEditingController.text),
                                          originalResidence: lastHouseTextEditingController.text,
                                          primery_key: usersInfo.primery_key,
                                          residenceStatus: controller.residence_status,
                                          shelter: usersInfo.shelter,
                                          status: controller.initialRadioValueStatus,
                                          mobile: int.parse(mobileTextEditingController.text))} );

                                    }else{
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("عليك الاتصال بشبكة الانترنت"), backgroundColor: Colors.red));

                                    }


                                      },
                                      widthButtton: MediaQuery.of(context).size.width * 0.25) ,
                                  Expanded(child: SizedBox(width: 10,)),
                                  Elevation_Button(backColor: Colors.red,
                                      inputText: "الغاء",
                                      function: (){
                                        Get.offNamed(Routes.showDetails , arguments: {"UsersInfo":UserInfo(
                                            id1: int.parse(id1TextEditingController.text),
                                            id2: int.parse(id2TextEditingController.text),
                                            name1: nameTextEditingController.text,
                                            name2: name2TextEditingController.text,
                                            notes: notesTextEditingController.text,
                                            numberOfFamily: int.parse(numberOfFamilyTextEditingController.text),
                                            originalResidence: lastHouseTextEditingController.text,
                                            primery_key: usersInfo.primery_key,
                                            residenceStatus: controller.residence_status,
                                            shelter: usersInfo.shelter,
                                            status: controller.initialRadioValueStatus,
                                            mobile: int.parse(mobileTextEditingController.text))} );
                                      },
                                      widthButtton: MediaQuery.of(context).size.width * 0.25) ,
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                    );
                  })
          ),
        ),
      ),
    );
  }
   Widget socilaStatus(String status ,  BuildContext context){
     if(status == "مطلق/ة" || status == "أرمل/ة" || status == "مهجورة"){
       return Column(children:[
         Row(
           children: [
             Text("الاسم رباعي : ") ,
             SizedBox(width: 15) ,
             Expanded(child:
             Text_Filed(
               textEditingController: nameTextEditingController,
               onChanged: (v){
                 print(v);
                 controller.saveEditMode();
               },
               hintText: "" ,
               widthTextFiled: MediaQuery.of(context).size.width * 0.5,)) ,
           ],
         ),

         SizedBox(height: 10,),


         Row(
           children: [
             Text("الهوية :") ,
             SizedBox(width: 15) ,
             Expanded(child: Text_Filed(
               onChanged: (v){
                 print(v);
                 controller.saveEditMode();
               },
               textEditingController: id1TextEditingController,
               textInputType: TextInputType.number,

               hintText: "" , widthTextFiled: MediaQuery.of(context).size.width * 0.5,)) ,
           ],
         ),


         SizedBox(height: 10,),


         Row(
           children: [
             Text("رقم الجوال : ") ,
             SizedBox(width: 15) ,
             Expanded(child: Text_Filed(hintText: "" ,
               onChanged: (v){
                 print(v);
                 controller.saveEditMode();
               },
               textEditingController: mobileTextEditingController,
               textInputType: TextInputType.number,
               widthTextFiled: MediaQuery.of(context).size.width * 0.5,)) ,
           ],
         ),

         SizedBox(height: 10,),


         Row(
           children: [
             Text("عدد أفراد الأسرة : ") ,
             SizedBox(width: 15) ,
             Expanded(child: Text_Filed(hintText: "" ,
               onChanged: (v){
                 print(v);
                 controller.saveEditMode();
               },
               textInputType: TextInputType.number,
               textEditingController: numberOfFamilyTextEditingController,
               widthTextFiled: MediaQuery.of(context).size.width * 0.5,)) ,
           ],
         ),

         SizedBox(height: 10,),


         Row(
           children: [
             Text("السكن السابق : ") ,
             SizedBox(width: 15) ,
             Expanded(child: Text_Filed(hintText: "" ,
               onChanged: (v){
                 print(v);
                 controller.saveEditMode();
               },
               textEditingController: lastHouseTextEditingController,
               widthTextFiled: MediaQuery.of(context).size.width * 0.5,
             textInputType: TextInputType.text,)) ,
           ],
         ),

         SizedBox(height: 10,),

         Row(
           children: [
             Container(child: Text("الملاحظات : ")) ,
             SizedBox(width: 15) ,
             Expanded(child: Text_Filed(hintText: "" ,
               onChanged: (v){
                 print(v);
                 controller.saveEditMode();
               },
               textEditingController: notesTextEditingController,
               widthTextFiled: MediaQuery.of(context).size.width * 0.5,)) ,
           ],
         ),
       ] );
       }
     else
     if(status == "آنسة" || status == "أعزب كبير في السن"){
       numberOfFamilyTextEditingController.text = "1";
       return Column(children:[
         Row(
           children: [
             Text("الاسم رباعي : ") ,
             SizedBox(width: 15) ,
             Expanded(child:
             Text_Filed(
               textEditingController: nameTextEditingController,
               hintText: "" , widthTextFiled: MediaQuery.of(context).size.width * 0.5,)) ,
           ],
         ),

         SizedBox(height: 10,),


         Row(
           children: [
             Text("الهوية :") ,
             SizedBox(width: 15) ,
             Expanded(child: Text_Filed(
               textInputType: TextInputType.number,
               textEditingController: id1TextEditingController,

               hintText: "" , widthTextFiled: MediaQuery.of(context).size.width * 0.5,)) ,
           ],
         ),


         SizedBox(height: 10,),


         Row(
           children: [
             Text("رقم الجوال : ") ,
             SizedBox(width: 15) ,
             Expanded(child: Text_Filed(hintText: "" ,
               textInputType: TextInputType.number,
               textEditingController: mobileTextEditingController,
               widthTextFiled: MediaQuery.of(context).size.width * 0.5,)) ,
           ],
         ),

         SizedBox(height: 10,),



         SizedBox(height: 10,),


         Row(
           children: [
             Text("السكن السابق : ") ,
             SizedBox(width: 15) ,
             Expanded(child: Text_Filed(hintText: "" ,
               textEditingController: lastHouseTextEditingController,
               widthTextFiled: MediaQuery.of(context).size.width * 0.5,)) ,
           ],
         ),

         SizedBox(height: 10,),







         Row(
           children: [
             Container(child: Text("الملاحظات : ")) ,
             SizedBox(width: 15) ,
             Expanded(child: Text_Filed(hintText: "" ,
               textEditingController: notesTextEditingController,
               widthTextFiled: MediaQuery.of(context).size.width * 0.5,)) ,
           ],
         ),
       ] );

     }

     else
     if(status == "متزوج/ة"){
       return Column(children:[
         Row(
           children: [
             Text("اسم الزوج رباعي : ") ,
             SizedBox(width: 15) ,
             Expanded(child:
             Text_Filed(
               onChanged: (v){
                 print(v);
                 controller.saveEditMode();
               },
               textEditingController: nameTextEditingController,
               hintText: "" , widthTextFiled: MediaQuery.of(context).size.width * 0.5,)) ,
           ],
         ),

         SizedBox(height: 10,),


         Row(
           children: [
             Text("الهوية :") ,
             SizedBox(width: 15) ,
             Expanded(child: Text_Filed(
               textEditingController: id1TextEditingController,
               onChanged: (v){
                 print(v);
                 controller.saveEditMode();
               },
               textInputType: TextInputType.number,
               hintText: "" , widthTextFiled: MediaQuery.of(context).size.width * 0.5,)) ,
           ],
         ),


         SizedBox(height: 10,),

         Row(
           children: [
             Text("اسم الزوجة رباعي : ") ,
             SizedBox(width: 15) ,
             Expanded(child: Text_Filed(hintText: "" ,
               onChanged: (v){
                 print(v);
                 controller.saveEditMode();
               },
               textEditingController: name2TextEditingController,
               widthTextFiled: MediaQuery.of(context).size.width * 0.5,)) ,
           ],
         ),


         SizedBox(height: 10,),

         Row(
           children: [
             Text("الهوية : ") ,
             SizedBox(width: 15) ,
             Expanded(child: Text_Filed(hintText: "" ,
               onChanged: (v){
                 print(v);
                 controller.saveEditMode();
               },
               textEditingController: id2TextEditingController,
               textInputType: TextInputType.number,
               widthTextFiled: MediaQuery.of(context).size.width * 0.5,)) ,
           ],
         ),

         SizedBox(height: 10,),
         Row(
           children: [
             Text("رقم الجوال : ") ,
             SizedBox(width: 15) ,
             Expanded(child: Text_Filed(hintText: "" ,
               onChanged: (v){
                 print(v);
                 controller.saveEditMode();
               },
               textEditingController: mobileTextEditingController,
               textInputType: TextInputType.number,
               widthTextFiled: MediaQuery.of(context).size.width * 0.5,)) ,
           ],
         ),

         SizedBox(height: 10,),


         Row(
           children: [
             Text("عدد أفراد الأسرة : ") ,
             SizedBox(width: 15) ,
             Expanded(child: Text_Filed(hintText: "" ,
               onChanged: (v){
                 print(v);
                 controller.saveEditMode();
               },
               textEditingController: numberOfFamilyTextEditingController,
               textInputType: TextInputType.number,
               widthTextFiled: MediaQuery.of(context).size.width * 0.5,)) ,
           ],
         ),

         SizedBox(height: 10,),


         Row(
           children: [
             Text("السكن السابق : ") ,
             SizedBox(width: 15) ,
             Expanded(child: Text_Filed(hintText: "" ,
               onChanged: (v){
                 print(v);
                 controller.saveEditMode();
               },
               textEditingController: lastHouseTextEditingController,
               widthTextFiled: MediaQuery.of(context).size.width * 0.5,)) ,
           ],
         ),

         SizedBox(height: 10,),

         Row(
           children: [
             Container(child: Text("الملاحظات : ")) ,
             SizedBox(width: 15) ,
             Expanded(child: Text_Filed(hintText: "" ,
               onChanged: (v){
                 print(v);
                 controller.saveEditMode();
               },
               textEditingController: notesTextEditingController,
               widthTextFiled: MediaQuery.of(context).size.width * 0.5,)) ,
           ],
         ),
       ] );

     }
     else
     if(status == "أيتام"){
       return Column(children:[
         Row(
           children: [
             Text("اسم الوصي رباعي : ") ,
             SizedBox(width: 15) ,
             Expanded(child:
             Text_Filed(
               textEditingController: nameTextEditingController,
               onChanged: (v){
                 print(v);
                 controller.saveEditMode();
               },
               hintText: "" , widthTextFiled: MediaQuery.of(context).size.width * 0.5,)) ,
           ],
         ),

         SizedBox(height: 10,),


         Row(
           children: [
             Text("هوية الوصي :") ,
             SizedBox(width: 15) ,
             Expanded(child: Text_Filed(
               textEditingController: id1TextEditingController,
               onChanged: (v){
                 print(v);
                 controller.saveEditMode();
               },
               textInputType: TextInputType.number,
               hintText: "" , widthTextFiled: MediaQuery.of(context).size.width * 0.5,)) ,
           ],
         ),


         SizedBox(height: 10,),


         Row(
           children: [
             Text("رقم جوال الوصي: ") ,
             SizedBox(width: 15) ,
             Expanded(child: Text_Filed(hintText: "" ,
               onChanged: (v){
                 print(v);
                 controller.saveEditMode();
               },
               textEditingController: mobileTextEditingController,
               textInputType: TextInputType.number,
               widthTextFiled: MediaQuery.of(context).size.width * 0.5,)) ,
           ],
         ),

         SizedBox(height: 10,),


         Row(
           children: [
             Text("عدد الأطفال اليتاما : ") ,
             SizedBox(width: 15) ,
             Expanded(child: Text_Filed(hintText: "" ,
               onChanged: (v){
                 print(v);
                 controller.saveEditMode();
               },
               textEditingController: numberOfFamilyTextEditingController,
               textInputType: TextInputType.number,
               widthTextFiled: MediaQuery.of(context).size.width * 0.5,)) ,
           ],
         ),

         SizedBox(height: 10,),


         Row(
           children: [
             Text("السكن السابق : ") ,
             SizedBox(width: 15) ,
             Expanded(child: Text_Filed(hintText: "" ,
               onChanged: (v){
                 print(v);
                 controller.saveEditMode();
               },
               textEditingController: lastHouseTextEditingController,
               widthTextFiled: MediaQuery.of(context).size.width * 0.5,)) ,
           ],
         ),

         SizedBox(height: 10,),

         Row(
           children: [
             Container(child: Text("الملاحظات : ")) ,
             SizedBox(width: 15) ,
             Expanded(child: Text_Filed(hintText: "" ,
               onChanged: (v){
                 print(v);
                 controller.saveEditMode();
               },
               textEditingController: notesTextEditingController,
               widthTextFiled: MediaQuery.of(context).size.width * 0.5,)) ,
           ],
         ),
       ] );
     }
     else{
       return SizedBox();
     }
   }

   // Function to validate the input fields
   bool _validateInput(BuildContext context) {

     if (controller.initialRadioValueStatus == "متزوج/ة") {
       if (nameTextEditingController.text.isEmpty || name2TextEditingController.text.isEmpty
           || nameTextEditingController.text == null  || name2TextEditingController.text == null ||
           nameTextEditingController.text.length < 11 || name2TextEditingController.text.length < 11) {
         _showError(context, "يرجى إدخال الاسم رباعي");
         return false;
       }
       if (id1TextEditingController.text.isEmpty || int.tryParse(id1TextEditingController.text) == null ||
           id2TextEditingController.text.isEmpty || int.tryParse(id2TextEditingController.text) == null ||
           int.parse(id1TextEditingController.text.toString()) > 9999999999 || int.parse(id1TextEditingController.text.toString()) < 1111111 ||
           int.parse(id2TextEditingController.text.toString()) > 9999999999 || int.parse(id2TextEditingController.text.toString()) < 1111111 ) {
         _showError(context, "يرجى إدخال رقم هوية صحيح");
         return false;
       }

     }

     if (nameTextEditingController.text.isEmpty ||  nameTextEditingController.text == null ||
         nameTextEditingController.text.length < 11) {
       _showError(context, "يرجى إدخال الاسم رباعي");
       return false;
     }
     if (id1TextEditingController.text.isEmpty || int.tryParse(id1TextEditingController.text) == null) {
       _showError(context, "يرجى إدخال رقم هوية صحيح");
       return false;
     }
     if (mobileTextEditingController.text.isEmpty ||
         !mobileTextEditingController.text.startsWith("056") &&
             !mobileTextEditingController.text.startsWith("059") ||
         mobileTextEditingController.text.length > 10 ||
         mobileTextEditingController.text.length < 10) {
       _showError(context, "يرجى إدخال رقم جوال صحيح");
       return false;
     }
     if (numberOfFamilyTextEditingController.text.isEmpty && controller.initialRadioValueStatus != "آنسة"
         && controller.initialRadioValueStatus != "أعزب كبير في السن")  {
       _showError(context, "يرجى إدخال عدد أفراد الأسرة");
       return false;
     }
     if (lastHouseTextEditingController.text.isEmpty) {
       _showError(context, "يرجى إدخال السكن السابق");
       return false;
     }

     return true;
   }

   // Helper function to show error messages
   void _showError(BuildContext context, String message) {
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
         backgroundColor: Colors.redAccent,
         content: Text(message),
       ),
     );
   }


   void showdialogToSendRequestDelte(String reciverShelter , String senderShelter ,  String idUserDeleted , String id2UserDeleted , String nameUserDeleted, BuildContext context ) {

     showDialog(
       context: context,
       barrierDismissible: false, // Prevent closing by tapping outside
       builder: (BuildContext context) {
         return AlertDialog(
           title: Text("هل تود ارسال طلب حذف للمندوب ${reciverShelter} "),

           actions: [
             TextButton(
               onPressed: () {
                 Navigator.of(context).pop(); // Close the dialog
               },
               child: Text("إلغاء"),
             ),
             ElevatedButton(
               onPressed: () async {
                 int idNotification = DateTime.now().millisecondsSinceEpoch;
                 Map<dynamic, dynamic> notificationMap = {
                   "deletedName": nameUserDeleted,
                   "idUserDeleted" : idUserDeleted,
                   "id2UserDeleted" : id2UserDeleted,
                   "date_time": Constant.getCurrentDateTime(),
                   "id": idNotification,
                   "status": "cancel",
                   "sender": senderShelter ,
                   "reciver" : reciverShelter
                 };

                 try{

                   // Fetch the current number of notifications
                   var event = await firebaseController.getUserNotificationNumber(reciverShelter).first;
                   int numberNotification = event != null && event["notificationNumber"] != null
                       ? event["notificationNumber"] + 1
                       : 1;


                   await firebaseController.addnotificationFromUserToUser(notificationMap, context, idNotification.toString() , reciverShelter);
                   firebaseController.getNotificationNumber().listen((event) {

                   });

                   await  firebaseController.addNumberOfNotificationFromUserToUser( {"notificationNumber": numberNotification} , reciverShelter);

                   print("Notification saved successfully: $numberNotification");
                   Get.back();
                   Navigator.of(context).pop(); // Close the dialog
                 }catch(e){
                   print("Error: $e");

                 }

               },
               child: Text("موافق"),
             ),
           ],
         );
       },
     );

   }

}
