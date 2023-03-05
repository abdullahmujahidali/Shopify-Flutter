import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../../common/enums/load_state.dart';
import '../../../models/app_model.dart';
import '../../../models/brand_layout_model.dart';
import '../../../models/entities/back_drop_arguments.dart';
import '../../../routes/flux_navigate.dart';
import '../config/brand_config.dart';
import '../helper/header_view.dart';
import 'brand_list_layout.dart';
import 'widgets/brand_item.dart';
import 'widgets/brand_skeleton.dart';

class BrandLayout extends StatefulWidget {
  final BrandConfig? config;

  const BrandLayout({this.config});

  @override
  State<BrandLayout> createState() => _BrandLayoutState();
}

class _BrandLayoutState extends State<BrandLayout> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      final model = Provider.of<BrandLayoutModel>(context, listen: false);
      final langCode = Provider.of<AppModel>(context, listen: false).langCode;
      model.getBrands(langCode);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BrandLayoutModel>(
      builder: (_, model, __) {
        if (model.state == FSLoadState.loading) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: HeaderView(
                    headerText: widget.config!.name ?? ' ',
                    verticalMargin: 4,
                    showSeeAll: false),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 12.0,
                    ),
                    ...List.filled(
                      5,
                      BrandItemSkeleton(),
                    ),
                  ],
                ),
              )
            ],
          );
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: HeaderView(
                  headerText: widget.config!.name ?? ' ',
                  verticalMargin: 4,
                  callback: () {
                    FluxNavigate.pushNamed(
                      RouteList.brandList,
                      arguments: BrandListLayoutArgs(
                        config: widget.config,
                      ),
                    );
                  },
                  showSeeAll: true),
            ),
            Container(
              color: Theme.of(context).colorScheme.background,
              constraints: const BoxConstraints(
                minHeight: 100,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 12.0,
                    ),
                    for (var i = 0;
                        i <
                            (model.brands.length > 10
                                ? 10
                                : model.brands.length);
                        i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: BrandItem(
                          brand: model.brands[i],
                          onTap: () => FluxNavigate.pushNamed(
                            RouteList.backdrop,
                            arguments: BackDropArguments(
                              config: widget.config?.toJson(),
                              brandId: model.brands[i].id,
                              brandName: model.brands[i].name,
                              brandImg: model.brands[i].image,
                              // data: snapshot.data,
                            ),
                          ),
                          isBrandNameShown:
                              widget.config?.isBrandNameShown ?? true,
                          isLogoCornerRounded:
                              widget.config?.isLogoCornerRounded ?? true,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
