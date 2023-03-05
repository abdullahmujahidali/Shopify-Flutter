class DeliveryStat {
  int? delivered;
  int? pending;
  int? total;

  DeliveryStat({
    required this.delivered,
    required this.pending,
    required this.total,
  });

  DeliveryStat.fromJson(json) {
    delivered = int.parse(json['delivered'].toString());
    pending = int.parse(json['pending'].toString());
    total = int.parse(json['total'].toString());
  }

  Map toJson() {
    return {
      'delivered': delivered,
      'pending': pending,
      'total': total,
    };
  }
}
