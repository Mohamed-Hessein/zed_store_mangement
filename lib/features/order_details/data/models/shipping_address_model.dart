import 'package:hive/hive.dart';
import '../../domain/entities/shipping_address_entity.dart';

@HiveType(typeId: 13)
class ShippingAddressModel extends ShippingAddressEntity {
  @HiveField(0)
  final String street;
  @HiveField(1)
  final String city;
  @HiveField(2)
  final String state;
  @HiveField(3)
  final String postalCode;
  @HiveField(4)
  final String country;

  ShippingAddressModel({
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
  }) : super(
    street: street,
    city: city,
    state: state,
    postalCode: postalCode,
    country: country,
  );

  factory ShippingAddressModel.fromJson(Map<String, dynamic> json) {
    return ShippingAddressModel(
      street: json['street']?.toString() ?? '',
      city: json['city'] is Map ? (json['city']['name']?.toString() ?? '') : json['city']?.toString() ?? '',
      state: json['district']?.toString() ?? '',
      postalCode: json['postal_code']?.toString() ?? '',
      country: json['country'] is Map ? (json['country']['name']?.toString() ?? '') : json['country']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'postal_code': postalCode,
      'country': country,
    };
  }
}
