import 'package:flutter/material.dart';

import '../../../common/config.dart';
import '../../../models/index.dart' show PaymentMethod;
import '../../../services/index.dart';
import '../../../widgets/common/flux_image.dart';

class PaymentMethodItem extends StatelessWidget {
  const PaymentMethodItem(
      {Key? key,
      required this.paymentMethod,
      this.onSelected,
      this.selectedId,
      this.descWidget})
      : super(key: key);
  final PaymentMethod paymentMethod;
  final Function(String?)? onSelected;
  final String? selectedId;
  final Widget? descWidget;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () {
            if (onSelected != null) onSelected!(paymentMethod.id);
          },
          child: Container(
            decoration: BoxDecoration(
                color: paymentMethod.id == selectedId
                    ? Theme.of(context).primaryColorLight
                    : Colors.transparent),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      Radio<String?>(
                          value: paymentMethod.id,
                          groupValue: selectedId,
                          onChanged: onSelected),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            if (kPayments[paymentMethod.id] != null)
                              FluxImage(
                                imageUrl: kPayments[paymentMethod.id],
                                height: 30,
                              ),
                            if (kPayments[paymentMethod.id] == null)
                              Services().widget.renderShippingPaymentTitle(
                                  context, paymentMethod.title!),
                          ],
                        ),
                      )
                    ],
                  ),
                  if (descWidget != null) descWidget!
                ],
              ),
            ),
          ),
        ),
        const Divider(height: 1)
      ],
    );
  }
}
