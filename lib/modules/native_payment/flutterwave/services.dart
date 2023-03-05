import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterwave_standard/core/transaction_status.dart';
import 'package:flutterwave_standard/flutterwave.dart';

import '../../../common/config.dart';
import '../../../common/constants.dart';
import '../../../services/services.dart';

class FlutterwaveServices {
  FlutterwaveServices(
      {required this.amount,
      required this.orderId,
      this.email,
      this.name,
      this.phone,
      this.currency,
      this.paymentMethod});

  var publicKey = kFlutterwaveConfig['publicKey'];

  final domain = Services().api.domain;
  final String amount;
  final String orderId;
  final String? name;
  final String? phone;
  final String? email;
  final String? currency;
  final String? paymentMethod;

  Future<void> _verifyPayment(String? txref) async {
    try {
      await httpGet(
        '$domain/wp-json/api/flutter_flutterwave/flw_verify_payment?txref=$txref'
            .toUri()!,
        headers: {'content-type': 'application/json'},
      );
      return;
    } catch (e) {
      rethrow;
    }
  }

  Future openPayment(BuildContext context, Function(bool) onLoading) async {
    try {
      Future.delayed(const Duration(milliseconds: 200), () {
        onLoading(true);
      });

      final customer = Customer(
          name: name ?? '', phoneNumber: phone ?? '', email: email ?? '');

      final flutterwave = Flutterwave(
          context: context,
          publicKey: publicKey,
          currency: currency,
          redirectUrl: 'https://google.com',
          txRef: 'WOOC_${orderId}_${DateTime.now().millisecondsSinceEpoch}',
          amount: amount,
          customer: customer,
          paymentOptions: 'ussd, card, barter, payattitude',
          customization: Customization(),
          isTestMode: kFlutterwaveConfig['production']);
      var response = await flutterwave.charge();
      if (response.success == true) {
        await _verifyPayment(response.txRef);
        onLoading(false);
      } else if (response.status == TransactionStatus.ERROR) {
        onLoading(false);
        throw 'Payment is failed';
      } else {
        onLoading(false);
      }
    } catch (e) {
      onLoading(false);
      if (e is PlatformException) {
        if (e.details is Map && Map.from(e.details)['response'] != null) {
          throw '${e.message ?? ''} ${Map.from(e.details)['response']}';
        } else {
          throw '${e.message ?? ''} ${e.details}';
        }
      } else if (e.toString() ==
          "type 'Null' is not a subtype of type 'FutureOr<ChargeResponse>'") {
        // handle back button
        throw 'Cancelled';
      } else {
        rethrow;
      }
    }
  }
}
