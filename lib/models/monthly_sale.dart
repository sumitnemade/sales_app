import 'dish.dart';

class MonthlySales {
  int? totalQuantity;
  int? totalPrice;
  double? popularItemAvg;
  String? popularItem;
  String? popularRevenueItem;
  int? allEntries;
  int? minQuantity;
  int? maxQuantity;
  Map<String, Dish>? dishes;

  MonthlySales({
    this.totalQuantity,
    this.totalPrice,
    this.popularItemAvg,
    this.popularItem,
    this.dishes,
    this.maxQuantity,
    this.allEntries,
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
      allEntries: json['allEntries'],
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
    data['allEntries'] = this.allEntries;

    return data;
  }
}
