import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zed_store_mangent/core/resources/app_colors.dart';
import 'package:zed_store_mangent/core/resources/app_styles.dart';
import '../../data/model/product_model.dart';

class BulkEditProductsSheet extends StatefulWidget {
  final List<Results> products;
  final Function(List<Results> updatedProducts) onSave;

  const BulkEditProductsSheet({
    super.key,
    required this.products,
    required this.onSave
  });

  @override
  State<BulkEditProductsSheet> createState() => _BulkEditProductsSheetState();
}

class _BulkEditProductsSheetState extends State<BulkEditProductsSheet> {
  final Map<dynamic, TextEditingController> priceControllers = {};
  final Map<dynamic, TextEditingController> stockControllers = {};

  @override
  void initState() {
    super.initState();
    for (var product in widget.products) {
      final id = product.id;

      priceControllers[id] = TextEditingController(text: _parseToText(product.price));
      stockControllers[id] = TextEditingController(text: _parseToText(product.quantity));
    }
  }


  String _parseToText(dynamic value) {
    if (value == null) return "0";
    if (value is Map) {
      return value['amount']?.toString() ?? value.values.first.toString();
    }
    return value.toString();
  }

  @override
  void dispose() {
    for (var c in priceControllers.values) c.dispose();
    for (var c in stockControllers.values) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(width: 50.w, height: 5.h, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10.r))),
            ),
            SizedBox(height: 20.h),
            Text("مراجعة وتعديل المنتجات", style: AppStyles.text16PurpleBold),
            Text("تم مسح ${widget.products.length} منتجات", style: AppStyles.text14bold),
            SizedBox(height: 15.h),
            Expanded(
              child: ListView.separated(
                itemCount: widget.products.length,
                separatorBuilder: (context, index) => Divider(height: 30.h, color: Colors.grey[200]),
                itemBuilder: (context, index) {
                  final product = widget.products[index];


                  String displayName = "";
                  if (product.name is Map) {
                    displayName = product.name['ar'] ?? product.name['en'] ?? "منتج غير معروف";
                  } else {
                    displayName = product.name?.toString() ?? "منتج غير معروف";
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(displayName, style: AppStyles.text16PurpleBold),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Expanded(
                            child: _buildInputField(
                              label: "السعر الجديد",
                              controller: priceControllers[product.id]!,
                              icon: Icons.attach_money,
                            ),
                          ),
                          SizedBox(width: 15.w),
                          Expanded(
                            child: _buildInputField(
                              label: "الكمية",
                              controller: stockControllers[product.id]!,
                              icon: Icons.inventory_2_outlined,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: () {
                for (var product in widget.products) {
                  final id = product.id;

                  product.price = double.tryParse(priceControllers[id]!.text) ?? 0.0;
                  product.quantity = int.tryParse(stockControllers[id]!.text) ?? 0;
                }
                widget.onSave(widget.products);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                minimumSize: Size(double.infinity, 55.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
              ),
              child: Text("حفظ التعديلات للكل", style: AppStyles.text14White),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({required String label, required TextEditingController controller, required IconData icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppStyles.text12grey),
        SizedBox(height: 5.h),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 18.sp, color: AppColors.primaryPurple),
            contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
          ),
        ),
      ],
    );
  }
}
