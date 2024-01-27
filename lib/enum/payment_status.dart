enum PaymentStatus {
  waiting('waiting', '입금대기'),
  completed('completed', '결제완료'),
  canceled('canceled', '주문취소');

  const PaymentStatus(this.status, this.name);
  final String status;
  final String name;

  factory PaymentStatus.byStatus(String status) =>
      PaymentStatus.values.firstWhere((payment) =>
        payment.status == status,
        orElse: () => PaymentStatus.waiting);

  // factory PaymentStatus.byName(String name) =>
  //     PaymentStatus.values.firstWhere((payment) =>
  //       payment.name == name,
  //       orElse: () => PaymentStatus.waiting);
}
