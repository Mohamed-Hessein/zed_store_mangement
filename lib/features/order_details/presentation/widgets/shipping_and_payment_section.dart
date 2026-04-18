import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_styles.dart';
import '../../domain/entities/order_entity.dart';

class ShippingAndPaymentSection extends StatelessWidget {
  final OrderEntity order;

  const ShippingAndPaymentSection({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Shipping & Payment Details', style: AppStyles.text16bold),
        SizedBox(height: 16.h),

        _buildInfoCard(
          title: 'Shipping Address',
          icon: Icons.location_on_outlined,
          content: order.shippingAddress.fullAddress,
        ),
        SizedBox(height: 12.h),

        _buildInfoCard(
          title: 'Payment Method',
          icon: Icons.credit_card_outlined,
          content: order.paymentMethod,
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required String content,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderLight, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18.sp, color: AppColors.primaryPurple),
              SizedBox(width: 8.w),
              Text(title, style: AppStyles.text13bold),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            content,
            style: TextStyle(
              color: AppColors.textGrey,
              fontSize: 12.sp,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

