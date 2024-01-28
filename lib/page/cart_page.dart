import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shopping_mall/page/checkout_page.dart';
import 'package:flutter_shopping_mall/util/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/product_data.dart';

class CartPage extends StatefulWidget {
  CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<(int, int)> cartList = [
    (1, 2),
    (4, 3),
  ];

  Map<String, dynamic> _cartMap = {};
  late SharedPreferences? _prefs;

  @override
  void initState() {
    _initializeSharedPreferences();
    super.initState();
  }

  Future<void> _initializeSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    if (_prefs == null) return;

    setState(() {
      _cartMap = jsonDecode(_prefs!.getString('cartMap') ?? '{}');
      print(_cartMap);
    });
  }

  double get totalPrice2 => cartList.fold(0.0, (total, cart) =>
      total + productList[cart.$1].price! * cart.$2);

  double get totalPrice => _cartMap.entries.fold(0.0, (total, cart) =>
    total + productList[int.parse(cart.key)].price! * (cart.value as int));

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
            // ...cartList
            //     .map((cart) => cartContainer(cart)).toList(),
            ..._cartMap.entries
                .map((cart) => cartContainer(cart)).toList(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(20),
        child: FilledButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CheckoutPage(),)),
          child: Text('총 ${numberFormat.format(totalPrice)}원 결제하기'),
        ),
      ),
    );
  }

  Widget cartContainer(MapEntry<String, dynamic> cart) {
    print('cartContainer() : ' + cart.toString());

    var foundProduct = productList.firstWhere((product) => product.no == int.parse(cart.key));

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
                          Text('${cart.value as int}',),
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
                      Text('합계: ${numberFormat.format(foundProduct.price! * (cart.value as int))}원',),
                    ],
                  ),
                )
              ],
            ),
          );
  }
}
