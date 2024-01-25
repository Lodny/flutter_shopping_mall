import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shopping_mall/util/util.dart';

import '../data/product_data.dart';
import '../model/product.dart';

class CartPage extends StatefulWidget {
  CartPage(this.name, this.imageUrl, this.price, {super.key});

  String name;
  String imageUrl;
  double price;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<(int, int)> cartList = [
    (1, 2),
    (4, 3),
  ];

  List<Product> cartList2 = [
    Product(
        no: 1,
        name: "노트북(Laptop)",
        imageUrl: "https://picsum.photos/id/1/300/300",
        price: 600000),
    Product(
        no: 4,
        name: "키보드(Keyboard)",
        imageUrl: "https://picsum.photos/id/60/300/300",
        price: 50000),
  ];

  double get totalPrice => cartList.fold(0.0, (total, cart) =>
      total + productList[cart.$1].price! * cart.$2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '장바구니',
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            ...cartList
                .map((cart) => cartContainer(cart)).toList(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(20),
        child: FilledButton(
          onPressed: () {},
          child: Text('총 ${numberFormat.format(totalPrice)}원 결재하기'),
        ),
      ),
    );
  }

  Widget cartContainer((int, int) cart) {
    print(cart);

    var foundProduct = productList.firstWhere((product) => product.no == cart.$1);

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
