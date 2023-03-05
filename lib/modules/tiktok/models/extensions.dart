import 'tiktok_video.dart';
import 'tiktok_video_info.dart';

extension TikTokVideoExtension on TikTokVideo {
  String get url {
    var videoUrl = playAddr;
    if (videoUrl != null && videoUrl.isNotEmpty) {
      return videoUrl;
    }
    videoUrl = downloadAddr;
    if (videoUrl != null && videoUrl.isNotEmpty) {
      return videoUrl;
    }
    return '';
  }
}

extension TikTokVideoInfoExtension on TikTokVideoInfo {
  String get videoUrl {
    return video?.url ?? '';
  }

  int get duration {
    return video?.duration ?? 0;
  }

  String get videoThumbnail {
    var url = video?.cover;
    if (url != null && url.isNotEmpty) {
      return url;
    }

    url = video?.originCover;
    if (url != null && url.isNotEmpty) {
      return url;
    }
    final urls = video?.shareCover;
    if (urls != null && urls.isNotEmpty) {
      return urls.last;
    }

    return '';
  }
}
