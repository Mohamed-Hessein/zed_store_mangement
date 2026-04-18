class SubscriptionEntity {
  final String status;
  final String? planName;
  final DateTime? endDate;
  final String? merchantEmail;

  SubscriptionEntity({
    required this.status,
    this.planName,
    this.endDate,
    this.merchantEmail,
  });
}
