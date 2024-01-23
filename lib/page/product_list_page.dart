import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../model/product.dart';

class ItemListPage extends StatefulWidget {
  const ItemListPage({super.key});

  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  final NumberFormat numberFormat = NumberFormat('###,###,###,###');

  List<Product> productList = [
    Product(
        no: 1,
        name: "노트북(Laptop)",
        imageUrl: "https://picsum.photos/id/1/300/300",
        price: 600000),
    Product(
        no: 2,
        name: "스마트폰(Phone)",
        imageUrl: "https://picsum.photos/id/20/300/300",
        price: 500000),
    Product(
        no: 3,
        name: "머그컵(Cup)",
        imageUrl: "https://picsum.photos/id/30/300/300",
        price: 15000),
    Product(
        no: 4,
        name: "키보드(Keyboard)",
        imageUrl: "https://picsum.photos/id/60/300/300",
        price: 50000),
    Product(
        no: 5,
        name: "포도(Grape)",
        imageUrl: "https://picsum.photos/id/75/200/300",
        price: 75000),
    Product(
        no: 6,
        name: "책(book)",
        imageUrl: "https://picsum.photos/id/24/200/300",
        price: 24000),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('제품 리스트'),
        centerTitle: true,
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.9,
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
    return Container(
      padding: EdgeInsets.all(5),
      child: Column(
        children: [
          CachedNetworkImage(
            height: 15,
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
    );
  }
}
