import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zed_store_mangent/core/resources/app_colors.dart';
import 'package:zed_store_mangent/core/resources/app_string.dart';
import 'package:zed_store_mangent/core/resources/app_styles.dart';

import '../../../../di.dart';
import '../../../home/data/model/order_model.dart';
import '../../../shared/presentation/pages/qr_display_screen.dart';
import '../../data/model/product_model.dart';
import '../bloc/ai_bloc.dart';
import '../bloc/ai_events.dart';
import '../bloc/product_events.dart';
import '../bloc/products_bloc.dart';
import 'BulkEditProductsSheet.dart';
import 'ai_bottom_sheet.dart';


class AskAiFab extends StatelessWidget {
  final List<Results> products;
  final List<OrderModel>? orders;

  const AskAiFab({super.key, required this.orders, required this.products});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        GestureDetector(
          onLongPress: () async {

            final int? maxCount = await _showScanCountDialog(context);

            if (maxCount != null) {

              final dynamic scannedResults = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QRScannerScreen(multiScanCount: maxCount),
                ),
              );

              if (scannedResults != null && scannedResults is List<String> && scannedResults.isNotEmpty) {
                List<Results> scannedProductsList = [];

                for (var code in scannedResults) {
                  String cleanCode = code.trim().split('/').last;


                  final product = products.firstWhere(
                        (p) =>
                    p.sku == cleanCode ||
                        p.barcode == cleanCode ||
                        p.id.toString() == cleanCode,
                    orElse: () => Results(id: '-1'),
                  );

                  if (product.id != '-1') {
                    scannedProductsList.add(product);
                  }
                }

                if (scannedProductsList.isNotEmpty) {
                  _showBulkEditSheet(context, scannedProductsList);
                }
              }
            }
          },
          child: FloatingActionButton(
            heroTag: "scan_btn",
            backgroundColor: AppColors.primaryPurple,
            onPressed: () async {

              final dynamic scannedCode = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QRScannerScreen()),
              );

              if (scannedCode != null && scannedCode is String && scannedCode.isNotEmpty) {
                String cleanCode = scannedCode.trim().split('/').last;

                try {

                  final matchingProduct = products.firstWhere(
                        (o) =>
                    o.sku == cleanCode ||
                        o.barcode == cleanCode ||
                        o.id.toString() == cleanCode,
                    orElse: () => throw Exception("Product not found"),
                  );

                  _showBulkEditSheet(context, [matchingProduct]);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("المنتج غير موجود في القائمة (تأكد من الـ Barcode أو الـ SKU)"),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              }
            },
            child: const Icon(Icons.qr_code_scanner, color: Colors.white),
          ),
        ),

        SizedBox(height: 10.h),


















       ],
    );
  }


  void _showBulkEditSheet(BuildContext context, List<Results> scannedProducts) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (innerContext) => BlocProvider.value(
        value: context.read<ProductsBloc>(),
        child: BulkEditProductsSheet(
          products: scannedProducts,
          onSave: (updatedProducts) {
            _handleSaveProducts(context, updatedProducts);
          },
        ),
      ),
    );
  }


  void _handleSaveProducts(BuildContext context, List<Results> updatedProducts) {
    final productsBloc = context.read<ProductsBloc>();
    for (var product in updatedProducts) {
      productsBloc.add(
        updateProduct(
          nameAr: _safeExtractValue(product.name, 'ar'),
          nameEn: _safeExtractValue(product.name, 'en'),
          product: product,
          price: product.price,
          stock: product.quantity,
          salePrice: product.salePrice,
        ),
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("جاري تحديث ${updatedProducts.length} منتجات..."),
        backgroundColor: AppColors.primaryPurple,
      ),
    );
  }


  String _safeExtractValue(dynamic data, String langKey) {
    if (data is Map) {
      return data[langKey]?.toString() ?? data.values.first.toString();
    }
    return data?.toString() ?? "";
  }


  Future<int?> _showScanCountDialog(BuildContext context) {
    return showDialog<int>(
      context: context,
      builder: (context) {
        int selectedCount = 5;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
          title: Text("مسح سريع ومتعدد", style: AppStyles.text16PurpleBold, textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("حدد عدد المنتجات المراد مسحها", style: AppStyles.text14bold),
              SizedBox(height: 20.h),
              StatefulBuilder(
                builder: (context, setDialogState) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCountBtn(Icons.remove, () {
                        if (selectedCount > 1) setDialogState(() => selectedCount--);
                      }),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Text("$selectedCount", style: AppStyles.text18purple),
                      ),
                      _buildCountBtn(Icons.add, () {
                        if (selectedCount < 50) setDialogState(() => selectedCount++);
                      }),
                    ],
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("إلغاء", style: AppStyles.text14grey),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, selectedCount),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
              ),
              child: Text("ابدأ الآن", style: AppStyles.text14White),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCountBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: AppColors.primaryPurple.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.primaryPurple),
      ),
    );
  }


  void _showAiChatSheet(BuildContext context, List<Results> products) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (childContext) => BlocProvider(
        create: (context) => getIt<AiAssistantBloc>()
          ..add(
            AskAiEvent(
              "أعطني ملخصاً سريعاً لحالة المخزون بناءً على البيانات المتوفرة.",
              products,
              orders: orders ?? [],
            ),
          ),
        child: AiChatWidget(products: products),
      ),
    );
  }
}
