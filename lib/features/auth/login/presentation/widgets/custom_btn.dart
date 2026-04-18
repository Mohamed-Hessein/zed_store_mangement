import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zed_store_mangent/core/resources/app_colors.dart';

class CutstomBtn extends StatelessWidget {
  const CutstomBtn({super.key, required this.text, required this.onPressed});
  final String text;
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ElevatedButton(
          style:ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),backgroundColor: AppColors.primiry) ,
          onPressed:onPressed, child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Text(text,style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),)),
SizedBox(width: 6.w,),
          Icon(Icons.arrow_right_alt,color: Colors.white,size: 40,),
            ],
          )),
    );
  }
}
