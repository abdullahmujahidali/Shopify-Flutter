import 'package:location/location.dart';

import '../common/constants.dart';

class LocationService {
  bool _serviceEnabled = false;

  LocationData? _locationData;
  LocationData? get locationData => _locationData;

  bool _canUseLocation = false;
  bool get canUseLocation => _canUseLocation;

  Future<void> init() async {
    try {
      if (_canUseLocation) {
        return;
      }

      var permissionGranted = PermissionStatus.denied;
      final location = Location();
      _serviceEnabled = await location.serviceEnabled();

      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return;
        }
      }

      permissionGranted = await location.hasPermission();

      if (permissionGranted == PermissionStatus.deniedForever) {
        return;
      }

      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return;
        }
      }
      _locationData = await location.getLocation();
      if (_serviceEnabled &&
          _locationData != null &&
          (permissionGranted == PermissionStatus.granted ||
              permissionGranted == PermissionStatus.grantedLimited)) {
        _canUseLocation = true;
      }
    } catch (err, trace) {
      printError(err, trace);
    }
  }
}
