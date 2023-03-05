import 'dart:convert';

import 'package:quiver/strings.dart';

import '../../common/constants.dart';

class Tag {
  String? id;
  String? name;
  String? slug;
  String? description;
  int? count;

  Tag({
    this.id,
    this.name,
    this.slug,
    this.description,
    this.count,
  });

  Tag.fromJson(Map json) {
    try {
      id = json['id']?.toString();
      name = json['name'];
      slug = json['slug'];
      description = json['description'];
      count = json['count'];
    } catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['description'] = description;
    data['count'] = count;
    return data;
  }

  @override
  String toString() => 'Tag ${jsonEncode(toJson())}';

  static List<Tag> parseTagList(response) {
    /// API may return duplicate tags. Need to store in a map.
    // var tags = <String, Tag>{};
    final tags = <Tag>[];
    if (response is Map && isNotBlank(response['message'])) {
      printLog('[Exception tag_model.dart - parseTagList]');
      printLog(response['message']);
      return <Tag>[];

      /// throw Exception(response['message']);
    } else {
      if (response is List) {
        for (var item in response) {
          final tag = Tag.fromJson(item);
          tags.add(tag);
        }
      }
      return tags;
    }
  }
}
