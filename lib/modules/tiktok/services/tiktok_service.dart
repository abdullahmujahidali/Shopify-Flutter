import 'dart:convert';

import '../../../common/constants.dart';
import '../constants/endpoint.dart';
import '../models/index.dart';
import 'tiktok_base_service.dart';

class TikTokService extends TikTokBaseService {
  String _username = '';
  String _userId = '';
  String _secUserId = '';
  String _userAvatar = '';

  @override
  Future<void> init(
      String username, String uid, String secUid, String avatarUrl) async {
    _username = username;
    _userId = uid;
    _secUserId = secUid;
    _userAvatar = avatarUrl;
  }

  @override
  Future<void> reInit(String response) async {
    _userId = '';
    _secUserId = '';
    _userAvatar = '';

    try {
      var data = jsonDecode(response);
      final user = data['userInfo']?['user'];
      if (user is Map) {
        final String? id = user['id'];
        final String? secUid = user['secUid'];
        final String userAvatar = user['avatarThumb'] ?? '';
        if (id != null &&
            id.isNotEmpty &&
            secUid != null &&
            secUid.isNotEmpty) {
          _userId = id;
          _secUserId = secUid;
          _userAvatar = userAvatar;
        }
      }
    } catch (err, trace) {
      printError(err, trace);
    }
  }

  @override
  String getUserRequestUrl() {
    return TikTokEndPoints.getUserEndpointAlt(_username);
  }

  @override
  String getRequestUrl([int count = 10]) {
    if (_userId.isEmpty || _secUserId.isEmpty) {
      return '';
    }
    final endpoint = TikTokEndPoints.getVideosInfoEndpoint(
      _userId,
      _secUserId,
      count: count,
    );
    return endpoint;
  }

  @override
  Future<List<TikTokVideoInfo>> parseVideoInfo({
    required String response,
  }) async {
    final result = <TikTokVideoInfo>[];
    try {
      var data = jsonDecode(response);

      final videos = data['items'] ?? [];
      for (var videoInfo in videos) {
        final item = TikTokVideoInfo.fromJson(videoInfo);
        item.authorAvatar = _userAvatar;
        result.add(item);
      }
    } catch (err, trace) {
      printError(err, trace);
    }
    return result;
  }
}
