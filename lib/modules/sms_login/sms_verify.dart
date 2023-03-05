import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../generated/l10n.dart';
import 'sms_model.dart';
import 'widgets/custom_keyboard.dart';

class SMSVerifyWidget extends StatefulWidget {
  final Function onCallBack;
  const SMSVerifyWidget({Key? key, required this.onCallBack}) : super(key: key);

  @override
  State<SMSVerifyWidget> createState() => _SMSVerifyWidgetState();
}

class _SMSVerifyWidgetState extends State<SMSVerifyWidget> {
  void _onUpdate(String val) {
    final model = Provider.of<SMSModel>(context, listen: false);
    model.updateSMSCode(val);
  }

  bool _isCodeValid(smsCode) {
    if (smsCode.isEmpty || smsCode.length < 6) {
      return false;
    }
    return true;
  }

  Widget _buildSMSCode(smsCode) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          6,
          (index) {
            final isInvalid = index > (smsCode.length - 1);
            return Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isInvalid
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              child: isInvalid
                  ? Text(
                      '1',
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          color: Colors.transparent, fontFamily: 'Roboto'),
                    )
                  : Text(
                      smsCode[index],
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(fontFamily: 'Roboto'),
                    ),
            );
          },
        ),
      ),
    );
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
                S.of(context).verificationCode,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 10.0,
              ),
              Consumer<SMSModel>(
                  builder: (_, model, __) => _buildSMSCode(model.smsCode)),
              const SizedBox(height: 20.0),
              Center(
                child: Consumer<SMSModel>(
                  builder: (_, model, __) => TextButton(
                    onPressed: () {
                      if (model.state != SMSModelState.loading) {
                        if (_isCodeValid(model.smsCode)) {
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
          child: CustomKeyboard.verifySms(
            onCallBack: (val) {
              _onUpdate(val);
            },
          ),
        ),
      ],
    );
  }
}
