import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_styles.dart';
import '../../domain/entities/customer_entity.dart';

class CustomerInfoSection extends StatelessWidget {
  final CustomerEntity customer;

  const CustomerInfoSection({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Customer Information', style: AppStyles.text16bold),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.backgroundCard,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.borderLight, width: 1),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28.r,
                backgroundColor: AppColors.primaryPurple,
                backgroundImage: customer.avatarUrl != null
                    ? NetworkImage(customer.avatarUrl!)
                    : null,
                child: customer.avatarUrl == null
                    ? Text(
                        customer.name[0].toUpperCase(),
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : null,
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.name,
                      style: AppStyles.text14bold,
                    ),
                    SizedBox(height: 8.h),
                    _buildContactRow(Icons.phone, customer.phone),
                    SizedBox(height: 4.h),
                    _buildContactRow(Icons.email, customer.email),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactRow(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 14.sp, color: AppColors.iconGrey),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            value,
            style: AppStyles.text12grey,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

