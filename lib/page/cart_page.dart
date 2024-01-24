import 'package:flutter/material.dart';

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
    );
  }

  Widget cartContainer((int, int) cart) {
    print(cart);

    return Container();
  }
}
