import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart'
    hide HttpGetResponse;
// ignore: implementation_imports
import 'package:flutter_cache_manager/src/web/mime_converter.dart';
import 'package:http/http.dart' as http;
import 'package:inspireui/utils/http_client.dart';

// Time keep the file without a cache-control header
const Duration keepDuration = Duration(hours: 1);

class HttpFileService extends FileService {
  final http.Client _httpClient;

  HttpFileService({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  @override
  Future<FileServiceResponse> get(String url,
      {Map<String, String>? headers}) async {
    final req = http.Request('GET', Uri.parse(url));
    if (headers != null) {
      req.headers.addAll(headers);
    }
    final httpResponse = await _httpClient.send(req);

    return HttpGetResponse(httpResponse);
  }
}

class HttpGetResponse implements FileServiceResponse {
  HttpGetResponse(this._response);

  final DateTime _receivedTime = DateTime.now();

  final http.StreamedResponse _response;

  @override
  int get statusCode => _response.statusCode;

  String? _header(String name) {
    return _response.headers[name];
  }

  @override
  Stream<List<int>> get content => _response.stream;

  @override
  int? get contentLength => _response.contentLength;

  @override
  DateTime get validTill {
    var ageDuration = Duration(milliseconds: keepDuration.inMilliseconds);
    final controlHeader = _header(HttpHeaders.cacheControlHeader);
    if (controlHeader != null) {
      final controlSettings = controlHeader.split(',');
      for (final setting in controlSettings) {
        final sanitizedSetting = setting.trim().toLowerCase();
        if (sanitizedSetting == 'no-cache') {
          ageDuration = const Duration();
        }
        if (sanitizedSetting.startsWith('max-age=')) {
          var validSeconds = int.tryParse(sanitizedSetting.split('=')[1]) ?? 0;
          if (validSeconds > 0) {
            ageDuration = Duration(seconds: validSeconds);
          }
        }
      }
    }

    return _receivedTime.add(ageDuration);
  }

  @override
  String? get eTag => _header(HttpHeaders.etagHeader);

  @override
  String get fileExtension {
    var fileExtension = '';
    final contentTypeHeader = _header(HttpHeaders.contentTypeHeader);
    if (contentTypeHeader != null) {
      final contentType = ContentType.parse(contentTypeHeader);
      fileExtension = contentType.fileExtension;
    }
    return fileExtension;
  }
}

class HttpCacheManager extends CacheManager with ImageCacheManager {
  static const key = 'libCachedImageData';

  static final HttpCacheManager _instance = HttpCacheManager._();
  factory HttpCacheManager() {
    return _instance;
  }

  HttpCacheManager._()
      : super(Config(
          key,
          fileService: HttpFileService(httpClient: HttpBase()),
        ));
}
