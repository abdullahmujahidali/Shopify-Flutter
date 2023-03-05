import 'package:flutter/material.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../data/boxes.dart';
import '../../generated/l10n.dart';
import '../../widgets/common/webview.dart';
import '../posts/post_screen.dart';

class PrivacyTermScreen extends StatefulWidget {
  final bool showAgreeButton;

  const PrivacyTermScreen({
    Key? key,
    this.showAgreeButton = true,
  }) : super(key: key);

  @override
  State<PrivacyTermScreen> createState() => _PrivacyTermScreenState();
}

class _PrivacyTermScreenState extends State<PrivacyTermScreen> {
  void _onTapAgree() {
    UserBox().hasAgreedPrivacy = true;
    Navigator.of(context).pushReplacementNamed(RouteList.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    final pageId = kAdvanceConfig.privacyPoliciesPageId;
    final pageUrl = kAdvanceConfig.privacyPoliciesPageUrl;

    return Scaffold(
      bottomNavigationBar: !widget.showAgreeButton
          ? null
          : Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: SafeArea(
                minimum: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    onPressed: _onTapAgree,
                    child: Text(
                      S.current.agree.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
      body: Builder(builder: (context) {
        var canPop = ModalRoute.of(context)!.canPop;

        if (pageId != null) {
          return PostScreen(
            pageId: pageId,
            isLocatedInTabbar: !canPop,
            pageTitle: S.of(context).agreeWithPrivacy,
          );
        }

        return WebView(
          url: pageUrl,
          enableClose: canPop,
          enableBackward: false,
          enableForward: false,
          title: S.of(context).agreeWithPrivacy,
          appBar: AppBar(
            title: Text(S.of(context).agreeWithPrivacy),
            automaticallyImplyLeading: canPop,
          ),
        );
      }),
    );
  }
}
