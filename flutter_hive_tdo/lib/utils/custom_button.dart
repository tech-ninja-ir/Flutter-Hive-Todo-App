
import 'package:flutter/material.dart';
import 'package:flutter_hive_tdo/utils/app_color.dart';

class CustomButton extends StatelessWidget{
  final EdgeInsets? padding;
  final String? buttonText;
  final Color? textColor;
  final double? buttonWith;
  const CustomButton({this.padding, this.buttonText,this.buttonWith, this.textColor, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        height: 50,
        width: buttonWith,
        padding: padding,
        decoration: BoxDecoration(
          color: AppColor.primaryColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: AppColor.neoBoxShadow,
        ),
        child: buttonText != null
            ? Center(
              child: Padding(padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
              child: Text(buttonText!, style: TextStyle(color: textColor, fontSize: 18),)),
            )
        :Center(child: const Icon(Icons.add, color: Colors.white,)),
      ),
    );
  }
}