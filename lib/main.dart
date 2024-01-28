import 'package:flutter/material.dart';
import 'package:flutter_shopping_mall/page/product_list_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 필수: 앱이 실행되기 전에 ensureInitialized() 호출

  // SharedPreferences 초기화
  await initSharedPreferences();

  runApp(const MyApp());
}

Future<void> initSharedPreferences() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('cartMap', '{}');

  print('init cartMap');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Shopping Mall',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: ItemListPage(),
    );
  }
}
