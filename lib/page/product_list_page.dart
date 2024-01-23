import 'package:flutter/material.dart';
import 'package:flutter_shopping_mall/page/product_detail_page.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../data/product_data.dart';

class ItemListPage extends StatefulWidget {
  const ItemListPage({super.key});

  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  final NumberFormat numberFormat = NumberFormat('###,###,###,###');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('제품 리스트'),
        centerTitle: true,
      ),
      body: GridView.builder(
        itemCount: productList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: .8,
        ),
        itemBuilder: (context, index) {
          return productContainer(
            name: productList[index].name ?? '',
            imageUrl: productList[index].imageUrl ?? '',
            price: productList[index].price ?? 0.0,
          );
        },),
    );
  }

  Widget productContainer({
    required String name,
    required String imageUrl,
    required double price}) {
    return GestureDetector(
      onTap: () {
        print('product: ' + name);
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ProductDetailPage(name, imageUrl, price),
        ));
      },
      child: Container(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            CachedNetworkImage(
              height: 150,
              fit: BoxFit.cover,
              imageUrl: imageUrl,
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
              padding: EdgeInsets.all(8),
              child: Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: Text(
                '${numberFormat.format(price)}원',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
