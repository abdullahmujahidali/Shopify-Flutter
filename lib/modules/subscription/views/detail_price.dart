import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/tools.dart';
import '../../../models/app_model.dart';
import '../../../models/entities/product.dart';

class DetailPrice extends StatelessWidget {
  final Product product;
  final String? price;
  const DetailPrice({Key? key, required this.product, this.price})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (product.type == 'variable-subscription' ||
        product.type == 'subscription') {
      final currency = Provider.of<AppModel>(context, listen: false).currency;
      final currencyRate =
          Provider.of<AppModel>(context, listen: false).currencyRate;

      final billingInterval = product.metaData.firstWhere(
          (element) => element['key'] == '_subscription_period_interval',
          orElse: () => {})['value'];
      final billingPeriod = product.metaData.firstWhere(
          (element) => element['key'] == '_subscription_period',
          orElse: () => {})['value'];
      final trialLength = product.metaData.firstWhere(
          (element) => element['key'] == '_subscription_trial_length',
          orElse: () => {})['value'];
      final trialPeriod = product.metaData.firstWhere(
          (element) => element['key'] == '_subscription_trial_period',
          orElse: () => {})['value'];
      final signUpFee = product.metaData.firstWhere(
          (element) => element['key'] == '_subscription_sign_up_fee',
          orElse: () => {})['value'];

      var title =
          '${PriceTools.getCurrencyFormatted(price ?? '0.0', currencyRate, currency: currency)!} every ';
      if (billingInterval.toString().isNotEmpty &&
          int.parse(billingInterval.toString()) > 1) {
        title += billingInterval + ' ' + billingPeriod + 's';
      } else {
        title += billingPeriod;
      }

      if (trialLength.toString().isNotEmpty &&
          int.parse(trialLength.toString()) > 0) {
        var trailLength = ' with $trialLength';
        title += '$trailLength-$trialPeriod free trial';
      }

      if (signUpFee.toString().isNotEmpty &&
          int.parse(signUpFee.toString()) > 0) {
        title +=
            ' and a ${PriceTools.getCurrencyFormatted(signUpFee ?? '0.0', currencyRate, currency: currency)!} sign-up fee';
      }
      return Text(
        title,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w600,
            ),
      );
    } else {
      return const SizedBox();
    }
  }
}
