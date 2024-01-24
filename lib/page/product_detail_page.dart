import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../util/util.dart';
import 'cart_page.dart';

class ProductDetailPage extends StatefulWidget {
  ProductDetailPage(this.name, this.imageUrl, this.price, {super.key});
  String name;
  String imageUrl;
  double price;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
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
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(20),
        child: FilledButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CartPage(widget.name, widget.imageUrl, widget.price),
              ),
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
