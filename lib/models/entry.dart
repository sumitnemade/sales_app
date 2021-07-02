class Entry {
  DateTime? date;
  String? sku;
  int? unitPrice;
  int? quantity;
  int? totalPrice;

  Entry({
    this.date,
    this.sku,
    this.unitPrice,
    this.quantity,
    this.totalPrice,
  });

  factory Entry.fromJson(Map<String?, dynamic> json) {
    return Entry(
      date: json['date'],
      sku: json['sku'],
      unitPrice: json['unitPrice'],
      quantity: json['quantity'],
      totalPrice: json['totalPrice'],
    );
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['date'] = this.date;
    data['sku'] = this.sku;
    data['unitPrice'] = this.unitPrice;
    data['quantity'] = this.quantity;
    data['totalPrice'] = this.totalPrice;
    return data;
  }
}
