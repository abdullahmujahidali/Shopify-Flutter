import 'package:flutter/material.dart';

import '../../models/audio/media_item.dart';
import '../../models/audio/playlist_audio.dart';
import 'notifiers/play_button_notifier.dart';
import 'notifiers/progress_notifier.dart';

export 'notifiers/index.dart';

/// Handle event native
abstract class AudioManager {
  ValueNotifier<PlaylistAudio> get data;

  ValueNotifier<ProgressBarState> get progressNotifier;

  ValueNotifier<bool> get stateStickyAudioWidget;

  ValueNotifier<bool> get isFirstSongNotifier;

  ValueNotifier<bool> get isLastSongNotifier;

  ValueNotifier<ButtonState> get playButtonNotifier;

  ValueNotifier<List<FluxMediaItem>> get playlistNotifier;

  ValueNotifier<FluxMediaItem?> get currentMediaItemNotifier;

  ValueNotifier<double> get speedNotifier;

  bool get isStickyAudioWidgetActive;

  bool? get autoPlay;

  String timeCreate = 'NULL';

  void dispose();

  void savePlaylist();

  void stop();

  void next();

  void prev();

  void replay();

  void pause();

  void play();

  void seek(Duration duration);

  void setRepeat(bool isRepeat);

  void playMediaItem(FluxMediaItem item);

  void removeMediaItem(FluxMediaItem mediaItem);

  Future<void> setSpeed(double speed);

  Future<void> fastForward();

  Future<void> rewind();

  Future<void> addMediaItem(FluxMediaItem mediaItem);

  Future<void> addListMediaItem(List<FluxMediaItem> listMediaItem);

  Future<void> playFromMediaId(String mediaId, [Map<String, dynamic>? extras]);

  void setAutoNext(bool autoNextEnabled);

  void setAutoPlay(bool isAutoPlay);

  void hideStickyAudioWidget();

  void showStickyAudioWidget();
}

class AudioServiceEmpty extends AudioManager {
  AudioServiceEmpty();

  @override
  bool? get autoPlay => false;

  @override
  ValueNotifier<PlaylistAudio> get data =>
      ValueNotifier(PlaylistAudio(name: '', playlist: [], createdAt: ''));

  @override
  void dispose() {}

  @override
  bool get isStickyAudioWidgetActive => false;

  @override
  void next() {}

  @override
  void pause() {}

  @override
  void prev() {}

  @override
  void removeMediaItem(FluxMediaItem mediaItem) {}

  @override
  void replay() {}

  @override
  void savePlaylist() {}

  @override
  void seek(Duration duration) {}

  @override
  void setAutoNext(bool autoNextEnabled) {}

  @override
  void setAutoPlay(bool isAutoPlay) {}

  @override
  void setRepeat(bool isRepeat) {}

  @override
  ValueNotifier<bool> get stateStickyAudioWidget => ValueNotifier(false);

  @override
  void stop() {}

  @override
  ValueNotifier<FluxMediaItem?> get currentMediaItemNotifier =>
      throw UnimplementedError();

  @override
  void hideStickyAudioWidget() {}

  @override
  void showStickyAudioWidget() {}

  @override
  ValueNotifier<bool> get isFirstSongNotifier => throw UnimplementedError();

  @override
  ValueNotifier<bool> get isLastSongNotifier => throw UnimplementedError();

  @override
  void play() {}

  @override
  ValueNotifier<ButtonState> get playButtonNotifier =>
      throw UnimplementedError();

  @override
  ValueNotifier<List<FluxMediaItem>> get playlistNotifier =>
      throw UnimplementedError();

  @override
  ValueNotifier<ProgressBarState> get progressNotifier =>
      throw UnimplementedError();

  @override
  Future<void> addMediaItem(FluxMediaItem mediaItem) async {}

  @override
  void playMediaItem(FluxMediaItem item, [bool isStart = false]) {}

  @override
  Future<void> addListMediaItem(List<FluxMediaItem> listMediaItem) async {}

  @override
  Future<void> playFromMediaId(String mediaId,
      [Map<String, dynamic>? extras]) async {}

  @override
  Future<void> fastForward() async {}

  @override
  Future<void> rewind() async {}

  @override
  ValueNotifier<double> get speedNotifier => throw UnimplementedError();

  @override
  Future<void> setSpeed(double speed) async {}
}
