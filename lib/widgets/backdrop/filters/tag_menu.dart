import 'package:flutter/material.dart';
import 'package:inspireui/widgets/expandable/expansion_widget.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../../models/index.dart' show ProductModel, TagModel;
import 'filter_option_item.dart';

class BackDropTagMenu extends StatefulWidget {
  const BackDropTagMenu({
    Key? key,
    this.onChanged,
  }) : super(key: key);

  final Function(String? tagId)? onChanged;

  @override
  State<BackDropTagMenu> createState() => _BackDropTagMenuState();
}

class _BackDropTagMenuState extends State<BackDropTagMenu> {
  String? get tagId =>
      Provider.of<ProductModel>(context, listen: false).tagId.toString();

  TagModel get tagModel => Provider.of<TagModel>(context, listen: false);
  String? _tagId;

  @override
  void initState() {
    _tagId = tagId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableProvider.value(
      value: Provider.of<TagModel>(context),
      child: Consumer<TagModel>(
        builder: (context, TagModel tagModel, _) {
          var tagList = tagModel.tagList ?? [];

          if (tagList.isEmpty) {
            return const SizedBox();
          }

          return ExpansionWidget(
            showDivider: true,
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
              top: 15,
              bottom: 10,
            ),
            title: Text(
              S.of(context).byTag,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 10.0),
                    height: 100,
                    child: GridView.count(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      childAspectRatio: 0.4,
                      children: List.generate(
                        tagList.length,
                        (index) {
                          final tagItem = tagList[index];
                          final selected = _tagId == tagItem.id.toString();
                          return FilterOptionItem(
                            enabled: true,
                            selected: selected,
                            isValid: _tagId != '-1',
                            title: tagList[index].name!.toUpperCase(),
                            onTap: () {
                              setState(() {
                                if (_tagId == tagItem.id.toString()) {
                                  _tagId = null;
                                } else {
                                  _tagId = tagItem.id.toString();
                                }
                              });
                              Provider.of<ProductModel>(context, listen: false)
                                  .updateTagId(tagId: _tagId);
                              widget.onChanged?.call(_tagId);
                            },
                          );
                        },
                      )..add(Builder(builder: (context) {
                          if (!tagModel.hasNext) {
                            return const SizedBox();
                          }
                          if (tagModel.isLoadMore) {
                            return SizedBox(
                              width: 70,
                              height: 50,
                              child: Center(
                                child: JumpingDots(
                                  innerPadding: 2,
                                  radius: 6,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            );
                          }
                          return FilterOptionItem(
                            title: S.of(context).more,
                            selected: false,
                            onTap: tagModel.getData,
                          );
                        })),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
