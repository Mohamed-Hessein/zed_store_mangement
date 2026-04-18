import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_styles.dart';
import '../../domain/entities/order_item_entity.dart';

class OrderedItemsList extends StatelessWidget {
  final List<OrderItemEntity> items;

  const OrderedItemsList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Order Items', style: AppStyles.text16bold),
        SizedBox(height: 16.h),
        ...List.generate(
          items.length,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: _buildItemCard(items[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildItemCard(OrderItemEntity item) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderLight, width: 1),
      ),
      child: Row(
        children: [

          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: AppColors.backgroundSearch,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: item.imageUrl != null
                ? Image.network(
                    item.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.image_not_supported, color: AppColors.iconGrey),
                  )
                : Icon(Icons.shopping_bag, color: AppColors.iconGrey),
          ),
          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: AppStyles.text14bold,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SAR ${item.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: AppColors.primaryPurple,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppColors.primaryPurpleLight,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        'Qty: ${item.quantity}',
                        style: TextStyle(
                          color: AppColors.primaryPurple,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

