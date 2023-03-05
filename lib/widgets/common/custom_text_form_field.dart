import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final TextDirection? textDirection;
  final bool autofocus;
  final bool obscureText;
  final bool? autocorrect;
  final bool enableSuggestions;
  final int maxLines;
  final int? minLines;
  final bool expands;
  final bool readOnly;
  // final ToolbarOptions? toolbarOptions;
  final bool? showCursor;
  final int? maxLength;
  final bool maxLengthEnforced;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final double? cursorWidth;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final Brightness? keyboardAppearance;
  final EdgeInsets? scrollPadding;
  final bool? enableInteractiveSelection;
  final GestureTapCallback? onTap;
  final InputCounterWidgetBuilder? buildCounter;
  final ScrollPhysics? scrollPhysics;
  final ScrollController? scrollController;
  final FocusNode? nextNode;
  final Iterable<String>? autofillHints;
  final String? hintText;
  final VoidCallback? onCancel;
  final AutovalidateMode? autovalidateMode;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;

  /// Icon [Icons.visibility] at right of text field
  /// If true then [Icons.visibility]
  /// And if false then [Icons.visibility_off]
  /// Click icon to change show or hide password
  final bool showEyeIcon;

  /// Icon [Icons.cancel] at right of text field
  /// When text is not empty then icon will be shown
  /// And if text is empty then icon will be hide
  final bool showCancelIcon;

  const CustomTextFormField({
    key,
    this.controller,
    this.focusNode,
    this.decoration,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.strutStyle,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.textDirection,
    this.readOnly = false,
    // this.toolbarOptions,
    this.showCursor,
    this.autofocus = false,
    this.obscureText = false,
    this.autocorrect = false,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.maxLengthEnforced = true,
    this.onChanged,
    this.onEditingComplete,
    this.inputFormatters,
    this.enabled,
    this.cursorWidth,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.scrollPadding,
    this.enableInteractiveSelection,
    this.onTap,
    this.buildCounter,
    this.scrollController,
    this.scrollPhysics,
    this.nextNode,
    this.autofillHints,
    this.autovalidateMode,
    this.onFieldSubmitted,
    this.onSaved,
    this.validator,
    this.hintText,
    this.showCancelIcon = false,
    this.onCancel,
    this.showEyeIcon = false,
  })  : assert(
          !(showEyeIcon == showCancelIcon) || (!showEyeIcon || !showCancelIcon),
          'only one of them',
        ),
        super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextFormField>
    with SingleTickerProviderStateMixin {
  final _defaultTextController = TextEditingController();

  TextEditingController get controller =>
      widget.controller ?? _defaultTextController;

  bool get showCancelIcon => widget.showCancelIcon;

  bool get showEyeIcon => widget.showEyeIcon;

  bool _showCancelIconInState = false;

  bool? _showPasswordInState;

  @override
  void initState() {
    super.initState();
    controller.addListener(handleHideCancelIcon);
    if (showEyeIcon) {
      _showPasswordInState = true;
    }
  }

  void handleHideCancelIcon() {
    if (controller.text.isEmpty && showCancelIcon) {
      if (_showCancelIconInState) {
        setState(() {
          _showCancelIconInState = false;
        });
      }
    } else {
      if (!_showCancelIconInState && showCancelIcon) {
        setState(() {
          _showCancelIconInState = true;
        });
      }
    }
  }

  void handleHidePassword() {
    if (showEyeIcon) {
      setState(() {
        _showPasswordInState = !_showPasswordInState!;
      });
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: widget.focusNode,
      decoration: widget.decoration != null
          ? widget.decoration!.copyWith(
              suffixIcon: buildSuffixIconDecoration(),
            )
          : const InputDecoration(),
      keyboardType: widget.keyboardType,
      textInputAction: widget.nextNode != null
          ? TextInputAction.next
          : (widget.textInputAction ?? TextInputAction.done),
      textCapitalization: widget.textCapitalization,
      style: widget.style,
      strutStyle: widget.strutStyle,
      textAlign: widget.textAlign,
      textAlignVertical: widget.textAlignVertical,
      textDirection: widget.textDirection,
      readOnly: widget.readOnly,
      // toolbarOptions: widget.toolbarOptions,
      showCursor: widget.showCursor,
      autofocus: widget.autofocus,
      obscureText: _showPasswordInState ?? widget.obscureText,
      autocorrect: widget.autocorrect ?? false,
      enableSuggestions: widget.enableSuggestions,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      expands: widget.expands,
      maxLength: widget.maxLength,
      onChanged: widget.onChanged,
      onEditingComplete: widget.onEditingComplete,
      onFieldSubmitted: widget.nextNode == null
          ? widget.onFieldSubmitted
          : (value) {
              FocusScope.of(context).requestFocus(widget.nextNode);
              if (widget.onFieldSubmitted != null) {
                widget.onFieldSubmitted!(value);
              }
            },
      inputFormatters: widget.inputFormatters,
      autofillHints: widget.autofillHints,
      enabled: widget.enabled,
      cursorWidth: widget.cursorWidth ?? 2.0,
      cursorRadius: widget.cursorRadius,
      cursorColor: widget.cursorColor,
      keyboardAppearance: widget.keyboardAppearance,
      scrollPadding: widget.scrollPadding ?? const EdgeInsets.all(20.0),
      enableInteractiveSelection: widget.enableInteractiveSelection ?? true,
      onTap: widget.onTap,
      buildCounter: widget.buildCounter,
      scrollController: widget.scrollController,
      scrollPhysics: widget.scrollPhysics,
      autovalidateMode: widget.autovalidateMode,
      onSaved: widget.onSaved,
      validator: widget.validator,
    );
  }

  Widget? buildSuffixIconDecoration() {
    if (_showCancelIconInState) {
      return buildCloseIcon();
    } else if (showEyeIcon) {
      if (_showPasswordInState!) {
        return buildEyeShowIcon();
      }
      return buildEyeHideIcon();
    }
    return widget.decoration!.suffixIcon;
  }

  Widget buildCloseIcon() {
    return GestureDetector(
      onTap: () {
        controller.clear();
        widget.onCancel?.call();
      },
      child: Container(
        color: Colors.transparent,
        child: const Icon(Icons.cancel),
      ),
    );
  }

  Widget buildEyeShowIcon() {
    return GestureDetector(
      onTap: handleHidePassword,
      child: Container(
        color: Colors.transparent,
        child: const Icon(
          Icons.visibility_off,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget buildEyeHideIcon() {
    return GestureDetector(
      onTap: handleHidePassword,
      child: Container(
        color: Colors.transparent,
        child: const Icon(
          Icons.visibility,
          color: Colors.grey,
        ),
      ),
    );
  }
}
