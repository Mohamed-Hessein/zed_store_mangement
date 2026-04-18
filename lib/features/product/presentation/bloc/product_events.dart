import 'package:zed_store_mangent/features/product/data/model/product_model.dart';

abstract class ProductEvents {}
class GetProducts extends ProductEvents {
  final bool isLoadMore;
  final String? searchQuery; 

  GetProducts({this.isLoadMore = false, this.searchQuery});
}class updateProduct extends ProductEvents {
  final Results product;
  final String nameAr;
  final String nameEn;
  final dynamic price; 
  final dynamic salePrice; 
  final dynamic stock;

  updateProduct({
    required this.nameAr,
    required this.nameEn,
    required this.product,
    required this.price,
    required this.salePrice, 
    required this.stock,
  });
}
