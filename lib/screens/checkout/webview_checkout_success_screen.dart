import 'package:flutter/material.dart';

import '../../common/constants.dart';
import '../../models/index.dart' show Order;
import 'widgets/success.dart';

class WebviewCheckoutSuccessScreen extends StatelessWidget {
  final Order? order;

  const WebviewCheckoutSuccessScreen({this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        backgroundColor: kGrey200,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: OrderedSuccess(order: order),
      ),
    );
  }
}
