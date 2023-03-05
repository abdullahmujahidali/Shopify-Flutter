import 'package:flutter/material.dart';
import 'package:inspireui/icons/constants.dart';

import '../../common/constants.dart';
import '../common/flux_image.dart';
import 'web_layout_mixin.dart';
import 'widgets/download_app_widget.dart';
import 'widgets/follow_social_widget.dart';
import 'widgets/my_account_widget.dart';
import 'widgets/quick_links_widget.dart';
import 'widgets/send_email_widget.dart';

class FooterWeb extends StatefulWidget {
  const FooterWeb({Key? key}) : super(key: key);

  @override
  State<FooterWeb> createState() => _FooterWebState();
}

class _FooterWebState extends State<FooterWeb> with WebLayoutMixin {
  void _onTapOpenUrlWeb(String urlWeb) => onTapOpenUrl(context, urlWeb);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      color: Theme.of(context).primaryColor.withOpacity(0.1),
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxWidth: kLimitWidthScreen),
              child: LayoutBuilder(builder: (_, constraints) {
                final maxWidthSession = constraints.maxWidth / 3;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: FluxImage(
                              imageUrl: kLogoImage,
                              width: maxWidthSession * 0.5,
                            ),
                          ),
                          const SendEmailWidget(),
                          FollowSocialWidget(
                            title: const Text('Follow Us On:'),
                            direction: Axis.vertical,
                            onTap: _onTapOpenUrlWeb,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: DownloadAppWidget(
                          onTap: _onTapOpenUrlWeb,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: const [
                            Expanded(child: MyAccountWidget()),
                            Expanded(child: QuickLinksWidget()),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text('Copyright @ 2022, InspireUI'),
          ),
        ],
      ),
    );
  }
}
