import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shopping_mall/enum/delivery_status.dart';
import 'package:flutter_shopping_mall/enum/payment_status.dart';

import '../data/product_data.dart';
import '../model/order.dart';
import '../util/util.dart';

class MyOrderListPage extends StatefulWidget {
  const MyOrderListPage({super.key});

  @override
  State<MyOrderListPage> createState() => _MyOrderListPageState();
}

class _MyOrderListPageState extends State<MyOrderListPage> {

  final orderList = [
    Order(
      orderId: 1,
      productNo: 1,
      orderDate: '2024-01-27',
      orderNo: '20240127-123456789',
      quantity: 2,
      totalPrice: 120000,
      paymentStatus: 'completed',
      deliveryStatus: 'delivering',
    ),
    Order(
      orderId: 2,
      productNo: 4,
      orderDate: '2024-01-27',
      orderNo: '20240127-97456789',
      quantity: 3,
      totalPrice: 560000,
      paymentStatus: 'waiting',
      deliveryStatus: 'waiting',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('나의 주문목록',),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              itemCount: orderList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) => _orderContainer(orderList[index]),
            ),
          ]
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: FilledButton(
          child: Text('홈으로'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  Widget _orderContainer(Order order) {
    var foundProduct = productList.firstWhere((product) =>
    product.no == order.productNo);

    return foundProduct == null
        ? Container()
        : Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: Text(
              '주문날짜: ${order.orderDate}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: foundProduct.imageUrl!,
                width: MediaQuery.of(context).size.width * .3,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
                errorWidget: (context, url, error) => Center(
                  child: const Text('오류 발생'),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8,),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      foundProduct.name!,
                      textScaleFactor: 1.2,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('${numberFormat.format(foundProduct.price)}'),
                    Text('수량: ${order.quantity}',),
                    Text('합계: ${numberFormat.format(order.totalPrice)}원',),
                    Text(
                      '${PaymentStatus.byStatus(order.paymentStatus!).name} / ${DeliveryStatus.byStatus(order.deliveryStatus!).name}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              FilledButton.tonal(
                onPressed: () {},
                child: const Text(
                  '주문취소',
                ),
              ),
              SizedBox(width: 10,),
              FilledButton(
                onPressed: () {},
                child: const Text(
                  '배송조회',
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
