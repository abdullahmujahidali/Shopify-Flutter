import 'package:country_code_picker/country_code.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inspireui/inspireui.dart';
import 'package:provider/provider.dart';

import '../../../../../generated/l10n.dart';
import '../../../common/config.dart';
import '../../../common/tools/tools.dart';
import '../../../screens/common/select_country_mixin.dart';
import '../../../screens/home/privacy_term_screen.dart';
import '../../../widgets/common/common_safe_area.dart';
import '../../../widgets/common/custom_text_field.dart';
import '../../../widgets/common/index.dart';
import '../sms_model.dart';

class SMSInputPhoneV2 extends StatefulWidget {
  final VoidCallback onCallBack;

  const SMSInputPhoneV2({Key? key, required this.onCallBack}) : super(key: key);

  @override
  State<SMSInputPhoneV2> createState() => _SMSInputPhoneV2State();
}

class _SMSInputPhoneV2State extends State<SMSInputPhoneV2>
    with SelectCountryMixin {
  SMSModel get model => Provider.of<SMSModel>(context, listen: false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      model.updateCountryCode(CountryCode(
        code: LoginSMSConstants.countryCodeDefault,
        dialCode: LoginSMSConstants.dialCodeDefault,
        name: LoginSMSConstants.nameDefault,
        flagUri: elements
            .where((element) =>
                element.code == LoginSMSConstants.countryCodeDefault)
            .first
            .flagUri,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return AutoHideKeyboard(
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    S.current.welcome,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    S.current.enterYourPhone,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.color
                            ?.withOpacity(0.75)),
                  ),
                  const SizedBox(height: 30.0),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(color: Theme.of(context).dividerColor),
                    ),
                    child: Column(
                      children: [
                        Consumer<SMSModel>(
                          builder: (context, model, child) {
                            return GestureDetector(
                              onTap: () async {
                                final result =
                                    await showModel(model.country.code);
                                if (result == null) return;
                                model.updateCountryCode(result);
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      model.flagUri,
                                      package: 'country_code_picker',
                                      width: 24.0,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Skeleton(
                                          width: 24,
                                          height: 24,
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 8.0),
                                    Text(model.countryName),
                                    const SizedBox(width: 8.0),
                                    Text(
                                      '(${model.countryDialCode})',
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                      child: const Icon(
                                        Icons.arrow_drop_down,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const Divider(height: 1.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4.0,
                          ),
                          child: CustomTextField(
                            showCancelIcon: true,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            // Only numbers can
                            keyboardType: TextInputType.number,
                            onCancel: () {
                              model.updatePhoneNumber('');
                            },
                            onChanged: (value) {
                              model.updatePhoneNumber(value);
                            },
                            decoration: InputDecoration(
                              hintText: S.current.phoneNumber,
                              hintStyle: Theme.of(context).textTheme.bodyLarge,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28.0),
                  Center(
                    child: RichText(
                      maxLines: 2,
                      text: TextSpan(
                        text: S.current.bySignup,
                        style: Theme.of(context).textTheme.bodyLarge,
                        children: <TextSpan>[
                          TextSpan(
                            text: S.of(context).agreeWithPrivacy,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const PrivacyTermScreen(
                                        showAgreeButton: false,
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          CommonSafeArea(
            child: SizedBox(
              height: 48,
              width: double.infinity,
              child: Selector<SMSModel, bool>(
                selector: (context, provider) => provider.isValidPhoneNumber,
                builder: (context, isValidPhoneNumber, child) {
                  return ElevatedButton.icon(
                    onPressed: !isValidPhoneNumber
                        ? null
                        : () {
                            Tools.hideKeyboard(context);
                            widget.onCallBack();
                          },
                    label: Text(
                      S.current.continues,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    icon: Icon(
                      CupertinoIcons.arrow_right_square_fill,
                      color: Theme.of(context).colorScheme.background,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
