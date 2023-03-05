import 'dart:async';
import 'dart:convert' as convert;

import 'package:flutter/services.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';

import '../../../common/config.dart';
import '../../../common/constants.dart';
import '../../../services/services.dart';

class PayTmServices {
  PayTmServices({required this.amount, required this.orderId, this.email});

  final domain = Services().api.domain;
  final String amount;
  final String orderId;
  final String? email;

  Future<String?> _generateTxnToken(params) async {
    try {
      var response = await httpPost(
        '$domain/wp-json/api/flutter_paytm/generate_txn_token'.toUri()!,
        body: convert.jsonEncode(params),
        headers: {'content-type': 'application/json'},
      );

      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 200 &&
          body['txnToken'] != null &&
          body['txnToken'].toString().isNotEmpty) {
        return body['txnToken'];
      } else if (body['message'] != null) {
        throw body['message'];
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future openPayment() async {
    try {
      var params = {
        'order_id': orderId,
        'amount': amount,
        'cust_id': email ?? 'CUST_$orderId'
      };
      final txnToken = await _generateTxnToken(params);
      if (txnToken != null) {
        var merchantId = kPayTmConfig['merchantId'];
        var isProduction = kPayTmConfig['production'] ?? false;
        var restrictAppInvoke = false;
        var callbackUrl = !isProduction
            ? 'https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=$orderId'
            : 'https://securegw.paytm.in/theia/paytmCallback?ORDER_ID=$orderId';
        var value = await AllInOneSdk.startTransaction(merchantId, orderId,
            amount, txnToken, callbackUrl, !isProduction, restrictAppInvoke);
        return value;
      } else {
        throw "Can't generate txn token";
      }
    } catch (e) {
      if (e is PlatformException) {
        if (e.details is Map && Map.from(e.details)['response'] != null) {
          throw '${e.message ?? ''} ${Map.from(e.details)['response']}';
        } else {
          throw '${e.message ?? ''} ${e.details}';
        }
      } else {
        rethrow;
      }
    }
  }
}
