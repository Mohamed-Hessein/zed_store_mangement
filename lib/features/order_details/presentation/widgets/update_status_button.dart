import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/app_colors.dart';
import '../../domain/entities/order_entity.dart';
import '../bloc/order_details_bloc.dart';
import '../bloc/order_details_event.dart';
import '../bloc/order_details_state.dart';

class UpdateStatusButton extends StatefulWidget {
  final OrderEntity order;
  const UpdateStatusButton({super.key, required this.order});

  @override
  State<UpdateStatusButton> createState() => _UpdateStatusButtonState();
}

class _UpdateStatusButtonState extends State<UpdateStatusButton> {
  String? _selectedStatus;

  String _mapServerStatusToLocal(String status) {
    String s = status.toLowerCase().trim();
    if (s.contains('إلغاء') || s.contains('ملغي') || s.contains('cancelled')) return 'cancelled';
    if (s.contains('جديد') || s.contains('new')) return 'new';
    if (s.contains('تجهيز') || s.contains('preparing')) return 'preparing';
    if (s.contains('شحن') || s.contains('ready')) return 'ready';
    if (s.contains('توصيل') || s.contains('delivery')) return 'indelivery';
    if (s.contains('تم التوصيل') || s.contains('delivered')) return 'delivered';
    return 'new';
  }

  @override
  void initState() {
    super.initState();
    _selectedStatus = _mapServerStatusToLocal(widget.order.status);
  }

  @override
  void didUpdateWidget(UpdateStatusButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.order.status != widget.order.status) {
      setState(() {
        _selectedStatus = _mapServerStatusToLocal(widget.order.status);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> statuses = ['new', 'preparing', 'ready', 'indelivery', 'delivered', 'cancelled'];
    final String currentStatus = _mapServerStatusToLocal(widget.order.status);

    return BlocConsumer<OrderDetailsBloc, OrderDetailsState>(

      listener: (context, state) {
        if (state is OrderDetailsSuccess || state is OrderStatusUpdated) {







          Future.delayed(const Duration(milliseconds: 300), () {
            context.router.pop({
              'id': widget.order.id,
              'status': _getStatusDisplayName(_selectedStatus ?? currentStatus),
            });});

        }
        },
      builder: (context, state) {
        final String safeValue = statuses.contains(_selectedStatus)
            ? _selectedStatus!
            : statuses.first;

        final bool isOrderFinished = currentStatus == 'cancelled' || currentStatus == 'delivered';
        final bool isLoading = state is OrderStatusUpdating;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: safeValue,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: 'تحديث حالة الطلب',
                labelStyle: TextStyle(color: AppColors.primaryPurple, fontSize: 14.sp),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                filled: true,
                fillColor: isOrderFinished ? Colors.grey.shade100 : Colors.transparent,
              ),
              onChanged: (isOrderFinished || isLoading) ? null : (v) => setState(() => _selectedStatus = v),
              items: statuses.map((s) => DropdownMenuItem(
                  value: s,
                  child: Text(_getStatusDisplayName(s),
                      style: TextStyle(
                        color: s == currentStatus ? AppColors.primaryPurple : Colors.black87,
                        fontWeight: s == currentStatus ? FontWeight.bold : FontWeight.normal,
                      ))
              )).toList(),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isOrderFinished ? Colors.grey : AppColors.primaryPurple,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                onPressed: (isOrderFinished || _selectedStatus == currentStatus || isLoading)
                    ? null
                    : () {
                  context.read<OrderDetailsBloc>().add(
                    UpdateOrderStatusEvent(widget.order.id, _selectedStatus!),
                  );
                },
                child: isLoading
                    ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                )
                    : const Text(
                  'تحديث الحالة الآن',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String _getStatusDisplayName(String status) {
    switch (status) {
      case 'new': return 'طلب جديد';
      case 'preparing': return 'قيد التجهيز';
      case 'ready': return 'جاهز للشحن';
      case 'indelivery': return 'جاري التوصيل';
      case 'delivered': return 'تم التوصيل ✅';
      case 'cancelled': return 'ملغي ❌';
      default: return status;
    }
  }
}
