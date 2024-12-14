import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Text_Filed extends StatelessWidget {
   Text_Filed({
     required this.hintText ,
     required this.widthTextFiled,
     required this.textEditingController,
     this.textInputType=TextInputType.text ,
     this.onChanged, // Optional onChanged parameter



     // required this.controller
 });

  // TextEditingController controller;
  String hintText;
  double widthTextFiled;
  TextEditingController textEditingController;
   TextInputType textInputType;
   final Function(String)? onChanged;




   @override
  Widget build(BuildContext context) {
    return
      Container(
        width: widthTextFiled,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5))
      ),
      height: 50,
      child: TextField(
        controller: textEditingController,
        textDirection: TextDirection.rtl,
        cursorColor: Colors.black,
        onChanged: onChanged,
        keyboardType: textInputType,
        decoration: InputDecoration(
          fillColor: Colors.pink,
          hintText: hintText,
          hintTextDirection: TextDirection.rtl,
          focusedBorder:  OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.blueAccent),
          ),
          enabledBorder:  OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.black),
          ),
        ),
      ),
    );

  }
}
