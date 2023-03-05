import 'package:flutter/cupertino.dart';

import '../../models/entities/vacation_settings.dart';
import '../../services/index.dart';

enum StoreOpenOptionState { loading, loaded }

class StoreOpenOptionModel extends ChangeNotifier {
  final String _userId;
  final String _cookie;
  final _services = Services();
  VacationSettings? _vacationSettings;
  StoreOpenOptionState _state = StoreOpenOptionState.loading;
  StoreOpenOptionState get state => _state;
  VacationSettings? get vacationSettings => _vacationSettings;

  void _updateState(state) {
    _state = state;
    notifyListeners();
  }

  StoreOpenOptionModel(this._userId, this._cookie) {
    getVacationSettings();
  }

  Future<bool> apply() async {
    _updateState(StoreOpenOptionState.loading);
    final result =
        await _services.api.setVacationSettings(_cookie, _vacationSettings!);
    _updateState(StoreOpenOptionState.loaded);
    return result!;
  }

  Future<void> getVacationSettings() async {
    _vacationSettings = await _services.api.getVacationSettings(_userId);
    _vacationSettings ??= VacationSettings();
    _updateState(StoreOpenOptionState.loaded);
  }

  void update(
      {bool? vacationMode,
      bool? disablePurchase,
      String? msg,
      DateTime? startDate,
      DateTime? endDate,
      VacationOption? vacationOption}) {
    if (vacationMode != null) {
      _vacationSettings!.vacationMode = vacationMode;
    }
    if (disablePurchase != null) {
      _vacationSettings!.disableVacationPurchase = disablePurchase;
    }
    if (msg != null) {
      _vacationSettings!.message = msg;
    }
    if (startDate != null) {
      _vacationSettings!.startDate = startDate;
    }
    if (endDate != null) {
      _vacationSettings!.endDate = endDate;
    }
    if (vacationOption != null) {
      _vacationSettings!.vacationOption = vacationOption;
    }
  }
}
