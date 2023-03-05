part of '../constants.dart';

class EventOpenNativeDrawer {
  const EventOpenNativeDrawer();
}

class EventCloseNativeDrawer {
  const EventCloseNativeDrawer();
}

class EventOpenCustomDrawer {
  const EventOpenCustomDrawer();
}

class EventCloseCustomDrawer {
  const EventCloseCustomDrawer();
}

class EventSwitchStateCustomDrawer {
  const EventSwitchStateCustomDrawer();
}

class EventChangeLanguage {
  const EventChangeLanguage();
}

class EventChangeSelectedVariation {
  final ProductVariation? productVariation;

  const EventChangeSelectedVariation(this.productVariation);
}

class EventLoadedAppConfig {
  const EventLoadedAppConfig();
}
