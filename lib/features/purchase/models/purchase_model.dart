// To parse this JSON data, do
//
//     final PurchaseModel = PurchaseModelFromJson(jsonString);

import 'dart:convert';

List<PurchaseModel> purchaseModelFromJson(String str) =>
    List<PurchaseModel>.from(
        json.decode(str).map((x) => PurchaseModel.fromJson(x)));

class PurchaseModel {
  List<StarNpItemList>? starNpItemList;
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

  PurchaseModel({
    this.starNpItemList,
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

  factory PurchaseModel.fromJson(Map<String, dynamic> json) => PurchaseModel(
        starNpItemList: List<StarNpItemList>.from(
            json["starNPItemList"].map((x) => StarNpItemList.fromJson(x))),
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

class StarNpItemList {
  String? starInvovice;
  double? starAmount;
  double? starPaidAmount;
  String? starUserName;
  dynamic starCustomerName;
  String? starSupplierName;

  StarNpItemList({
    this.starInvovice,
    this.starAmount,
    this.starPaidAmount,
    this.starUserName,
    this.starCustomerName,
    this.starSupplierName,
  });

  factory StarNpItemList.fromJson(Map<String, dynamic> json) => StarNpItemList(
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
