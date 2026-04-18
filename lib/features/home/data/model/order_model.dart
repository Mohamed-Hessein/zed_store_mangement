class ZidOrdersResponse {
  final String? status;
  final List<OrderModel>? orders;
  final int? totalCount;

  ZidOrdersResponse({this.status, this.orders, this.totalCount});

  factory ZidOrdersResponse.fromJson(Map<String, dynamic> json) {
    return ZidOrdersResponse(
      status: json['status'],
      orders: json['orders'] != null
          ? List<OrderModel>.from(json['orders'].map((x) => OrderModel.fromJson(x)))
          : [],
      totalCount: json['total_order_count'],
    );
  }
}

class OrderModel {
  final int id;
  final String code;
  final String storeName;
  final String orderTotal;
  final String issueDate;
  final OrderStatus? orderStatus;
  final Customer? customer;
  final Address? address;
  final String paymentMethod;

  OrderModel({
    required this.id,
    required this.code,
    required this.storeName,
    required this.orderTotal,
    required this.issueDate,
    this.orderStatus,
    this.customer,
    this.address,
    required this.paymentMethod,
  });


  OrderModel copyWith({
    int? id,
    String? code,
    String? storeName,
    String? orderTotal,
    String? issueDate,
    OrderStatus? orderStatus,
    Customer? customer,
    Address? address,
    String? paymentMethod,
  }) {
    return OrderModel(
      id: id ?? this.id,
      code: code ?? this.code,
      storeName: storeName ?? this.storeName,
      orderTotal: orderTotal ?? this.orderTotal,
      issueDate: issueDate ?? this.issueDate,
      orderStatus: orderStatus ?? this.orderStatus,
      customer: customer ?? this.customer,
      address: address ?? this.address,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      storeName: json['store_name'] ?? '',
      orderTotal: json['order_total_string'] ?? '',
      issueDate: json['issue_date'] ?? '',
      orderStatus: json['order_status'] != null
          ? OrderStatus.fromJson(json['order_status'])
          : null,
      customer: json['customer'] != null
          ? Customer.fromJson(json['customer'])
          : null,
      address: (json['shipping'] != null && json['shipping']['address'] != null)
          ? Address.fromJson(json['shipping']['address'])
          : null,
      paymentMethod: (json['payment'] != null &&
          json['payment']['method'] != null)
          ? (json['payment']['method']['name'] ?? '')
          : '',
    );
  }
}

class OrderStatus {
  final String name;
  final String code;

  OrderStatus({required this.name, required this.code});


  OrderStatus copyWith({
    String? name,
    String? code,
  }) {
    return OrderStatus(
      name: name ?? this.name,
      code: code ?? this.code,
    );
  }

  factory OrderStatus.fromJson(Map<String, dynamic> json) {
    return OrderStatus(
      name: json['name'] ?? '',
      code: json['code'] ?? '',
    );
  }
}

class Customer {
  final int id;
  final String name;
  final String mobile;

  Customer({required this.id, required this.name, required this.mobile});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      mobile: json['mobile'] ?? '',
    );
  }
}

class Address {
  final String street;
  final String district;
  final String city;
  final String country;

  Address({
    required this.street,
    required this.district,
    required this.city,
    required this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'] ?? '',
      district: json['district'] ?? '',
      city: (json['city'] is Map) ? (json['city']['name'] ?? '') : (json['city'] ?? ''),
      country: (json['country'] is Map) ? (json['country']['name'] ?? '') : (json['country'] ?? ''),
    );
  }
}
