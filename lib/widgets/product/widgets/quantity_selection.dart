import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../common/constants.dart' show TextEditingControllerExt, kGrey200;
import '../../../generated/l10n.dart';
import '../../../services/index.dart';

class QuantitySelection extends StatefulWidget {
  final int limitSelectQuantity;
  final int? value;
  final double width;
  final double height;
  final Function? onChanged;
  final Color color;
  final bool useNewDesign;
  final bool enabled;
  final bool expanded;
  final FocusNode? focusNode;

  const QuantitySelection({
    required this.value,
    this.focusNode,
    this.width = 40.0,
    this.height = 42.0,
    this.limitSelectQuantity = 100,
    required this.color,
    this.onChanged,
    this.useNewDesign = true,
    this.enabled = true,
    this.expanded = false,
  });

  @override
  State<QuantitySelection> createState() => _QuantitySelectionState();
}

class _QuantitySelectionState extends State<QuantitySelection> {
  final _textController = TextEditingController();
  FocusNode? _focusNode;
  Timer? _debounce;

  Timer? _changeQuantityTimer;

  @override
  void initState() {
    super.initState();
    _textController.text = widget.value?.toString() ?? '';
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode?.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant QuantitySelection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.limitSelectQuantity != widget.limitSelectQuantity) {
      changeQuantity(widget.value ?? 1, forceUpdate: true);
    }
    if (oldWidget.value != null &&
        widget.value.toString() != _textController.text &&
        !(_focusNode?.hasFocus ?? false)) {
      _textController.text = widget.value?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _textController.removeListener(_onQuantityChanged);
    if (_changeQuantityTimer?.isActive ?? false) {
      _changeQuantityTimer?.cancel();
    }
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    _textController.dispose();
    _focusNode?.removeListener(_onFocusChange);
    _focusNode?.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode?.hasFocus ?? false) {
      _textController.selectAll();
    } else {
      var value = int.tryParse(_textController.text) ?? 1;
      if (value <= 0) {
        value = 1;
      }
      if (value > widget.limitSelectQuantity) {
        value = widget.limitSelectQuantity;
      }
      _textController.text = '$value';
      widget.onChanged?.call(value);
    }
  }

  int get currentQuantity => int.tryParse(_textController.text) ?? -1;

  bool _validateQuantity([int? value]) {
    if ((value ?? currentQuantity) <= 0) {
      return false;
    }
    if ((value ?? currentQuantity) > widget.limitSelectQuantity) {
      return false;
    }
    return true;
  }

  void changeQuantity(int value, {bool forceUpdate = false}) {
    if (!_validateQuantity(value)) {
      return;
    }

    if (value != currentQuantity || forceUpdate == true) {
      _textController.text = '$value';
      widget.onChanged?.call(value);
    }
  }

  void _onQuantityChanged() {
    if (!_validateQuantity()) {
      return;
    }

    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }
    _debounce = Timer(
      const Duration(milliseconds: 300),
      () {
        if (widget.onChanged != null) {
          widget.onChanged?.call(currentQuantity);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.useNewDesign == true) {
      final iconPadding = EdgeInsets.all(
        max(
          ((widget.height) - 24.0 - 8) * 0.5,
          0.0,
        ),
      );
      final textField = Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        padding: const EdgeInsets.only(bottom: 2),
        height: widget.height,
        width: widget.expanded == true ? null : widget.width,
        decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: kGrey200),
          borderRadius: BorderRadius.circular(3),
        ),
        alignment: Alignment.center,
        child: TextField(
          focusNode: _focusNode,
          readOnly: widget.enabled == false,
          enabled: widget.enabled == true,
          controller: _textController,
          maxLines: 1,
          maxLength: '${widget.limitSelectQuantity}'.length,
          onChanged: (_) => _onQuantityChanged(),
          onSubmitted: (_) => _onQuantityChanged(),
          decoration: const InputDecoration(
            border: InputBorder.none,
            counterText: '',
          ),
          keyboardType: const TextInputType.numberWithOptions(
            signed: true,
            decimal: false,
          ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          textAlign: TextAlign.center,
        ),
      );
      return Row(
        children: [
          widget.enabled == true
              ? Container(
                  height: widget.height,
                  width: widget.height,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(3.0),
                    border: Border.all(
                      color: kGrey200,
                    ),
                  ),
                  child: IconButton(
                    padding: iconPadding,
                    onPressed: () {
                      if (_focusNode?.hasFocus ?? false) {
                        _focusNode?.unfocus();
                      }
                      changeQuantity(currentQuantity - 1);
                    },
                    icon: const Icon(
                      Icons.remove,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          widget.expanded == true
              ? Expanded(
                  child: textField,
                )
              : textField,
          widget.enabled == true
              ? Container(
                  height: widget.height,
                  width: widget.height,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(3.0),
                    border: Border.all(
                      color: kGrey200,
                    ),
                  ),
                  child: IconButton(
                    padding: iconPadding,
                    onPressed: () {
                      if (_focusNode?.hasFocus ?? false) {
                        _focusNode?.unfocus();
                      }
                      changeQuantity(currentQuantity + 1);
                    },
                    icon: const Icon(
                      Icons.add,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      );
    }
    return GestureDetector(
      onTap: () {
        if (widget.onChanged != null) {
          showOptions(context);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: kGrey200),
          borderRadius: BorderRadius.circular(3),
        ),
        height: widget.height,
        width: widget.width,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: 2.0,
              horizontal: (widget.onChanged != null) ? 5.0 : 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Text(
                    widget.value.toString(),
                    style: TextStyle(fontSize: 14, color: widget.color),
                  ),
                ),
              ),
              if (widget.onChanged != null)
                const SizedBox(
                  width: 5.0,
                ),
              if (widget.onChanged != null)
                Icon(Icons.keyboard_arrow_down,
                    size: 14, color: Theme.of(context).colorScheme.secondary)
            ],
          ),
        ),
      ),
    );
  }

  void showOptions(context) {
    showModalBottomSheet(
        context: context,
        useRootNavigator: !ServerConfig().isBuilder,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      for (int option = 1;
                          option <= widget.limitSelectQuantity;
                          option++)
                        ListTile(
                            onTap: () {
                              widget.onChanged!(option);
                              Navigator.pop(context);
                            },
                            title: Text(
                              option.toString(),
                              textAlign: TextAlign.center,
                            )),
                    ],
                  ),
                ),
              ),
              Container(
                height: 1,
                decoration: const BoxDecoration(color: kGrey200),
              ),
              ListTile(
                title: Text(
                  S.of(context).selectTheQuantity,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        });
  }
}
