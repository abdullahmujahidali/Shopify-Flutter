import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../../common/tools.dart';
import '../../../generated/l10n.dart';
import '../../../models/booking/booking_model.dart';
import '../../../models/cart/cart_model.dart';
import '../../../models/entities/index.dart';
import '../../../services/services.dart';

class ReOrderItemList extends StatefulWidget {
  final List<ProductItem> lineItems;

  const ReOrderItemList({Key? key, required this.lineItems}) : super(key: key);

  @override
  State<ReOrderItemList> createState() => _ReOrderItemListState();
}

class _ReOrderItemListState extends State<ReOrderItemList> {
  final Map<String, String> _errorMessages = {};
  final Map<String, BookingModel?> _bookingProducts = {};
  final _pageController = PageController();
  String _currentProductId = '';

  final Map<String, ProductItem> _products = {};

  bool _isSelectingDate = false;

  @override
  void initState() {
    for (var item in widget.lineItems) {
      final id = item.id;
      if (id == null) {
        continue;
      }
      _products[id] = item;
    }
    super.initState();
  }

  void _selectDatesTapped(String id) {
    _currentProductId = id;
    _isSelectingDate = true;
    _pageController.jumpToPage(1);
    setState(() {});
  }

  void _setBookingInfo(BookingModel bookingInfo) {
    _bookingProducts[_currentProductId] = bookingInfo;
    _isSelectingDate = false;
    _pageController.jumpToPage(0);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: const EdgeInsets.only(top: 8.0),
            alignment: Alignment.center,
            width: 40.0,
            height: 4.0,
            decoration: BoxDecoration(
              color: kGrey400,
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        Positioned(
          top: 44.0,
          bottom: 0,
          right: 0,
          left: 0,
          child: SafeArea(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                ListView.separated(
                  padding: const EdgeInsets.only(
                    bottom: kToolbarHeight,
                    left: 16.0,
                    right: 16.0,
                  ),
                  itemBuilder: (context, _) {
                    final product = _products.values.elementAt(_);
                    final productId = product.id;

                    var addonsOptions = {};
                    if (product.addonsOptions.isNotEmpty) {
                      for (var element in (product.addonsOptions.keys)) {
                        addonsOptions[element] = Tools.getFileNameFromUrl(
                            product.addonsOptions[element]!);
                      }
                    }

                    final isBookingType =
                        product.product!.type == 'appointment';
                    final isBookingSet = _bookingProducts[productId] != null;

                    if (isBookingType) {
                      if (!isBookingSet) {
                        addonsOptions = {};
                      } else {
                        addonsOptions['appointment_date'] =
                            '${_bookingProducts[productId]!.month}/${_bookingProducts[productId]!.day}/${_bookingProducts[productId]!.year} ${DateFormat('jm', 'en').format(_bookingProducts[productId]!.timeStart!)}';
                      }
                    }
                    return Dismissible(
                      key: ValueKey(productId),
                      onDismissed: (_) {
                        _products.remove(productId);
                        _bookingProducts.remove(productId);
                        _errorMessages.remove(productId);
                        setState(() {});
                        if (_products.isEmpty) {
                          Navigator.of(context).pop();
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 120,
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Container(
                                      width: 120,
                                      height: 120,
                                      color: Colors.grey.withOpacity(0.2),
                                      child: ImageResize(
                                        url: product.featuredImage,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name ?? '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.w700),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        S
                                            .of(context)
                                            .qtyTotal(product.quantity ?? 0),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(fontSize: 12.0),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      if (isBookingType)
                                        Flexible(
                                          child: GestureDetector(
                                            onTap: () {
                                              if (productId != null) {
                                                _selectDatesTapped(productId);
                                              }
                                            },
                                            child: Text(
                                              isBookingSet
                                                  ? addonsOptions[
                                                      'appointment_date']
                                                  : S.of(context).selectDates,
                                              maxLines: 2,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                      fontSize: 12.0,
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                            ),
                                          ),
                                        ),
                                      if (!isBookingType)
                                        Flexible(
                                          child: Text(
                                            addonsOptions.values.join(', '),
                                            maxLines: 2,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(fontSize: 12.0),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_errorMessages[productId]?.isNotEmpty ?? false)
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: _errorMessages[productId] == 'added'
                                  ? Text(
                                      S.of(context).added,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                              color: Colors.green,
                                              fontSize: 10.0),
                                    )
                                  : Text(
                                      _errorMessages[productId] ?? '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                              color: Colors.red,
                                              fontSize: 10.0),
                                    ),
                            ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: _products.length,
                ),
                if (_products[_currentProductId]?.product!.type ==
                    'appointment')
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                    ),
                    child: CustomScrollView(
                      slivers: [
                        Services().getBookingLayout(
                          product: _products[_currentProductId]!.product!,
                          onCallBack: _setBookingInfo,
                        )
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: _isSelectingDate
              ? TextButton(
                  onPressed: () {
                    _isSelectingDate = false;
                    _pageController.jumpToPage(0);
                    setState(() {});
                  },
                  child: Text(
                    S.of(context).back,
                  ),
                )
              : TextButton(
                  onPressed: Navigator.of(context).pop,
                  child: Text(
                    S.of(context).cancel,
                  ),
                ),
        ),
        if (!_isSelectingDate)
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    color: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                    ),
                    child: SafeArea(
                      child: GestureDetector(
                        onTap: _addToCart,
                        child: Text(
                          S.of(context).addToCart,
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: Colors.white,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  ProductItem _addSelectedAddOnOptions(ProductItem productItem) {
    try {
      final addonsOptions = productItem.addonsOptions;
      final product = productItem.product;
      if (product?.addOns != null &&
          product!.addOns != null &&
          product.addOns!.isNotEmpty &&
          (addonsOptions.isNotEmpty)) {
        product.selectedOptions = [];

        for (var option in addonsOptions.keys) {
          var isSet = false;
          for (var addon in product.addOns!) {
            final index = product.selectedOptions!.indexWhere((element) {
              return element.fieldName == addon.fieldName;
            });
            if (index == -1) {
              final optionIndex = addon.options?.indexWhere((element) =>
                  (element.label != null &&
                      option.contains(element.parent!) &&
                      addonsOptions[option] == element.label));
              if (optionIndex != null && optionIndex != -1) {
                product.selectedOptions!.add(addon.options![optionIndex]);
                isSet = true;
              } else {
                if (addon.name != null && option.contains(addon.name!)) {
                  // Handle in case addon do not have any options. Eg: Customer Defined Price (custom_price) doesn't have any options.
                  if ((addon.options == null || addon.options!.isEmpty) &&
                      addon.isCustomPriceType) {
                    final addonsOption = AddonsOption.fromJson({
                      'parent': addon.name,
                      'label': addonsOptions[option].toString(),
                      'field_name': addon.fieldName,
                      'type': addon.type,
                      'display': addon.display,
                      'price': double.tryParse(addonsOptions[option]!
                              .replaceAll(RegExp('[^\\d.,]+'), '')) ??
                          '0.0',
                    });
                    product.selectedOptions!.add(addonsOption);
                    isSet = true;
                  } else {
                    final addonsOption = AddonsOption.fromJson({
                      'parent': addon.name,
                      'label': Tools.getFileNameFromUrl(addonsOptions[option]!),
                      'field_name': addon.fieldName,
                      'type': addon.type,
                      'display': addon.display,
                      'price': addon.price,
                    });
                    product.selectedOptions!.add(addonsOption);
                    isSet = true;
                  }
                }
              }
            }
            if (isSet) {
              break;
            }
          }
        }
        productItem.product = product;
      }
      return productItem;
    } catch (e) {
      printLog(e);
    }
    return productItem;
  }

  Future<void> _addToCart() async {
    final cartModel = Provider.of<CartModel>(context, listen: false);
    var hasError = false;
    for (var id in _products.keys) {
      if (_errorMessages[id] == 'added') {
        continue;
      }
      final productItem = _addSelectedAddOnOptions(_products[id]!);
      final product = productItem.product!;
      ProductVariation? variation;
      var options = <String, dynamic>{};
      if (product.isVariableProduct) {
        final addonsOptions =
            _products[id]?.addonsOptions.values.map((e) => e.trim()).toList() ??
                [];

        variation = await Services().api.getVariationProduct(
            productItem.product!.id, productItem.variationId);

        for (var item in product.attributes ?? <ProductAttribute>[]) {
          for (var option in item.options ?? []) {
            if (addonsOptions.firstWhereOrNull((e) =>
                    e.toLowerCase() == option['name'].toLowerCase().trim()) !=
                null) {
              if (item.name == null) continue;
              options[item.name!] = option['name'];
              variation!.attributes.add(Attribute(
                  id: int.parse(
                    item.id.toString(),
                  ),
                  name: item.slug,
                  option: option['slug']));
              break;
            }
          }
        }
      }

      if (product.type == 'appointment' && _bookingProducts[id] == null) {
        _errorMessages[id] = S.of(context).pleaseSelectADate;
        hasError = true;
        continue;
      }

      final message = cartModel.addProductToCart(
        context: context,
        product: product,
        quantity: productItem.quantity,
        variation: variation,
        options: options,
      );

      if (message.isNotEmpty) {
        _errorMessages[id] = message;
        hasError = true;
        continue;
      }
      _errorMessages[id] = 'added';
    }
    if (!hasError) {
      Navigator.of(context).pop(true);
      return;
    }

    setState(() {});
  }
}
