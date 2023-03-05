part of '../../boxes.dart';

extension UserPosSettingsExtension on UserBox {
  Map? get selectedPrinter {
    return box.get(
      BoxKeys.selectedPrinter,
    );
  }

  set selectedPrinter(Map? value) {
    if (value == null) {
      box.delete(BoxKeys.selectedPrinter);
      return;
    }
    box.put(BoxKeys.selectedPrinter, value);
  }
}
