import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/constants.dart';
import '../../../../generated/l10n.dart';
import '../../../../models/index.dart' show ProductModel;
import '../../../../modules/dynamic_layout/config/product_config.dart';
import '../../../../services/index.dart';

class RecentProductsCustom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var screenWidth = constraints.maxWidth;

        return Consumer<ProductModel>(builder: (context, model, child) {
          if (model.recentSearch?.isEmpty ?? true) {
            return const SizedBox();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  S.of(context).recents,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                color: kGrey200,
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: screenWidth * 0.35 + 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: model.recentSearch!.length,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemBuilder: (_, index) => FittedBox(
                    child: Services().widget.renderProductCardView(
                          item: model.recentSearch![index],
                          width: screenWidth * 0.35,
                          config: ProductConfig.empty(),
                        ),
                  ),
                ),
              ),
            ],
          );
        });
      },
    );
  }
}
