import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../common/tools/flash.dart';
import '../../generated/l10n.dart';
import '../../models/app_model.dart';
import '../../services/service_config.dart';
import '../../widgets/common/index.dart' show FluxImage;
import '../common/app_bar_mixin.dart';

class LanguageScreen extends StatefulWidget {
  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> with AppBarMixin {
  bool isUpdating = false;

  @override
  Widget build(BuildContext context) {
    var list = <Widget>[];
    var languages = getLanguages();
    final currentLanguage =
        Provider.of<AppModel>(context, listen: false).langCode;

    for (var i = 0; i < languages.length; i++) {
      if (ServerConfig().isVendorManagerType()) {
        if (unsupportedLanguages
            .contains(languages[i]['code'])) {
          continue;
        }
      }
      final isSelected = currentLanguage == languages[i]['code'];
      list.add(
        ListTile(
          leading: FluxImage(
            imageUrl: languages[i]['icon'],
            width: 30,
            height: 20,
            fit: BoxFit.cover,
          ),
          title: Text(languages[i]['text']),
          onTap: isUpdating
              ? null
              : () {
                  if (isSelected) {
                    return;
                  }
                  setState(() {
                    isUpdating = true;
                  });
                  Provider.of<AppModel>(context, listen: false)
                      .changeLanguage(
                    languages[i]['code'],
                    context,
                  )
                      .then((_) {
                    setState(() {
                      isUpdating = false;
                    });
                    FlashHelper.message(
                      context,
                      message: S.of(context).languageSuccess,
                    );
                    context.navigator.pop();
                  });
                },
          trailing: !isSelected
              ? null
              : Icon(
                  Icons.check,
                  color: Theme.of(context).primaryColor,
                ),
        ),
      );
      if (i < languages.length - 1) {
        list.add(
          Divider(
            color: Theme.of(context).primaryColorLight,
            height: 1.0,
            indent: 75,
            endIndent: 30,
          ),
        );
      }
    }

    return renderScaffold(
      routeName: RouteList.language,
      secondAppBar: AppBar(
        title: Text(
          S.of(context).language,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        leading: isUpdating
            ? const Padding(
          padding: EdgeInsets.all(16.0),
          child: SizedBox.square(
            dimension: 24.0,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2.0,
            ),
          ),
        )
            : Center(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ...list,
            SizedBox(height: MediaQuery.of(context).padding.bottom + 32),
          ],
        ),
      ),
    );
  }
}
