class ShippingAddressEntity {
  final String street;
  final String city;
  final String state;
  final String postalCode;
  final String country;

  ShippingAddressEntity({
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
  });

  String get fullAddress => '$street, $city, $state $postalCode, $country';
}

