import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zed_store_mangent/core/resources/app_colors.dart';
import 'package:zed_store_mangent/core/resources/auto_route.gr.dart';

import '../../../../di.dart';

import '../../../order_details/data/models/order_model.dart';
import '../../../order_details/domain/entities/order_entity.dart';
import '../../../order_details/presentation/bloc/order_details_bloc.dart';
import '../../../order_details/presentation/bloc/order_details_event.dart';
import '../../../order_details/presentation/bloc/order_details_state.dart';
import '../../../order_details/presentation/widgets/Bulk_Update_Sheet.dart';
import '../../../shared/presentation/pages/qr_display_screen.dart';

import '../bloc/order_bloc.dart';
import '../bloc/order_event.dart';
import '../bloc/order_states.dart';
import '../widget/RecentActivityHeader.dart';
import '../widget/custom_appBAr.dart';
import '../widget/order_lsit.dart';
import '../widget/order_shimmer.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<OrdersBloc>()..add(FetchOrdersEvent()),
        ),
        BlocProvider(
          create: (context) => getIt<OrderDetailsBloc>(),
        ),
      ],
      child: BlocListener<OrderDetailsBloc, OrderDetailsState>(
        listener: (context, state) {


          if (state is OrderStatusUpdated || state is OrderDetailsBulkSuccess) {
            context.read<OrdersBloc>().add(FetchOrdersEvent());


            if (state is OrderStatusUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم تحديث حالة الطلب')),
              );
            }
          }
        },
        child: BlocBuilder<OrdersBloc, OrdersState>(
          builder: (context, state) {
            if(state is OrderDetailsLoading|| state.status == OrdersRequestStatus.loading){
              return OrderShimmerLoading();
            }
            final orders = state.orders ?? [];
            return Scaffold(
              backgroundColor: AppColors.backgroundLight,
              appBar: const CustomAppBar(),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    const SearchBarWidget(),
                    const RecentActivityHeader(),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          if (state.status == OrdersRequestStatus.loading && orders.isEmpty) {
                            return Center(child: CircularProgressIndicator(color: AppColors.primaryPurple));
                          }
                          if (orders.isEmpty && state.status != OrdersRequestStatus.loading) {
                            return const EmptyOrdersWidget();
                          }
                          return OrdersListView(orders: orders);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: HomeFab(orders: orders),
            );
          },
        ),
      ),
    );
  }
}

class HomeFab extends StatefulWidget {
  final List<OrderModel> orders;
  const HomeFab({super.key, required this.orders});

  @override
  State<HomeFab> createState() => _HomeFabState();
}

class _HomeFabState extends State<HomeFab> {
  List<OrderModel> scannedOrders = [];

  Future<void> _startMultiScan(int count) async {
    final List<String>? scannedResults = await Navigator.push<List<String>>(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) => QRScannerScreen(multiScanCount: count),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );

    if (scannedResults != null && scannedResults.isNotEmpty) {
      scannedOrders = [];
      for (var code in scannedResults) {
        String cleanCode = code.trim().split('/').last;
        try {
          final order = widget.orders.firstWhere(
                (o) => o.id == cleanCode || o.transactionId == cleanCode,
          );
          scannedOrders.add(order);
        } catch (e) {
          debugPrint("Order not found: $cleanCode");
        }
      }

      if (scannedOrders.isNotEmpty) {
        _showBulkSheet();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('لم يتم العثور على طلبات مطابقة'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _showBulkSheet() {

    final List<OrderEntity> entityList = scannedOrders.map((model) => model as OrderEntity).toList();

    final orderDetailsBloc = context.read<OrderDetailsBloc>();
    final ordersBloc = context.read<OrdersBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24.r))),
      builder: (sheetContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: orderDetailsBloc),
          BlocProvider.value(value: ordersBloc),
        ],
        child: BulkUpdateSheet(
          orders: entityList,
          onUpdateAll: (newStatus, ids) {

            ordersBloc.add(UpdateOrdersLocalStatus(ids, newStatus));


            orderDetailsBloc.stream.firstWhere(
                  (state) => state is OrderDetailsBulkSuccess,
            ).then((_) {
              if (mounted) {
                context.read<OrdersBloc>().add(FetchOrdersEvent());
              }
            });


            orderDetailsBloc.add(UpdateMultipleOrdersStatusEvent(
              orders: entityList,
              orderIds: ids,
              newStatus: newStatus,
            ));


            Navigator.pop(context);


            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('جاري تحديث ${ids.length} طلبات...'),
                backgroundColor: AppColors.primaryPurple,
                duration: const Duration(seconds: 1),
              ),
            );
          },     ),
      ),
    );
  }

  void _showMultiScanDialog() {
    final TextEditingController countController = TextEditingController();
    showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('المسح المتعدد'),
        content: TextFormField(
          controller: countController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'عدد الطلبات'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, int.tryParse(countController.text)),
            child: const Text('ابدأ'),
          ),
        ],
      ),
    ).then((value) {
      if (value != null && value > 0) _startMultiScan(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onLongPress: _showMultiScanDialog,
          child: FloatingActionButton(
            heroTag: "scan_btn",
            backgroundColor: AppColors.primaryPurple,
              onPressed: () async {
                final String? code = await Navigator.push(
                  context,
                  PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (context, _, __) => const QRScannerScreen(),
                  ),
                );

                if (code != null) {
                  String cleanCode = code.trim().split('/').last;


                  final result = await context.pushRoute(
                    DetailsRoute(orderId: cleanCode),
                  );







                  if (result is Map && mounted) {
                    final String id = result['id'];
                    final String newStatus = result['status'];

                    context.read<OrdersBloc>().add(
                      UpdateOrdersLocalStatus([id], newStatus),
                    );
                  }
                }},    child: const Icon(Icons.qr_code_scanner, color: Colors.white),
          ),
        ),
        SizedBox(height: 15.h),
        FloatingActionButton(
          heroTag: "refresh_btn",
          backgroundColor: AppColors.primaryPurple,
          onPressed: () => context.read<OrdersBloc>().add(FetchOrdersEvent()),
          child: const Icon(Icons.refresh, color: Colors.white),
        ),
      ],
    );
  }
}

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
late TextEditingController searchController;
  @override
  initState() {
    super.initState();
    searchController = TextEditingController();
  }
  Widget build(BuildContext context) {
    return Container(
      height: 55.h,
      margin: EdgeInsets.symmetric(vertical: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.backgroundLightGrey,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        children: [
          Icon(CupertinoIcons.search, color: AppColors.textGreyShade600, size: 22.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: TextField(
              onChanged: (value){

                final trimmedValue = value.trim();


                if (mounted) {
                  context.read<OrdersBloc>().add(
                    FetchOrdersEvent(
                      searchQuery: trimmedValue, 
                      isLoadMore: false,
                    ),
                  );
                }
              },
              controller: searchController,
              decoration: const InputDecoration(
                hintText: "Search orders...",
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
