import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/config.dart';
import '../../../models/app_model.dart';
import '../../../screens/base_screen.dart';
import '../../../services/service_config.dart';

class ButtonChooseLanguage extends StatefulWidget {
  final TextStyle? style;
  final double width;
  const ButtonChooseLanguage({Key? key, this.style, this.width = 120})
      : super(key: key);

  @override
  State<ButtonChooseLanguage> createState() => _ButtonChooseLanguageState();
}

class _ButtonChooseLanguageState extends BaseScreen<ButtonChooseLanguage>
    with TickerProviderStateMixin {
  final _listLanguage = <Map<dynamic, dynamic>>[];
  var _dropdownValue = <dynamic, dynamic>{};
  OverlayEntry? overlayEntry;

  @override
  void afterFirstLayout(BuildContext context) {
    Future.delayed(const Duration(seconds: 1)).then((value) => _loadLanguage());
    super.afterFirstLayout(context);
  }

  void _onChanged(Map? lang) {
    _hide();

    if (lang != null && lang != _dropdownValue) {
      setState(() {
        _dropdownValue = lang;
      });
      Provider.of<AppModel>(context, listen: false)
          .changeLanguage(lang['code'], context)
          .then((value) => _loadLanguage());
    }
  }

  void _loadLanguage() {
    var languages = getLanguages();
    _listLanguage.clear();
    for (var i = 0; i < languages.length; i++) {
      if (ServerConfig().isVendorManagerType()) {
        if (unsupportedLanguages.contains(languages[i]['code'])) {
          continue;
        }
      }
      if (Provider.of<AppModel>(context, listen: false).langCode ==
          languages[i]['code']) {
        _dropdownValue = languages[i];
      }

      _listLanguage.add(languages[i]);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: GestureDetector(
        key: globalKeyCenterButton,
        onTap: _showOverLay,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _dropdownValue['icon'] == null
                ? const SizedBox(width: 30, height: 20)
                : Image.asset(
                    _dropdownValue['icon'],
                    width: 30,
                    height: 20,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return const SizedBox(width: 30, height: 20);
                    },
                  ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  _dropdownValue['text'] ?? 'Language',
                  style: widget.style,
                ),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded, size: 20)
          ],
        ),
      ),
    );
  }

  GlobalKey globalKeyCenterButton = GlobalKey();

  Future<void> _showOverLay() async {
    var renderBox =
        globalKeyCenterButton.currentContext!.findRenderObject() as RenderBox?;
    var offset = renderBox!.localToGlobal(Offset.zero);

    var overlayState = Overlay.of(context);
    // if (overlayState == null) {
    //   return;
    // }

    overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: _hide,
            child: Container(
              color: Colors.transparent,
            ),
          ),
          Positioned(
            left: offset.dx,
            top: offset.dy,
            child: Material(
              child: Card(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  padding: const EdgeInsets.only(left: 5),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _listLanguage.length,
                        (index) => GestureDetector(
                          onTap: () => _onChanged(_listLanguage[index]),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            color: _listLanguage[index]['code'] ==
                                    _dropdownValue['code']
                                ? Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.5)
                                : Colors.transparent,
                            width: widget.width,
                            child: Center(
                              child: Row(
                                children: [
                                  Image.asset(_listLanguage[index]['icon'],
                                      width: 30, height: 20, fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) {
                                    return const SizedBox(
                                        width: 30, height: 20);
                                  }),
                                  const SizedBox(width: 5),
                                  Expanded(
                                      child: Text(
                                    _listLanguage[index]['text'],
                                    style: widget.style,
                                  )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    overlayState.insert(overlayEntry!);
  }

  void _hide() {
    overlayEntry!.remove();
  }
}
