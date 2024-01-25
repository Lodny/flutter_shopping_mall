import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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

  double get totalPrice => cartList.fold(
      0.0, (total, cart) => total + productList[cart.$1].price! * cart.$2);

  // controller 변수 추가
  TextEditingController buyerNameController = TextEditingController();
  TextEditingController buyerEmailController = TextEditingController();
  TextEditingController buyerPhoneController = TextEditingController();
  TextEditingController receiverNameController = TextEditingController();
  TextEditingController receiverPhoneController = TextEditingController();
  TextEditingController receiverZipController = TextEditingController();
  TextEditingController receiverAddress1Controller = TextEditingController();
  TextEditingController receiverAddress2Controller = TextEditingController();
  TextEditingController userPwdController = TextEditingController();
  TextEditingController userConfirmPwdController = TextEditingController();
  TextEditingController cardNoController = TextEditingController();
  TextEditingController cardAuthController = TextEditingController();
  TextEditingController cardExpiredDateController = TextEditingController();
  TextEditingController cardPwdTwoDigitsController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('결재시작',),
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
            _buyerNameTextFiled(),
            _buyerEmailTextField(),
            _buyerPhoneTextField(),
            _receiverNameTextField(),
            _receiverPhoneTextField(),
            _receiverZipTextField(),
            _receiverAddress1TextField(),
            _receiverAddress2TextField(),
            _userPwdTextField(),
            _userConfirmPwdTextField(),
            _cardNoTextField(),
            _cardAuthTextField(),
            _cardExpiredDateTextField(),
            _cardPwdTwoDigitsTextField(),
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
            padding: EdgeInsets.all(8),
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
                    child: Text('오류 발생'),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8,),
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

  Widget _buyerNameTextFiled() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        controller: buyerNameController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: '주문자명'
        ),
      ),
    );
  }

  Widget _buyerEmailTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: buyerEmailController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: "주문자 이메일",
        ),
      ),
    );
  }

  Widget _buyerPhoneTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: buyerPhoneController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: "주문자 휴대전화",
        ),
      ),
    );
  }

  Widget _receiverNameTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: receiverNameController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: "받는 사람 이름",
        ),
      ),
    );
  }

  Widget _receiverPhoneTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: receiverPhoneController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: "받는 사람 휴대 전화",
        ),
      ),
    );
  }

  Widget _receiverZipTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: receiverZipController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: "우편번호",
        ),
      ),
    );
  }

  Widget _receiverAddress1TextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: receiverAddress1Controller,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: "기본 주소",
        ),
      ),
    );
  }

  Widget _receiverAddress2TextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: receiverAddress2Controller,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: "상세 주소",
        ),
      ),
    );
  }

  Widget _userPwdTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: userPwdController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: "비회원 주문조회 비밀번호",
        ),
      ),
    );
  }

  Widget _userConfirmPwdTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: userConfirmPwdController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: "비회원 주문조회 비밀번호 확인",
        ),
      ),
    );
  }

  Widget _cardNoTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: cardNoController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: "카드번호",
        ),
      ),
    );
  }

  Widget _cardAuthTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: cardAuthController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: "카드명의자 주민번호 앞자리",
        ),
      ),
    );
  }

  Widget _cardExpiredDateTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: cardExpiredDateController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: "카드 만료일",
        ),
      ),
    );
  }

  Widget _cardPwdTwoDigitsTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: cardPwdTwoDigitsController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: "카드 비밀번호 앞2자리",
        ),
      ),
    );
  }
}
