
import '../../data/model/product_model.dart';
import '../../data/model/update_product_request.dart';

abstract class ProductRepo {
  Future<ProductResponse> getProducts(dynamic searchQuery,{ required int page, required int pageSize});

  Future<UpdateProductRequest> updateProduct( {
    required Results product, 
    required dynamic newPrice,
    required dynamic newQuantity,
    required String nameAr,
    required String nameEn,
  });


}
