import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_styles.dart';
import '../../domain/entities/order_entity.dart';

class BulkUpdateSheet extends StatefulWidget {
  final List<OrderEntity> orders;
  final Function(String newStatus, List<String> ids) onUpdateAll;

  const BulkUpdateSheet({
    super.key,
    required this.orders,
    required this.onUpdateAll
  });

  @override
  State<BulkUpdateSheet> createState() => _BulkUpdateSheetState();
}

class _BulkUpdateSheetState extends State<BulkUpdateSheet> {
  String? _selectedStatus; 

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('مراجعة المسح المتعدد', style: AppStyles.text20purple),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text('${widget.orders.length} طلبات',
                    style: TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          SizedBox(height: 20.h),


          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 280.h),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: widget.orders.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) => _buildOrderTile(widget.orders[index]),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Divider(color: Colors.grey.shade200, thickness: 1),
          ),


          Text('تطبيق حالة جديدة على الكل:', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 10.h),
          _buildStatusDropdown(),

          SizedBox(height: 24.h),


          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedStatus == null ? Colors.grey.shade400 : AppColors.primaryPurple,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
              ),
              onPressed: _selectedStatus == null
                  ? null
                  : () {
                final ids = widget.orders.map((e) => e.id).toList();
                widget.onUpdateAll(_selectedStatus!, ids);

              },
              child: Text(
                'تحديث ${widget.orders.length} طلبات الآن',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 10.h), 
        ],
      ),
    );
  }

  Widget _buildOrderTile(OrderEntity order) {

    final bool hasItems = order.items.isNotEmpty;
    final String? imageUrl = hasItems ? order.items.first.imageUrl : null;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: (imageUrl != null && imageUrl.isNotEmpty)
                ? Image.network(
              imageUrl,
              width: 45.w,
              height: 45.w,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _buildPlaceholderIcon(),
            )
                : _buildPlaceholderIcon(),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('طلب #${order.id}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
                Text('الحالة: ${order.status}', style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
              ],
            ),
          ),
          Icon(Icons.check_circle_rounded, color: const Color(0xFF8B5CF6), size: 20.sp),
        ],
      ),
    );
  }


  Widget _buildPlaceholderIcon() {
    return Container(
      width: 45.w,
      height: 45.w,
      color: Colors.grey.shade200,
      child: Icon(Icons.inventory_2_outlined, color: Colors.grey, size: 24.sp),
    );
  }

  Widget _buildStatusDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedStatus,
      hint: const Text('اضغط لاختيار الحالة الجديدة'),
      isExpanded: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
      ),
      items: const [
        DropdownMenuItem(value: 'preparing', child: Text('قيد التجهيز')),
        DropdownMenuItem(value: 'ready', child: Text('جاهز للشحن')),
        DropdownMenuItem(value: 'indelivery', child: Text('جاري التوصيل')),
        DropdownMenuItem(value: 'delivered', child: Text('تم التوصيل ✅')),
      ],
      onChanged: (v) => setState(() => _selectedStatus = v),
    );
  }
}
