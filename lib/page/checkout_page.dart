import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../data/product_data.dart';
import '../util/util.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  List<(int, int)> cartList = [
    (1, 2),
    (4, 3),
  ];

  double get totalPrice => cartList.fold(
      0.0, (total, cart) => total + productList[cart.$1].price! * cart.$2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('결재시작'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: cartList.length,
        itemBuilder: (context, index) => _checkoutContainer(cartList[index]),
      ),
    );
  }

  Widget _checkoutContainer((int, int) cart) {
    print(cart);

    var foundProduct = productList.firstWhere((product) =>
    product.no == cart.$1);

    return foundProduct == null
        ? Container()
        : Container(
            padding: EdgeInsets.all(8),
            child: Row(
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
                    child: Text('오류 발생'),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8,),
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
                      Row(
                        children: [
                          Text('수량:',),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.remove),
                          ),
                          Text('${cart.$2}',),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.add),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.delete),
                          ),
                        ],
                      ),
                      Text('합계: ${numberFormat.format(foundProduct.price! * cart.$2)}원',),
                    ],
                  ),
                )
              ],
            ),
          );
  }
}
