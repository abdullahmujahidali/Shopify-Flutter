import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:inspireui/utils.dart';

import 'media_item.dart';

class PlaylistAudio {
  late String name;
  late String createdAt;
  late List<FluxMediaItem>? playlist;

  PlaylistAudio({
    required this.name,
    required this.createdAt,
    this.playlist,
  });

  PlaylistAudio copyWith({
    String? name,
    String? createdAt,
    List<FluxMediaItem>? playlist,
  }) {
    return PlaylistAudio(
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      playlist: List<FluxMediaItem>.from(
          playlist ?? this.playlist ?? <FluxMediaItem>[]),
    );
  }

  PlaylistAudio.fromJson(Map parsedJson) {
    try {
      name = parsedJson['name'];
      createdAt = parsedJson['createdAt'];
      playlist = <FluxMediaItem>[];
      if (parsedJson['playlist'] is List) {
        for (var item in parsedJson['playlist']) {
          if ((item['urlSource']?.isNotEmpty ?? false) &&
              (item['title']?.isNotEmpty ?? false) &&
              (item['image']?.isNotEmpty ?? false)) {
            playlist?.add(FluxMediaItem(
              id: item['id'] ?? '${UniqueKey()}',
              urlSource: item['urlSource'],
              album: item['album'],
              title: item['title'],
              artUri: item['image'],
            ));
          }
        }
      }
    } catch (e, trace) {
      printError(e, trace);
      printLog('AudioItem $name error: ${e.toString()}');
    }
  }

  Map<String, dynamic> toJson() {
    // final playlistJson = playlist?.map((e) => e.toJson()).toList() ?? [];
    return {
      'name': name,
      'createdAt': createdAt,
      // 'playlist': playlistJson,
    };
  }

  @override
  String toString() => jsonEncode(toJson());
}
