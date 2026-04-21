import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/resources/hive_helper.dart' show HiveCacheHelper;
import '../../../../core/resources/internet_checker.dart';
import '../../../../di.dart';
import '../../../order_details/data/models/order_model.dart';
import '../../domian/usecase/order_usecase.dart';
import 'order_event.dart';
import 'order_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart'; // المكتبة الجديدة

import '../../../../core/resources/hive_helper.dart' show HiveCacheHelper;
import '../../../../core/resources/internet_checker.dart';
import '../../../../di.dart';
import '../../../order_details/data/models/order_model.dart';
import '../../domian/usecase/order_usecase.dart';
import 'order_event.dart';
import 'order_states.dart';

@injectable
class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final GetOrdersUseCase getOrdersUseCase;

  OrdersBloc(this.getOrdersUseCase) : super(const OrdersState()) {

    on<FetchOrdersEvent>((event, emit) async {

     if (state.isPaginating || (event.isLoadMore && !state.hasMore)) return;

      try {
        final int pageToFetch = event.isLoadMore ? state.currentPage : 1;

        if (event.isLoadMore) {
           emit(state.copyWith(isPaginating: true));
        } else {

          final cachedData = await HiveCacheHelper.getData<dynamic>(
            boxName: HiveCacheHelper.ordersBoxName,
            key: 'all_orders',
          );

          if (cachedData is List) {
            final List<OrderModel> orders = cachedData.map((e) => e as OrderModel).toList();
            emit(state.copyWith(
              status: OrdersRequestStatus.success,
              orders: orders,
              currentPage: 1,
              hasMore: true,
            ));
          } else {
            emit(state.copyWith(
                status: OrdersRequestStatus.loading,
                currentPage: 1,
                hasMore: true
            ));
          }
        }

         if (!getIt<InternetConnectivity>().isConnected) {
          emit(state.copyWith(isPaginating: false));
          return;
        }
   final result = await getOrdersUseCase.call(event.searchQuery, page: pageToFetch);

        result.fold(
              (failure) {
            emit(state.copyWith(
              status: event.isLoadMore ? OrdersRequestStatus.success : OrdersRequestStatus.error,
              isPaginating: false,
              errorMessage: failure.toString(),
            ));
          },
              (newOrdersList) {
             final bool hasMore = newOrdersList.length >= 3;

             final List<OrderModel> updatedList = event.isLoadMore
                ? [...(state.orders ?? []), ...newOrdersList]
                : newOrdersList;
    if (!event.isLoadMore) {
              HiveCacheHelper.saveData<List<OrderModel>>(
                boxName: HiveCacheHelper.ordersBoxName,
                key: 'all_orders',
                value: updatedList,
              );
            }

            emit(state.copyWith(
              status: OrdersRequestStatus.success,
              orders: updatedList,
              isPaginating: false,
              currentPage: pageToFetch + 1,
              hasMore: hasMore,
            ));
          },
        );
      } catch (e) {
        emit(state.copyWith(
          status: OrdersRequestStatus.error,
          isPaginating: false,
          errorMessage: e.toString(),
        ));
      }
    },
      transformer: droppable(),  );

    on<UpdateOrdersLocalStatus>((event, emit) {
      if (state.orders != null) {
        final updatedList = state.orders!.map((order) {
          if (event.ids.contains(order.id) || event.ids.contains(order.transactionId)) {
            return order.copyWith(status: event.newStatus);
          }
          return order;
        }).toList();

        emit(state.copyWith(
          orders: List.from(updatedList),
          status: OrdersRequestStatus.success,
        ));
      }
    });
  }
}