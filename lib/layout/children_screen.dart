import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:untitled2/controller/firebase_controller.dart';
import 'package:untitled2/modles/children_Info.dart';
import 'package:untitled2/routes/app_routes.dart';
import 'package:untitled2/shared/constant.dart';
import '../widgets/elevation_button.dart';

class ChildrenScreen extends StatefulWidget {
  String? userName;
  ChildrenScreen({this.userName});
  @override
  _ChildrenScreenState createState() => _ChildrenScreenState();
}

class _ChildrenScreenState extends State<ChildrenScreen> {
  TextEditingController numberController = TextEditingController();
  TextEditingController nameParentController = TextEditingController();
  TextEditingController idParentController = TextEditingController();
  List<TextEditingController> textFieldControllers = [];
  List<TextEditingController> idFieldControllers = [];
  List<TextEditingController> eageieldControllers = [];
  List<TextEditingController> dateFieldControllers = [];
  List<GlobalKey<FormState>> formKeys = []; // قائمة المفاتيح للتحقق

  int numberOfFields = 0;
  bool saveed=false;

  FirebaseController _firebaseController = Get.put(FirebaseController());

  void generateTextFields() {
    setState(() {
      // تحديث عدد الحقول بناءً على الرقم المُدخل
      numberOfFields = int.tryParse(numberController.text) ?? 0;

      // تنظيف القوائم السابقة
      textFieldControllers.clear();
      idFieldControllers.clear();
      formKeys.clear();

      // إنشاء Controllers وKeys جديدة
      for (int i = 0; i < numberOfFields; i++) {
        textFieldControllers.add(TextEditingController());
        idFieldControllers.add(TextEditingController());
        dateFieldControllers.add(TextEditingController());
        eageieldControllers.add(TextEditingController());
        formKeys.add(GlobalKey<FormState>());
      }
    });
  }

  bool validateFields() {
    // التحقق من الحقول النصية الرئيسية
    if (nameParentController.text.isEmpty || nameParentController.text.length < 11) {
      Get.snackbar("خطأ", " يرجى إدخال اسم ولي الأمر رباعي");
      return false;
    }

    if (idParentController.text.isEmpty) {
      Get.snackbar("خطأ", "يرجى إدخال هوية ولي الأمر");
      return false;
    }

    // التحقق من الحقول الديناميكية
    for (int i = 0; i < formKeys.length; i++) {
      if (!formKeys[i].currentState!.validate()) {
        return false;
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  TextField(
                    controller: nameParentController,
                    decoration: InputDecoration(
                      labelText: "اسم ولي الأمر رباعي",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: idParentController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "هوية ولي الأمر",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 50),
                  TextField(
                    controller: numberController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "أدخل عدد الأطفال",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => generateTextFields(),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: numberOfFields,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Form(
                            key: formKeys[index], // ربط المفتاح لكل حقل
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: textFieldControllers[index],
                                  decoration: InputDecoration(
                                    labelText: "اسم الطفل رباعي${index + 1}",
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty || value.length < 11) {
                                      return " يرجى إدخال اسم الطفل رباعي";
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  controller: idFieldControllers[index],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: "هوية الطفل ${index + 1}",
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty || int.parse(value!) > 9999999999 || int.parse(value!) < 1111111) {
                                      return "يرجى إدخال هوية الطفل";
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  controller: eageieldControllers[index],
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    labelText: "إدخال العمر مثال 3 (سنوات - شهور - أيام ) ",
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    print("eage ${value}");
                                    if ( value!.isEmpty) {
                                      return 'يرجى إدخال عمر الطفل';
                                    }


                                    return null;
                                  },
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  controller: dateFieldControllers[index],
                                  onTap: () {
                                    _selectDate(context, dateFieldControllers[index]);
                                  },
                                  readOnly: true,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: "تاريخ ميلاد الطفل ${index + 1}",
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "يرجى إدخال تاريخ الميلاد";
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  saveed?
                  CircularProgressIndicator()
                      :
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Elevation_Button(
                        backColor: Colors.blueAccent,
                        inputText: "حفظ",
                        function: () async {

                        bool inter = await   Constant.checkInternetConnection();
                        if(inter){
                          if (validateFields()) {
                            setState(() {
                              saveed=true;
                            });

                            if(numberController.text.isEmpty|| numberController.text.toString() == null || int.parse(numberController.text.toString()) <=0){
                              setState(() {
                                saveed=false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.redAccent,
                                  content: Text("الرجاء ادخال الأطفال"),
                                ),
                              );

                            }

                            print("saved  ${saveed}");

                            if(saveed == true){
                              String result = await _firebaseController.checkChildrenIsFound( int.parse(idParentController.text));
                              String result2 = await _firebaseController.checkChildrenparentIsSigned( int.parse(idParentController.text) , widget.userName!);

                              // unique key
                              int key =  DateTime.now().millisecondsSinceEpoch;
                              if(!result.isEmpty){
                                setState(() {
                                  saveed=false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.redAccent,
                                    content: Text("الأطفال مسجلين لدى   ${result} قم بالإضافة من واجهة ولي الأمر"),
                                  ),
                                );



                              }
                              else

                              if(result2 == _firebaseController.UserName){
                                int idCildren = DateTime.now().millisecondsSinceEpoch;
                                List<Children> lisOfCildren=[];
                                for (int i = 0 ; i < textFieldControllers.length; i++) {
                                  String name = textFieldControllers[i].text.toString();
                                  String id = idFieldControllers[i].text.toString();
                                  String date = dateFieldControllers[i].text.toString();

                                  lisOfCildren.add(Children(name: name, id: id,primeryKey: i.toString() ,bdate: date , eage: eageieldControllers[i].text));
                                }
                                ChildrenInfo child = ChildrenInfo(
                                    parentId: idParentController.text,
                                    parentName: nameParentController.text,
                                    numberOfChildren: numberOfFields,
                                    primery_key: idCildren,
                                    shelter: _firebaseController.UserName,
                                    listChildren: lisOfCildren);

                                _firebaseController.addChildren(child.toJson(), context, _firebaseController.UserName, int.parse(idParentController.text)) ;
                                // جميع الحقول صالحة
                                Get.snackbar("نجاح", "تم حفظ البيانات بنجاح!");
                                Get.toNamed(Routes.usersHomeScreen);
                                setState(() {
                                  saveed=false;
                                });

                              }
                              else

                              {
                                setState(() {
                                  saveed=false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.redAccent,
                                    content: Text("للأسف ولي آمر الطفل غير مسجل "),
                                  ),
                                );

                              }
                            }

                          }

                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("عليك الاتصال بشبكة الانترنت"), backgroundColor: Colors.red));

                        }
                        },
                        widthButtton: MediaQuery.of(context).size.width * 0.25,
                      ),
                      // Expanded(child: SizedBox(width: 10)),
                      // Elevation_Button(
                      //   backColor: Colors.red,
                      //   inputText: "الغاء",
                      //   function: () {
                      //     Get.back();
                      //   },
                      //   widthButtton: MediaQuery.of(context).size.width * 0.25,
                      // ),
                    ],
                  ),


                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to show the DatePicker and set the selected date to the TextField
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
