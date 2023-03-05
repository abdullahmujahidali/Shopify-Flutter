import 'dart:async';

import 'package:collection/collection.dart';
import 'package:quiver/strings.dart';

import '../common/constants.dart';
import 'entities/paging_response.dart';
import 'entities/tag.dart';
import 'mixins/language_mixin.dart';
import 'paging_data_model.dart';

class TagModel extends PagingDataModel<Tag> with LanguageMixin {
  String? message;

  StreamSubscription? _subLanguageChange;

  int _limit = 9;

  TagModel([int limit = 9]) {
    _subLanguageChange = eventBus.on<EventChangeLanguage>().listen((event) {
      getTags();
    });
    _limit = limit;
  }

  UnmodifiableListView<Tag>? get tagList => data;

  String getTagName(String? tagId) {
    if (tagId == null) return '';
    return tagList?.firstWhereOrNull((element) => element.id == tagId)?.name ??
        '';
  }

  @override
  void dispose() {
    _subLanguageChange?.cancel();
    super.dispose();
  }

  Future<void> getTags() => getData();

  static Map<String, Tag> parseTagList(response) {
    /// API may return duplicate tags. Need to store in a map.
    var tags = <String, Tag>{};
    if (response is Map && isNotBlank(response['message'])) {
      printLog('[Exception tag_model.dart - parseTagList]');
      printLog(response['message']);
      return {};

      /// throw Exception(response['message']);
    } else {
      if (response is List) {
        for (var item in response) {
          final tag = Tag.fromJson(item);
          tags[tag.id.toString()] = tag;
        }
      }
      return tags;
    }
  }

  @override
  Future<PagingResponse<Tag>>? Function(dynamic p1) get requestApi =>
      (page) => api.getTagsByPage(
            limit: _limit,
            lang: langCode,
            page: page,
          );
}
