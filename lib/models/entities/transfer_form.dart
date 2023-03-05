class TransferForm {
  final String email;
  final int amount;
  final String? note;

  TransferForm({
    required this.email,
    required this.amount,
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'to': email,
      'amount': amount.toString(),
      'note': note ?? '',
    };
  }
}
