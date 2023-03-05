import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../common/tools/tools.dart';
import '../../../generated/l10n.dart';
import '../../../models/entities/prediction.dart';
import '../../../screens/common/google_map_mixin.dart';
import '../../../services/dependency_injection.dart';
import '../../../services/location_service.dart';
import '../../../services/services.dart';
import '../../../widgets/common/edit_product_info_widget.dart';
import '../model/vendor_on_boarding_model.dart';
import '../vendor_onboarding_services.dart';
import '../widgets/navigation_buttons.dart';

const kInitialLocation = CameraPosition(target: LatLng(0.0, 0.0));

class VendorLocationInformation extends StatefulWidget {
  final Function(bool isPrev) onCallBack;

  const VendorLocationInformation({Key? key, required this.onCallBack})
      : super(key: key);

  @override
  State<VendorLocationInformation> createState() =>
      _VendorLocationInformationState();
}

class _VendorLocationInformationState extends State<VendorLocationInformation>
    with GoogleMapMixin {
  double? _lat;
  double? _long;
  double _currentZoom = 16.0;
  final _locationController = TextEditingController();
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  List<Prediction> _autocompletePlaces = [];
  var _uuid;

  void onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    await setMapStyle(_mapController);
  }

  void _onCameraMove(CameraPosition pos) {
    _currentZoom = pos.zoom;
  }

  void _updatePosition(LatLng pos,
      {bool isTapOnMap = false, String? locationName}) async {
    Tools.hideKeyboard(context);
    _lat = pos.latitude;
    _long = pos.longitude;

    _markers.clear();
    _markers.add(
      Marker(
          markerId: MarkerId('$_lat-$_long'), position: LatLng(_lat!, _long!)),
    );
    if (locationName != null) {
      _locationController.text = locationName;
    }
    if (!isTapOnMap) {
      _autocompletePlaces.clear();
    }

    setState(() {});

    await _mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(_lat!, _long!),
          zoom: _currentZoom,
        ),
      ),
    );
    if (isTapOnMap) {
      _locationController.text = await (VendorOnBoardingServices()
          .getAddressFromLocation(_lat, _long));
    }
  }

  void _onUpdate() {
    final model = Provider.of<VendorOnBoardingModel>(context, listen: false);
    final data = {
      'location': _locationController.text,
      'lat': _lat,
      'long': _long,
    };
    model.updateLocation(data);
    widget.onCallBack(false);
  }

  void getPlaces() {
    EasyDebounce.cancel('getAutocompletePlaces');
    if (_locationController.text.isEmpty) {
      _autocompletePlaces.clear();
      setState(() {});
      return;
    }
    if (_locationController.text.trim().isNotEmpty) {
      EasyDebounce.debounce(
          'getAutocompletePlaces', const Duration(milliseconds: 300), () async {
        _autocompletePlaces = await Services()
            .api
            .getAutoCompletePlaces(_locationController.text, _uuid)!;
        if (mounted) {
          setState(() {});
        }
      });
    } else {
      _autocompletePlaces.clear();
    }
  }

  Future<void> getLocationFromPlace(int index) async {
    if (_autocompletePlaces.isNotEmpty) {
      _locationController.text = _autocompletePlaces[index].description!;
      final prediction = await Services()
          .api
          .getPlaceDetail(_autocompletePlaces[index], _uuid);
      _uuid = const Uuid().v4();
      if (prediction != null) {
        _updatePosition(LatLng(
            double.parse(prediction.lat!), double.parse(prediction.long!)));
      }
    }
  }

  @override
  void initState() {
    _uuid = const Uuid().v4();
    super.initState();

    WidgetsBinding.instance.endOfFrame.then((_) async {
      if (mounted) {
        final model =
            Provider.of<VendorOnBoardingModel>(context, listen: false);
        _locationController.text = model.location;
        _lat = model.lat;
        _long = model.long;
        if (_lat == null && _long == null) {
          final locationService = injector<LocationService>();
          await locationService.init();
          if (locationService.canUseLocation) {
            final data = {
              'location': '',
              'lat': locationService.locationData?.latitude ?? 0.0,
              'long': locationService.locationData?.longitude ?? 0.0,
            };
            _lat = locationService.locationData?.latitude ?? 0.0;
            _long = locationService.locationData?.longitude ?? 0.0;
            _markers.add(
              Marker(
                  markerId: MarkerId('$_lat-$_long'),
                  position: LatLng(_lat!, _long!)),
            );
            model.updateLocation(data);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    EditProductInfoWidget(
                      controller: _locationController,
                      label: S.of(context).location,
                      suffixIcon: _locationController.text.isEmpty
                          ? const SizedBox()
                          : GestureDetector(
                              onTap: () {
                                _locationController.clear();
                                _autocompletePlaces.clear();
                                setState(() {});
                              },
                              child: const Icon(Icons.close)),
                      onChanged: (s) => getPlaces(),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          GoogleMap(
                            mapType: MapType.normal,
                            initialCameraPosition: (_lat != null &&
                                    _long != null)
                                ? CameraPosition(target: LatLng(_lat!, _long!))
                                : kInitialLocation,
                            onMapCreated: onMapCreated,
                            markers: _markers,
                            compassEnabled: false,
                            zoomControlsEnabled: false,
                            onTap: (latLng) =>
                                _updatePosition(latLng, isTapOnMap: true),
                            onCameraMove: _onCameraMove,
                          ),
                          if (_autocompletePlaces.isNotEmpty)
                            Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 10.0),
                                height: 250,
                                decoration: BoxDecoration(
                                    color: Colors.white54,
                                    borderRadius: BorderRadius.circular(10.0)),
                                width: size.width,
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: List.generate(
                                        _autocompletePlaces.length,
                                        (index) => LocationSuggestion(
                                              title: _autocompletePlaces[index]
                                                      .description ??
                                                  '',
                                              onCallback: () =>
                                                  getLocationFromPlace(index),
                                            )),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: NavigationButtons(
              onBack: () {
                widget.onCallBack(true);
              },
              onNext: _onUpdate,
            ),
          ),
        ],
      ),
    );
  }
}

class LocationSuggestion extends StatelessWidget {
  final String title;
  final VoidCallback onCallback;

  const LocationSuggestion(
      {Key? key, required this.title, required this.onCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onCallback,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const Icon(
              Icons.location_on,
              color: Colors.black,
            ),
            const SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
