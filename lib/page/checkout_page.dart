import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kpostal/kpostal.dart';

import '../data/product_data.dart';
import '../util/util.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  List<(int, int)> cartList = [
    (1, 2),
    (4, 3),
  ];

  final formkey = GlobalKey<FormState>();

  double get totalPrice => cartList.fold(
      0.0, (total, cart) => total + productList[cart.$1].price! * cart.$2);

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

  // 결재수단
  final List<String> paymentMethodList = [
    '결재수단선택',
    '카드결재',
    '무통장입금',
  ];
  int _selectedPaymentIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('결재시작',),
        centerTitle: true,
      ),
      body: SingleChildScrollView(

        child: Column(
          children: [
            ListView.builder(
              itemCount: cartList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) => _checkoutContainer(cartList[index]),
            ),
            // 입력폼
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
            if (_selectedPaymentIndex == 1)
              Column(
                children: [
                  _getTextFormFiled(_cardNoController, '카드번호'),
                  _getTextFormFiled(_cardAuthController, '카드명의자 주민번호 앞자리', maxLength: 10),
                  _getTextFormFiled(_cardExpiredDateController, '카드 만료일 (YYYYMM)', maxLength: 6),
                  _getTextFormFiled(_cardPwdTwoDigitsController, '카드 비밀번호 앞2자리', obscureText: true, maxLength: 2),
                ],
              )
            else if (_selectedPaymentIndex == 2)
              _getTextFormFiled(_depositNameController, '입금자명'),
          ],
        ),
      ),
    );
  }

  Widget _checkoutContainer((int, int) cart) {
    print(cart);

    var foundProduct = productList.firstWhere((product) =>
    product.no == cart.$1);

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
                      Text('수량: ${cart.$2}',),
                      Text('합계: ${numberFormat.format(foundProduct.price! * cart.$2)}원',),
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
            _selectedPaymentIndex = paymentMethodList.indexWhere((payment) => payment == value);
          });
        },
        underline: Container(),
        isExpanded: true,
        items: paymentMethodList.map<DropdownMenuItem<String>>((payment) =>
          DropdownMenuItem<String>(
            child: Text(payment),
            value: payment,
          ),
        ).toList(),
        value: paymentMethodList[_selectedPaymentIndex],
      ),
    );
  }
}
