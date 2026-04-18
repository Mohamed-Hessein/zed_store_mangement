import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zed_store_mangent/core/resources/app_colors.dart';
import 'package:zed_store_mangent/core/resources/app_string.dart';
import 'package:zed_store_mangent/core/resources/app_styles.dart';

import '../../../../core/resources/app_strings.dart';

class InventoryHeader extends StatelessWidget {
  const InventoryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              CupertinoIcons.cube_box,
              size: 18.sp,
              color: AppColors.primaryPurple,
            ),
            SizedBox(width: 8.w),
            Text(
              AppStrings.myProducts,
              style: AppStyles.text14DarkBold,
            ),
          ],
        ),
        Icon(
          CupertinoIcons.search,
          size: 18.sp,
          color: AppColors.textGreyShade500,
        ),
      ],
    );
  }
}

