import '../../domain/subscribe_entity.dart';

class SubscriptionModel extends SubscriptionEntity {
  SubscriptionModel({
    required super.status,
    super.planName,
    super.endDate,
    super.merchantEmail,
  });


  SubscriptionModel copyWith({
    String? status,
    String? planName,
    DateTime? endDate,
    String? merchantEmail,
  }) {
    return SubscriptionModel(
      status: status ?? this.status,
      planName: planName ?? this.planName,
      endDate: endDate ?? this.endDate,
      merchantEmail: merchantEmail ?? this.merchantEmail,
    );
  }
  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {


    final Map<String, dynamic> data = json.containsKey('subscription')
        ? json['subscription']
        : json;

    return SubscriptionModel(
      status: data['subscription_status'] ?? 'inactive',
      planName: data['plan_name'],
      merchantEmail: data['merchant_email'],
      endDate: data['end_date'] != null ? DateTime.parse(data['end_date']) : null,
    );
  }}
