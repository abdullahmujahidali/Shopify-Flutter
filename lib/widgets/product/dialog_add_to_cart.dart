import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../models/index.dart' show Product, ProductModel;
import '../../screens/detail/widgets/index.dart';
import '../../services/index.dart';

class DialogAddToCart {
  static void show(BuildContext context,
      {required Product product, int quantity = 1}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.85,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(10.0),
          ),
        ),
        child: Stack(
          children: [
            RubberAddToCart(product: product, quantity: quantity),
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: CircleAvatar(
                  backgroundColor:
                      Theme.of(context).colorScheme.background.withOpacity(0.9),
                  child: Icon(
                    CupertinoIcons.xmark_circle,
                    size: 25,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RubberAddToCart extends StatefulWidget {
  final Product product;
  final int quantity;
  const RubberAddToCart({required this.product, this.quantity = 1});

  @override
  State<RubberAddToCart> createState() => _StateRubberAddToCart();
}

class _StateRubberAddToCart extends State<RubberAddToCart> {
  bool isLoading = true;
  Product product = Product.empty('1');

  @override
  void initState() {
    Future.microtask(() async {
      setState(() {
        product = widget.product;
      });
      product = (await Services().widget.getProductDetail(context, product)) ??
          widget.product;
      isLoading = false;
      if (mounted) {
        setState(() {});
      }
    });

    super.initState();
  }

  Widget renderProductInfo() {
    var body;
    if (isLoading == true) {
      body = Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: kLoadingWidget(context),
      );
    } else {
      switch (product.type) {
        case 'appointment':
          return Services().getBookingLayout(product: product);
        case 'booking':
          body = ListingBooking(product);
          break;
        case 'grouped':
          body = GroupedProduct(product);
          break;
        default:
          body = ProductVariant(
            product,
            defaultQuantity: widget.quantity,
            onSelectVariantImage: (String url) {},
          );
      }
    }
    return SliverToBoxAdapter(child: body);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductModel(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
            SliverToBoxAdapter(child: ProductTitle(product)),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            renderProductInfo(),
          ],
        ),
      ),
    );
  }
}
