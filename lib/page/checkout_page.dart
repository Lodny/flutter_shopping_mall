import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shopping_mall/component/basic_dialog.dart';
import 'package:flutter_shopping_mall/enum/payment_type.dart';
import 'package:flutter_shopping_mall/page/order_result_page.dart';
import 'package:kpostal/kpostal.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/product_data.dart';
import '../util/util.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late SharedPreferences? _prefs;
  Map<String, dynamic> _cartMap = {};

  @override
  void initState() {
    _prefs = getSharedPreferences();
    _cartMap = jsonDecode(_prefs!.getString('cartMap') ?? '{}') ?? {};

    super.initState();
  }

  final formkey = GlobalKey<FormState>();

  double get totalPrice => _cartMap.entries.fold(0.0, (total, cart) {
    final foundProduct = productList.firstWhere((product) => product.no == int.parse(cart.key));
    return total + (foundProduct.price ?? 0) * cart.value;
  });

  // controller 변수 추가
  TextEditingController _buyerNameController = TextEditingController();
  TextEditingController _buyerEmailController = TextEditingController();
  TextEditingController _buyerPhoneController = TextEditingController();
  TextEditingController _receiverNameController = TextEditingController();
  TextEditingController _receiverPhoneController = TextEditingController();
  TextEditingController _receiverZipController = TextEditingController();
  TextEditingController _receiverAddress1Controller = TextEditingController();
  TextEditingController _receiverAddress2Controller = TextEditingController();
  TextEditingController _userPwdController = TextEditingController();
  TextEditingController _userConfirmPwdController = TextEditingController();
  TextEditingController _cardNoController = TextEditingController();
  TextEditingController _cardAuthController = TextEditingController();
  TextEditingController _cardExpiredDateController = TextEditingController();
  TextEditingController _cardPwdTwoDigitsController = TextEditingController();
  TextEditingController _depositNameController = TextEditingController();


  PaymentType _selectedPaymentType = PaymentType.select;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('결제시작',),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ListView.builder(
            //   itemCount: _cartMap.length,
            //   shrinkWrap: true,
            //   itemBuilder: (context, index) => _checkoutContainer(cartList[index]),
            // ),
            ..._cartMap.entries
                .map((cart) => _checkoutContainer(cart)).toList(),
            // 입력폼
            Form(
              key: formkey,
              child: Column(
                children: [
                  _getTextFormFiled(_buyerNameController, '주문자명'),
                  _getTextFormFiled(_buyerEmailController, '주문자 이메일'),
                  _getTextFormFiled(_buyerPhoneController, '주문자 휴대전화'),

                  _getTextFormFiled(_receiverNameController, '받는 사람 이름'),
                  _getTextFormFiled(_receiverPhoneController, '받는 사람 휴대 전화'),

                  _receiverZipTextField(),
                  _getTextFormFiled(_receiverAddress1Controller, '기본 주소', readOnly: true),
                  _getTextFormFiled(_receiverAddress2Controller, '상세 주소'),

                  _getTextFormFiled(_userPwdController, '비회원 주문조회 비밀번호', obscureText: true),
                  _getTextFormFiled(_userConfirmPwdController, '비회원 주문조회 비밀번호 확인', obscureText: true),

                  _paymentMethodDropdownButton(),
                  if (_selectedPaymentType == PaymentType.card)
                    Column(
                      children: [
                        _getTextFormFiled(_cardNoController, '카드번호'),
                        _getTextFormFiled(_cardAuthController, '카드명의자 주민번호 앞자리', maxLength: 10),
                        _getTextFormFiled(_cardExpiredDateController, '카드 만료일 (YYYYMM)', maxLength: 6),
                        _getTextFormFiled(_cardPwdTwoDigitsController, '카드 비밀번호 앞2자리', obscureText: true, maxLength: 2),
                      ],
                    )
                  else if (_selectedPaymentType == PaymentType.cash)
                    _getTextFormFiled(_depositNameController, '입금자명'),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: FilledButton(
          onPressed: () {
            if (! formkey.currentState!.validate()) return;

            if (_selectedPaymentType == PaymentType.select) {
              showDialog(
                context: context,
                builder: (context) =>
                    BasicDialog(
                      content: '결제수단을 선택해 주세요.',
                      buttonText: '닫기',
                      buttonFunction: () => Navigator.of(context).pop(),
                    ),
                barrierDismissible: true,
              );
              return;
            }

            Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                OrderResultPage(
                  paymentType: _selectedPaymentType,
                  paymentAmount: totalPrice,
                  zip: _receiverZipController.text,
                  address1: _receiverAddress1Controller.text,
                  address2: _receiverAddress2Controller.text,
                  receiveName: _receiverNameController.text,
                  receivePhone: _receiverPhoneController.text,
                ),
              ),
            );
          },
          child: Text(
            '합계: ${numberFormat.format(totalPrice)}원 결제하기',
          ),
        ),
      ),
    );
  }

  Widget _checkoutContainer(MapEntry<String, dynamic> cart) {
    print(cart);

    final foundProduct = productList.firstWhere((product) =>
      product.no == int.parse(cart.key));

    return foundProduct == null
        ? Container()
        : Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl: foundProduct.imageUrl!,
                  width: MediaQuery.of(context).size.width * .3,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                  errorWidget: (context, url, error) => Center(
                    child: const Text('오류 발생'),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8,),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        foundProduct.name!,
                        textScaleFactor: 1.2,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('${numberFormat.format(foundProduct.price)}'),
                      Text('수량: ${cart.value}',),
                      Text('합계: ${numberFormat.format(foundProduct.price! * cart.value)}원',),
                    ],
                  ),
                )
              ],
            ),
          );
  }

  Widget _getTextFormFiled(TextEditingController controller, String hintText, {
    bool readOnly = false,
    bool obscureText = false,
    int? maxLength}) {

    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        obscureText: obscureText,
        maxLength: maxLength,
        validator: (value) {
          if (value!.isEmpty) {
            return '내용을 입력해 주세요.';
          }

          if (controller == _userConfirmPwdController &&
              _userPwdController.text != _userConfirmPwdController.text) {
            return '비밀번호가 일치하지 않습니다.';
          }

          return null;
        },
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: hintText
        ),
      ),
    );
  }

  Widget _receiverZipTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              readOnly: true,
              controller: _receiverZipController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "우편번호",
              ),
            ),
          ),
          SizedBox(width: 15,),
          FilledButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => KpostalView(
                  callback: (result) {
                    _receiverZipController.text = result.postCode;
                    _receiverAddress1Controller.text = result.address;
                  },
                ),
              ),
            ),
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              )
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 22),
              child: const Text('우편 번호 찾기'),
            ),
          )
        ],
      ),
    );
  }

  Widget _paymentMethodDropdownButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(width: 0.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButton<String>(
        onChanged: (value) {
          setState(() {
            _selectedPaymentType = PaymentType.byCode(value!);
          });
        },
        underline: Container(),
        isExpanded: true,
        items: PaymentType.values.map<DropdownMenuItem<String>>((payment) =>
          DropdownMenuItem<String>(
            child: Text(payment.name),
            value: payment.code,
          ),
        ).toList(),
        value: _selectedPaymentType.code,
      ),
    );
  }
}
