import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/config.dart';
import '../../../common/constants.dart';
import '../../../models/index.dart' show AppModel, ProductAttribute;
import '../../../widgets/common/tooltip.dart' as tool_tip;

class AdditionalInformation extends StatelessWidget {
  final List<ProductAttribute> listInfo;

  const AdditionalInformation({required this.listInfo});

  @override
  Widget build(BuildContext context) {
    final lengthInfo = listInfo.length;
    var lang = Provider.of<AppModel>(context).langCode;

    return Column(
      children: [
        ...List.generate(
          listInfo.length,
          (index) {
            Color? color;
            if (index.isOdd && lengthInfo > 2) {
              color = Theme.of(context).primaryColorLight;
            }
            return renderItem(
              lang: lang,
              context: context,
              attribute: listInfo[index],
              color: color,
            );
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget renderItem({
    context,
    ProductAttribute? attribute,
    Color? color,
    required String lang,
  }) {
    if (attribute == null) return const SizedBox();

    var name = kProductVariantLanguage[lang] != null
        ? kProductVariantLanguage[lang]
                [attribute.cleanSlug ?? attribute.name] ??
            kProductVariantLanguage[lang][attribute.name?.toLowerCase()] ??
            attribute.label?.toLowerCase()
        : attribute.label?.toLowerCase();

    return Container(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(width: 10),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    name.toString().capitalize(),
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 6,
              child: attribute.name != 'color'
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Text(attribute.options!.join(', '),
                          style: const TextStyle(
                            color: kGrey600,
                            fontSize: 14,
                          )),
                    )
                  : Wrap(
                      runSpacing: 8.0,
                      spacing: 8.0,
                      children: <Widget>[
                        for (var i = 0; i < attribute.options!.length; i++)
                          tool_tip.Tooltip(
                            message: attribute.options![i] ?? '',
                            child: Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: HexColor(
                                  kNameToHex[attribute.options![i]
                                      .toString()
                                      .replaceAll(' ', '_')
                                      .toLowerCase()],
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
