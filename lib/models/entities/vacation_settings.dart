import '../../common/constants.dart';

import '../../generated/l10n.dart';

enum VacationOption { instant, dateWise }

extension VacationOptionExtension on VacationOption {
  String getTranslation(context) {
    switch (this) {
      case VacationOption.instant:
        return S.of(context).instantlyClose;
      default:
        return S.of(context).dateWiseClose;
    }
  }

  String get content {
    switch (this) {
      case VacationOption.instant:
        return 'instant';
      default:
        return 'date_wise';
    }
  }
}

class VacationSettings {
  bool vacationMode = false;
  bool disableVacationPurchase = false;
  VacationOption vacationOption = VacationOption.instant;
  DateTime? startDate;
  DateTime? endDate;
  String message = '';

  VacationSettings();

  VacationSettings.fromJson(json) {
    if (json['wcfm_vacation_mode'] != null) {
      vacationMode = json['wcfm_vacation_mode'] == 'yes';
    }
    if (json['wcfm_disable_vacation_purchase'] != null) {
      disableVacationPurchase = json['wcfm_disable_vacation_purchase'] == 'yes';
    }
    if (json['wcfm_vacation_mode_type'] != null) {
      if (json['wcfm_vacation_mode_type'] == 'date_wise') {
        vacationOption = VacationOption.dateWise;
      }
    }
    if (json['wcfm_vacation_start_date'] != null) {
      startDate = _convertStringToDateTime(json['wcfm_vacation_start_date']);
    }
    if (json['wcfm_vacation_end_date'] != null) {
      endDate = _convertStringToDateTime(json['wcfm_vacation_end_date']);
    }
    if (json['wcfm_vacation_mode_msg'] != null) {
      message = json['wcfm_vacation_mode_msg'];
    }
  }

  Map toJson() {
    return {
      'wcfm_vacation_mode': vacationMode ? 'yes' : 'no',
      'wcfm_disable_vacation_purchase': disableVacationPurchase ? 'yes' : 'no',
      'wcfm_vacation_mode_type': vacationOption.content,
      'wcfm_vacation_start_date': _convertDateTimeToString(startDate),
      'wcfm_vacation_end_date': _convertDateTimeToString(endDate),
      'wcfm_vacation_mode_msg': message,
    };
  }

  String _convertDateTimeToString(DateTime? date) {
    if (date == null) {
      return '';
    }
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  DateTime? _convertStringToDateTime(String date) {
    try {
      return DateTime.tryParse(date);
    } catch (e) {
      printLog(e);
    }
    return null;
  }

  bool isOpen() {
    if (vacationMode == true && vacationOption == VacationOption.instant) {
      return false;
    }
    final now = DateTime.now();
    if (vacationMode == true && startDate != null && endDate != null) {
      if (now.isBefore(endDate!) && now.isAfter(startDate!)) {
        return false;
      }
    }
    return true;
  }
}
