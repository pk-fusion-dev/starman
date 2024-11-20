// To parse this JSON data, do
//
//     final outstandingSupplierModel = outstandingSupplierModelFromJson(jsonString);

import 'dart:convert';

OutstandingSupplierModel outstandingSupplierModelFromJson(String str) =>
    OutstandingSupplierModel.fromJson(json.decode(str));

class OutstandingSupplierModel {
  List<StarOutstandingList>? starOutstandingList;
  double? starPayableTotal;
  String? starCurrency;

  OutstandingSupplierModel({
    this.starOutstandingList,
    this.starPayableTotal,
    this.starCurrency,
  });

  factory OutstandingSupplierModel.fromJson(Map<String, dynamic> json) =>
      OutstandingSupplierModel(
        starOutstandingList: List<StarOutstandingList>.from(
            json["starOutstandingList"]
                .map((x) => StarOutstandingList.fromJson(x))),
        starPayableTotal: json["starPayableTotal"],
        starCurrency: json["starCurrency"],
      );
}

class StarOutstandingList {
  String starType;
  String starName;
  String starAddress;
  String starPhone;
  double starBalance;
  double starTotal;
  dynamic starCurrency;

  StarOutstandingList({
    required this.starType,
    required this.starName,
    required this.starAddress,
    required this.starPhone,
    required this.starBalance,
    required this.starTotal,
    required this.starCurrency,
  });

  factory StarOutstandingList.fromJson(Map<String, dynamic> json) =>
      StarOutstandingList(
        starType: json["starType"],
        starName: json["starName"],
        starAddress: json["starAddress"],
        starPhone: json["starPhone"],
        starBalance: json["starBalance"],
        starTotal: json["starTotal"],
        starCurrency: json["starCurrency"],
      );

  Map<String, dynamic> toJson() => {
        "starType": starType,
        "starName": starName,
        "starAddress": starAddress,
        "starPhone": starPhone,
        "starBalance": starBalance,
        "starTotal": starTotal,
        "starCurrency": starCurrency,
      };
}
