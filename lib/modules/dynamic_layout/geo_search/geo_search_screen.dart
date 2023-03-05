import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:inspireui/inspireui.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../common/config.dart';
import '../../../common/constants.dart';
import '../../../generated/l10n.dart';
import '../../../models/index.dart';
import '../../../screens/common/app_bar_mixin.dart';
import '../../../widgets/vendor/store_item.dart';
import 'geo_search_screen_model.dart';

class GeoSearchArgs {
  final List<Store> stores;

  GeoSearchArgs({required this.stores});
}

class GeoSearchScreen extends StatefulWidget {
  final List<Store> stores;

  const GeoSearchScreen({Key? key, required this.stores}) : super(key: key);

  @override
  State<GeoSearchScreen> createState() => _GeoSearchScreenState();
}

class _GeoSearchScreenState extends State<GeoSearchScreen> with AppBarMixin{
  final _searchController = TextEditingController();
  final _controller = RefreshController();

  void _onLoadMore(GeoSearchScreenModel model) async {
    final list = await model.loadStores(name: _searchController.text);
    if (list.isEmpty) {
      _controller.loadNoData();
    } else {
      _controller.loadComplete();
    }
  }

  void _onUpdateRadius(GeoSearchScreenModel model, double radius) async {
    model.updateRadius(radius);
    EasyDebounce.cancel('_onUpdateRadius');
    EasyDebounce.debounce('_onUpdateRadius', const Duration(milliseconds: 300),
        () async {
      final list = await model.getStores(name: _searchController.text);
      if (list.isEmpty) {
        _controller.loadNoData();
      } else {
        _controller.loadComplete();
      }
      _controller.refreshCompleted();
    });
  }

  void _onSearch(GeoSearchScreenModel model) async {
    EasyDebounce.cancel('_onSearch');
    EasyDebounce.debounce('_onSearch', const Duration(milliseconds: 300),
        () async {
      final list = await model.getStores(name: _searchController.text);
      if (list.isEmpty) {
        _controller.loadNoData();
      } else {
        _controller.loadComplete();
      }
      _controller.refreshCompleted();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ChangeNotifierProvider<GeoSearchScreenModel>(
      create: (_) => GeoSearchScreenModel(widget.stores),
      lazy: false,
      child: renderScaffold(
        routeName: RouteList.geoSearch,
        backgroundColor: theme.colorScheme.background,
        child: SafeArea(
          child: Column(
            children: [
              Card(
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.arrow_back_ios_sharp)),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 0.5,
                                color: Colors.grey,
                              ),
                            ),
                            child: Consumer<GeoSearchScreenModel>(
                              builder: (_, model, __) => TextField(
                                controller: _searchController,
                                onChanged: (val) {
                                  _onSearch(model);
                                },
                                decoration: const InputDecoration(
                                    hintText: 'Search...',
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10.0)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                      ],
                    ),
                    Consumer<GeoSearchScreenModel>(
                      builder: (_, model, __) => Row(
                        children: [
                          const SizedBox(
                            width: 10.0,
                          ),
                          Text(S.of(context).distance(model.currentRadius)),
                          Expanded(
                            child: Slider(
                              value: model.currentRadius,
                              max: kAdvanceConfig.maxQueryRadiusDistance * 1.0,
                              min: kAdvanceConfig.minQueryRadiusDistance * 1.0,
                              onChanged: (val) {
                                _onUpdateRadius(model, val);
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Consumer<GeoSearchScreenModel>(
                builder: (_, model, __) => Flexible(
                  child: SmartRefresher(
                    controller: _controller,
                    onLoading: () {
                      _onLoadMore(model);
                    },
                    enablePullUp: true,
                    enablePullDown: false,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (_, index) =>
                          model.state == GeoSearchScreenState.loading
                              ? const StoreLoadingItem()
                              : StoreItem(store: model.stores[index]),
                      itemCount: model.state == GeoSearchScreenState.loading
                          ? 5
                          : model.stores.length,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StoreLoadingItem extends StatelessWidget {
  const StoreLoadingItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      child: Skeleton(
        width: size.width,
        height: 200,
      ),
    );
  }
}
