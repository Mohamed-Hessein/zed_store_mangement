import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zed_store_mangent/core/resources/app_colors.dart';
import 'package:zed_store_mangent/core/resources/app_styles.dart';
import '../../../../core/resources/app_strings.dart';
import '../../data/model/product_model.dart';
import '../bloc/products_bloc.dart';
import '../bloc/product_events.dart';
import 'stock_status_badge.dart';

class ProductCard extends StatelessWidget {
  final Results product;
  const ProductCard({super.key, required this.product});

  String _getProductName() {
    if (product.name == null) return '';
    if (product.name is Map) {
      return product.name['ar'] ?? product.name['en'] ?? '';
    }
    return product.name.toString();
  }

  StockStatus _getStockStatus() {
    if (product.isInfinite == true) return StockStatus.inStock;
    final qty = product.quantity ?? 0;
    if (qty == 0) return StockStatus.outOfStock;
    if (qty <= 5) return StockStatus.lowStock;
    return StockStatus.inStock;
  }

  String _getStockStatusText() {
    if (product.isInfinite == true) return AppStrings.inStock;
    final qty = product.quantity ?? 0;
    return qty == 0 ? AppStrings.outOfStock : '$qty ${AppStrings.inStock}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProductImage(imageUrl: product.images?.isNotEmpty == true ? product.images![0].image?.medium : null),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        _getProductName(),
                        style: AppStyles.text14DarkBold.copyWith(fontSize: 15.sp),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _ProductActions(
                      onEditPressed: () => _showEditBottomSheet(context),
                      onAiPressed: () {},
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  '${product.price ?? 0.0} ${product.currency ?? "SAR"}',
                  style: AppStyles.text16PurpleBold.copyWith(
                    color: AppColors.primaryPurple,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 12.h),
                StockStatusBadge(
                  status: _getStockStatusText(),
                  type: _getStockStatus(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditBottomSheet(BuildContext parentContext) {
    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => BlocProvider.value(
        value: parentContext.read<ProductsBloc>(),
        child: EditProductBottomSheet(product: product),
      ),
    );
  }
}
class EditProductBottomSheet extends StatefulWidget {
  final Results product;
   EditProductBottomSheet({required this.product});

  @override
  State<EditProductBottomSheet> createState() => _EditProductBottomSheetState();
}

class _EditProductBottomSheetState extends State<EditProductBottomSheet> {
  late TextEditingController _priceController;
  late TextEditingController _quantityController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController(text: widget.product.price?.toString() ?? '0.0');
    _quantityController = TextEditingController(text: (widget.product.quantity ?? 0).toString());
  }


  String _getProductName() {
    if (widget.product.name == null) return '';
    if (widget.product.name is Map) {
      return widget.product.name['ar'] ?? widget.product.name['en'] ?? '';
    }
    return widget.product.name.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      padding: EdgeInsets.only(
        left: 24.w,
        right: 24.w,
        top: 12.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 30.h,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 45.w, height: 4.5.h, decoration: BoxDecoration(color: const Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(10.r)))),
            SizedBox(height: 25.h),
            Text("Update Inventory", style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w800, color: const Color(0xFF1A1A1A))),
            SizedBox(height: 6.h),
            Text(
              "${widget.product.sku ?? 'ZID-0000'} • ${_getProductName()}", 
              style: TextStyle(fontSize: 14.sp, color: Colors.black54, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 30.h),
            _buildFieldLabel(AppStrings.updatePrice),
            _buildCustomField(controller: _priceController, icon: Icons.account_balance_wallet_outlined, hint: "450.00"),
            SizedBox(height: 25.h),
            _buildFieldLabel(AppStrings.updateStock),
            _buildCustomField(controller: _quantityController, icon: Icons.inventory_2_outlined, hint: "12"),
            SizedBox(height: 35.h),
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleUpdate,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPurple, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.r)), elevation: 0),
                child: _isLoading
                    ? SizedBox(height: 24.h, width: 24.h, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save_outlined, color: Colors.white, size: 22.sp),
                    SizedBox(width: 10.w),
                    const Text(AppStrings.saveChanges, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleUpdate() {
    final newPrice = double.tryParse(_priceController.text) ?? 0.0;
    final newStock = int.tryParse(_quantityController.text) ?? 0;

    if (newPrice <= 0 || newStock < 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter valid values')));
      return;
    }


    String nameAr = widget.product.name is Map ? widget.product.name['ar'] ?? '' : widget.product.name?.toString() ?? '';
    String nameEn = widget.product.name is Map ? widget.product.name['en'] ?? '' : widget.product.name?.toString() ?? '';


    context.read<ProductsBloc>().add(updateProduct(
      product: widget.product,
      price: newPrice,
      stock: newStock,
      salePrice: newPrice,
      nameAr: nameAr,
      nameEn: nameEn,
    ));


    Navigator.pop(context);
  }
  Widget _buildFieldLabel(String label) => Padding(padding: EdgeInsets.only(bottom: 10.h, left: 4.w), child: Text(label, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: const Color(0xFF4A4A4A))));

  Widget _buildCustomField({required TextEditingController controller, required IconData icon, required String hint}) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFFF1EFFF), borderRadius: BorderRadius.circular(18.r)),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: const Color(0xFF2D2D2D)),
        decoration: InputDecoration(prefixIcon: Icon(icon, color: Colors.black45, size: 22.sp), hintText: hint, border: InputBorder.none, contentPadding: EdgeInsets.symmetric(vertical: 18.h)),
      ),
    );
  }
}


class _ProductActions extends StatelessWidget {
  final VoidCallback onEditPressed;
  final VoidCallback onAiPressed;
  const _ProductActions({required this.onEditPressed, required this.onAiPressed});
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      GestureDetector(onTap: onAiPressed, child: Icon(Icons.auto_awesome_outlined, color: AppColors.primaryPurple, size: 20.sp)),
      SizedBox(width: 12.w),
      GestureDetector(onTap: onEditPressed, child: Icon(CupertinoIcons.pencil, color: const Color(0xFF2D2D2D), size: 20.sp)),
    ]);
  }
}

class _ProductImage extends StatelessWidget {
  final String? imageUrl;
  const _ProductImage({this.imageUrl});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w, height: 90.h,
      decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(16.r)),
      child: (imageUrl != null && imageUrl!.isNotEmpty)
          ? ClipRRect(borderRadius: BorderRadius.circular(16.r), child: Image.network(imageUrl!, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(CupertinoIcons.cube_box, color: Colors.grey)))
          : const Icon(CupertinoIcons.cube_box, color: Colors.grey),
    );
  }
}
