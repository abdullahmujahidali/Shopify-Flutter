import 'package:charts_flutter_new/flutter.dart';

class SaleStats {
  SaleStats({
    this.grossSales,
    this.earnings,
    this.currency,
  });

  final Earnings? grossSales;
  final Earnings? earnings;
  final String? currency;

  factory SaleStats.fromMap(Map json) => SaleStats(
        grossSales: Earnings.fromMap(json['gross_sales']),
        earnings: Earnings.fromMap(json['earnings']),
        currency: json['currency'],
      );

  Map<String, dynamic> toMap() => {
        'gross_sales': grossSales!.toMap(),
        'earnings': earnings!.toMap(),
        'currency': currency,
      };
}

class Earnings {
  Earnings({
    this.lastMonth,
    this.month,
    this.year,
    this.week5,
    this.week4,
    this.week3,
    this.week2,
    this.week1,
    this.all,
    this.profitPercentage,
  });

  final double? lastMonth;
  final double? month;
  final double? year;
  final double? week5;
  final double? week4;
  final double? week3;
  final double? week2;
  final double? week1;
  final double? all;
  final double? profitPercentage;

  factory Earnings.fromMap(Map json) => Earnings(
        lastMonth: json['last_month'].toDouble(),
        month: json['month'].toDouble(),
        year: json['year'].toDouble(),
        week5: json['week_5'].toDouble(),
        week4: json['week_4'].toDouble(),
        week3: json['week_3'].toDouble(),
        week2: json['week_2'].toDouble(),
        week1: json['week_1'].toDouble(),
        all: json['all'].toDouble(),
        profitPercentage: json['profit_percentage']?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
        'last_month': lastMonth,
        'month': month,
        'year': year,
        'week_5': week5,
        'week_4': week4,
        'week_3': week3,
        'week_2': week2,
        'week_1': week1,
        'all': all,
        'profit_percentage': profitPercentage,
      };
}

class SaleSeries {
  String week;
  double sale;
  Color color;

  SaleSeries(this.week, this.sale, this.color);
}
