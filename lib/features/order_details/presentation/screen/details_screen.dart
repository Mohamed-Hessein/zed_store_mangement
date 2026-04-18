import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_styles.dart';
import '../../../../di.dart';
import '../../domain/entities/order_entity.dart'; 
import '../bloc/order_details_bloc.dart';
import '../bloc/order_details_event.dart';
import '../bloc/order_details_state.dart';
import '../widgets/customer_info_section.dart';
import '../widgets/order_header.dart';
import '../widgets/ordered_items_list.dart';
import '../widgets/payment_summary.dart';
import '../widgets/shipping_and_payment_section.dart';
import '../widgets/update_status_button.dart';

@RoutePage()
class DetailsScreen extends StatefulWidget implements AutoRouteWrapper {
  final String orderId;

  const DetailsScreen({super.key, required this.orderId});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<OrderDetailsBloc>()..add(FetchOrderDetailsEvent(orderId)),
      child: this,
    );
  }

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  void _fetchData() {
    context.read<OrderDetailsBloc>().add(FetchOrderDetailsEvent(widget.orderId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderDetailsBloc, OrderDetailsState>(
      listener: (context, state) {
        if (state is OrderStatusUpdated) {
          context.router.pop({
            'id': state.updatedOrder.id,
            'status': state.updatedOrder.status,
          });
        }

        if (state is OrderDetailsError) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.backgroundLight,
          appBar: _buildAppBar(),
          bottomNavigationBar: _buildBottomBar(state),
          body: _buildBody(state),
        );
      },
    );
  }

  Widget? _buildBottomBar(OrderDetailsState state) {
    OrderEntity? order;
    if (state is OrderDetailsSuccess) order = state.order;
    if (state is OrderStatusUpdating) order = state.order;
    if (state is OrderStatusUpdated) order = state.updatedOrder;

    if (order != null) {
      return Padding(
        padding: EdgeInsets.all(20.w),
        child: UpdateStatusButton(order: order),
      );
    }
    return null;
  }

  Widget _buildBody(OrderDetailsState state) {
    if (state is OrderDetailsLoading) {
      return Center(child: CircularProgressIndicator(color: AppColors.primaryPurple));
    }


    OrderEntity? order;
    if (state is OrderDetailsSuccess) order = state.order;
    if (state is OrderStatusUpdating) order = state.order;
    if (state is OrderStatusUpdated) order = state.updatedOrder;

    if (order != null) {
      return RefreshIndicator(
        onRefresh: () async => _fetchData(),
        child: SingleChildScrollView(

          key: ValueKey('${order.id}_${order.status}'),
          padding: EdgeInsets.all(20.w),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OrderHeader(order: order),
              SizedBox(height: 24.h),
              CustomerInfoSection(customer: order.customer),
              SizedBox(height: 24.h),
              OrderedItemsList(items: order.items),
              SizedBox(height: 24.h),
              PaymentSummary(order: order),
              SizedBox(height: 24.h),
              ShippingAndPaymentSection(order: order),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      );
    }

    if (state is OrderDetailsError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 50.sp, color: AppColors.error),
            SizedBox(height: 16.h),
            Text(state.message, textAlign: TextAlign.center, style: AppStyles.text14grey),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: _fetchData,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPurple),
              child: const Text('إعادة المحاولة', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    return const Center(child: Text('لا توجد بيانات متاحة'));
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.backgroundLight,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: AppColors.textDark),
        onPressed: () => context.router.maybePop(true), 
      ),
      title: Text('تفاصيل الطلب', style: AppStyles.text20purple),
      centerTitle: false,
    );
  }
}
