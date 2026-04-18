
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
         title: Text("Orders Manager",
          style: TextStyle(color: const Color(0xFF5E49BF), fontWeight: FontWeight.bold, fontSize: 22.sp)),

    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
