import 'package:flutter/material.dart';
import 'package:inspireui/widgets/circle_button_text.dart';
import 'package:inspireui/widgets/radio_button.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../models/index.dart';
import '../../widgets/common/flux_image.dart';

mixin ChangeLanguage<T extends StatefulWidget> on State<T> {
  List<Map> get languages => getLanguages();

  AppModel get appModel => Provider.of<AppModel>(context, listen: false);

  void onTapChangeLanguage(Map langInfo) {
    appModel.changeLanguage(langInfo['code'], context);
    Navigator.of(context).pop();
  }

  void _showModel(context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              color: Colors.white,
            ),
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: const Color(0xFF555555).withOpacity(0.1),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Icon(Icons.close),
                      ),
                    ),
                  ),
                ),
                const Text(
                  'Change language',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 16),
                  child: Text(
                    'Which language do you prefer?',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    key: const Key('changeLanguageList'),
                    itemCount: languages.length,
                    itemBuilder: (context, i) {
                      return GestureDetector(
                        key:
                            ValueKey('changeLanguageTo${languages[i]['text']}'),
                        onTap: () {
                          onTapChangeLanguage(languages[i]);
                        },
                        child: Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              FluxImage(
                                imageUrl: languages[i]['icon'],
                                width: 30,
                                height: 20,
                                fit: BoxFit.cover,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    languages[i]['text'],
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              RadioButton(
                                radius: 14,
                                isActive: languages[i]['code']
                                        .toString()
                                        .toLowerCase() ==
                                    appModel.langCode.toLowerCase(),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget iconLanguage() {
    return Align(
      alignment: Alignment.topRight,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(right: 16.0, top: 16),
          child: GestureDetector(
            key: const Key('changeLanguageIconButton'),
            onTap: () => _showModel(context),
            child: Selector<AppModel, String>(
              selector: (_, model) => model.langCode,
              builder: (context, langCode, child) => CircleButtonText(
                langCode.toUpperCase(),
                radius: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
