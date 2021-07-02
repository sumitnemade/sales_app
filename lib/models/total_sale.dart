import 'package:sales_app/models/entry.dart';

class TotalSales {
  int? totalQuantity;
  int? totalPrice;
  List<Entry>? allEntries;

  TotalSales({
    this.totalQuantity,
    this.totalPrice,
    this.allEntries,
  });

  factory TotalSales.fromJson(Map<String?, dynamic> json) {
    return TotalSales(
      totalQuantity: json['totalQuantity'],
      totalPrice: json['totalPrice'],
      allEntries: json['allEntries'] != null
          ? (json['allEntries'] as List).map((i) => Entry.fromJson(i)).toList()
          : null,
    );
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();

    data['totalQuantity'] = this.totalQuantity;
    data['totalPrice'] = this.totalPrice;
    if (this.allEntries != null) {
      data['allEntries'] = this.allEntries!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
