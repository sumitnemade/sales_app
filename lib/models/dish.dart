class Dish {
  String? sku;
  int? totalPrice;
  int? quantity;
  int? totalOrder;
  int? maxQuantity;
  int? minQuantity;

  Dish({
    this.sku,
    this.totalPrice,
    this.quantity,
    this.totalOrder,
    this.minQuantity,
    this.maxQuantity,
  });

  factory Dish.fromJson(Map<String?, dynamic> json) {
    return Dish(
      sku: json['sku'],
      totalPrice: json['totalPrice'],
      quantity: json['quantity'],
      maxQuantity: json['maxQuantity'],
      totalOrder: json['totalOrder'],
      minQuantity: json['minQuantity'],
    );
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['sku'] = this.sku;
    data['totalPrice'] = this.totalPrice;
    data['quantity'] = this.quantity;
    data['minQuantity'] = this.minQuantity;
    data['maxQuantity'] = this.maxQuantity;
    data['totalOrder'] = this.totalOrder;
    return data;
  }
}
