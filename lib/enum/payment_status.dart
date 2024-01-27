enum PaymentStatus {
  waiting('waiting', '입금대기'),
  completed('completed', '결제완료'),
  canceled('canceled', '주문취소');

  const PaymentStatus(this.status, this.statusName);
  final String status;
  final String statusName;

  factory PaymentStatus.byStatus(String status) =>
      PaymentStatus.values.firstWhere((payment) =>
        payment.status == status,
        orElse: () => PaymentStatus.waiting);
}
