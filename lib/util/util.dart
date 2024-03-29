import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/product.dart';

final NumberFormat numberFormat = NumberFormat('###,###,###,###');
late final SharedPreferences _sharedPreferences;
late final CollectionReference<Product> _productListRef;

Future<void> initSharedPreferences() async {
  _sharedPreferences = await SharedPreferences.getInstance();
  _sharedPreferences.setString('cartMap', '{}');

  print('> initSharedPreferences() : ' + _sharedPreferences.toString());
}

SharedPreferences getSharedPreferences() => _sharedPreferences;

void initProductCollectionReference() {
  _productListRef = FirebaseFirestore.instance
    .collection('products')
    .withConverter(
      fromFirestore: (snapshot, _) => Product.fromJson(snapshot.data()!),
      toFirestore: (product, _) => product.toJson(),
    );
}

CollectionReference<Product> getProductCollectionReference() => _productListRef;
