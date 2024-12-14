import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Elevation_Button extends StatelessWidget {
   Elevation_Button({
  required this.backColor ,
  required this.inputText ,
   required this.function,
   required this.widthButtton});
  
  Color backColor;
  String inputText;
  Function() function;
  double widthButtton;


  @override
  Widget build(BuildContext context) {
    return  Container(
      width: widthButtton,
      decoration: BoxDecoration(
          color: backColor,
          borderRadius: BorderRadius.all(Radius.circular(5))
      ),
      child: TextButton(onPressed: function,
          child: Text(inputText , style: TextStyle(color: Colors.white),))
    );
  }
}
