import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shopping_mall/model/product.dart';
import 'package:flutter_shopping_mall/page/checkout_page.dart';
import 'package:flutter_shopping_mall/util/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {
  CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Map<String, dynamic> _cartMap = {};
  late SharedPreferences? _prefs;
  Stream<QuerySnapshot<Product>>? _productList;

  @override
  void initState() {
    super.initState();

    try {
      _prefs = getSharedPreferences();
      _cartMap = jsonDecode(_prefs!.getString('cartMap') ?? '{}') ?? {};
    } catch (e) {
      debugPrint(e.toString());
    }

    if (_cartMap.isEmpty) return;

    _productList = getProductCollectionReference()
      .where('no',
        whereIn: _cartMap.keys
            .map((key) => int.parse(key),)
            .toList(),
      )
      .orderBy('no')
      .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '장바구니',
        ),
        centerTitle: true,
      ),
      body: _cartMap.isEmpty
        ? Container()
        : StreamBuilder(
            stream: _productList,
            builder: (context, snapshot) {
              if (snapshot.hasError) return Center(child: Text('오류가 발생 했습니다.'),);
              if (! snapshot.hasData) return Center(child: CircularProgressIndicator(strokeWidth: 2,),);

              return ListView(
                children: snapshot.data!.docs.map((doc) {
                    final product = doc.data();
                    if (_cartMap[product.no.toString()] == null) return Container();

                    return cartContainer(product, _cartMap.entries.firstWhere((cart) => cart.key == product.no.toString()));
                  },
                ).toList(),
              );
            },
      ),
      bottomNavigationBar: _cartMap.isEmpty
        ? Center(child: Text('장바구니에 담긴 제품이 없습니다.'),)
        : StreamBuilder(
            stream: _productList,
            builder: (context, snapshot) {
              if (snapshot.hasError) return Center(child: Text('오류가 발생 했습니다.'),);
              if (! snapshot.hasData) return Center(child: CircularProgressIndicator(strokeWidth: 2,),);

              final totalPrice = snapshot.data?.docs.fold(0.0, (total, doc) {
                  final product = doc.data();
                  if (_cartMap[product.no.toString()] == null) return total;

                  return total + (product.price ?? 0) * _cartMap[product.no.toString()];
                },
              );

              return Padding(
                padding: EdgeInsets.all(20),
                child: FilledButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckoutPage(),
                      )),
                  child: Text('총 ${numberFormat.format(totalPrice)}원 결제하기'),
                ),
              );
            },
          ),
    );
  }

  Widget cartContainer(Product product, MapEntry<String, dynamic> cart) {
    print('cartContainer() : ' + product.toString());
    print('quantity : ' + cart.toString());

    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: product.imageUrl!,
            width: MediaQuery.of(context).size.width * .3,
            height: 130,
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
            padding: EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  product.name!,
                  textScaleFactor: 1.2,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('${numberFormat.format(product.price)}'),
                Row(
                  children: [
                    Text(
                      '수량:',
                    ),
                    IconButton(
                      onPressed: () {
                        _cartMap[cart.key] = max(1, (cart.value as int) - 1);
                        if (_cartMap[cart.key] == cart.value) return;

                        print('> after dec : ' + _cartMap.toString());
                        setState(() {
                          _prefs!.setString('cartMap', jsonEncode(_cartMap));
                        });
                      },
                      icon: Icon(Icons.remove),
                    ),
                    Text(
                      '${cart.value as int}',
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _cartMap[cart.key] = cart.value + 1;
                          print('> after inc : ' + _cartMap.toString());

                          setState(() {
                            _prefs!.setString('cartMap', jsonEncode(_cartMap));
                          });
                        });
                      },
                      icon: Icon(Icons.add),
                    ),
                    IconButton(
                      onPressed: () {
                        _cartMap.remove(cart.key);
                        print('> after del : ' + _cartMap.toString());
                        setState(() {
                          _prefs!.setString('cartMap', jsonEncode(_cartMap));
                        });
                      },
                      icon: Icon(Icons.delete),
                    ),
                  ],
                ),
                Text(
                  '합계: ${numberFormat.format(product.price! * (cart.value as int))}원',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
