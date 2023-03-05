import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../../common/enums/load_state.dart';
import '../../../generated/l10n.dart';
import '../../../models/index.dart';
import '../../../routes/flux_navigate.dart';
import '../../../screens/common/app_bar_mixin.dart';
import '../config/brand_config.dart';
import 'widgets/brand_item.dart';

class BrandListLayoutArgs {
  final BrandConfig? config;

  const BrandListLayoutArgs({this.config});
}

class BrandListLayout extends StatefulWidget {
  final BrandListLayoutArgs? args;

  const BrandListLayout({Key? key, this.args}) : super(key: key);

  @override
  State<BrandListLayout> createState() => _BrandListLayoutState();
}

class _BrandListLayoutState extends State<BrandListLayout> with AppBarMixin {
  late BrandLayoutModel model =
      Provider.of<BrandLayoutModel>(context, listen: false);
  late String langCode = Provider.of<AppModel>(context, listen: false).langCode;

  BrandConfig? get config => widget.args?.config;

  final _controller = ScrollController();
  var _isLoading = false;
  var _isEnd = false;

  @override
  void initState() {
    WidgetsBinding.instance.endOfFrame.then((_) {
      if (model.state == FSLoadState.noData) {
        _isEnd = true;
      }
      _controller.addListener(_scrollListener);
    });
    super.initState();
  }

  void _scrollListener() {
    if (!mounted) {
      return;
    }
    if (_controller.position.atEdge) {
      if (!_isLoading && !_isEnd) {
        _isLoading = true;
        try {
          model.loadBrands(langCode).then((value) {
            if (value.isEmpty) {
              _isEnd = true;
            }
            _isLoading = false;
          });
        } catch (e) {
          _isLoading = false;
        }
      }
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    _controller.dispose();
    super.dispose();
  }

  void onRefresh() {
    model = Provider.of<BrandLayoutModel>(context, listen: false);
    langCode = Provider.of<AppModel>(context, listen: false).langCode;
    try {
      if (_isLoading) {
        return;
      }
      _isEnd = false;
      _isLoading = true;
      model.getBrands(langCode).then((value) {
        if (value.isEmpty) {
          _isEnd = true;
        }
        _isLoading = false;
      });
    } catch (e) {
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return renderScaffold(
      routeName: RouteList.brandList,
      secondAppBar: AppBar(
        flexibleSpace: Container(
          color: Theme.of(context).primaryColor,
        ),
      ),
      child: RefreshIndicator(
        onRefresh: () async => onRefresh(),
        child: CustomScrollView(
          controller: _controller,
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: () async => onRefresh(),
            ),
            SliverToBoxAdapter(
              child: Consumer<BrandLayoutModel>(
                builder: (_, model, __) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).colorScheme.background,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.0, 0.8],
                          tileMode: TileMode.clamp),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          config?.name ?? 'Top Brands',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        GridView.count(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(0.0),
                          crossAxisCount: 4,
                          shrinkWrap: true,
                          mainAxisSpacing: 12.0,
                          children: List.generate(
                            model.brands.length > 8 ? 8 : model.brands.length,
                            (i) => BrandItem(
                              brand: model.brands[i],
                              onTap: () => FluxNavigate.pushNamed(
                                RouteList.backdrop,
                                arguments: BackDropArguments(
                                  config: config?.toJson(),
                                  brandId: model.brands[i].id,
                                  brandName: model.brands[i].name,
                                  brandImg: model.brands[i].image,
                                  // data: snapshot.data,
                                ),
                              ),
                              isBrandNameShown: config?.isBrandNameShown,
                              isLogoCornerRounded: config?.isLogoCornerRounded,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 20),
                child: Text(
                  S.of(context).allBrands,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ),
            Consumer<BrandLayoutModel>(
              builder: (_, model, __) => SliverGrid.count(
                crossAxisCount: 4,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 10.0,
                children: List.generate(
                  model.brands.length,
                  (i) => BrandItem(
                    brand: model.brands[i],
                    onTap: () => FluxNavigate.pushNamed(
                      RouteList.backdrop,
                      arguments: BackDropArguments(
                        config: config?.toJson(),
                        brandId: model.brands[i].id,
                        brandName: model.brands[i].name,
                        brandImg: model.brands[i].image,
                        // data: snapshot.data,
                      ),
                    ),
                    isBrandNameShown: config?.isBrandNameShown,
                    isLogoCornerRounded: config?.isLogoCornerRounded,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
