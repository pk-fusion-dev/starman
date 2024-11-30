import 'dart:convert';

OutstandingCustomerModel outstandingCustomerModelFromJson(String str) =>
    OutstandingCustomerModel.fromJson(json.decode(str));

class OutstandingCustomerModel {
  List<StarOutstandingList>? starOutstandingList;
  double? starReceivableTotal;
  String? starCurrency;

  OutstandingCustomerModel({
    this.starOutstandingList,
    this.starReceivableTotal,
    this.starCurrency,
  });

  factory OutstandingCustomerModel.fromJson(Map<String, dynamic> json) =>
      OutstandingCustomerModel(
        starOutstandingList: List<StarOutstandingList>.from(
            json["starOutstandingList"]
                .map((x) => StarOutstandingList.fromJson(x))),
        starReceivableTotal: json["starReceivableTotal"],
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
