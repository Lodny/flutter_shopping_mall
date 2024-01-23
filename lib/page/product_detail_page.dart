import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
            CachedNetworkImage(
              height: 150,
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
            Text(widget.name),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('가격: ${widget.price}'),
              ],
            )
          ],
        ),
      ),
    );
  }
}
