class Product {
  int? no;
  String? name;
  String? detail;
  String? imageUrl;
  double? price;

  Product({this.no, this.name, this.detail, this.imageUrl, this.price});

  Product.fromJson(Map<String, dynamic> json) {
    no = int.parse(json['no']);
    name = json['name'];
    detail = json['detail'];
    imageUrl = json['imageUrl'];
    price = double.parse(json['price']);
  }

  Map<String, dynamic> toJson() {
    return {
      'no': no,
      'name': name,
      'detail': detail,
      'imageUrl': imageUrl,
      'price': price,
    };
  }
}
