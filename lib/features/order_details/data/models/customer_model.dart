import 'package:hive/hive.dart';
import '../../domain/entities/customer_entity.dart';

@HiveType(typeId: 11)
class CustomerModel extends CustomerEntity {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String phone;
  @HiveField(4)
  final String? avatarUrl;

  CustomerModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatarUrl,
  }) : super(
    id: id,
    name: name,
    email: email,
    phone: phone,
    avatarUrl: avatarUrl,
  );

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['mobile']?.toString() ?? '',
      avatarUrl: json['avatar_url']?.toString() ?? json['avatar']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar_url': avatarUrl,
    };
  }
}
