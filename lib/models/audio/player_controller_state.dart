import 'media_item.dart';

enum PlayerState { loading, playing, stop }

class PlayerControllerState {
  bool isPlaying;
  bool isRepeat;
  bool isRepeatList;
  bool isSeeking;
  bool autoNextEnabled;
  int duration;
  int index;
  int position;
  FluxMediaItem? current;
  PlayerState state;

  PlayerControllerState({
    this.isPlaying = false,
    this.isRepeat = false,
    this.isRepeatList = false,
    this.autoNextEnabled = true,
    this.isSeeking = false,
    this.duration = 0,
    this.position = 0,
    this.current,
    this.index = 0,
    this.state = PlayerState.stop,
  });

  PlayerControllerState copyWith({
    bool? isPlaying,
    bool? isRepeat,
    bool? isSeeking,
    bool? autoNextEnabled,
    int? duration,
    int? index,
    int? position,
    FluxMediaItem? current,
    PlayerState? state,
  }) {
    return PlayerControllerState(
      isPlaying: isPlaying ?? this.isPlaying,
      isRepeat: isRepeat ?? this.isRepeat,
      isSeeking: isSeeking ?? this.isSeeking,
      autoNextEnabled: autoNextEnabled ?? this.autoNextEnabled,
      duration: duration ?? this.duration,
      index: index ?? this.index,
      position: position ?? this.position,
      current: current ?? this.current,
      state: state ?? this.state,
    );
  }
}
