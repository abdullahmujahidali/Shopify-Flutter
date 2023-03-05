import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../common/constants.dart';
import '../../data/boxes.dart';
import 'classes/metadata.dart';

//// only call new api per hour because limit request
class InstagramService {
  static Future<Metadata> getMetadata(String path) async {
    try {
      var localData = CacheBox().getInstagramCache(path);

      if (localData != null) {
        var time = localData['time'];

        /// load from local if time change < 60s
        if (time != null &&
            DateTime.fromMillisecondsSinceEpoch(time).isAfter(
              DateTime.now()
                  .subtract(const Duration(seconds: Duration.secondsPerHour)),
            )) {
          printLog('⬇️ Load Instagram data from local');
          return Metadata.fromJson(localData);
        }
      }
      printLog('⬇️ Load Instagram data from server');
      final endpoint = 'www.instagram.com/$path/?__a=1'.replaceAll('//', '/');
      var response = await http.get(
        Uri.parse('https://$endpoint'),
      );
      var body = response.body;
      var data = jsonDecode(body);
      data['time'] = DateTime.now().millisecondsSinceEpoch;
      unawaited(CacheBox().setInstagramCache(path, data));
      return Metadata.fromJson(data);
    } catch (e, trace) {
      printError(e, trace);
      return Metadata(loadFail: true);
    }
  }
}
