import 'package:flutter/material.dart';

import '../../common/tools.dart';

class PinCodeWidget extends StatefulWidget {
  final TextEditingController controller;
  final int length;
  final Function(String) onChanged;
  final double borderRadius;
  final String? code;

  const PinCodeWidget({
    Key? key,
    required this.controller,
    required this.length,
    required this.onChanged,
    this.borderRadius = 0.0,
    this.code,
  }) : super(key: key);

  @override
  State<PinCodeWidget> createState() => _PinCodeWidgetState();
}

class _PinCodeWidgetState extends State<PinCodeWidget> {
  List<FocusNode> listFocusNode = [];
  int currentIndex = 0;
  List<TextEditingController> controllers = [];

  @override
  void initState() {
    List.generate(widget.length, (index) {
      listFocusNode.add(FocusNode());
      controllers.add(TextEditingController());
    });
    super.initState();

    WidgetsBinding.instance.endOfFrame.then((_) {
      if (mounted) {
        widget.controller.addListener(_listener);
        Future.microtask(() {
          listFocusNode.first.requestFocus();
        });
      }
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);
    super.dispose();
  }

  String replaceCharAt(String oldString, int index, String newChar) {
    return oldString.substring(0, index) +
        newChar +
        oldString.substring(index + 1);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.code != null && widget.code!.trim().isNotEmpty) {
      var index = 0;
      for (var element in widget.code!.characters) {
        controllers[index].text = element;
        index++;
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.length, (index) {
        return Flexible(
          child: Container(
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.only(left: 3.0, top: 7.0),
            decoration: BoxDecoration(
              border: Border.all(
                  color: listFocusNode[index].hasFocus
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).colorScheme.secondary),
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            child: TextField(
              controller: controllers[index],
              textDirection: TextDirection.ltr,
              focusNode: listFocusNode[index],
              maxLength: 1,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
              onTap: () {
                currentIndex = index;
                controllers[index].selectAll();
                setState(() {});
              },
              onSubmitted: (value) {
                if (widget.controller.text.length == widget.length) {
                  widget.onChanged(widget.controller.text);
                }
              },
              onChanged: (value) {
                if (value.isEmpty) {
                  return;
                }
                if (index < widget.controller.text.length) {
                  widget.controller.text =
                      replaceCharAt(widget.controller.text, index, value);
                } else {
                  widget.controller.text += value;
                }

                listFocusNode[index].unfocus();
                if ((index + 1) < widget.length) {
                  currentIndex++;
                  listFocusNode[index + 1].requestFocus();
                  controllers[index + 1].selectAll();
                  setState(() {});
                }
              },
              decoration: const InputDecoration(
                counter: SizedBox(),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(1),
              ),
            ),
          ),
        );
      }),
    );
  }

  void _listener() {
    if (mounted) {
      Tools.hideKeyboard(context);
    }

    if (widget.controller.text.length == widget.length &&
        currentIndex == widget.length - 1) {
      widget.onChanged(widget.controller.text);
    }
  }
}
