import '../model/product_model.dart';
import '../model/update_product_request.dart';

abstract class ProductDs {

  Future<ProductResponse>getProducts(dynamic searchQuery,{ required int page, required int pageSize});

  Future<UpdateProductRequest> updateProduct(  {
    required Results product,
    required dynamic newPrice,
    required dynamic newQuantity,
    required String nameAr,
    required String nameEn,








  });

}
