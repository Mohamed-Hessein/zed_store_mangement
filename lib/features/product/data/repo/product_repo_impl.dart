import 'package:injectable/injectable.dart';
import 'package:zed_store_mangent/features/product/data/data_source/product_ds.dart';

import 'package:zed_store_mangent/features/product/data/model/update_product_request.dart';

import '../../domain/repo/product_repo.dart';
import '../model/product_model.dart';
@Injectable(as: ProductRepo)
class ProductRepoImpl  implements ProductRepo  {

  ProductDs productDs;
  ProductRepoImpl(this.productDs);
  @override
  Future<ProductResponse> getProducts(dynamic searchQuery,{ required int page, required int pageSize})async {
  try{
    return await productDs.getProducts(searchQuery,page:page,pageSize:pageSize);

  }  catch(e){
    rethrow;
  }
  }

  @override
  Future<UpdateProductRequest> updateProduct(  {
    required Results product, 
    required dynamic newPrice,
    required dynamic newQuantity,
    required String nameAr,
    required String nameEn,
  })async {
    try{
      return await productDs.updateProduct(nameAr: nameAr,nameEn: nameEn,product: product,newPrice: newPrice,newQuantity: newQuantity);

    }  catch(e){
      rethrow;
    }
  }

}
