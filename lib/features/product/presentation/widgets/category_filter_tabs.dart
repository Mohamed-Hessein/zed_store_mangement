import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zed_store_mangent/core/resources/app_colors.dart';
import 'package:zed_store_mangent/core/resources/app_string.dart';
import 'package:zed_store_mangent/core/resources/app_styles.dart';

import '../../../../core/resources/app_strings.dart';

enum FilterCategory {
  all,
  lowStock,
  outOfStock,
}

class FilterTabs extends StatelessWidget {
  const FilterTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterTab(label: AppStrings.allProducts, isSelected: true),
          SizedBox(width: 12.w),
          _FilterTab(label: AppStrings.lowStock, isSelected: false),
          SizedBox(width: 12.w),
          _FilterTab(label: AppStrings.outOfStock, isSelected: false),
        ],
      ),
    );
  }
}

class _FilterTab extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _FilterTab({
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryPurple : AppColors.inputBackgroundGrey,
        borderRadius: BorderRadius.circular(20.r),
        border: isSelected
            ? null
            : Border.all(color: AppColors.inputBorderGrey, width: 1),
      ),
      child: Text(
        label,
        style: AppStyles.text12DarkMedium.copyWith(
          color: isSelected ? AppColors.white : AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

