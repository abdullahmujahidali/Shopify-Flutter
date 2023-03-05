import 'package:flutter/cupertino.dart';

import '../../../common/config.dart';
import '../../../models/entities/prediction.dart';
import '../../../models/index.dart';
import '../../../services/index.dart';
import '../../../services/location_service.dart';

enum GeoSearchState { loading, loaded }

class GeoSearchModel extends ChangeNotifier {
  final List<Store> _stores = [];

  List<Store> get stores => _stores;
  GeoSearchState _state = GeoSearchState.loading;

  GeoSearchState get state => _state;
  final _locationService = injector<LocationService>()..init();
  final _services = Services();

  void _updateState(state) {
    _state = state;
    notifyListeners();
  }

  GeoSearchModel() {
    getStores();
  }

  Future<List<Store>> getStores() async {
    _stores.clear();
    if (_state == GeoSearchState.loaded) {
      _updateState(GeoSearchState.loading);
    }
    final prediction = Prediction();
    prediction.lat = _locationService.locationData!.latitude.toString();
    prediction.long = _locationService.locationData!.longitude.toString();
    final list = await _services.api.getNearbyStores(
      prediction,
      perPage: 10,
      page: 1,
      radius: kAdvanceConfig.queryRadiusDistance.toInt(),
    );
    if (list!.isNotEmpty) {
      _stores.addAll(list);
    }
    _updateState(GeoSearchState.loaded);
    return list;
  }
}
