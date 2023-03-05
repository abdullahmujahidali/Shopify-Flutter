import 'package:inspireui/inspireui.dart';

import 'user.dart';

class Transaction {
  final String id;
  final String? type;
  final double amount;
  final double balance;
  final String details;
  final String? createdTime;
  final String currency;
  final User? userCreate;

  const Transaction({
    this.id = '',
    this.type,
    this.amount = 0.0,
    this.balance = 0.0,
    this.details = '',
    this.createdTime,
    this.currency = '',
    this.userCreate,
  });

  factory Transaction.fromJson(Map parsedJson) {
    try {
      final id = parsedJson['transaction_id'].toString();
      final type = parsedJson['type'];
      final amount = double.parse(parsedJson['amount']);
      final balance = double.parse(parsedJson['balance']);
      final details = parsedJson['details'];
      final created = parsedJson['date'];
      final userCreateData = parsedJson['created_by'];
      final createdBy = parsedJson['created_by'] != null
          ? User.fromJson(userCreateData)
          : null;
      return Transaction(
        id: id,
        type: type,
        amount: amount,
        balance: balance,
        details: details,
        createdTime: created,
        currency: parsedJson['currency'] ?? '',
        userCreate: createdBy,
      );
    } catch (e, trace) {
      printLog(trace);
      return const Transaction();
    }
  }

  bool get isCredit => type == 'credit';

  bool get isTransfer => type == 'debit' && details.contains('transfer');

  String get transferNote => details;
}
