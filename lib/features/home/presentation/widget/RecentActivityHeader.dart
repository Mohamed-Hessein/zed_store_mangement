import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zed_store_mangent/core/resources/app_colors.dart';

import '../../../../core/resources/app_string.dart';
import '../../../../core/resources/app_strings.dart';

class RecentActivityHeader extends StatelessWidget {
  const RecentActivityHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppStrings.recentActivity,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppColors.textBlack87),
        ),

      ],
    );
  }
}
