import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_styles.dart';
import '../../domain/entities/order_entity.dart';

class OrderHeader extends StatelessWidget {
  final OrderEntity order;

  const OrderHeader({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '#${order.transactionId}',
                style: AppStyles.text18purple.copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 4.h),
              Text(_formatDate(order.createdAt), style: AppStyles.text12grey),
            ],
          ),
        ),
        _buildStatusBadge(),
      ],
    );
  }

  Widget _buildStatusBadge() {
    final (bgColor, textColor, display) = _getStatusStyle();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        display,
        style: TextStyle(
          color: textColor,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  (Color, Color, String) _getStatusStyle() {
    return switch (order.status.toLowerCase()) {
      'pending' => (AppColors.statusPendingBg, AppColors.statusPendingText, 'Pending'),
      'processing' => (AppColors.statusProcessingBg, AppColors.statusProcessingText, 'Processing'),
      'shipped' => (AppColors.statusShippedBg, AppColors.statusShippedText, 'Shipped'),
      'delivered' => (AppColors.statusShippedBg, AppColors.statusShippedText, 'Delivered'),
      _ => (AppColors.statusPendingBg, AppColors.statusPendingText, order.status),
    };
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

