class CreditCard {
  String? cardNumber;
  String? cardHolderName;
  String? expiryDate;
  String? cvv;
  bool? isCvvFocused = false;

  CreditCard({
    this.cardNumber,
    this.cardHolderName,
    this.expiryDate,
    this.cvv,
    this.isCvvFocused,
  });

  void setCreditCard(
      String cardNumber, String cardHolderName, String expiryDate, String cvv) {
    this.cardNumber = cardNumber;
    this.cardHolderName = cardHolderName;
    this.expiryDate = expiryDate;
    this.cvv = cvv;
  }

  Map<String, dynamic> toJson() {
    return {
      'cardNumber': cardNumber,
      'cardHolderName': cardHolderName,
      'expiryDate': expiryDate,
      'cvv': cvv,
    };
  }

  CreditCard.fromLocalJson(Map json) {
    try {
      cardNumber = json['cardNumber'];
      cardHolderName = json['cardHolderName'];
      expiryDate = json['expiryDate'];
      cvv = json['cvv'];
    } catch (_) {}
  }
}
