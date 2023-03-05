import 'package:flutter/cupertino.dart';

import '../../../common/config.dart';
import '../../../models/entities/prediction.dart';
import '../../../models/index.dart';
import '../../../services/index.dart';
import '../../../services/location_service.dart';

enum GeoSearchScreenState { loading, loaded }

class GeoSearchScreenModel extends ChangeNotifier {
  List<Store> _stores = [];
  List<Store> get stores => _stores;
  GeoSearchScreenState _state = GeoSearchScreenState.loaded;
  GeoSearchScreenState get state => _state;
  int _page = 1;
  final _perPage = 10;
  final _locationService = injector<LocationService>()..init();
  final _services = Services();

  double _currentRadius = kAdvanceConfig.queryRadiusDistance * 1.0;
  double get currentRadius => _currentRadius;

  void updateRadius(double radius) {
    _currentRadius = radius.roundToDouble();
    notifyListeners();
  }

  void _updateState(state) {
    _state = state;
    notifyListeners();
  }

  GeoSearchScreenModel(stores) {
    _stores = stores ?? [];
  }

  Future<List<Store>> getStores({String? name}) async {
    if (_state == GeoSearchScreenState.loaded) {
      _updateState(GeoSearchScreenState.loading);
    }
    _page = 1;
    final prediction = Prediction();
    prediction.lat = _locationService.locationData!.latitude.toString();
    prediction.long = _locationService.locationData!.longitude.toString();
    final list = await _services.api.getNearbyStores(prediction,
        perPage: _perPage,
        page: _page,
        radius: _currentRadius.toInt(),
        name: name);
    _stores.clear();
    if (list!.isNotEmpty) {
      _stores.addAll(list);
    }

    _updateState(GeoSearchScreenState.loaded);
    return list;
  }

  Future<List<Store>> loadStores({String? name}) async {
    _page++;
    final prediction = Prediction();
    prediction.lat = _locationService.locationData!.latitude.toString();
    prediction.long = _locationService.locationData!.longitude.toString();
    final list = await _services.api.getNearbyStores(
      prediction,
      perPage: _perPage,
      page: _page,
      radius: _currentRadius.toInt(),
      name: name,
    );
    if (list!.isNotEmpty) {
      _stores.addAll(list);
    }
    _updateState(GeoSearchScreenState.loaded);
    return list;
  }
}
