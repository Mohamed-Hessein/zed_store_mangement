import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyStateView extends StatelessWidget {
  const EmptyStateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.cube_box,
            size: 48.sp,
            color: const Color(0xFFE0E0E0),
          ),
          SizedBox(height: 12.h),
          Text(
            'No products found',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF999999),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Try adjusting your filters or search',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFFCCCCCC),
            ),
          ),
        ],
      ),
    );
  }
}

