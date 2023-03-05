const _kDefaultShowPrivacyPolicyFirstTime = false;
const _kDefaultShowDeleteAccount = false;
const _kDefaultCaptcha = 'PERMANENTLY DELETE';

class GdprConfig {
  final bool showPrivacyPolicyFirstTime;
  final bool showDeleteAccount;
  final String confirmCaptcha;

  const GdprConfig({
    required this.showPrivacyPolicyFirstTime,
    required this.showDeleteAccount,
    required this.confirmCaptcha,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GdprConfig &&
          runtimeType == other.runtimeType &&
          showPrivacyPolicyFirstTime == other.showPrivacyPolicyFirstTime &&
          showDeleteAccount == other.showDeleteAccount &&
          confirmCaptcha == other.confirmCaptcha);

  @override
  int get hashCode =>
      showPrivacyPolicyFirstTime.hashCode ^
      showDeleteAccount.hashCode ^
      confirmCaptcha.hashCode;

  @override
  String toString() {
    return 'GdprConfig{ showPrivacyPolicyFirstTime: $showPrivacyPolicyFirstTime, showDeleteAccount: $showDeleteAccount, confirmCaptcha: $confirmCaptcha,}';
  }

  GdprConfig copyWith({
    bool? showPrivacyPolicyFirstTime,
    bool? showDeleteAccount,
    String? confirmCaptcha,
  }) {
    return GdprConfig(
      showPrivacyPolicyFirstTime:
          showPrivacyPolicyFirstTime ?? this.showPrivacyPolicyFirstTime,
      showDeleteAccount: showDeleteAccount ?? this.showDeleteAccount,
      confirmCaptcha: confirmCaptcha ?? this.confirmCaptcha,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'showPrivacyPolicyFirstTime': showPrivacyPolicyFirstTime,
      'showDeleteAccount': showDeleteAccount,
      'confirmCaptcha': confirmCaptcha,
    };
  }

  factory GdprConfig.fromMap(Map map) {
    return GdprConfig(
      showPrivacyPolicyFirstTime: map['showPrivacyPolicyFirstTime'] ??
          _kDefaultShowPrivacyPolicyFirstTime,
      showDeleteAccount: map['showDeleteAccount'] ?? _kDefaultShowDeleteAccount,
      confirmCaptcha: map['confirmCaptcha'] ?? _kDefaultCaptcha,
    );
  }
}
