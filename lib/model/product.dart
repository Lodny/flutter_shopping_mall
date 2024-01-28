class Product {
  int? no;
  String? name;
  String? detail;
  String? imageUrl;
  double? price;

  Product({this.no, this.name, this.detail, this.imageUrl, this.price});

  Product.fromJson(Map<String, dynamic> json) {
    no = json['no'];
    name = json['name'];
    imageUrl = json['imageUrl'];
    price = (json['price'] as int).toDouble();
    price = (json['price'] as int).toDouble();
  }

  Map<String, dynamic> toJson() {
    return {
      'no': no,
      'name': name,
      // 'detail': detail,
      'imageUrl': imageUrl,
      'price': price,
    };
  }
}
