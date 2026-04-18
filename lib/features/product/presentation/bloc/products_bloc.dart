import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zed_store_mangent/features/product/domain/usecase/product_usecaswe.dart';
import 'package:zed_store_mangent/features/product/presentation/bloc/product_events.dart';
import 'package:zed_store_mangent/features/product/presentation/bloc/product_states.dart';
import '../../data/model/product_model.dart';

@injectable
class ProductsBloc extends Bloc<ProductEvents, ProductState> {
  final ProductUsecase productUsecase;
  Timer? _debounce;


  ProductsBloc(this.productUsecase) : super(ProductState(products: ProductResponse(results: const []))) {

    on<GetProducts>((event, emit) async {
      if (event.isLoadMore && (!state.hasMore || state.isPaginating)) return;

      if (!event.isLoadMore && event.searchQuery != null && event.searchQuery!.isNotEmpty) {
        if (_debounce?.isActive ?? false) _debounce!.cancel();
        final Completer<void> completer = Completer<void>();
        _debounce = Timer(const Duration(milliseconds: 500), () => completer.complete());
        await completer.future;
      }

      try {
        if (event.isLoadMore) {
          emit(state.copyWith(isPaginating: true));
        } else {

          emit(state.copyWith(
            status: ProductRequestStatus.loading,
            currentPage: 1,
            hasMore: true,
          ));
        }

        final int pageToFetch = event.isLoadMore ? state.currentPage : 1;
        final res = await productUsecase.callProduct(
          event.searchQuery,
          page: pageToFetch,
          pageSize: 10,
        );

        final List<Results> newResults = res.results ?? [];
        final bool hasMore = newResults.length >= 10;

        List<Results> updatedList;
        if (event.isLoadMore) {
          updatedList = List.from(state.products?.results ?? [])..addAll(newResults);
        } else {
          updatedList = newResults;
        }

        emit(state.copyWith(
          status: ProductRequestStatus.success,
          isPaginating: false,
          products: ProductResponse(results: updatedList),
          currentPage: pageToFetch + 1,
          hasMore: hasMore,
        ));
      } catch (e) {
        emit(state.copyWith(
          status: ProductRequestStatus.error,
          isPaginating: false,
          errorMessage: e.toString(),
        ));
      }
    });

    on<updateProduct>((event, emit) async {
      try {
        final currentProducts = state.products?.results ?? [];
        final updatedList = currentProducts.map((p) {
          if (p.id == event.product.id) {
            p.price = double.tryParse(event.price.toString());
            p.quantity = int.tryParse(event.stock.toString());
            return p;
          }
          return p;
        }).toList();


        emit(state.copyWith(
          status: ProductRequestStatus.success,
          products: ProductResponse(results: updatedList),
          changeNotifier: DateTime.now().toString(),
        ));

        await productUsecase.callUpdate(
          nameAr: event.nameAr,
          nameEn: event.nameEn,
          product: event.product,
          newQuantity: event.stock,
          newPrice: event.price,
        );

        emit(state.copyWith(
          status: ProductRequestStatus.updateSuccess,
          changeNotifier: DateTime.now().toString(),
        ));
      } catch (e) {
        add(GetProducts()); 
        emit(state.copyWith(
          status: ProductRequestStatus.updateError,
          errorMessage: e.toString(),
        ));
      }
    });
  }
}
