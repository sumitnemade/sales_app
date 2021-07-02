import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/dish.dart';
import 'models/entry.dart';
import 'models/monthly_sale.dart';
import 'models/total_sale.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TotalSales _totalSales = TotalSales();
  Map<String, MonthlySales> monthlyReport = Map();

  @override
  void initState() {
    _loadEntries();
    super.initState();
  }

  void _loadEntries() async {
    List<Entry> entries = [];
    int j = 0;
    int totalPrice = 0;
    int totalQuantity = 0;

    await rootBundle.loadString('assets/sales-data.txt').then((q) {
      for (String i in LineSplitter().convert(q)) {
        if (j == 0) {
          j++;
        } else {
          var splitted = i.split(",");

          Entry entry = Entry();
          entry.date = DateTime.parse(splitted[0].toString());
          entry.sku = splitted[1].toString();
          entry.unitPrice = int.parse(splitted[2].toString());
          entry.quantity = int.parse(splitted[3].toString());
          entry.totalPrice = int.parse(splitted[4].toString());
          entries.add(entry);

          totalPrice = totalPrice + int.parse(splitted[4].toString());
          totalQuantity = totalPrice + int.parse(splitted[3].toString());
        }
      }
    });

    _totalSales.allEntries = entries;
    _totalSales.totalPrice = totalPrice;
    _totalSales.totalQuantity = totalQuantity;

    List<String> _months = [];

    entries.forEach((element) {
      if (!_months.contains("${element.date!.month}-${element.date!.year}"))
        _months.add("${element.date!.month}-${element.date!.year}");
    });

    _months.forEach((element) {
      MonthlySales mSales = MonthlySales();
      mSales.allEntries = entries
          .where((entry) =>
              entry.date!.month.toString() == element.toString().split("-")[0])
          .toList();
      int totalPriceMonth = 0;
      int totalQuantityMonth = 0;
      List<Dish?>? _dishes = [];
      mSales.allEntries!.forEach((ele) {
        totalPriceMonth = totalPriceMonth + ele.totalPrice!;
        totalQuantityMonth = totalQuantityMonth + ele.quantity!;
        Dish? did = _dishes.length > 0
            ? _dishes.firstWhere((d) => d?.sku == ele.sku, orElse: () => null)
            : null;

        if (did == null || did.sku == null) {
          Dish dd = Dish();
          dd.sku = ele.sku!;
          dd.totalOrder = mSales.allEntries!
              .where((ss) => ss.sku == dd.sku)
              .toList()
              .length;
          dd.quantity = ele.quantity!;
          dd.maxQuantity = ele.quantity!;
          dd.minQuantity = ele.quantity!;
          dd.totalPrice = ele.totalPrice!;
          _dishes.add(dd);
        } else {
          int ind = _dishes.indexWhere(
            (ind) => ind!.sku == did.sku,
          );

          if (did != null && did.sku != null) {
            if (did.maxQuantity! < ele.quantity!)
              did.maxQuantity = ele.quantity!;

            if (did.minQuantity! > ele.quantity!)
              did.minQuantity = ele.quantity!;

            did.totalPrice = did.totalPrice! + ele.totalPrice!;
            did.quantity = did.quantity! + ele.quantity!;
            _dishes[ind] = did;
          }
        }
      });

      _dishes.sort((a, b) => a!.quantity!.compareTo(b!.quantity!));

      mSales.totalPrice = totalPriceMonth;
      mSales.totalQuantity = totalQuantityMonth;
      mSales.popularItem = _dishes.last!.sku;
      mSales.maxQuantity = _dishes.last!.maxQuantity;
      mSales.minQuantity = _dishes.last!.minQuantity;
      mSales.popularItemAvg =
          (mSales.allEntries!.length / _dishes.last!.totalOrder!);

      _dishes.sort((a, b) => a!.totalPrice!.compareTo(b!.totalPrice!));

      mSales.popularRevenueItem = _dishes.last!.sku;

      monthlyReport[element] = mSales;
    });

    setState(() {});
  }

  String _getMonth(String m) {
    if (m == "1")
      return "January";
    else if (m == "2")
      return "February";
    else if (m == "3")
      return "March";
    else
      return "";
  }

  Widget _textTile(String key, String value) {
    return Row(
      children: [
        Text(
          key,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          value,
        ),
      ],
    );
  }

  Widget _mainTile(String key, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 3),
      child: Column(
        children: [
          Text(
            key,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            value,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sales App"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _mainTile('Total quantities', '${_totalSales.totalQuantity}'),
                _mainTile('Total price', 'Rs.${_totalSales.totalPrice}'),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: monthlyReport.length,
              padding: EdgeInsets.symmetric(vertical: 10),
              itemBuilder: (context, i) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _textTile("Month: ",
                        '${_getMonth(monthlyReport.keys.elementAt(i).split("-")[0])} - ${monthlyReport.keys.elementAt(i).split("-")[1]}'),
                    _textTile("Total Price: ",
                        'Rs.${monthlyReport.values.elementAt(i).totalPrice}'),
                    _textTile("Total Quantity: ",
                        '${monthlyReport.values.elementAt(i).totalQuantity}'),
                    _textTile("Most Revenue generated by: ",
                        '${monthlyReport.values.elementAt(i).popularRevenueItem}'),
                    _textTile("Popular item: ",
                        '${monthlyReport.values.elementAt(i).popularItem}'),
                    _textTile("Average orders: ",
                        '${monthlyReport.values.elementAt(i).popularItemAvg!.toStringAsFixed(2)}'),
                    _textTile("Minimum quantity: ",
                        '${monthlyReport.values.elementAt(i).minQuantity}'),
                    _textTile("Max quantity: ",
                        '${monthlyReport.values.elementAt(i).maxQuantity}'),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                );
              },
            )
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
