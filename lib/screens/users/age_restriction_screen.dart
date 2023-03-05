import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/config/models/age_restriction_config.dart';
import '../../common/tools/flash.dart';
import '../../data/boxes.dart';
import '../../generated/l10n.dart';
import '../../models/app_model.dart';
import '../../widgets/common/index.dart';
import 'pin_code_widget.dart';

class AgeRestrictionScreen extends StatefulWidget {
  final AgeRestrictionConfig config;
  final VoidCallback? overrideEligibleCallback;
  final VoidCallback? overrideInvalidAgeCallback;

  const AgeRestrictionScreen({
    Key? key,
    required this.config,
    this.overrideEligibleCallback,
    this.overrideInvalidAgeCallback,
  }) : super(key: key);

  @override
  State<AgeRestrictionScreen> createState() => _AgeRestrictionScreenState();
}

class _AgeRestrictionScreenState extends State<AgeRestrictionScreen> {
  final TextEditingController _yearController = TextEditingController();

  int get _currentYear => DateTime.now().year;

  int _year = 0;

  int get _age => _currentYear - _year;

  bool get isDone => _yearController.text.length == 4;

  /// Who is older than 150? 👻
  bool get isAgeInvalid => isDone && (_age < 0 || _age > 150);

  bool get isEligible => isDone && _age >= widget.config.minimumAge;

  Key _yearFieldKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return isEligible;
      },
      child: Scaffold(
        appBar: null,
        body: Stack(
          children: [
            if (widget.config.backgroundImageUrl.isNotEmpty)
              Positioned.fill(
                child: FluxImage(
                  imageUrl: widget.config.backgroundImageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            Positioned.fill(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      if (widget.config.useLogo)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: FluxImage(
                              imageUrl: context
                                  .select((AppModel _) => _.themeConfig.logo),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      if (!widget.config.useLogo &&
                          widget.config.imageUrl.isNotEmpty)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: FluxImage(
                              imageUrl: widget.config.imageUrl,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Text(
                                widget.config.title,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: PinCodeWidget(
                                key: _yearFieldKey,
                                controller: _yearController,
                                length: 4,
                                onChanged: (String value) {
                                  if (!mounted) {
                                    return;
                                  }
                                  _year = int.tryParse(value) ?? 0;
                                  setState(() {});
                                  if (isAgeInvalid) {
                                    _yearController.clear();
                                    _yearFieldKey = UniqueKey();
                                    setState(() {});

                                    if (widget.overrideInvalidAgeCallback !=
                                        null) {
                                      widget.overrideInvalidAgeCallback?.call();
                                      return;
                                    }

                                    FlashHelper.errorMessage(
                                      context,
                                      message: S.of(context).invalidYearOfBirth,
                                    );
                                    return;
                                  }

                                  if (isEligible &&
                                      widget.overrideEligibleCallback != null) {
                                    widget.overrideEligibleCallback?.call();
                                    return;
                                  }

                                  if (isEligible) {
                                    UserBox().hasAnswerAgeRestriction = true;
                                    Navigator.of(context).pop();
                                  }
                                },
                              ),
                            ),
                            if (isDone && !isEligible && !isAgeInvalid)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  widget.config.deniedMessage,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w600,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            if (_yearController.text.trim().isEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  widget.config.hintMessage,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
