import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/util.dart';
import 'cart_page.dart';

class ProductDetailPage extends StatefulWidget {
  ProductDetailPage(this.no, this.name, this.imageUrl, this.price, {super.key});
  int no;
  String name;
  String imageUrl;
  double price;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '제품 상세'
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 15,),
              _productImage(context),
              SizedBox(height: 15,),
              _productName(),
              SizedBox(height: 15,),
              _productPrice(),
              SizedBox(height: 15,),
              _productQuantity(),
              _productTotalPrice(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(20),
        child: FilledButton(
          onPressed: () async {
            final SharedPreferences prefs = getSharedPreferences();
            Map<String, dynamic> cartMap = jsonDecode(prefs.getString('cartMap') ?? '{}') ?? {};
            print('>> after read : ' + cartMap.toString());

            cartMap.update(widget.no.toString(), (count) => _quantity + (count as int), ifAbsent: () => _quantity);
            print('>> after update : ' + cartMap.toString());
            prefs.setString('cartMap', jsonEncode(cartMap));

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CartPage(),),
            );
          },
          child: Text(
              '장바구니 담기',
          ),
        ),
      ),
    );
  }

  Text _productTotalPrice() => Text(
        '합계: ${numberFormat.format(widget.price * _quantity)}원',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        textScaleFactor: 1.3,
      );

  Row _productQuantity() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '수량:',
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _quantity = max(1, _quantity - 1);
            });
          },
          icon: Icon(Icons.remove),
        ),
        Text(
          '${_quantity}',
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _quantity++;
            });
          },
          icon: Icon(Icons.add),
        ),
      ],
    );
  }

  Row _productPrice() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '가격: ${numberFormat.format(widget.price)}원',
          textScaleFactor: 1.3,
        ),
      ],
    );
  }

  Text _productName() {
    return Text(
      widget.name,
      textScaleFactor: 1.5,
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  CachedNetworkImage _productImage(BuildContext context) {
    return CachedNetworkImage(
      width: MediaQuery.of(context).size.width * .7,
      fit: BoxFit.cover,
      imageUrl: widget.imageUrl,
      placeholder: (context, url) => Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      ),
      errorWidget: (context, url, error) => Center(
        child: Text('오류 발생'),
      ),
    );
  }
}
