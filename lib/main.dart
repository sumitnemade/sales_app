import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/dish.dart';
import 'models/monthly_sale.dart';

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
  Map<String, MonthlySales> monthlyReport = Map();
  int _totalPrice = 0;
  int _totalQuantity = 0;

  bool _isLoading = false;

  @override
  void initState() {
    _loadEntries();
    super.initState();
  }

  void _loadEntries() async {
    setState(() {
      _isLoading = true;
    });

    await rootBundle.loadString('assets/sales-data.txt').then((q) {
      List<String> rows = LineSplitter().convert(q);

      for (int i = 0; i < rows.length; i++) {
        if (i != 0) {
          var splitted = rows[i].split(",");

          DateTime date = DateTime.parse(splitted[0].toString());
          String sku = splitted[1].toString();
          int quantity = int.parse(splitted[3].toString());
          int totalPrice = int.parse(splitted[4].toString());

          _totalPrice = _totalPrice + int.parse(splitted[4].toString());
          _totalQuantity = _totalQuantity + int.parse(splitted[3].toString());

          String key = "${date.month}-${date.year}";

          if (!monthlyReport.containsKey(key)) {
            MonthlySales mSales = MonthlySales();
            mSales.dishes = Map();
            mSales.allEntries = 1;
            mSales.totalQuantity = quantity;
            mSales.totalPrice = totalPrice;
            mSales.minQuantity = quantity;
            mSales.minQuantity = quantity;

            Dish dd = Dish();
            dd.sku = sku;
            dd.totalOrder = 1;
            dd.quantity = quantity;
            dd.maxQuantity = quantity;
            dd.minQuantity = quantity;
            dd.totalPrice = totalPrice;
            mSales.dishes![sku] = dd;
            monthlyReport[key] = mSales;
          } else {
            monthlyReport[key]!.allEntries =
                monthlyReport[key]!.allEntries! + 1;
            monthlyReport[key]!.totalQuantity =
                monthlyReport[key]!.totalQuantity! + quantity;
            monthlyReport[key]!.totalPrice =
                monthlyReport[key]!.totalPrice! + totalPrice;
            if (!monthlyReport[key]!.dishes!.containsKey(sku)) {
              Dish dd = Dish();
              dd.sku = sku;
              dd.totalOrder = 1;
              dd.quantity = quantity;
              dd.maxQuantity = quantity;
              dd.minQuantity = quantity;
              dd.totalPrice = totalPrice;
              monthlyReport[key]!.dishes![sku] = dd;
            } else {
              if (monthlyReport[key]!.dishes![sku]!.maxQuantity! < quantity)
                monthlyReport[key]!.dishes![sku]!.maxQuantity = quantity;

              if (monthlyReport[key]!.dishes![sku]!.minQuantity! > quantity)
                monthlyReport[key]!.dishes![sku]!.minQuantity = quantity;

              monthlyReport[key]!.dishes![sku]!.totalPrice =
                  monthlyReport[key]!.dishes![sku]!.totalPrice! + totalPrice;

              monthlyReport[key]!.dishes![sku]!.totalOrder =
                  monthlyReport[key]!.dishes![sku]!.totalOrder! + 1;

              int qnt = monthlyReport[key]!.dishes![sku]!.quantity! + quantity;
              monthlyReport[key]!.dishes![sku]!.quantity = qnt;
            }
          }
        }
      }
    });

    monthlyReport.forEach((key, value) {
      var sortedKeys = value.dishes!.keys.toList(growable: false)
        ..sort((k1, k2) => value.dishes![k1]!.quantity!
            .compareTo(value.dishes![k2]!.quantity!));
      LinkedHashMap sortedMap = new LinkedHashMap.fromIterable(sortedKeys,
          key: (k) => k, value: (k) => value.dishes![k]);

      value.popularItem = sortedMap.entries.last.value.sku;
      value.maxQuantity = sortedMap.entries.last.value.maxQuantity;
      value.minQuantity = sortedMap.entries.last.value.minQuantity;
      value.popularItemAvg =
          (value.allEntries! / sortedMap.entries.last.value.totalOrder!);

      var sortedKeyss = value.dishes!.keys.toList(growable: false)
        ..sort((k1, k2) => value.dishes![k1]!.totalPrice!
            .compareTo(value.dishes![k2]!.totalPrice!));
      LinkedHashMap sortedMaps = new LinkedHashMap.fromIterable(sortedKeyss,
          key: (k) => k, value: (k) => value.dishes![k]);

      value.popularRevenueItem = sortedMaps.entries.last.value.sku;
    });

    setState(() {
      _isLoading = false;
    });
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
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: ListView(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _mainTile('Total quantities', '$_totalQuantity'),
                    _mainTile('Total price', 'Rs.$_totalPrice'),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                if (monthlyReport.isNotEmpty)
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
                              '${monthlyReport.values.elementAt(i).popularItemAvg?.toStringAsFixed(2) ?? 0} '),
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
          if (_isLoading) Center(child: CircularProgressIndicator())
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
