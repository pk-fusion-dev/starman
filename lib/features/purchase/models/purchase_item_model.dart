import 'dart:convert';

List<PurchaseItemModel> purchaseItemModelFromJson(String str) =>
    List<PurchaseItemModel>.from(
        json.decode(str).map((x) => PurchaseItemModel.fromJson(x)));

class PurchaseItemModel {
  List<StarItemList>? starItemList;
  double? starTotalAmount;
  String? starFilter;
  int? starItemCount;
  double? starTotalQty;
  String? starCurrency;

  PurchaseItemModel({
    this.starItemList,
    this.starTotalAmount,
    this.starFilter,
    this.starItemCount,
    this.starTotalQty,
    this.starCurrency,
  });

  factory PurchaseItemModel.fromJson(Map<String, dynamic> json) =>
      PurchaseItemModel(
        starItemList: List<StarItemList>.from(
            json["starItemList"].map((x) => StarItemList.fromJson(x))),
        starTotalAmount: json["starTotalAmount"],
        starFilter: json["starFilter"],
        starItemCount: json["starItemCount"],
        starTotalQty: json["starTotalQty"],
        starCurrency: json["starCurrency"],
      );
}

class StarItemList {
  String? starCategoryName;
  String? starItemName;
  double? starQty;
  String? starUnit;
  double? starAmount;

  StarItemList({
    this.starCategoryName,
    this.starItemName,
    this.starQty,
    this.starUnit,
    this.starAmount,
  });

  factory StarItemList.fromJson(Map<String, dynamic> json) => StarItemList(
        starCategoryName: json["starCategoryName"],
        starItemName: json["starItemName"],
        starQty: json["starQty"],
        starUnit: json["starUnit"],
        starAmount: json["starAmount"],
      );
}
