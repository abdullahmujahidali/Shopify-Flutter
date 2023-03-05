import 'package:flutter/material.dart';
import 'package:inspireui/inspireui.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../../common/tools.dart';
import '../../../generated/l10n.dart';
import '../../../models/index.dart';
import '../../../routes/flux_navigate.dart';
import '../../../services/index.dart';
import '../../../services/location_service.dart';
import '../../../widgets/common/start_rating.dart';
import '../config/geo_search_config.dart';
import '../helper/header_view.dart';
import 'geo_search_model.dart';
import 'geo_search_screen.dart';

class GeoSearch extends StatefulWidget {
  final GeoSearchConfig? geoSearchConfig;

  const GeoSearch({Key? key, this.geoSearchConfig}) : super(key: key);

  @override
  State<GeoSearch> createState() => _GeoSearchState();
}

class _GeoSearchState extends State<GeoSearch> {
  final _locationService = injector<LocationService>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.endOfFrame.then((_) async {
      if (mounted) {
        await _locationService.init();
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_locationService.canUseLocation) {
      return const SizedBox();
    }
    final theme = Theme.of(context);

    return ChangeNotifierProvider<GeoSearchModel>(
        create: (_) => GeoSearchModel(),
        lazy: false,
        child: Consumer<GeoSearchModel>(builder: (_, model, __) {
          if (model.state == GeoSearchState.loaded && model.stores.isEmpty) {
            return const SizedBox();
          }

          return Container(
            color: theme.cardColor,
            padding: const EdgeInsets.only(bottom: 10.0),
            margin: const EdgeInsets.only(bottom: 10.0),
            child: Column(
              children: [
                HeaderView(
                  headerText: widget.geoSearchConfig?.headerText ?? '',
                  showSeeAll: widget.geoSearchConfig?.showSeeAll ?? false,
                  callback: () => FluxNavigate.pushNamed(
                    RouteList.geoSearch,
                    arguments: GeoSearchArgs(
                      stores: model.stores,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(
                        model.state == GeoSearchState.loading
                            ? 5
                            : model.stores.length,
                        (index) => model.state == GeoSearchState.loading
                            ? const StoreWidget.loading()
                            : StoreWidget(store: model.stores[index])),
                  ),
                ),
              ],
            ),
          );
        }));
  }
}

class StoreWidget extends StatelessWidget {
  final Store? store;

  const StoreWidget({Key? key, required this.store}) : super(key: key);

  const StoreWidget.loading({Key? key, this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (store == null) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        child: const Skeleton(
          width: 140,
          height: 160,
        ),
      );
    }
    final locationService = injector<LocationService>()..init();
    final theme = Theme.of(context);

    final distance = Tools.calculateDistance(
        locationService.locationData!.latitude!,
        locationService.locationData!.longitude!,
        store!.lat!,
        store!.long!);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          RouteList.storeDetail,
          arguments: StoreDetailArgument(store: store),
        );
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(width: 0.5, color: Colors.grey)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.2,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0)),
                child: ImageResize(
                  url: store!.banner,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store!.name ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 2.0,
                  ),
                  Row(
                    children: [
                      SmoothStarRating(
                        rating: store!.rating ?? 0,
                        size: 10.0,
                      ),
                      if (locationService.locationData != null) ...[
                        const Spacer(),
                        Text(
                          distance > 10.0
                              ? S.of(context).greaterDistance(10)
                              : S.of(context).distance(distance),
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                      ]
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
