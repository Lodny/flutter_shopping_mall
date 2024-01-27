enum DeliveryStatus {
  waiting('waiting', '배송대기'),
  delivering('delivering', '배송중'),
  delivered('delivered', '배송완료');

  const DeliveryStatus(this.status, this.statusName);
  final String status;
  final String statusName;

  factory DeliveryStatus.byStatus(String status) =>
      DeliveryStatus.values.firstWhere((delivery) =>
        delivery.status == status,
        orElse: () => DeliveryStatus.waiting);
}
