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
  int _count = 1;
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
              SizedBox(height: 20,),
              CachedNetworkImage(
                width: MediaQuery.of(context).size.width * .8,
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
              ),
              SizedBox(height: 20,),
              Text(
                widget.name,
                textScaleFactor: 1.5,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '가격: ${numberFormat.format(widget.price)}원',
                    textScaleFactor: 1.3,
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('수량:',),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _count = max(1, _count - 1);
                      });
                    },
                    icon: Icon(Icons.remove),
                  ),
                  Text('${_count}',),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _count++;
                      });
                    },
                    icon: Icon(Icons.add),
                  ),
                  IconButton(
                    onPressed: () {
                      print('delete');
                    },
                    icon: Icon(Icons.delete),
                  ),
                ],
              ),
              Text('합계: ${numberFormat.format(widget.price * _count)}원',),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(20),
        child: FilledButton(
          onPressed: () async {
            final SharedPreferences prefs = await SharedPreferences.getInstance();

            Map<String, dynamic> cartMap = {};
            final String? cartListString = prefs.getString('cartMap');
            print(cartListString);
            if (cartListString != null)
              cartMap = jsonDecode(cartListString);
            print('>> after read : ' + cartMap.toString());

            cartMap.update(widget.no.toString(), (count) => _count, ifAbsent: () => _count);
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
}
