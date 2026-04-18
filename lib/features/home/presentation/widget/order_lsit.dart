import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zed_store_mangent/core/resources/app_colors.dart';
import 'package:zed_store_mangent/core/resources/auto_route.gr.dart';

import '../../../order_details/data/models/order_model.dart';
import '../bloc/order_bloc.dart';
import '../bloc/order_event.dart';
import '../bloc/order_states.dart'; 
import 'OrderCard.dart';

class OrdersListView extends StatefulWidget {
  final List<OrderModel> orders;
  const OrdersListView({super.key, required this.orders});

  @override
  State<OrdersListView> createState() => _OrdersListViewState();
}

class _OrdersListViewState extends State<OrdersListView> {

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {

    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9) {
      context.read<OrdersBloc>().add(FetchOrdersEvent(isLoadMore: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {

        final allOrders = state.orders ?? widget.orders;

        return RefreshIndicator(
          color: AppColors.primaryPurple,
          onRefresh: () async => context.read<OrdersBloc>().add(FetchOrdersEvent()),
          child: ListView.builder(
            controller: _scrollController, 
            padding: EdgeInsets.only(bottom: 20.h),

            itemCount: state.hasMore ? allOrders.length + 1 : allOrders.length,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {

              if (index >= allOrders.length) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                );
              }

              final order = allOrders[index];
              return GestureDetector(
                onTap: () async {
                  await context.pushRoute(DetailsRoute(orderId: order.id));
                  if (context.mounted) {
                    context.read<OrdersBloc>().add(FetchOrdersEvent());
                  }
                },
                child: OrderCard(
                  id: "#${order.id}",
                  name: order.customer.name,
                  date: _formatDate(order.createdAt),
                  status: order.status,
                  amount: "${order.grandTotal} ${order.paymentMethod ?? 'SAR'}",
                ),
              );
            },
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}

class EmptyOrdersWidget extends StatelessWidget {
  const EmptyOrdersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primaryPurple,
      onRefresh: () async => context.read<OrdersBloc>().add(FetchOrdersEvent()),
      child: ListView(
        children: [
          SizedBox(height: 150.h),
          Center(
            child: Column(
              children: [
                Icon(
                  CupertinoIcons.doc_text,
                  size: 50.sp,
                  color: AppColors.textGreyShade500,
                ),
                SizedBox(height: 10.h),
                Text(
                  "لا توجد طلبات حالياً",
                  style: TextStyle(color: AppColors.textGreyShade600, fontSize: 14.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
