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
}
