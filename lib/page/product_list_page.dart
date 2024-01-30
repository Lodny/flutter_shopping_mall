import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shopping_mall/page/cart_page.dart';
import 'package:flutter_shopping_mall/page/my_order_list_page.dart';
import 'package:flutter_shopping_mall/page/product_detail_page.dart';

import '../util/util.dart';

class ItemListPage extends StatefulWidget {
  const ItemListPage({super.key});

  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  final _productListRef = getProductCollectionReference();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('제품 리스트'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              final _orderCollection = FirebaseFirestore.instance.collection('orders');
              final orderList = await getOrderListFromFirestore();
              final orderNoList = orderList.map((e) => e.orderNo!,).toList();
              final productList = await getProductListFromFirestoreByOrderNo(orderNoList);

              print('>> orderList.length : ${orderList.length}');
              print('>> productList.length : ${productList.length}');

              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MyOrderListPage(orderList, productList),
              ),
            );
            },
            icon: Icon(
              Icons.account_circle,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CartPage(),
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _productListRef.orderBy('no').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: .8,
              ),
              children:
                snapshot.data!.docs.map((doc) {
                  final product = doc.data();
                  return productContainer(
                    no: product.no ?? 0,
                    name: product.name ?? '',
                    imageUrl: product.imageUrl ?? '',
                    price: product.price ?? 0.0,
                  );
                }).toList(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                '오류가 발생했습니다.',
              ),
            );
          }

          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          );
        },
      ),
    );
  }

  Widget productContainer({
    required int no,
    required String name,
    required String imageUrl,
    required double price}) {
    return GestureDetector(
      onTap: () {
        print('product: ' + name);
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ProductDetailPage(no, name, imageUrl, price),
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
