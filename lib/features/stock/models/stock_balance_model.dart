import 'dart:convert';

StockBalanceModel stockBalanceFromJson(String str) => StockBalanceModel.fromJson(json.decode(str));

class StockBalanceModel {
  List<StarStockBalanceList>? starStockBalanceList;
  double? starTotalQty;
  double? starTotalAmount;
  String? starCurrency;

  StockBalanceModel({
    this.starStockBalanceList,
    this.starTotalQty,
    this.starTotalAmount,
    this.starCurrency,
  });

  factory StockBalanceModel.fromJson(Map<String, dynamic> json) => StockBalanceModel(
    starStockBalanceList: List<StarStockBalanceList>.from(json["starStockBalanceList"].map((x) => StarStockBalanceList.fromJson(x))),
    starTotalQty: json["starTotalQty"],
    starTotalAmount: json["starTotalAmount"],
    starCurrency: json["starCurrency"],
  );

}

class StarStockBalanceList {
  String starItemCode;
  String starItemName;
  String starCategoryName;
  double starQty;
  String starUnit;
  double starAmount;
  dynamic starCurrency;
  double starPurPrice;
  double starSalePrice1;
  double starSalePrice2;
  double starSalePrice3;
  String starLocationName;

  StarStockBalanceList({
    required this.starItemCode,
    required this.starItemName,
    required this.starCategoryName,
    required this.starQty,
    required this.starUnit,
    required this.starAmount,
    required this.starCurrency,
    required this.starPurPrice,
    required this.starSalePrice1,
    required this.starSalePrice2,
    required this.starSalePrice3,
    required this.starLocationName,
  });

  factory StarStockBalanceList.fromJson(Map<String, dynamic> json) => StarStockBalanceList(
    starItemCode: json["starItemCode"],
    starItemName: json["starItemName"],
    starCategoryName: json["starCategoryName"],
    starQty: json["starQty"],
    starUnit: json["starUnit"],
    starAmount: json["starAmount"],
    starCurrency: json["starCurrency"],
    starPurPrice: json["starPurPrice"],
    starSalePrice1: json["starSalePrice1"]?.toDouble(),
    starSalePrice2: json["starSalePrice2"]?.toDouble(),
    starSalePrice3: json["starSalePrice3"],
    starLocationName: json["StarLocationName"],
  );

  Map<String, dynamic> toJson() => {
    "starItemCode": starItemCode,
    "starItemName": starItemName,
    "starCategoryName": starCategoryName,
    "starQty": starQty,
    "starUnit": starUnit,
    "starAmount": starAmount,
    "starCurrency": starCurrency,
    "starPurPrice": starPurPrice,
    "starSalePrice1": starSalePrice1,
    "starSalePrice2": starSalePrice2,
    "starSalePrice3": starSalePrice3,
    "StarLocationName": starLocationName,
  };
}
