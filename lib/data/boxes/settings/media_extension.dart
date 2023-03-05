part of '../../boxes.dart';

extension MediaSettings on SettingsBox {
  bool get autoPlayAudio {
    return box.get(
      BoxKeys.autoPlayAudio,
      defaultValue: false,
    );
  }

  set autoPlayAudio(bool isAutoPlay) {
    box.put(BoxKeys.autoPlayAudio, isAutoPlay);
  }
}
