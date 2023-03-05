class RatingCount {
  final int oneStar;
  final int twoStar;
  final int threeStar;
  final int fourStar;
  final int fiveStar;

  const RatingCount({
    this.oneStar = 0,
    this.twoStar = 0,
    this.threeStar = 0,
    this.fourStar = 0,
    this.fiveStar = 0,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RatingCount &&
          runtimeType == other.runtimeType &&
          oneStar == other.oneStar &&
          twoStar == other.twoStar &&
          threeStar == other.threeStar &&
          fourStar == other.fourStar &&
          fiveStar == other.fiveStar);

  @override
  int get hashCode =>
      oneStar.hashCode ^
      twoStar.hashCode ^
      threeStar.hashCode ^
      fourStar.hashCode ^
      fiveStar.hashCode;

  @override
  String toString() {
    return 'ProductReviewRatingCount{ oneStar: $oneStar, twoStar: $twoStar, threeStar: $threeStar, fourStar: $fourStar, fiveStar: $fiveStar,}';
  }

  RatingCount copyWith({
    int? oneStar,
    int? twoStar,
    int? threeStar,
    int? fourStar,
    int? fiveStar,
  }) {
    return RatingCount(
      oneStar: oneStar ?? this.oneStar,
      twoStar: twoStar ?? this.twoStar,
      threeStar: threeStar ?? this.threeStar,
      fourStar: fourStar ?? this.fourStar,
      fiveStar: fiveStar ?? this.fiveStar,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'oneStar': oneStar,
      'twoStar': twoStar,
      'threeStar': threeStar,
      'fourStar': fourStar,
      'fiveStar': fiveStar,
    };
  }

  factory RatingCount.fromJson(Map<String, dynamic> map) {
    return RatingCount(
      oneStar: map['rating_1'] as int? ?? 0,
      twoStar: map['rating_2'] as int? ?? 0,
      threeStar: map['rating_3'] as int? ?? 0,
      fourStar: map['rating_4'] as int? ?? 0,
      fiveStar: map['rating_5'] as int? ?? 0,
    );
  }
}
