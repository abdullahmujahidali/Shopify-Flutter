import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inspireui/icons/constants.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../common/tools/navigate_tools.dart';
import '../../generated/l10n.dart';
import '../../models/user_model.dart';
import '../../modules/dynamic_layout/index.dart';
import '../../routes/flux_navigate.dart';
import '../common/flux_image.dart';
import '../home/preview_overlay.dart';
import 'web_layout_mixin.dart';
import 'widgets/button_language.dart';
import 'widgets/follow_social_widget.dart';

const kHeightAppBarWeb = 130.0;
const kStyleTextInAppBarWeb = TextStyle(
  fontWeight: FontWeight.normal,
  fontSize: 12,
);

class AppBarWeb extends StatefulWidget {
  final bool isPinAppBar;
  final bool isSliver;
  final Map<String, dynamic> config;
  final Widget? searchWidget;
  final Function()? onRefresh;

  const AppBarWeb({
    Key? key,
    this.isPinAppBar = true,
    this.onRefresh,
    this.config = const {},
    this.isSliver = true,
    this.searchWidget,
  }) : super(key: key);

  @override
  State<AppBarWeb> createState() => _AppBarWebState();
}

class _AppBarWebState extends State<AppBarWeb> with WebLayoutMixin {
  void _onTapNotify() => FluxNavigate.pushNamed(RouteList.notify);

  void _onTapSupport() => onTapOpenUrl(context, kAdvanceConfig.supportPageUrl);

  void _onTapSignout() =>
      Provider.of<UserModel>(context, listen: false).logout();

  void _onTapSignUp() => NavigateTools.navigateRegister(context);

  void _onTapSignIn() => FluxNavigate.pushNamed(RouteList.login);

  void _onTapDownloadPage() =>
      onTapOpenUrl(context, kAdvanceConfig.downloadPageUrl);

  void _onTapSearch() => FluxNavigate.pushNamed(RouteList.search);

  void _onTapCart() => FluxNavigate.pushNamed(RouteList.cart);

  void _onTapLogo() => FluxNavigate.pushNamedAndRemoveUntil(
        RouteList.home,
        (route) => false,
      );

  @override
  Widget build(BuildContext context) {
    final colorAppBar = Theme.of(context).appBarTheme.backgroundColor ??
        Theme.of(context).primaryColor;

    final bodyAppBar = PreviewOverlay(
      index: 0,
      config: widget.config,
      builder: (value) {
        return Container(
          color: colorAppBar,
          child: Center(
            child: Container(
              height: kHeightAppBarWeb,
              color: colorAppBar,
              constraints: const BoxConstraints(maxWidth: kLimitWidthScreen),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: LayoutBuilder(
                builder: (_, constrain) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 50,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (kIsWeb == false &&
                                      Navigator.canPop(context)) ...[
                                    _renderButton(
                                      S.of(context).back,
                                      icon: Icons.arrow_back,
                                      onTap: Navigator.of(context).pop,
                                    ),
                                    _renderSpace(),
                                  ],
                                  _renderButton(
                                    S.of(context).downloadApp,
                                    onTap: _onTapDownloadPage,
                                  ),
                                  _renderSpace(),
                                  FollowSocialWidget(
                                    title: Text(
                                      S.of(context).connect,
                                      style: kStyleTextInAppBarWeb,
                                    ),
                                    direction: Axis.horizontal,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _renderButton(
                                    S.of(context).notifications,
                                    icon: CupertinoIcons.bell,
                                    onTap: _onTapNotify,
                                  ),
                                  _renderButton(
                                    S.of(context).support,
                                    icon: CupertinoIcons.question_circle,
                                    onTap: _onTapSupport,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: ButtonChooseLanguage(
                                      style: kStyleTextInAppBarWeb,
                                    ),
                                  ),
                                  ..._renderAuth(context),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 60,
                                    width: constrain.maxWidth * 0.2,
                                    child: InkWell(
                                      hoverColor: Colors.transparent,
                                      onTap: _onTapLogo,
                                      child: const FluxImage(
                                        imageUrl: kLogo,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: constrain.maxWidth * 0.7,
                                    child: widget.searchWidget ??
                                        HeaderSearch(
                                          config: HeaderConfig(
                                            radius: 3.0,
                                            title: 'Search for items',
                                          ),
                                          onSearch: _onTapSearch,
                                        ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Center(
                                    child: InkWell(
                                      hoverColor: Colors.transparent,
                                      onTap: _onTapCart,
                                      child: const FluxImage(
                                        imageUrl:
                                            'assets/icons/tabs/icon-cart2.png',
                                        fit: BoxFit.contain,
                                        width: 30,
                                        height: 30,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );

    if (widget.isSliver) {
      return SliverAppBar(
        pinned: false,
        snap: true,
        floating: true,
        titleSpacing: 0,
        elevation: 0,
        forceElevated: true,
        toolbarHeight: kHeightAppBarWeb,
        backgroundColor: colorAppBar,
        // TODO: update use ipad
        leading: const SizedBox(),
        title: bodyAppBar,
      );
    }

    return bodyAppBar;
  }

  List<Widget> _renderAuth(BuildContext context) {
    final loggedIn = Provider.of<UserModel>(context).loggedIn;

    return [
      if (loggedIn)
        _renderButton(S.of(context).logout, onTap: _onTapSignout)
      else ...[
        _renderButton(S.of(context).login, onTap: _onTapSignIn),
        _renderSpace(),
        _renderButton(S.of(context).signUp, onTap: _onTapSignUp),
      ]
    ];
  }

  Widget _renderSpace() => const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          '|',
          style: kStyleTextInAppBarWeb,
        ),
      );

  Widget _renderButton(String title, {Function()? onTap, IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        hoverColor: Colors.transparent,
        onTap: onTap,
        child: Row(
          children: [
            if (icon != null)
              Padding(
                padding: const EdgeInsets.only(right: 2),
                child: Icon(icon, size: 20),
              ),
            Text(
              title,
              style: kStyleTextInAppBarWeb,
            ),
          ],
        ),
      ),
    );
  }
}
