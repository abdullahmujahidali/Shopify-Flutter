class NotionDataTools {
  static const String newlineListData = '---------------\n';
  static const int lengthId = 36;

  static bool mapNotNullEmpty(dynamic data) {
    return data != null && data is Map && data.isNotEmpty;
  }

  static bool listNotNullEmpty(dynamic data) {
    return data != null && data is List && data.isNotEmpty;
  }

  static String getConfigJson(Map<String, dynamic>? config) {
    try {
      if (config == null) return '';
      return config['results'][0]['code']['text'][0]['text']['content'] ?? '';
    } catch (e) {
      return '';
    }
  }

  static List<String>? fromRichText(Map<String, dynamic>? richtext) {
    try {
      if (richtext == null) return null;

      final listRichText = (richtext['rich_text'] ?? []) as List;
      return listRichText.isEmpty
          ? null
          : listRichText.map((e) => '${e['text']['content']}').toList();
    } catch (e) {
      return null;
    }
  }

  static String? fromRichTextToText(Map<String, dynamic>? richtext) {
    try {
      if (richtext == null) return null;

      final listRichText = (richtext['rich_text'] ?? []) as List;

      if (listRichText.isEmpty) {
        return null;
      }
      return listRichText.first['text']['content'];
    } catch (e) {
      return null;
    }
  }

  static List<String>? fromFile(Map<String, dynamic>? files) {
    try {
      if (files == null) return null;
      final listFile = (files['files'] ?? []) as List;
      final data = listFile.isEmpty
          ? null
          : listFile.map((e) {
              if (e['file'] != null && e['file']['url'] != null) {
                /// File
                return '${e['file']['url']}';
              } else if (e['external'] != null &&
                  e['external']['url'] != null) {
                /// File External
                return '${e['external']['url']}';
              } else if (e['name'] != null) {
                /// file name
                return '${e['name']}';
              }
              return '';
            }).toList();

      return data;
    } catch (e) {
      return null;
    }
  }

  static Map<String, dynamic> toCheckBox(bool checked) {
    return {'type': 'checkbox', 'checkbox': checked};
  }

  static List<String>? fromRelation(Map<String, dynamic>? relation) {
    try {
      if (relation == null) return null;
      final listRelation = (relation['relation'] ?? []) as List;
      return listRelation.isEmpty
          ? null
          : listRelation.map((e) => '${e['id']}').toList();
    } catch (e) {
      return null;
    }
  }

  static bool? fromCheckBox(Map<String, dynamic>? checkbox) {
    try {
      if (checkbox == null) return null;
      return checkbox['checkbox'] ?? false;
    } catch (e) {
      return null;
    }
  }

  static List<String>? fromMultiSelect(Map<String, dynamic>? multiSelect) {
    try {
      if (multiSelect == null) return null;
      final listSelect = (multiSelect['multi_select'] ?? []) as List;
      return listSelect.isEmpty
          ? null
          : listSelect.map((e) => '${e['name']}').toList();
    } catch (e) {
      return null;
    }
  }

  static num? fromNumber(Map<String, dynamic>? number) {
    try {
      if (number == null) return null;

      return number['number'] as num;
    } catch (e) {
      return null;
    }
  }

  static String? fromTitle(Map<String, dynamic>? title) {
    try {
      if (title == null) return null;

      return title['title'][0]['text']['content'] as String;
    } catch (e) {
      return null;
    }
  }

  static String? fromDate(Map<String, dynamic>? date) {
    if (date == null) return null;

    try {
      return date['date']['start'];
    } catch (e) {
      return null;
    }
  }

  static String? fromUrl(Map<String, dynamic> url) {
    try {
      return url['url'] as String;
    } catch (e) {
      return null;
    }
  }

  static Map<String, dynamic> textToRichText(String richText) {
    final pattern = RegExp('.{1,1500}');
    final contentText = <Map<String, dynamic>>[];
    for (var match in pattern.allMatches(richText)) {
      contentText.add({
        'type': 'text',
        'text': {'content': match.group(0) ?? ''}
      });
    }

    return {'type': 'rich_text', 'rich_text': contentText};
  }

  static Map<String, dynamic> listStringToRichText(List<String> listString) {
    return {
      'type': 'rich_text',
      'rich_text': listString.isEmpty
          ? null
          : listString
              .map((e) => {
                    'type': 'text',
                    'text': {'content': e}
                  })
              .toList()
    };
  }

  static Map<String, dynamic> toRichText(String text) {
    final data = text.replaceAll('\\', '\\\\');

    final pattern = RegExp('.{1,1500}');
    final contentText = <Map<String, dynamic>>[];
    for (var match in pattern.allMatches(data)) {
      contentText.add({
        'type': 'text',
        'text': {'content': match.group(0) ?? ''}
      });
    }

    return {'type': 'rich_text', 'rich_text': contentText};
  }

  static Map<String, dynamic> toDate(DateTime datetime) {
    return {
      'type': 'date',
      'date': {'start': datetime.toString()}
    };
  }

  static Map<String, dynamic> toNumber(num number) {
    return {'type': 'number', 'number': number};
  }

  static Map<String, dynamic> toTitle(String title) {
    return {
      'id': 'title',
      'type': 'title',
      'title': [
        {
          'type': 'text',
          'text': {'content': title},
        }
      ]
    };
  }

  static Map<String, dynamic> toMultiSelect(
      List<Map<String, dynamic>> listSelected) {
    return {'type': 'multi_select', 'multi_select': listSelected};
  }

  static Map<String, dynamic> toMultiSelectWithString(
      List<String> listSelected) {
    return {
      'type': 'multi_select',
      'multi_select': listSelected.map((e) => {'name': e}).toList()
    };
  }

  static Map<String, dynamic> toUrl(String url) {
    return {'type': 'url', 'url': url.isEmpty ? null : url};
  }

  static Map<String, dynamic> toFileExternal(List<String?> listfile) {
    return {
      'type': 'files',
      'files': listfile.isEmpty
          ? null
          : listfile
              .map((e) => {
                    'name': e,
                    'type': 'external',
                    'external': {'url': e}
                  })
              .toList()
    };
  }

  static Map<String, dynamic> toRelation(List<String> listId) {
    return {
      'type': 'relation',
      'relation': listId.isEmpty ? null : listId.map((e) => {'id': e}).toList()
    };
  }

  /// Condition:
  ///
  /// `equals` (string): Only return pages where the page property value matches the provided value exactly.
  ///
  /// `does_not_equal`(string): Only return pages where the page property value does not match the provided value exactly.
  ///
  /// `contains`(string): Only return pages where the page property value contains the provided value.
  ///
  /// `does_not_contain`(string): Only return pages where the page property value does not contain the provided value.
  ///
  /// `starts_with`(string): Only return pages where the page property value starts with the provided value.
  ///
  /// `ends_with`(string): Only return pages where the page property value ends with the provided value.
  static Map<String, dynamic> toFilterRichText(String property, String text,
      {String condition = 'equals'}) {
    return {
      'property': property,
      'rich_text': {condition: text}
    };
  }

  static Map<String, dynamic> toFilterTitle(String property, String text,
      {String condition = 'equals'}) {
    return {
      'property': property,
      'title': {condition: text}
    };
  }

  /// Condition:
  ///
  /// `equals` (string): Only return pages where the page property value matches the provided value exactly.
  ///
  /// `does_not_equal`(string): Only return pages where the page property value does not match the provided value exactly.
  ///
  /// `contains`(string): Only return pages where the page property value contains the provided value.
  ///
  /// `does_not_contain`(string): Only return pages where the page property value does not contain the provided value.
  ///
  /// `starts_with`(string): Only return pages where the page property value starts with the provided value.
  ///
  /// `ends_with`(string): Only return pages where the page property value ends with the provided value.
  static Map<String, dynamic> toFilterNumber(String property, num number,
      {String condition = 'equals'}) {
    return {
      'property': property,
      'number': {condition: number}
    };
  }
}
