import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zed_store_mangent/features/order_details/presentation/bloc/order_details_event.dart';
import 'package:zed_store_mangent/features/product/data/model/product_model.dart';
import 'package:zed_store_mangent/features/product/presentation/bloc/product_events.dart';
import 'package:zed_store_mangent/features/product/presentation/bloc/products_bloc.dart';

import '../../../../di.dart';
import '../../../order_details/presentation/bloc/order_details_bloc.dart';
import '../../data/data_source/ai_ds.dart';
import 'ai_events.dart';
import 'ai_states.dart';@injectable
class AiAssistantBloc extends Bloc<AiAssistantEvent, AiAssistantState> {
  final AIChatRemoteDataSource dataSource;

  AiAssistantBloc(this.dataSource) : super(AiInitial()) {
    on<AskAiEvent>((event, emit) async {
      emit(AiLoading());
      try {
        final inventoryContext = event.products.isEmpty
            ? "لا توجد منتجات حالياً"
            : event.products.map((p) =>
        "- ${p.name ?? 'منتج بدون اسم'} (ID: ${p.id ?? '0'}): الكمية ${p.quantity ?? 0}, السعر ${p.price ?? 0}"
        ).join("\n");

        final ordersContext = (event.orders == null || event.orders!.isEmpty)
            ? "لا توجد بيانات طلبات حالياً."
            : event.orders!.map((o) =>
        "- طلب رقم ${o.id ?? 'N/A'}: الحالة ${o.orderStatus ?? 'غير محدد'}, الإجمالي ${o.orderTotal ?? 0}"
        ).join("\n");

        final fullPrompt = """
        أنت مدير متجر "زد" التنفيذي. رد باللهجة السعودية البيضاء بذكاء وحزم وود.
        بيانات المخزن: $inventoryContext
        بيانات الطلبات: $ordersContext
        
        صلاحياتك للتنفيذ (Actions):
        - لتغيير السعر: [ACTION: UPDATE_PRICE, ID: {id}, VALUE: {price}]
        - لتغيير الكمية: [ACTION: UPDATE_QTY, ID: {id}, VALUE: {quantity}]
        - لتغيير حالة طلب: [ACTION: UPDATE_ORDER, ID: {order_id}, STATUS: {new_status}]

        المطلوب:
        1. تحليل البيانات وتقديم نصائح.
        2. إذا وافقت على تغيير، ضع الكود في نهاية الرد.
        3. استخدم الفواصل (.) والـ (،) للـ TTS.

        سؤال المستخدم: ${event.userPrompt}
        """;

        final result = await dataSource.getChatResponse(fullPrompt);


        if (result.contains("[ACTION:")) {
          _handleAllActions(result, event.products);
        }

        emit(AiSuccess(result));
      } catch (e) {
        print("Detailed AI Bloc Error: $e");
        emit(AiError("حدث خطأ: ${e.toString()}"));
      }
    });
  }
  void _handleAllActions(String response, List<Results> currentProducts) {
    try {
      final regExp = RegExp(r"\[ACTION:\s*(\w+),\s*ID:\s*([\w-]+),\s*(VALUE|STATUS):\s*(.*?)\]");
      final matches = regExp.allMatches(response);

      for (final match in matches) {
        final String actionType = match.group(1)!;
        final String id = match.group(2)!;
        final String newValue = match.group(4)!;

        print("🚀 تنفيذ أمر من AI: $actionType على ID: $id");


        if (actionType == 'UPDATE_PRICE' || actionType == 'UPDATE_QTY') {
          try {
            final originalProduct = currentProducts.firstWhere(
                  (p) => p.id.toString() == id.toString(),
            );

            String safeNameAr = (originalProduct.name is Map)
                ? (originalProduct.name['ar']?.toString() ?? '')
                : originalProduct.name?.toString() ?? '';
            String safeNameEn = (originalProduct.name is Map)
                ? (originalProduct.name['en']?.toString() ?? '')
                : originalProduct.name?.toString() ?? '';

            final double? updatedPrice = actionType == 'UPDATE_PRICE'
                ? (double.tryParse(newValue) ?? double.tryParse(originalProduct.price.toString()))
                : double.tryParse(originalProduct.price.toString());

            final int? updatedStock = actionType == 'UPDATE_QTY'
                ? (int.tryParse(newValue) ?? originalProduct.quantity)
                : originalProduct.quantity;

            getIt<ProductsBloc>().add(updateProduct(
              product: originalProduct,
              nameAr: safeNameAr,
              nameEn: safeNameEn,
              price: updatedPrice,
              salePrice: originalProduct.salePrice,
              stock: updatedStock,
            ));
            print("✅ تم تحديث المنتج بنجاح");
          } catch (e) {
            print("❌ خطأ في تحديث المنتج: $e");
          }
        }


        else if (actionType == 'UPDATE_ORDER') {
          try {
            print("📦 جاري تحديث حالة الطلب $id إلى $newValue");



             getIt<OrderDetailsBloc>().add(UpdateOrderStatusEvent( id, newValue));

            print("✅ تم إرسال طلب تحديث الحالة بنجاح");
          } catch (e) {
            print("❌ خطأ في تحديث الطلب: $e");
          }
        }
      }
    } catch (e) {
      print("❌ خطأ عام في معالجة أوامر الـ AI: $e");
    }
  }}
