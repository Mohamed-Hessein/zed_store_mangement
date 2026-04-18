import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zed_store_mangent/core/resources/app_colors.dart';
import 'package:zed_store_mangent/core/resources/app_string.dart';
import 'package:zed_store_mangent/core/resources/app_styles.dart';
import 'package:zed_store_mangent/di.dart';
import '../../../../core/resources/app_strings.dart';
import '../bloc/products_bloc.dart';
import '../bloc/product_events.dart';
import '../bloc/product_states.dart';
import '../widgets/ask_ai_fab.dart';
import '../widgets/category_filter_tabs.dart';
import '../widgets/product_card.dart';
import '../widgets/product_search_bar.dart';
import '../widgets/inventory_header.dart';
import '../widgets/product_shimmer.dart';

@RoutePage()
class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final ScrollController _scrollController = ScrollController();

  late ProductsBloc _productsBloc;

  @override
  void initState() {
    super.initState();

    _productsBloc = getIt<ProductsBloc>()..add(GetProducts());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  void _onScroll() {
    final state = _productsBloc.state; 

    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9) {

      if (state.status != ProductRequestStatus.loading && state.hasMore) {
        _productsBloc.add(GetProducts(isLoadMore: true));
      }
    }

  }

  @override
  Widget build(BuildContext context) {

    return BlocProvider.value(
      value: _productsBloc,
      child: Scaffold(
        extendBody: true,
        backgroundColor: AppColors.backgroundPageGrey,
        appBar: _buildAppBar(context),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              SizedBox(height: 16.h),
              const InventoryHeader(),
              SizedBox(height: 12.h),
              ProductSearchBar(),



              SizedBox(height: 16.h),
              Expanded(
                child: BlocBuilder<ProductsBloc, ProductState>(
                  builder: (context, state) {
                    final results = state.products?.results ?? [];


                    if (state.status == ProductRequestStatus.loading && results.isEmpty) {
                      return const InventoryShimmer();
                    }

                    if (results.isEmpty && state.status != ProductRequestStatus.loading) {
                      return Center(child: Text('No products found', style: AppStyles.text14grey));
                    }

                    return RefreshIndicator(
                      color: AppColors.primaryPurple,
                      onRefresh: () async {
                        _productsBloc.add(GetProducts());
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),

                        itemCount: state.hasMore ? results.length + 1 : results.length,
                        itemBuilder: (context, index) {
                          if (index >= results.length) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                            );
                          }

                          final product = results[index];
                          return ProductCard(key: ValueKey(product.id), product: product);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: BlocBuilder<ProductsBloc, ProductState>(
          builder: (context, state) {
            return AskAiFab(products: state.products?.results ?? [], orders: state.orders ?? [],);
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.backgroundWhite,
      elevation: 0,

      title: Text(AppStrings.inventoryManagement, style: AppStyles.text16PurpleBold),

    );
  }
}
