enum PaymentType {
  select('select', '결제수단선택'),
  card('card', '카드결제'),
  cash('cash', '무통장입금');

  const PaymentType(this.code, this.name);
  final String code;
  final String name;

  factory PaymentType.byCode(String code) =>
    PaymentType.values.firstWhere((payment) =>
      payment.code == code,
      orElse: () => PaymentType.select);
}

