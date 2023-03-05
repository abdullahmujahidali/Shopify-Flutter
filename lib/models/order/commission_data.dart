import 'dart:convert';

class CommissionData {
  final String commissionPercent;
  final String commissionFixed;
  CommissionData({
    required this.commissionPercent,
    required this.commissionFixed,
  });

  CommissionData copyWith({
    String? commissionPercent,
    String? commissionFixed,
  }) {
    return CommissionData(
      commissionPercent: commissionPercent ?? this.commissionPercent,
      commissionFixed: commissionFixed ?? this.commissionFixed,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'commission_percent': commissionPercent,
      'commission_fixed': commissionFixed,
    };
  }

  factory CommissionData.fromMap(Map map) {
    return CommissionData(
      commissionPercent: map['commission_percent'] ?? '',
      commissionFixed: map['commission_fixed'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CommissionData.fromJson(String source) =>
      CommissionData.fromMap(json.decode(source));

  @override
  String toString() =>
      'CommissionData(commission_percent: $commissionPercent, commission_fixed: $commissionFixed)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CommissionData &&
        other.commissionPercent == commissionPercent &&
        other.commissionFixed == commissionFixed;
  }

  @override
  int get hashCode => commissionPercent.hashCode ^ commissionFixed.hashCode;
}
