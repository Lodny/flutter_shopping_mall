class Order {
  int? orderId;
  int? productNo;
  String? orderDate;
  String? orderNo;
  int? quantity;
  double? totalPrice;
  String? paymentStatus;
  String? deliveryStatus;

  Order({
    this.orderId,
    this.productNo,
    this.orderDate,
    this.orderNo,
    this.quantity,
    this.totalPrice,
    this.paymentStatus,
    this.deliveryStatus
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderId'] ?? 0,
      productNo: json['productNo'] ?? 0,
      orderDate: json['orderDate'] ?? '',
      orderNo: json['orderNo'] ?? '',
      quantity: json['quantity'] ?? 0,
      totalPrice: json['totalPrice'] ?? 0,
      paymentStatus: json['paymentStatus'] ?? '',
      deliveryStatus: json['deliveryStatus'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId ?? 0,
      'productNo': productNo ?? 0,
      'orderDate': orderDate ?? '',
      'orderNo': orderNo ?? '',
      'quantity': quantity ?? 0,
      'totalPrice': totalPrice ?? 0,
      'paymentStatus': paymentStatus ?? '',
      'deliveryStatus': deliveryStatus ?? '',
    };
  }
}
