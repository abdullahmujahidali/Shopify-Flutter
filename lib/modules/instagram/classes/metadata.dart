import 'metadata_item.dart';

class Metadata {
  late bool loadFail = false;
  late List<MetadataItem> data = [];

  Metadata({this.loadFail = false, this.data = const []});

  Metadata.fromJson(dynamic json) {
    var graphql = json['graphql'];

    /// load metadata with user id
    var user = graphql?['user'];
    if (user != null) {
      var videoTimeline = user['edge_felix_video_timeline'];
      var videoEdges = videoTimeline?['edges'] as List?;
      var profileImage = user['profile_pic_url'];
      if (videoEdges != null && videoEdges.isNotEmpty) {
        for (var item in videoEdges) {
          data.add(MetadataItem.fromJson(item['node'], profile: profileImage));
        }
      }
      var mediaTimeline = user['edge_owner_to_timeline_media'];
      var mediaEdges = mediaTimeline['edges'] as List?;
      if (mediaEdges != null && mediaEdges.isNotEmpty) {
        for (var item in mediaEdges) {
          data.add(MetadataItem.fromJson(item['node'], profile: profileImage));
        }
      }
    }

    /// load metadata with hashtag
    var hashtag = graphql?['hashtag'];
    if (hashtag != null) {
      var mediaTimeline = hashtag['edge_hashtag_to_media'];
      var mediaEdges = mediaTimeline['edges'] as List?;
      var profileImage = hashtag['profile_pic_url'];
      if (mediaEdges != null && mediaEdges.isNotEmpty) {
        for (var item in mediaEdges) {
          data.add(MetadataItem.fromJson(item['node'], profile: profileImage));
        }
      }
    }
  }
}
