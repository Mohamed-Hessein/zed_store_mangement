import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zed_store_mangent/core/resources/app_colors.dart';
import 'package:zed_store_mangent/core/resources/app_string.dart';
import 'package:zed_store_mangent/core/resources/app_styles.dart';
import 'package:zed_store_mangent/features/product/presentation/bloc/products_bloc.dart';
import '../../../../core/resources/app_strings.dart';
import '../bloc/product_events.dart';


class ProductSearchBar extends StatefulWidget {
  const ProductSearchBar({super.key});

  @override
  State<ProductSearchBar> createState() => _ProductSearchBarState();
}

class _ProductSearchBarState extends State<ProductSearchBar> {

  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {

    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: AppColors.inputBackgroundGrey,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.inputBorderGrey, width: 1),
      ),
      child: TextField(
        controller: searchController,
        onChanged: (value) {



            final trimmedValue = value.trim();


            if (mounted) {
              context.read<ProductsBloc>().add(
                GetProducts(
                  searchQuery: trimmedValue, 
                  isLoadMore: false,
                ),
              );
            }

        },
        decoration: InputDecoration(
          hintText: AppStrings.filterByNameOrSku,
          hintStyle: AppStyles.text12grey.copyWith(
            color: AppColors.textGreyShade500,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 12.w, right: 8.w),
            child: Icon(
              CupertinoIcons.search,
              size: 18.sp,
              color: AppColors.textGreyShade500,
            ),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14.h),
        ),
        style: AppStyles.text14bold.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
