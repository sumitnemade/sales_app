import 'package:sales_app/models/entry.dart';

class MonthlySales {
  int? totalQuantity;
  int? totalPrice;
  double? popularItemAvg;
  List<Entry>? allEntries;
  String? popularItem;
  String? popularRevenueItem;
  int? minQuantity;
  int? maxQuantity;

  MonthlySales({
    this.totalQuantity,
    this.totalPrice,
    this.allEntries,
    this.popularItemAvg,
    this.popularItem,
    this.maxQuantity,
    this.minQuantity,
    this.popularRevenueItem,
  });

  factory MonthlySales.fromJson(Map<String?, dynamic> json) {
    return MonthlySales(
      totalQuantity: json['totalQuantity'],
      popularRevenueItem: json['popularRevenueItem'],
      popularItem: json['popularItem'],
      maxQuantity: json['maxQuantity'],
      totalPrice: json['totalPrice'],
      popularItemAvg: json['popularItemAvg'],
      minQuantity: json['minQuantity'],
      allEntries: json['allEntries'] != null
          ? (json['allEntries'] as List).map((i) => Entry.fromJson(i)).toList()
          : null,
    );
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();

    data['totalQuantity'] = this.totalQuantity;
    data['popularRevenueItem'] = this.popularRevenueItem;
    data['popularItem'] = this.popularItem;
    data['maxQuantity'] = this.maxQuantity;
    data['totalPrice'] = this.totalPrice;
    data['popularItemAvg'] = this.popularItemAvg;
    data['minQuantity'] = this.minQuantity;
    if (this.allEntries != null) {
      data['allEntries'] = this.allEntries!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
