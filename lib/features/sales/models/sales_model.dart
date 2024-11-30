// To parse this JSON data, do
//
//     final salesModel = salesModelFromJson(jsonString);

import 'dart:convert';

List<SalesModel> salesModelFromJson(String str) =>
    List<SalesModel>.from(json.decode(str).map((x) => SalesModel.fromJson(x)));

class SalesModel {
  List<StarNsItemList>? starNsItemList;
  double? starTotalAmount;
  double? starTaxAmount;
  double? starDiscountAmount;
  double? starPaidAmount;
  double? starNetAmount;
  double? starBalance;
  int? starTotalInvoice;
  String? starFiler;
  String? starCurrency;
  bool? starUseSingleLine;

  SalesModel({
    this.starNsItemList,
    this.starTotalAmount,
    this.starTaxAmount,
    this.starDiscountAmount,
    this.starPaidAmount,
    this.starNetAmount,
    this.starBalance,
    this.starTotalInvoice,
    this.starFiler,
    this.starCurrency,
    this.starUseSingleLine,
  });

  factory SalesModel.fromJson(Map<String, dynamic> json) => SalesModel(
        starNsItemList: List<StarNsItemList>.from(
            json["starNSItemList"].map((x) => StarNsItemList.fromJson(x))),
        starTotalAmount: json["starTotalAmount"],
        starTaxAmount: json["starTaxAmount"],
        starDiscountAmount: json["starDiscountAmount"],
        starPaidAmount: json["starPaidAmount"],
        starNetAmount: json["starNetAmount"],
        starBalance: json["starBalance"],
        starTotalInvoice: json["starTotalInvoice"],
        starFiler: json["starFiler"],
        starCurrency: json["starCurrency"],
        starUseSingleLine: json["starUseSingleLine"],
      );
}

class StarNsItemList {
  String? starInvovice;
  double? starAmount;
  double? starPaidAmount;
  String? starUserName;
  String? starCustomerName;
  dynamic starSupplierName;

  StarNsItemList({
    this.starInvovice,
    this.starAmount,
    this.starPaidAmount,
    this.starUserName,
    this.starCustomerName,
    this.starSupplierName,
  });

  factory StarNsItemList.fromJson(Map<String, dynamic> json) => StarNsItemList(
        starInvovice: json["starInvovice"],
        starAmount: json["starAmount"],
        starPaidAmount: json["starPaidAmount"],
        starUserName: json["starUserName"],
        starCustomerName: json["starCustomerName"],
        starSupplierName: json["starSupplierName"],
      );

  Map<String, dynamic> toJson() => {
        "starInvovice": starInvovice,
        "starAmount": starAmount,
        "starPaidAmount": starPaidAmount,
        "starUserName": starUserName,
        "starCustomerName": starCustomerName,
        "starSupplierName": starSupplierName,
      };
}
