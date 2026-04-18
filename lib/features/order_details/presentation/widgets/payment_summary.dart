import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_styles.dart';
import '../../domain/entities/order_entity.dart';

class PaymentSummary extends StatelessWidget {
  final OrderEntity order;

  const PaymentSummary({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payment Summary', style: AppStyles.text16bold),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.backgroundCard,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.borderLight, width: 1),
          ),
          child: Column(
            children: [
              _buildSummaryRow('Subtotal', 'SAR ${order.subtotal.toStringAsFixed(2)}'),
              SizedBox(height: 12.h),
              _buildSummaryRow('Shipping Cost', 'SAR ${order.shippingCost.toStringAsFixed(2)}'),
              SizedBox(height: 12.h),
              _buildSummaryRow('VAT (15%)', 'SAR ${order.vatAmount.toStringAsFixed(2)}'),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Divider(
                  color: AppColors.borderLight,
                  thickness: 1,
                ),
              ),
              _buildSummaryRow(
                'Total Amount',
                'SAR ${order.grandTotal.toStringAsFixed(2)}',
                isTotal: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? AppStyles.text14bold
              : TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 13.sp,
                ),
        ),
        Text(
          value,
          style: isTotal
              ? TextStyle(
                  color: AppColors.primaryPurple,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                )
              : TextStyle(
                  color: AppColors.textDark,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
        ),
      ],
    );
  }
}

