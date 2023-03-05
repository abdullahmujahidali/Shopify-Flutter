import '../../models/entities/user.dart';
import '../../services/index.dart';

class ScannerModel {
  final _services = Services();
  final User? _user;

  ScannerModel(this._user);

  Future<dynamic> getDataFromScanner(
    String data,
  ) async {
    var result;
    try {
      result =
          await _services.api.getDataFromScanner(data, cookie: _user?.cookie);
    } catch (e) {
      return e;
    }
    return result;
  }
}
