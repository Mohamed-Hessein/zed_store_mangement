import 'package:injectable/injectable.dart';
import 'package:zed_store_mangent/features/product/domain/repo/product_repo.dart';

import '../../data/model/product_model.dart';
import '../../data/model/update_product_request.dart';

@injectable
class ProductUsecase {
  ProductRepo productRepo;
  ProductUsecase(this.productRepo);

  Future<ProductResponse> callProduct(dynamic searchQuery,{ required int page, required int pageSize}) async {
    try {
      return await productRepo.getProducts(searchQuery,page:page, pageSize:pageSize);
    } catch (e) {
      rethrow;
    }
  }

  Future<UpdateProductRequest> callUpdate({
    required Results product,
    required dynamic newPrice,
    required dynamic newQuantity,
    required String nameAr,
    required String nameEn,
  }) async {
    try {
      return await productRepo.updateProduct(
        nameAr: nameAr,
        nameEn: nameEn,
        product: product,
        newPrice: newPrice,
        newQuantity: newQuantity,
      );
    } catch (e) {
      rethrow;
    }
  }
}
