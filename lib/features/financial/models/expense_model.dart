import 'dart:convert';

List<ExpenseModel> expenseModelFromJson(String str) => List<ExpenseModel>.from(
    json.decode(str).map((x) => ExpenseModel.fromJson(x)));

class ExpenseModel {
  List<StarIncExpList>? starIncExpList;
  double? starTotal;
  String? starFilter;
  String? starCurrency;

  ExpenseModel({
    this.starIncExpList,
    this.starTotal,
    this.starFilter,
    this.starCurrency,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) => ExpenseModel(
        starIncExpList: List<StarIncExpList>.from(
            json["starIncExpList"].map((x) => StarIncExpList.fromJson(x))),
        starTotal: json["starTotal"],
        starFilter: json["starFilter"],
        starCurrency: json["starCurrency"],
      );
}

class StarIncExpList {
  String? starName;
  double? starAmount;
  int starStatus;

  StarIncExpList({
    this.starName,
    this.starAmount,
    required this.starStatus,
  });

  factory StarIncExpList.fromJson(Map<String, dynamic> json) => StarIncExpList(
        starName: json["starName"],
        starAmount: json["starAmount"],
        starStatus: json["starStatus"] ?? 1,
      );
}
