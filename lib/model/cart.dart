class Cart {
  int id;
  int count;

  Cart(this.id, this.count);

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      int.parse(json['id']),
      int.parse(json['count']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'count': count,
    };
  }
}
