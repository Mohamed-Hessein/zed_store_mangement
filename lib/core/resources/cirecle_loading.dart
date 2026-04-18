import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomPurpleLoadingBar extends StatelessWidget {
  const CustomPurpleLoadingBar({super.key});

  @override
  Widget build(BuildContext context) {

    final Color primaryPurple = const Color(0xFF673AB7);
    final Color lightPurple = primaryPurple.withOpacity(0.3);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        height: 8.h,
        width: double.infinity,
        color: lightPurple,
        child: LinearProgressIndicator(

          valueColor: AlwaysStoppedAnimation<Color>(primaryPurple),
          backgroundColor: Colors.transparent,        ),
      ),
    );
  }
}
