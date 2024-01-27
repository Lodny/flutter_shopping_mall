import 'package:flutter/material.dart';
import 'package:flutter_shopping_mall/util/util.dart';

class OrderResultPage extends StatefulWidget {
  OrderResultPage({
    super.key,
    required this.paymentMethod,
    required this.paymentAmount,
    required this.receiveName,
    required this.receivePhone,
    required this.zip,
    required this.address1,
    required this.address2,
  });

  String paymentMethod = '';
  double paymentAmount = .0;
  String receiveName = '';
  String receivePhone = '';
  String zip = '';
  String address1 = '';
  String address2 = '';


  @override
  State<OrderResultPage> createState() => _OrderResultPageState();
}

class _OrderResultPageState extends State<OrderResultPage> {
  List<(int, int)> cartList = [
    (1, 2),
    (4, 3),
  ];

  String generateOrderNumber() {
    final dateTime = DateTime.now();
    return '${dateTime.year}${dateTime.month}${dateTime.day}-${dateTime
        .hour}${dateTime.minute}${dateTime.microsecond}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('주문완료',),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              children: [
                SizedBox(height: 20,),
                Text(
                    '주문이 완료되었습니다.',
                  textScaleFactor: 1.2,
                ),
                SizedBox(height: 20,),
                if (widget.paymentMethod == '무통장입금')
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Text('아래 계좌 정보로 입금해 주시면 결제 완료처리가 됩니다.'),
                  ),

                Container(
                  margin: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      if (widget.paymentMethod == '무통장입금') _depositInfoRow(),
                      if (widget.paymentMethod == '무통장입금') Divider(),
                      _paymentAmountRow(),
                      Divider(),
                      _orderNumberRow(),
                      Divider(),
                      _shippingAddressRow(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: FilledButton(
          onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
          child: Text('홈으로'),
        ),
      ),
    );
  }

  Widget _depositInfoRow() {
    return Container(
      padding: EdgeInsets.all(15),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 35,
            child: Text("임급계좌안내"),
          ),
          Expanded(
            flex: 65,
            child: Text("12345678901234 (은행명)"),
          ),
        ],
      ),
    );
  }

  Widget _paymentAmountRow() {
    return Container(
      padding: EdgeInsets.all(15),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 35,
            child: Text(widget.paymentMethod == '무통장입금' ? '입금금액' : '결제금액'),
          ),
          Expanded(
            flex: 65,
            child: Text('${numberFormat.format(widget.paymentAmount)}'),
          ),
        ],
      ),
    );
  }

  Widget _orderNumberRow() {
    return Container(
      padding: EdgeInsets.all(15),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 35,
            child: Text('주문번호'),
          ),
          Expanded(
            flex: 65,
            child: Text('${generateOrderNumber()}'),
          ),
        ],
      ),
    );
  }

  Widget _shippingAddressRow() {
    return Container(
      padding: EdgeInsets.all(15),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 35,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('배송지'),
              ],
            ),
          ),
          Expanded(
            flex: 65,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    '${widget.receiveName} (${widget.receivePhone})',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('${widget.address1} ${widget.address2}'),
                Text('${widget.zip}'),
              ],
            ),
          ),
        ],
      ),
    );
  }


}
