import 'dart:async';
import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:provider/provider.dart';

import '../../../common/config.dart';
import '../../../common/constants.dart';
import '../../../models/app_model.dart';
import '../../../services/services.dart';

class PayStackServices {
  PayStackServices({required this.amount, required this.orderId, this.email});

  var publicKey = kPayStackConfig['publicKey'];
  final _plugin = PaystackPlugin();

  final domain = Services().api.domain;
  final String amount;
  final String orderId;
  final String? email;

  Future<String?> _initializeTransaction(params) async {
    try {
      var response = await httpPost(
        '$domain/wp-json/api/flutter_paystack/initialize_transaction'.toUri()!,
        body: convert.jsonEncode(params),
        headers: {'content-type': 'application/json'},
      );

      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 200 &&
          body['access_code'] != null &&
          body['access_code'].toString().isNotEmpty) {
        return body['access_code'];
      } else if (body['message'] != null) {
        throw body['message'];
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _verifyPayStackTransaction(params) async {
    try {
      await httpPost(
        '$domain/wp-json/api/flutter_paystack/verify_paystack_transaction'
            .toUri()!,
        body: convert.jsonEncode(params),
        headers: {'content-type': 'application/json'},
      );
      return;
    } catch (e) {
      rethrow;
    }
  }

  Future openPayment(BuildContext context, Function(bool) onLoading) async {
    try {
      final currency = Provider.of<AppModel>(context, listen: false).currency;
      Future.delayed(const Duration(milliseconds: 200), () {
        onLoading(true);
      });
      await _plugin.initialize(publicKey: publicKey);
      var params = {'order_id': orderId};
      var accessCode = await _initializeTransaction(params);
      var charge = Charge()
        ..amount = double.parse(amount).toInt() * 100
        ..accessCode = accessCode
        ..email = email
        ..currency = currency;
      onLoading(false);
      var response = await _plugin.checkout(
        context,
        method: CheckoutMethod.selectable,
        charge: charge,
      );
      if (response.status == true && response.message == 'Success') {
        onLoading(true);
        await _verifyPayStackTransaction({'reference': response.reference});
        onLoading(false);
        return;
      } else {
        throw response.message;
      }
    } catch (e) {
      onLoading(false);
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
