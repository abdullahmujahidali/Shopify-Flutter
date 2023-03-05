import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/user_model.dart';
import '../../../widgets/scanner/scanner_button.dart';

class SearchBox extends StatefulWidget {
  final double? width;
  final bool showCancelButton;
  final bool showSearchIcon;
  final bool autoFocus;
  final bool showQRCode;
  final String? initText;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final Function()? onCancel;
  final Function(String value)? onChanged;
  final Function(String value)? onSubmitted;

  const SearchBox({
    Key? key,
    this.focusNode,
    this.onCancel,
    this.width,
    this.onChanged,
    this.controller,
    this.initText,
    this.onSubmitted,
    this.autoFocus = false,
    this.showSearchIcon = true,
    this.showCancelButton = true,
    this.showQRCode = true,
  }) : super(key: key);

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  TextEditingController? _textController;

  double get widthButtonCancel => _textController!.text.isEmpty ? 0 : 50;

  String _oldSearchText = '';
  Timer? _debounceQuery;

  Function(String value)? get onChanged => widget.onChanged;

  @override
  void initState() {
    super.initState();
    _textController =
        widget.controller ?? TextEditingController(text: widget.initText ?? '');
    _textController!.addListener(_onSearchTextChange);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _textController!.dispose();
    }
    super.dispose();
  }

  void _onSearchTextChange() {
    if (_oldSearchText != _textController!.text) {
      if (_textController!.text.isEmpty) {
        _oldSearchText = _textController!.text;
        setState(() {});
        widget.onChanged?.call(_textController!.text);
        return;
      }

      if (_debounceQuery?.isActive ?? false) _debounceQuery!.cancel();
      _debounceQuery = Timer(const Duration(milliseconds: 800), () {
        _oldSearchText = _textController!.text;
        widget.onChanged?.call(_textController!.text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var canPop = Navigator.of(context).canPop() && widget.showCancelButton;

    return SizedBox(
      width: widget.width,
      child: Row(
        children: [
          if (canPop)
            IconButton(
              onPressed: () {
                var currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
                Navigator.of(context).pop();
              },
              icon: const Icon(CupertinoIcons.back),
            ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              margin: EdgeInsets.only(
                left: canPop ? 10 : 5,
                right: 5,
              ),
              child: CupertinoSearchTextField(
                autocorrect: false,
                controller: _textController,
                autofocus: widget.autoFocus,
                focusNode: widget.focusNode,
                itemColor: Theme.of(context).iconTheme.color!,
                style: Theme.of(context).textTheme.titleMedium,
                placeholderStyle: Theme.of(context).textTheme.titleMedium,
                onSubmitted: (value) => widget.onSubmitted?.call(value),
              ),
            ),
          ),
          if (widget.showQRCode)
            Consumer<UserModel>(
              builder: (_, model, __) => ScannerButton(
                user: model.user,
              ),
            ),
        ],
      ),
    );
  }
}
