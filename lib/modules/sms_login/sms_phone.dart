import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../generated/l10n.dart';
import 'sms_model.dart';
import 'widgets/custom_keyboard.dart';

class SMSInputWidget extends StatefulWidget {
  final Function onCallBack;
  const SMSInputWidget({Key? key, required this.onCallBack}) : super(key: key);

  @override
  State<SMSInputWidget> createState() => _SMSInputWidgetState();
}

class _SMSInputWidgetState extends State<SMSInputWidget> {
  bool _isPhoneValid(phoneNumber) {
    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(S.of(context).phoneEmpty),
        duration: const Duration(seconds: 1),
      ));
      return false;
    }
    const pattern = r'(^(?:[+0])?[0-9]{10,13}$)';
    final regExp = RegExp(pattern);
    if (!regExp.hasMatch(phoneNumber)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(S.of(context).invalidPhoneNumber),
        duration: const Duration(seconds: 3),
      ));
      return false;
    }
    return true;
  }

  void _onUpdate(String val) {
    final model = Provider.of<SMSModel>(context, listen: false);
    model.updatePhoneNumber(val);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20.0,
              ),
              Text(
                S.of(context).mobileVerification,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 5.0,
              ),
              Text(
                S.of(context).enterYourMobile,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: Consumer<SMSModel>(
                      builder: (_, model, __) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2,
                              color: model.dialPhoneNumber.isEmpty
                                  ? Colors.grey.withOpacity(0.8)
                                  : Theme.of(context).primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Text(
                            model.dialPhoneNumber.isEmpty
                                ? S.of(context).phoneHintFormat
                                : model.dialPhoneNumber,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontFamily: 'Roboto',
                                    color: model.dialPhoneNumber.isEmpty
                                        ? Colors.grey
                                        : Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                    fontWeight: FontWeight.w500),
                          )),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Center(
                child: Consumer<SMSModel>(
                  builder: (_, model, __) => TextButton(
                    onPressed: () {
                      if (model.state != SMSModelState.loading) {
                        if (_isPhoneValid(model.dialPhoneNumber)) {
                          widget.onCallBack();
                        }
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: model.state != SMSModelState.loading
                        ? const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          )
                        : const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.0,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: CustomKeyboard(
            onCallBack: _onUpdate,
            phoneNumber:
                Provider.of<SMSModel>(context, listen: false).dialPhoneNumber,
          ),
        ),
      ],
    );
  }
}
