import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../common/tools.dart';
import '../../generated/l10n.dart';
import '../../models/index.dart' show AppModel, CartModel, Product, TaxModel;
import '../../services/index.dart';
import '../../widgets/common/common_safe_area.dart';
import '../../widgets/common/expansion_info.dart';
import '../../widgets/product/cart_item.dart';
import '../base_screen.dart';
import '../cart/widgets/shopping_cart_sumary.dart';

class ReviewScreen extends StatefulWidget {
  final Function? onBack;
  final Function? onNext;

  const ReviewScreen({this.onBack, this.onNext});

  @override
  BaseScreen<ReviewScreen> createState() => _ReviewState();
}

class _ReviewState extends BaseScreen<ReviewScreen> {
  TextEditingController note = TextEditingController();
  bool enabledShipping = kPaymentConfig.enableShipping;

  @override
  void initState() {
    var notes = Provider.of<CartModel>(context, listen: false).notes;
    note.text = notes ?? '';
    super.initState();
    Future.delayed(Duration.zero, () {
      final cartModel = Provider.of<CartModel>(context, listen: false);
      setState(() {
        enabledShipping = cartModel.isEnabledShipping();
      });
    });
  }

  @override
  void afterFirstLayout(BuildContext context) {
    Provider.of<TaxModel>(context, listen: false).getTaxes(
        Provider.of<CartModel>(context, listen: false), (taxesTotal, taxes) {
      Provider.of<CartModel>(context, listen: false).taxesTotal = taxesTotal;
      Provider.of<CartModel>(context, listen: false).taxes = taxes;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencyRate = Provider.of<AppModel>(context).currencyRate;
    final taxModel = Provider.of<TaxModel>(context);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Consumer<CartModel>(
              builder: (context, model, child) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      enabledShipping
                          ? ExpansionInfo(
                              title: S.of(context).shippingAddress,
                              children: <Widget>[
                                ShippingAddressInfo(),
                              ],
                            )
                          : const SizedBox(),
                      Container(
                        height: 1,
                        decoration: const BoxDecoration(color: kGrey200),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Text(S.of(context).orderDetail,
                            style: const TextStyle(fontSize: 18)),
                      ),
                      ...getProducts(model, context),
                      const ShoppingCartSummary(showPrice: false),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              S.of(context).subtotal,
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            Text(
                              PriceTools.getCurrencyFormatted(
                                  model.getSubTotal(), currencyRate,
                                  currency: model.currencyCode)!,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontSize: 14,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                            )
                          ],
                        ),
                      ),
                      Services().widget.renderShippingMethodInfo(context),
                      if (model.getCoupon() != '')
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                S.of(context).discount,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                              ),
                              Text(
                                model.getCoupon(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      fontSize: 14,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                              )
                            ],
                          ),
                        ),
                      Services().widget.renderTaxes(taxModel, context),
                      Services().widget.renderRewardInfo(context),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              S.of(context).total,
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            Text(
                              PriceTools.getCurrencyFormatted(
                                  model.getTotal(), currencyRate,
                                  currency: model.currencyCode)!,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontSize: 20,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                            )
                          ],
                        ),
                      ),
                      Services().widget.renderRecurringTotals(context),
                      if (kEnableCustomerNote) ...[
                        const SizedBox(height: 20),
                        Text(
                          S.of(context).yourNote,
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 0.2,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextField(
                            maxLines: 5,
                            controller: note,
                            style: const TextStyle(fontSize: 13),
                            decoration: InputDecoration(
                                hintText: S.of(context).writeYourNote,
                                hintStyle: const TextStyle(fontSize: 12),
                                border: InputBorder.none),
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        _buildBottom(),
      ],
    );
  }

  Widget _buildBottom() {
    return CommonSafeArea(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (enabledShipping || kPaymentConfig.enableAddress) ...[
            SizedBox(
              width: 130,
              child: OutlinedButton(
                onPressed: () {
                  widget.onBack!();
                },
                child: Text(
                  S.of(context).goBack.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: ButtonTheme(
              height: 45,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Theme.of(context).primaryColor,
                  elevation: 0,
                ),
                onPressed: () {
                  widget.onNext!();
                  if (note.text.isNotEmpty) {
                    Provider.of<CartModel>(context, listen: false)
                        .setOrderNotes(note.text);
                  }
                },
                icon: const Icon(
                  CupertinoIcons.creditcard,
                  size: 18,
                ),
                label: Text(S.of(context).continueToPayment.toUpperCase()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> getProducts(CartModel model, BuildContext context) {
    return model.productsInCart.keys.map(
      (key) {
        var productId = Product.cleanProductID(key);

        return ShoppingCartRow(
          addonsOptions: model.productAddonsOptionsInCart[key],
          product: model.getProductById(productId),
          variation: model.getProductVariationById(key),
          quantity: model.productsInCart[key],
          options: model.productsMetaDataInCart[key],
        );
      },
    ).toList();
  }
}

class ShippingAddressInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartModel = Provider.of<CartModel>(context);
    final address = cartModel.address!;

    return Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 120,
                  child: Text(
                    '${S.of(context).firstName} :',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    address.firstName!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 120,
                  child: Text(
                    '${S.of(context).lastName} :',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    address.lastName!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 120,
                  child: Text(
                    '${S.of(context).email} :',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    address.email!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 120,
                  child: Text(
                    '${S.of(context).streetName} :',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    address.street!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 120,
                  child: Text(
                    '${S.of(context).city} :',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    address.city!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 120,
                  child: Text(
                    '${S.of(context).stateProvince} :',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    address.state!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                )
              ],
            ),
          ),
          FutureBuilder(
            future: Services().widget.getCountryName(context, address.country),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 120,
                        child: Text(
                          '${S.of(context).country} :',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          snapshot.data as String,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 120,
                  child: Text(
                    '${S.of(context).phoneNumber} :',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    address.phoneNumber!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
