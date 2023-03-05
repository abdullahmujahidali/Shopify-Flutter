import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

class MaterialLocalizationTi extends GlobalMaterialLocalizations {
  /// Create an instance of the translation bundle for Tigrinya.
  const MaterialLocalizationTi({
    String localeName = 'ti',
    required intl.DateFormat fullYearFormat,
    required intl.DateFormat compactDateFormat,
    required intl.DateFormat shortDateFormat,
    required intl.DateFormat mediumDateFormat,
    required intl.DateFormat longDateFormat,
    required intl.DateFormat yearMonthFormat,
    required intl.DateFormat shortMonthDayFormat,
    required intl.NumberFormat decimalFormat,
    required intl.NumberFormat twoDigitZeroPaddedFormat,
  }) : super(
          localeName: localeName,
          fullYearFormat: fullYearFormat,
          compactDateFormat: compactDateFormat,
          shortDateFormat: shortDateFormat,
          mediumDateFormat: mediumDateFormat,
          longDateFormat: longDateFormat,
          yearMonthFormat: yearMonthFormat,
          shortMonthDayFormat: shortMonthDayFormat,
          decimalFormat: decimalFormat,
          twoDigitZeroPaddedFormat: twoDigitZeroPaddedFormat,
        );

  @override
  String get aboutListTileTitleRaw => r'About $applicationName';

  @override
  String get alertDialogLabel => 'Alert';

  @override
  String get anteMeridiemAbbreviation => 'AM';

  @override
  String get backButtonTooltip => 'Back';

  @override
  String get calendarModeButtonLabel => 'Switch to calendar';

  @override
  String get cancelButtonLabel => 'CANCEL';

  @override
  String get closeButtonLabel => 'CLOSE';

  @override
  String get closeButtonTooltip => 'Close';

  @override
  String get collapsedIconTapHint => 'Expand';

  @override
  String get continueButtonLabel => 'CONTINUE';

  @override
  String get copyButtonLabel => 'Copy';

  @override
  String get cutButtonLabel => 'Cut';

  @override
  String get dateHelpText => 'mm/dd/yyyy';

  @override
  String get dateInputLabel => 'Enter Date';

  @override
  String get dateOutOfRangeLabel => 'Out of range.';

  @override
  String get datePickerHelpText => 'SELECT DATE';

  @override
  String get dateRangeEndDateSemanticLabelRaw => r'End date $fullDate';

  @override
  String get dateRangeEndLabel => 'End Date';

  @override
  String get dateRangePickerHelpText => 'SELECT RANGE';

  @override
  String get dateRangeStartDateSemanticLabelRaw => r'Start date $fullDate';

  @override
  String get dateRangeStartLabel => 'Start Date';

  @override
  String get dateSeparator => '/';

  @override
  String get deleteButtonTooltip => 'Delete';

  @override
  String get dialModeButtonLabel => 'Switch to dial picker mode';

  @override
  String get dialogLabel => 'Dialog';

  @override
  String get drawerLabel => 'Navigation menu';

  @override
  String get expandedIconTapHint => 'Collapse';

  @override
  String get firstPageTooltip => 'First page';

  @override
  String get hideAccountsLabel => 'Hide accounts';

  @override
  String get inputDateModeButtonLabel => 'Switch to input';

  @override
  String get inputTimeModeButtonLabel => 'Switch to text input mode';

  @override
  String get invalidDateFormatLabel => 'Invalid format.';

  @override
  String get invalidDateRangeLabel => 'Invalid range.';

  @override
  String get invalidTimeLabel => 'Enter a valid time';

  @override
  String get lastPageTooltip => 'Last page';

  @override
  String? get licensesPackageDetailTextFew => null;

  @override
  String? get licensesPackageDetailTextMany => null;

  @override
  String? get licensesPackageDetailTextOne => '1 license';

  @override
  String get licensesPackageDetailTextOther => r'$licenseCount licenses';

  @override
  String? get licensesPackageDetailTextTwo => null;

  @override
  String? get licensesPackageDetailTextZero => 'No licenses';

  @override
  String get licensesPageTitle => 'Licenses';

  @override
  String get modalBarrierDismissLabel => 'Dismiss';

  @override
  String get moreButtonTooltip => 'More';

  @override
  String get nextMonthTooltip => 'Next month';

  @override
  String get nextPageTooltip => 'Next page';

  @override
  String get okButtonLabel => 'OK';

  @override
  String get openAppDrawerTooltip => 'Open navigation menu';

  @override
  String get pageRowsInfoTitleRaw => r'$firstRow–$lastRow of $rowCount';

  @override
  String get pageRowsInfoTitleApproximateRaw =>
      r'$firstRow–$lastRow of about $rowCount';

  @override
  String get pasteButtonLabel => 'Paste';

  @override
  String get popupMenuLabel => 'Popup menu';

  @override
  String get postMeridiemAbbreviation => 'PM';

  @override
  String get previousMonthTooltip => 'Previous month';

  @override
  String get previousPageTooltip => 'Previous page';

  @override
  String get refreshIndicatorSemanticLabel => 'Refresh';

  @override
  String? get remainingTextFieldCharacterCountFew => null;

  @override
  String? get remainingTextFieldCharacterCountMany => null;

  @override
  String? get remainingTextFieldCharacterCountOne => '1 character remaining';

  @override
  String get remainingTextFieldCharacterCountOther =>
      r'$remainingCount characters remaining';

  @override
  String? get remainingTextFieldCharacterCountTwo => null;

  @override
  String? get remainingTextFieldCharacterCountZero => 'No characters remaining';

  @override
  String get reorderItemDown => 'Move down';

  @override
  String get reorderItemLeft => 'Move left';

  @override
  String get reorderItemRight => 'Move right';

  @override
  String get reorderItemToEnd => 'Move to the end';

  @override
  String get reorderItemToStart => 'Move to the start';

  @override
  String get reorderItemUp => 'Move up';

  @override
  String get rowsPerPageTitle => 'Rows per page:';

  @override
  String get saveButtonLabel => 'SAVE';

  @override
  ScriptCategory get scriptCategory => ScriptCategory.englishLike;

  @override
  String get searchFieldLabel => 'Search';

  @override
  String get selectAllButtonLabel => 'Select all';

  @override
  String get selectYearSemanticsLabel => 'Select year';

  @override
  String? get selectedRowCountTitleFew => null;

  @override
  String? get selectedRowCountTitleMany => null;

  @override
  String? get selectedRowCountTitleOne => '1 item selected';

  @override
  String get selectedRowCountTitleOther => r'$selectedRowCount items selected';

  @override
  String? get selectedRowCountTitleTwo => null;

  @override
  String? get selectedRowCountTitleZero => 'No items selected';

  @override
  String get showAccountsLabel => 'Show accounts';

  @override
  String get showMenuTooltip => 'Show menu';

  @override
  String get signedInLabel => 'Signed in';

  @override
  String get tabLabelRaw => r'Tab $tabIndex of $tabCount';

  @override
  TimeOfDayFormat get timeOfDayFormatRaw => TimeOfDayFormat.h_colon_mm_space_a;

  @override
  String get timePickerDialHelpText => 'SELECT TIME';

  @override
  String get timePickerHourLabel => 'Hour';

  @override
  String get timePickerHourModeAnnouncement => 'Select hours';

  @override
  String get timePickerInputHelpText => 'ENTER TIME';

  @override
  String get timePickerMinuteLabel => 'Minute';

  @override
  String get timePickerMinuteModeAnnouncement => 'Select minutes';

  @override
  String get unspecifiedDate => 'Date';

  @override
  String get unspecifiedDateRange => 'Date Range';

  @override
  String get viewLicensesButtonLabel => 'VIEW LICENSES';
  @override
  String get keyboardKeyAlt => 'Alt';

  @override
  String get keyboardKeyAltGraph => 'AltGr';

  @override
  String get keyboardKeyBackspace => 'Backspace';

  @override
  String get keyboardKeyCapsLock => 'Caps Lock';

  @override
  String get keyboardKeyChannelDown => 'Channel Down';

  @override
  String get keyboardKeyChannelUp => 'Channel Up';

  @override
  String get keyboardKeyControl => 'Ctrl';

  @override
  String get keyboardKeyDelete => 'Del';

  String get keyboardKeyEisu => 'Eisū';

  @override
  String get keyboardKeyEject => 'Eject';

  @override
  String get keyboardKeyEnd => 'End';

  @override
  String get keyboardKeyEscape => 'Esc';

  @override
  String get keyboardKeyFn => 'Fn';

  String get keyboardKeyHangulMode => 'Hangul Mode';

  String get keyboardKeyHanjaMode => 'Hanja Mode';

  String get keyboardKeyHankaku => 'Hankaku';

  String get keyboardKeyHiragana => 'Hiragana';

  String get keyboardKeyHiraganaKatakana => 'Hiragana Katakana';

  @override
  String get keyboardKeyHome => 'Home';

  @override
  String get keyboardKeyInsert => 'Insert';

  String get keyboardKeyKanaMode => 'Kana Mode';

  String get keyboardKeyKanjiMode => 'Kanji Mode';

  String get keyboardKeyKatakana => 'Katakana';

  @override
  String get keyboardKeyMeta => 'Meta';

  @override
  String get keyboardKeyMetaMacOs => 'Command';

  @override
  String get keyboardKeyMetaWindows => 'Win';

  @override
  String get keyboardKeyNumLock => 'Num Lock';

  @override
  String get keyboardKeyNumpad0 => 'Num 0';

  @override
  String get keyboardKeyNumpad1 => 'Num 1';

  @override
  String get keyboardKeyNumpad2 => 'Num 2';

  @override
  String get keyboardKeyNumpad3 => 'Num 3';

  @override
  String get keyboardKeyNumpad4 => 'Num 4';

  @override
  String get keyboardKeyNumpad5 => 'Num 5';

  @override
  String get keyboardKeyNumpad6 => 'Num 6';

  @override
  String get keyboardKeyNumpad7 => 'Num 7';

  @override
  String get keyboardKeyNumpad8 => 'Num 8';

  @override
  String get keyboardKeyNumpad9 => 'Num 9';

  @override
  String get keyboardKeyNumpadAdd => 'Num +';

  @override
  String get keyboardKeyNumpadComma => 'Num ,';

  @override
  String get keyboardKeyNumpadDecimal => 'Num .';

  @override
  String get keyboardKeyNumpadDivide => 'Num /';

  @override
  String get keyboardKeyNumpadEnter => 'Num Enter';

  @override
  String get keyboardKeyNumpadEqual => 'Num =';

  @override
  String get keyboardKeyNumpadMultiply => 'Num *';

  @override
  String get keyboardKeyNumpadParenLeft => 'Num (';

  @override
  String get keyboardKeyNumpadParenRight => 'Num )';

  @override
  String get keyboardKeyNumpadSubtract => 'Num -';

  @override
  String get keyboardKeyPageDown => 'PgDown';

  @override
  String get keyboardKeyPageUp => 'PgUp';

  @override
  String get keyboardKeyPower => 'Power';

  @override
  String get keyboardKeyPowerOff => 'Power Off';

  @override
  String get keyboardKeyPrintScreen => 'Print Screen';

  String get keyboardKeyRomaji => 'Romaji';

  @override
  String get keyboardKeyScrollLock => 'Scroll Lock';

  @override
  String get keyboardKeySelect => 'Select';

  @override
  String get keyboardKeySpace => 'Spasie';

  String get keyboardKeyZenkaku => 'Zenkaku';

  String get keyboardKeyZenkakuHankaku => 'Zenkaku Hankaku';

  @override
  String get menuBarMenuLabel => '';
}
