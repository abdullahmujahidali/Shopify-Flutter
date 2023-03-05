import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'cupertino/index.dart';
import 'local_widgets_localizations.dart';
import 'material/index.dart';

class SubMaterialLocalizations {
  static const LocalizationsDelegate<MaterialLocalizations> delegate =
      SubMaterialLocalizationsDelegate();
}

class SubCupertinoLocalizations {
  static const LocalizationsDelegate<CupertinoLocalizations> delegate =
      SubCupertinoLocalizationsDelegate();
}

class LocalWidgetLocalizations {
  static const LocalizationsDelegate<WidgetsLocalizations> delegate =
      WidgetsLocalizationsDelegate();
}
