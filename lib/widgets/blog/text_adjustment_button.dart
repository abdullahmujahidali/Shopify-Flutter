import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/text_style_model.dart';
import '../../screens/base_screen.dart';

class TextAdjustmentButton extends StatefulWidget {
  final double size;

  const TextAdjustmentButton(this.size);

  @override
  BaseScreen<TextAdjustmentButton> createState() =>
      _TextAdjustmentButtonState();
}

class _TextAdjustmentButtonState extends BaseScreen<TextAdjustmentButton> {
  double textSize = 15.0;

  @override
  void afterFirstLayout(BuildContext context) {
    textSize =
        Provider.of<TextStyleModel>(context, listen: false).contentTextSize;
    super.afterFirstLayout(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (context, StateSetter setState) {
                  return SizedBox(
                    height:
                        MediaQuery.of(context).copyWith().size.height * (1 / 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                CupertinoIcons.textformat,
                                size: 20,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              Icon(
                                CupertinoIcons.textformat,
                                size: 30,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              Icon(
                                CupertinoIcons.textformat,
                                size: 40,
                                color: Theme.of(context).iconTheme.color,
                              ),
                            ],
                          ),
                        ),
                        Slider(
                          onChanged: (double value) {
                            setState(() {
                              textSize = value;
                            });
                          },
                          onChangeEnd: (double value) {
                            Provider.of<TextStyleModel>(context, listen: false)
                                .adjustTextSize(value);
                          },
                          value: textSize,
                          min: 15.0,
                          max: 30.0,
                          divisions: 4,
                        ),
                      ],
                    ),
                  );
                },
              );
            });
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background.withOpacity(0.5),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Icon(
          CupertinoIcons.textformat_size,
          size: 18.0,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}
