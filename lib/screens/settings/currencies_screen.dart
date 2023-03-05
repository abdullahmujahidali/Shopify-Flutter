import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../common/tools/flash.dart';
import '../../generated/l10n.dart';
import '../../models/app_model.dart';
import '../../models/entities/currency.dart';
import '../base_screen.dart';
import '../common/app_bar_mixin.dart';

class CurrenciesScreen extends StatefulWidget {
  @override
  BaseScreen<CurrenciesScreen> createState() => _CurrenciesScreenState();
}

class _CurrenciesScreenState extends BaseScreen<CurrenciesScreen>
    with AppBarMixin {
  String? currencyDisplay;

  @override
  void afterFirstLayout(BuildContext context) {
    currencyDisplay = Provider.of<AppModel>(context, listen: false).currency;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final currencies = kAdvanceConfig.currencies;
    return renderScaffold(
      routeName: RouteList.currencies,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          padding: showAppBar(RouteList.currencies) ? EdgeInsets.zero : null,
        ),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              S.of(context).currencies,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            leading: Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          body: ListView.separated(
            itemCount: currencies.length,
            separatorBuilder: (_, __) => const Divider(
              color: Colors.black12,
              height: 1.0,
              indent: 75,
              //endIndent: 20,
            ),
            itemBuilder: (_, index) => buildItem(currencies[index]),
          ),
        ),
      ),
    );
  }

  Widget buildItem(Currency currency) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.all(0),
      child: ListTile(
        title: Text('${currency.currencyDisplay} (${currency.symbol})'),
        onTap: () {
          setState(() {
            currencyDisplay = currency.currencyDisplay;
          });

          Provider.of<AppModel>(context, listen: false).changeCurrency(
            currency.currencyDisplay,
            context,
            code: currency.currencyCode,
          );

          FlashHelper.message(
            context,
            message: S.of(context).changedCurrencyTo(
                  currency.currencyDisplay,
                ),
          );
          context.navigator.pop();
        },
        trailing: currencyDisplay == currency.currencyDisplay
            ? const Icon(Icons.done)
            : Container(
                width: 20,
              ),
      ),
    );
  }
}
