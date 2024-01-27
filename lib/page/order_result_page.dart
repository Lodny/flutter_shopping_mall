import 'package:flutter/material.dart';

class OrderResultPage extends StatefulWidget {
  const OrderResultPage({super.key});

  @override
  State<OrderResultPage> createState() => _OrderResultPageState();
}

class _OrderResultPageState extends State<OrderResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('주문완료',),
      ),
      body: Column(
        children: [
          Text('hi'),
        ],
      ),
    );
  }
}
