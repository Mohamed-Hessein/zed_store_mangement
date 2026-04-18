import 'package:zed_store_mangent/di.dart';
import 'package:zed_store_mangent/features/store_profile/domain/entity/store_profile_entity.dart';

import '../../../product/data/model/product_model.dart';

class StoreProfileModel extends StoreProfileEntity {
  const StoreProfileModel({
    required super.totalRevenue,
    required super.storeName,
    required super.storeId,
    required super.storeImageUrl,
    required super.rating,
    required super.verificationStatus,
    required super.totalProducts,
    required super.totalSales,
  });factory StoreProfileModel.fromJson(Map<String, dynamic> json, {int? productsCount ,dynamic?  totalSales, dynamic   totalRevenue,}) {
    final data = json['user'] as Map<String, dynamic>? ?? json;

    return StoreProfileModel(
      totalRevenue:totalRevenue ,
      storeName: data['name'] as String? ?? 'Zed User',
      storeId: data['id']?.toString() ?? '0',
      storeImageUrl: _generateAvatarUrl(data['name'] as String? ?? 'Z'),
      rating: '4.9',
      verificationStatus: (data['is_email_verified'] == true) ? 'VERIFIED STORE' : 'UNVERIFIED',

      totalProducts: productsCount ?? 0,
      totalSales:  totalSales ??0 );

  }
  static String _generateAvatarUrl(String name) {
    try {
      final encodedName = Uri.encodeComponent(name.isNotEmpty ? name : 'Store');
      return 'https://ui-avatars.com/api/?name=$encodedName&background=6200EE&color=fff&bold=true&size=128';
    } catch (e) {
      return 'https://ui-avatars.com/api/?name=Store&background=6200EE&color=fff&bold=true&size=128';
    }
  }

  static String _parseDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return 'Oct 23';
    }

    try {
      final dateObj = DateTime.parse(dateString);
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[dateObj.month - 1]} ${dateObj.year.toString().substring(2)}';
    } catch (e) {
      return 'Oct 23';
    }
  }

  Map<String, dynamic> toJson() {
    return {
'totalRevenue': totalRevenue,
      'name': storeName,
      'id': storeId,
      'storeImageUrl': storeImageUrl,
      'rating': rating,
      'verificationStatus': verificationStatus,
      'totalProducts': totalProducts,
      'totalSales': totalSales,
    };
  }
}
