import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zed_store_mangent/core/resources/app_colors.dart';

enum StockStatus {
  inStock,
  lowStock,
  outOfStock,
}

class StockStatusBadge extends StatelessWidget {
  final String status;
  final StockStatus type;

  const StockStatusBadge({
    super.key,
    required this.status,
    required this.type,
  });

  Color _getBackgroundColor() {
    switch (type) {
      case StockStatus.inStock:
        return const Color(0xFFE8F5E9); 
      case StockStatus.lowStock:
        return const Color(0xFFFFF3E0); 
      case StockStatus.outOfStock:
        return const Color(0xFFFFEBEE); 
    }
  }

  Color _getTextColor() {
    switch (type) {
      case StockStatus.inStock:
        return const Color(0xFF2E7D32);
      case StockStatus.lowStock:
        return const Color(0xFFE65100);
      case StockStatus.outOfStock:
        return AppColors.statusDeleteRed; 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: _getTextColor(),
        ),
      ),
    );
  }
}
