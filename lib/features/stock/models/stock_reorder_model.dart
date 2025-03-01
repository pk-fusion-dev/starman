import 'dart:convert';

List<StockReorderModel> stockReorderFromJson(String str) => List<StockReorderModel>.from(json.decode(str).map((x) => StockReorderModel.fromJson(x)));

String stockReorderToJson(List<StockReorderModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StockReorderModel {
  String? starItemCode;
  String? starItemName;
  String? starCategoryName;
  double? starInventoryQty;
  String? starUnit;
  double? starReorderQty;
  double? starFulfillQty;

  StockReorderModel({
    this.starItemCode,
    this.starItemName,
    this.starCategoryName,
    this.starInventoryQty,
    this.starUnit,
    this.starReorderQty,
    this.starFulfillQty,
  });

  factory StockReorderModel.fromJson(Map<String, dynamic> json) => StockReorderModel(
    starItemCode: json["starItemCode"],
    starItemName: json["starItemName"],
    starCategoryName: json["starCategoryName"],
    starInventoryQty: json["starInventoryQty"],
    starUnit: json["starUnit"],
    starReorderQty: json["starReorderQty"],
    starFulfillQty: json["starFulfillQty"],
  );

  Map<String, dynamic> toJson() => {
    "starItemCode": starItemCode,
    "starItemName": starItemName,
    "starCategoryName": starCategoryName,
    "starInventoryQty": starInventoryQty,
    "starUnit": starUnit,
    "starReorderQty": starReorderQty,
    "starFulfillQty": starFulfillQty,
  };
}
