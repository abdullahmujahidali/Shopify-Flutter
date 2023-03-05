import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inspireui/inspireui.dart' show AutoHideKeyboard, printLog;
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../common/tools.dart';
import '../../common/tools/flash.dart';
import '../../generated/l10n.dart';
import '../../menu/index.dart' show MainTabControlDelegate;
import '../../models/index.dart' show AppModel, CartModel, Product, UserModel;
import '../../routes/flux_navigate.dart';
import '../../services/index.dart';
import '../../widgets/product/cart_item.dart';
import '../../widgets/product/product_bottom_sheet.dart';
import '../checkout/checkout_screen.dart';
import 'widgets/empty_cart.dart';
import 'widgets/shopping_cart_sumary.dart';
import 'widgets/wishlist.dart';

// Move createShoppingCartRows is outside MyCart to reuse for POS
List<Widget> createShoppingCartRows(CartModel model, BuildContext context) {
  // ignore: curly_braces_in_flow_control_structures
  model.productsInCart.forEach((key, value) async {
    var productId = Product.cleanProductID(key);
    var productCheck = await Services().api.getProduct(productId);
    var product = model.getProductById(productId);

    // remove product if its out of stock
    if (productCheck?.inStock != true) {
      model.removeItemFromCart(key);
    }

    var cartQty = model.productsInCart[key];
    var availQty = productCheck?.stockQuantity;

    // minus product quantity if not available. CODE GOES BELOW
    if (availQty != null && cartQty! > availQty) {
      model.updateQuantity(product!, key, availQty);
    }
  });

  var productList = {};
  var productListWidget = model.productsInCart.keys.map(
    (key) {
      var productId = Product.cleanProductID(key);
      var product = model.getProductById(productId);

      if (product != null) {
        productList[key] = {
          'id': key,
          'product': product,
          'quantity': model.productsInCart[key]
        };

        return ShoppingCartRow(
          product: product,
          addonsOptions: model.productAddonsOptionsInCart[key],
          variation: model.getProductVariationById(key),
          quantity: model.productsInCart[key],
          options: model.productsMetaDataInCart[key],
          onRemove: () {
            Services().firebase.firebaseAnalytics?.logRemoveFromCart(
                currency: model.currencyCode,
                data: [productList[key]],
                price: double.tryParse(product.price ?? ''));

            model.removeItemFromCart(key);
          },
          onChangeQuantity: (val) {
            var message = model.updateQuantity(product, key, val);
            if (message.isNotEmpty) {
              final snackBar = SnackBar(
                content: Text(message),
                duration: const Duration(seconds: 1),
              );
              Future.delayed(
                const Duration(milliseconds: 300),
                () => ScaffoldMessenger.of(context).showSnackBar(snackBar),
              );
            }
          },
        );
      }
      return const SizedBox();
    },
  ).toList();

  Services().firebase.firebaseAnalytics?.logViewCart(
      currency: model.currencyCode,
      data: productList,
      price: model.getSubTotal());

  return productListWidget;
}

class MyCart extends StatefulWidget {
  final bool? isModal;
  final bool? isBuyNow;
  final bool hasNewAppBar;
  final ScrollController? scrollController;

  const MyCart({
    this.isModal,
    this.isBuyNow = false,
    this.hasNewAppBar = false,
    this.scrollController,
  });

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> with SingleTickerProviderStateMixin {
  bool isLoading = false;
  String errMsg = '';

  CartModel get cartModel => Provider.of<CartModel>(context, listen: false);

  void _loginWithResult(BuildContext context) async {
    // final result = await Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => LoginScreen(
    //       fromCart: true,
    //     ),
    //     fullscreenDialog: kIsWeb,
    //   ),
    // );

    //BUG: Missing login SMS as default
    await FluxNavigate.pushNamed(
      RouteList.login,
    ).then((value) {
      final user = Provider.of<UserModel>(context, listen: false).user;
      if (user != null && user.name != null) {
        Tools.showSnackBar(ScaffoldMessenger.of(context),
            '${S.of(context).welcome} ${user.name} !');
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    printLog('[Cart] build');

    final localTheme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    var layoutType = Provider.of<AppModel>(context).productDetailLayout;
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
    final canPop = parentRoute?.canPop ?? false;

    return CustomScrollView(
      controller: widget.scrollController,
      slivers: [
        MediaQuery.removePadding(
          context: context,
          removeTop: widget.hasNewAppBar && widget.isModal != true,
          child: SliverAppBar(
            pinned: true,
            centerTitle: false,
            leading: widget.isModal == true
                ? CloseButton(
                    onPressed: () {
                      if (widget.isBuyNow!) {
                        Navigator.of(context).pop();
                        return;
                      }

                      if (Navigator.of(context).canPop() &&
                          layoutType != 'simpleType') {
                        Navigator.of(context).pop();
                      } else {
                        ExpandingBottomSheet.of(context, isNullOk: true)
                            ?.close();
                      }
                    },
                  )
                : canPop
                    ? const BackButton()
                    : null,
            backgroundColor: Theme.of(context).colorScheme.background,
            title: Text(
              S.of(context).myCart,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.w700),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 16,
                ),
                child: Selector<CartModel, bool>(
                  selector: (_, cartModel) => cartModel.calculatingDiscount,
                  builder: (context, calculatingDiscount, child) {
                    return TextButton(
                      onPressed: calculatingDiscount
                          ? null
                          : () {
                              if (kAdvanceConfig.alwaysShowTabBar) {
                                MainTabControlDelegate.getInstance().changeTab(
                                    RouteList.cart,
                                    allowPush: false);
                                // return;
                              }
                              onCheckout(cartModel);
                            },
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 10,
                        ),
                        textStyle: const TextStyle(
                          letterSpacing: 0.8,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                        elevation: 0,
                      ),
                      child: child!,
                    );
                  },
                  child: Selector<CartModel, int>(
                    selector: (_, carModel) => cartModel.totalCartQuantity,
                    builder: (context, totalCartQuantity, child) {
                      // if (totalCartQuantity == 0) {
                      //   return const SizedBox();
                      // }
                      return Row(
                        children: [
                          totalCartQuantity > 0
                              ? (isLoading
                                  ? Text(S.of(context).loading.toUpperCase())
                                  : Text(S.of(context).checkout.toUpperCase()))
                              : Text(S.of(context).startShopping.toUpperCase()),
                          const SizedBox(width: 3),
                          const Icon(CupertinoIcons.right_chevron, size: 12),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Selector<CartModel, int>(
            selector: (_, cartModel) => cartModel.totalCartQuantity,
            builder: (context, totalCartQuantity, child) {
              return AutoHideKeyboard(
                child: Container(
                  decoration:
                      BoxDecoration(color: Theme.of(context).colorScheme.background),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 80.0),
                      child: Column(
                        children: [
                          if (totalCartQuantity > 0)
                            Container(
                              // decoration: BoxDecoration(
                              //     color: Theme.of(context).primaryColorLight),
                              padding: const EdgeInsets.only(
                                right: 15.0,
                                top: 4.0,
                              ),
                              child: SizedBox(
                                width: screenSize.width,
                                child: SizedBox(
                                  width: screenSize.width /
                                      (2 /
                                          (screenSize.height /
                                              screenSize.width)),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 25.0),
                                      Text(
                                        S.of(context).total.toUpperCase(),
                                        style: localTheme.textTheme.titleMedium!
                                            .copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        '$totalCartQuantity ${S.of(context).items}',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: Tools.isRTL(context)
                                              ? Alignment.centerLeft
                                              : Alignment.centerRight,
                                          child: TextButton(
                                            onPressed: () {
                                              if (totalCartQuantity > 0) {
                                                clearCartPopup(context);
                                              }
                                            },
                                            child: Text(
                                              S
                                                  .of(context)
                                                  .clearCart
                                                  .toUpperCase(),
                                              style: const TextStyle(
                                                color: Colors.redAccent,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          if (totalCartQuantity > 0)
                            const Divider(
                              height: 1,
                              // indent: 25,
                            ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const SizedBox(height: 16.0),
                              if (totalCartQuantity > 0)
                                Column(
                                  children: createShoppingCartRows(
                                      cartModel, context),
                                ),
                              const ShoppingCartSummary(),
                              if (totalCartQuantity == 0) EmptyCart(),
                              if (errMsg.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 10,
                                  ),
                                  child: Text(
                                    errMsg,
                                    style: const TextStyle(color: Colors.red),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              const SizedBox(height: 4.0),
                              WishList()
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  Future<Widget> clearCartPopup(context) async {
    return await showDialog(
      context: context,
      useRootNavigator: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(S.of(context).confirmClearTheCart),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(S.of(context).keep),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                cartModel.clearCart();
              },
              child: Text(
                S.of(context).clear,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void onCheckout(CartModel model) {
    var isLoggedIn = Provider.of<UserModel>(context, listen: false).loggedIn;
    final currencyRate =
        Provider.of<AppModel>(context, listen: false).currencyRate;
    final currency = Provider.of<AppModel>(context, listen: false).currency;
    var message;

    if (isLoading) return;

    if (kCartDetail['minAllowTotalCartValue'] != null) {
      if (kCartDetail['minAllowTotalCartValue'].toString().isNotEmpty) {
        var totalValue = model.getSubTotal() ?? 0;
        var minValue = PriceTools.getCurrencyFormatted(
            kCartDetail['minAllowTotalCartValue'], currencyRate,
            currency: currency);
        if (totalValue < kCartDetail['minAllowTotalCartValue'] &&
            model.totalCartQuantity > 0) {
          message = '${S.of(context).totalCartValue} $minValue';
        }
      }
    }

    if (kVendorConfig.disableMultiVendorCheckout &&
        ServerConfig().isVendorType()) {
      if (!model.isDisableMultiVendorCheckoutValid(
          model.productsInCart, model.getProductById)) {
        message = S.of(context).youCanOnlyOrderSingleStore;
      }
    }

    if (message != null) {
      FlashHelper.errorMessage(context, message: message);

      return;
    }

    if (model.totalCartQuantity == 0) {
      if (widget.isModal == true) {
        try {
          ExpandingBottomSheet.of(context)!.close();
        } catch (e) {
          Navigator.of(context).pushNamed(RouteList.dashboard);
        }
      } else {
        final modalRoute = ModalRoute.of(context);
        if (modalRoute?.canPop ?? false) {
          Navigator.of(context).pop();
        }
        MainTabControlDelegate.getInstance().changeTab(RouteList.home);
      }
    } else if (isLoggedIn || kPaymentConfig.guestCheckout) {
      doCheckout();
    } else {
      _loginWithResult(context);
    }
  }

  Future<void> doCheckout() async {
    showLoading();

    await Services().widget.doCheckout(
      context,
      success: () async {
        hideLoading('');
        await FluxNavigate.pushNamed(
          RouteList.checkout,
          arguments: CheckoutArgument(isModal: widget.isModal),
          forceRootNavigator: true,
        );
      },
      error: (message) async {
        if (message ==
            Exception('Token expired. Please logout then login again')
                .toString()) {
          setState(() {
            isLoading = false;
          });
          //logout
          final userModel = Provider.of<UserModel>(context, listen: false);
          await userModel.logout();
          await Services().firebase.signOut();

          _loginWithResult(context);
        } else {
          hideLoading(message);
          Future.delayed(const Duration(seconds: 3), () {
            setState(() => errMsg = '');
          });
        }
      },
      loading: (isLoading) {
        setState(() {
          this.isLoading = isLoading;
        });
      },
    );
  }

  void showLoading() {
    setState(() {
      isLoading = true;
      errMsg = '';
    });
  }

  void hideLoading(error) {
    setState(() {
      isLoading = false;
      errMsg = error;
    });
  }
}
