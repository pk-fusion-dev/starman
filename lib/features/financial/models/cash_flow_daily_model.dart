class CashFlowDailyModel {
  final List<StarCFByDateDetail>? starCFByDateDetailList;
  final double? starTotalIncome;
  final double? starTotalExpense;
  final double? starTotalBalance;
  final String? starFilter;
  final String? starCurrency;

  CashFlowDailyModel({
    this.starCFByDateDetailList,
    this.starTotalIncome,
    this.starTotalExpense,
    this.starTotalBalance,
    this.starFilter,
    this.starCurrency,
  });

  factory CashFlowDailyModel.fromJson(Map<String, dynamic> json) {
    return CashFlowDailyModel(
      starCFByDateDetailList: json['starCFByDateDetailList'] == null
          ? []
          : (json['starCFByDateDetailList'] as List)
              .map((item) => StarCFByDateDetail.fromJson(item))
              .toList(),
      starTotalIncome: json['starTotalIncome'].toDouble() ?? 0,
      starTotalExpense: json['starTotalExpense'].toDouble() ?? 0,
      starTotalBalance: json['starTotalBalance'].toDouble() ?? 0,
      starFilter: json['starFilter'] ?? '',
      starCurrency: json['starCurrency'] ?? '',
    );
  }

  @override
  String toString() {
    return 'CashFlowDailyModel(starCFByDateDetailList: $starCFByDateDetailList, '
        'starTotalIncome: $starTotalIncome, '
        'starTotalExpense: $starTotalExpense, '
        'starTotalBalance: $starTotalBalance, '
        'starFilter: $starFilter, '
        'starCurrency: $starCurrency)';
  }
}

class StarCFByDateDetail {
  String? starDate;
  double? starIncome;
  double? starExpense;
  double? starBalance;

  StarCFByDateDetail({
    this.starDate,
    this.starIncome,
    this.starExpense,
    this.starBalance,
  });

  factory StarCFByDateDetail.fromJson(Map<String, dynamic> json) {
    return StarCFByDateDetail(
      starDate: json['starDate'] ?? '-',
      starIncome: json['starIncome'].toDouble() ?? 0,
      starExpense: json['starExpense'].toDouble() ?? 0,
      starBalance: json['starBalance'].toDouble() ?? 0,
    );
  }

  @override
  String toString() {
    return 'StarCFByDateDetail(starDate: $starDate, '
        'starIncome: $starIncome, '
        'starExpense: $starExpense, '
        'starBalance: $starBalance)';
  }
}
