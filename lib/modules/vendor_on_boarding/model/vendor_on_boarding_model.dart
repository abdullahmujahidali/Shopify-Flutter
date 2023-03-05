import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common/tools/image_tools.dart';
import '../vendor_onboarding_services.dart';

enum VendorOnboardingState { loading, loaded }

class VendorOnBoardingModel extends ChangeNotifier {
  /// Address
  var _address = '';
  var _country = '';
  var _city = '';
  var _addressState = '';
  var _postal = '';

  String get address => _address;
  String get country => _country;
  String get city => _city;
  String get addressState => _addressState;
  String get postal => _postal;

  /// Basic Information
  var _storeName = '';
  var _storeSlug = '';
  var _storePhone = '';
  var _storeEmail = '';

  String get storeName => _storeName;
  String get storeSlug => _storeSlug;
  String get storePhone => _storePhone;
  String get storeEmail => _storeEmail;

  /// Images
  var _logo;
  var _banner;
  XFile? get logo => _logo;
  XFile? get banner => _banner;

  /// Location
  var _location = '';
  double _lat = 0.0;
  double _long = 0.0;
  String get location => _location;
  double get lat => _lat;
  double get long => _long;

  /// Services
  final _services = VendorOnBoardingServices();

  /// Data
  final _data = {};
  Map get data => _data;
  final _userCookie;
  var _state = VendorOnboardingState.loaded;
  VendorOnboardingState get state => _state;

  VendorOnBoardingModel(this._userCookie);

  void _updateState(state) {
    _state = state;
    notifyListeners();
  }

  void updateAddress(data) {
    _address = data['address'];
    _country = data['country'];
    _city = data['city'];
    _addressState = data['state'];
    _postal = data['postal'];

    _data['address'] = {};
    _data['address']['street_1'] = _address;
    _data['address']['street_2'] = '';
    _data['address']['city'] = _city;
    _data['address']['zip'] = _postal;
    _data['address']['country'] = _country;
    _data['address']['state'] = _addressState;
  }

  void updateBasicInformation(data) {
    _storeName = data['storeName'];
    _storeSlug = data['storeSlug'];
    _storePhone = data['storePhone'];
    _storeEmail = data['storeEmail'];

    _data['store_name'] = _storeName;
    _data['store_slug'] = _storeSlug;
    _data['store_email'] = _storeEmail;
    _data['phone'] = _storePhone;
  }

  void updateLocation(data) {
    _location = data['location'];
    _lat = data['lat'];
    _long = data['long'];

    _data['store_location'] = _location;
    _data['store_lat'] = _lat;
    _data['store_lng'] = _long;
  }

  void updateImages({logoImage, bannerImage}) {
    if (logoImage != null) {
      _logo = logoImage;
      ImageTools.compressImage(_logo).then((value) => _data['logo'] = value);
    }
    if (bannerImage != null) {
      _banner = bannerImage;
      ImageTools.compressImage(_banner).then((value) {
        _data['banner'] = value;
        _data['mobile_banner'] = value;
        _data['banner_type'] = 'single_img';
      });
    }
  }

  Future<void> updateProfile() async {
    _updateState(VendorOnboardingState.loading);
    if (_data.isNotEmpty) {
      await _services.updateVendorInformation(_userCookie, _data);
    }
  }

  void onFinish() {
    _updateState(VendorOnboardingState.loaded);
  }
}
