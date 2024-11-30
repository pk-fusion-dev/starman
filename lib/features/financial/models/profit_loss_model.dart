class ProfitLossModel {
  double? starSaleAmount;
  double? starSoldItemValue;
  double? starPurchaseDiscount;
  double? starOtherIncome;
  double? starExtraCharge;
  double? starTotalIncome;
  double? starSalesDiscount;
  double? starSalesTax;
  double? starPurchaseTax;
  double? starDamagedLostAmount;
  double? starOtherExpense;
  double? starTotalExpense;
  double? starProfitLoss;
  String? starFilter;
  String? starCurrency;
  double? starPurchaseExtraCharge;

  ProfitLossModel({
    this.starSaleAmount,
    this.starSoldItemValue,
    this.starPurchaseDiscount,
    this.starOtherIncome,
    this.starExtraCharge,
    this.starTotalIncome,
    this.starSalesDiscount,
    this.starSalesTax,
    this.starPurchaseTax,
    this.starDamagedLostAmount,
    this.starOtherExpense,
    this.starTotalExpense,
    this.starProfitLoss,
    this.starFilter,
    this.starCurrency,
    this.starPurchaseExtraCharge,
  });

  factory ProfitLossModel.fromJson(Map<String, dynamic> json) =>
      ProfitLossModel(
        starSaleAmount: json['starSaleAmount'] as double?,
        starSoldItemValue: json['starSoldItemValue'] as double?,
        starPurchaseDiscount: json['starPurchaseDiscount'] as double?,
        starOtherIncome: json['starOtherIncome'] as double?,
        starExtraCharge: json['starExtraCharge'] as double?,
        starTotalIncome: json['starTotalIncome'] as double?,
        starSalesDiscount: json['starSalesDiscount'] as double?,
        starSalesTax: json['starSalesTax'] as double?,
        starPurchaseTax: json['starPurchaseTax'] as double?,
        starDamagedLostAmount: json['starDamagedLostAmount'] as double?,
        starOtherExpense: json['starOtherExpense'] as double?,
        starTotalExpense: json['starTotalExpense'] as double?,
        starProfitLoss: json['starProfitLoss'] as double?,
        starFilter: json['starFilter'] as String?,
        starCurrency: json['starCurrency'] as String?,
        starPurchaseExtraCharge: json['starPurchaseExtraCharge'] as double?,
      );
}
