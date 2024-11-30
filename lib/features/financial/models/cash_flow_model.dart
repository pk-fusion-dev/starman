class CashFlowModel {
  double? starSalesAmount;
  double? starOtherIncome;
  double? starCustomerPayment;
  double? starTotalCashIn;
  double? starPurchaseAmount;
  double? starOtherExpense;
  double? starSupplierPayment;
  double? starDepositOwner;
  double? starTotalCashOut;
  double? starTotal;
  String? starFilter;
  String? starCurrency;

  CashFlowModel({
    this.starSalesAmount,
    this.starOtherIncome,
    this.starCustomerPayment,
    this.starTotalCashIn,
    this.starPurchaseAmount,
    this.starOtherExpense,
    this.starSupplierPayment,
    this.starDepositOwner,
    this.starTotalCashOut,
    this.starTotal,
    this.starFilter,
    this.starCurrency,
  });

  factory CashFlowModel.fromJson(Map<String, dynamic> json) => CashFlowModel(
        starSalesAmount: json['starSalesAmount'] as double?,
        starOtherIncome: json['starOtherIncome'] as double?,
        starCustomerPayment: json['starCustomerPayment'] as double?,
        starTotalCashIn: json['starTotalCashIn'] as double?,
        starPurchaseAmount: json['starPurchaseAmount'] as double?,
        starOtherExpense: json['starOtherExpense'] as double?,
        starSupplierPayment: json['starSupplierPayment'] as double?,
        starDepositOwner: json['starDepositOwner'] as double?,
        starTotalCashOut: json['starTotalCashOut'] as double?,
        starTotal: json['starTotal'] as double?,
        starFilter: json['starFilter'] as String?,
        starCurrency: json['starCurrency'] as String?,
      );
}
