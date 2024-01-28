import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

final NumberFormat numberFormat = NumberFormat('###,###,###,###');
late final SharedPreferences _sharedPreferences;

Future<void> initSharedPreferences() async {
  _sharedPreferences = await SharedPreferences.getInstance();
  _sharedPreferences.setString('cartMap', '{}');

  print('> initSharedPreferences() : ' + _sharedPreferences.toString());
}

SharedPreferences getSharedPreferences() {
  return _sharedPreferences;
}
