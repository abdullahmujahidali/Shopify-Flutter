import 'dart:async';

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../../services/index.dart';

class FlashHelper {
  static Completer<BuildContext> _buildCompleter = Completer<BuildContext>();

  static void init(BuildContext context) {
    if (_buildCompleter.isCompleted == false) {
      _buildCompleter.complete(context);
    }
  }

  static void dispose() {
    if (_buildCompleter.isCompleted == false) {
      _buildCompleter.completeError(FlutterError('disposed'));
    }
    _buildCompleter = Completer<BuildContext>();
  }

  static Future<T?> toast<T>(String message) async {
    final context = await _buildCompleter.future;
    return showFlash<T>(
      context: context,
      duration: const Duration(seconds: 3),
      builder: (_, controller) {
        return Flash.dialog(
          controller: controller,
          alignment: const Alignment(0, 0.5),
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          backgroundColor: Colors.black87,
          brightness: brightness(context),
          child: DefaultTextStyle(
            style: const TextStyle(fontSize: 16.0, color: Colors.white),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(message),
            ),
          ),
        );
      },
    );
  }

  static Color _backgroundColor(BuildContext context) {
    final theme = Theme.of(context);
    return theme.dialogTheme.backgroundColor ?? theme.dialogBackgroundColor;
  }

  // Fix bug https://github.com/sososdk/flash/issues/50
  static Brightness brightness(BuildContext context) {
    return Theme.of(context).brightness;
  }

  static TextStyle _titleStyle(BuildContext context, [Color? color]) {
    final theme = Theme.of(context);
    return (theme.dialogTheme.titleTextStyle ?? theme.textTheme.titleMedium)!
        .copyWith(color: color);
  }

  static TextStyle _contentStyle(BuildContext context, [Color? color]) {
    final theme = Theme.of(context);
    return (theme.dialogTheme.contentTextStyle ?? theme.textTheme.bodyLarge)!
        .copyWith(color: color);
  }

  static Future<T?> successBar<T>(
    BuildContext context, {
    String? title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    return showFlash<T>(
      context: context,
      duration: duration,
      builder: (_, controller) {
        return Flash(
          controller: controller,
          behavior: FlashBehavior.floating,
          position: FlashPosition.bottom,
          horizontalDismissDirection: HorizontalDismissDirection.horizontal,
          backgroundColor: Colors.black87,
          brightness: brightness(context),
          child: FlashBar(
            title: title == null
                ? null
                : Text(title, style: _titleStyle(context, Colors.white)),
            content: Text(message, style: _contentStyle(context, Colors.white)),
            icon: Icon(Icons.check_circle, color: Colors.green[300]),
          ),
        );
      },
    );
  }

  static Future<T?> informationBar<T>(
    BuildContext context, {
    String? title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    return showFlash<T>(
      context: context,
      duration: duration,
      builder: (_, controller) {
        return Flash(
          controller: controller,
          behavior: FlashBehavior.floating,
          position: FlashPosition.bottom,
          horizontalDismissDirection: HorizontalDismissDirection.horizontal,
          backgroundColor: Colors.black87,
          brightness: brightness(context),
          child: FlashBar(
            title: title == null
                ? null
                : Text(title, style: _titleStyle(context, Colors.white)),
            content: Text(message, style: _contentStyle(context, Colors.white)),
            icon: Icon(Icons.info_outline, color: Colors.blue[300]),
            indicatorColor: Colors.blue[300],
          ),
        );
      },
    );
  }

  static Future<T?>? errorBar<T>(
    BuildContext context, {
    String? title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    try {
      return showFlash<T>(
        context: context,
        duration: duration,
        builder: (_, controller) {
          return Flash(
            controller: controller,
            behavior: FlashBehavior.floating,
            position: FlashPosition.bottom,
            horizontalDismissDirection: HorizontalDismissDirection.horizontal,
            backgroundColor: Colors.black87,
            brightness: brightness(context),
            child: FlashBar(
              title: title == null
                  ? null
                  : Text(title, style: _titleStyle(context, Colors.white)),
              content:
                  Text(message, style: _contentStyle(context, Colors.white)),
              icon: Icon(Icons.warning, color: Colors.red[300]),
              indicatorColor: Colors.red[300],
            ),
          );
        },
      );
    } catch (_) {
      return null;
    }
  }

  static Future<T?> actionBar<T>(
    BuildContext context, {
    String? title,
    required String message,
    required Widget primaryAction,
    required ActionCallback onPrimaryActionTap,
    Duration duration = const Duration(seconds: 3),
  }) {
    return showFlash<T>(
      context: context,
      duration: duration,
      builder: (_, controller) {
        return Flash(
          controller: controller,
          behavior: FlashBehavior.floating,
          position: FlashPosition.bottom,
          horizontalDismissDirection: HorizontalDismissDirection.horizontal,
          backgroundColor: Colors.black87,
          brightness: brightness(context),
          child: FlashBar(
            title: title == null
                ? null
                : Text(title, style: _titleStyle(context, Colors.white)),
            content: Text(message, style: _contentStyle(context, Colors.white)),
            primaryAction: TextButton(
              // ignore: unnecessary_null_comparison
              onPressed: onPrimaryActionTap == null
                  ? null
                  : () => onPrimaryActionTap(controller),
              child: primaryAction,
            ),
          ),
        );
      },
    );
  }

  static Future<T?> simpleDialog<T>(
    BuildContext context, {
    String? title,
    required String message,
    Widget? negativeAction,
    ActionCallback? onNegativeActionTap,
    Widget? positiveAction,
    ActionCallback? positiveActionTap,
  }) {
    return showFlash<T>(
      context: context,
      persistent: !ServerConfig().isBuilder,
      builder: (_, controller) {
        return Flash.dialog(
          controller: controller,
          backgroundColor: _backgroundColor(context),
          brightness: brightness(context),
          margin: const EdgeInsets.only(left: 40.0, right: 40.0),
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          child: FlashBar(
            title:
                title == null ? null : Text(title, style: _titleStyle(context)),
            content: Text(message, style: _contentStyle(context)),
            actions: <Widget>[
              if (negativeAction != null)
                TextButton(
                  onPressed: onNegativeActionTap == null
                      ? null
                      : () => onNegativeActionTap(controller),
                  child: negativeAction,
                ),
              if (positiveAction != null)
                TextButton(
                  onPressed: positiveActionTap == null
                      ? null
                      : () => positiveActionTap(controller),
                  child: positiveAction,
                ),
            ],
          ),
        );
      },
    );
  }

  static Future<T?> blockDialog<T>(
    BuildContext context, {
    required Completer<T> dismissCompleter,
  }) {
    return showFlash<T>(
      context: context,
      persistent: !ServerConfig().isBuilder,
      onWillPop: () => Future.value(false),
      builder: (_, controller) {
        dismissCompleter.future.then((value) => controller.dismiss(value));
        return Flash.dialog(
          controller: controller,
          barrierDismissible: false,
          backgroundColor: Colors.black87,
          brightness: brightness(context),
          margin: const EdgeInsets.only(left: 40.0, right: 40.0),
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(strokeWidth: 2.0),
          ),
        );
      },
    );
  }

  static Future<T?>? message<T>(
    BuildContext context, {
    IconData? icon,
    String? title,
    required String message,
    Duration duration = const Duration(seconds: 3),
    bool isError = false,
  }) {
    try {
      return showFlash<T>(
        context: context,
        duration: duration,
        persistent: !ServerConfig().isBuilder,
        builder: (context, controller) {
          return Flash(
            backgroundColor: isError
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).primaryColor,
            brightness: brightness(context),
            controller: controller,
            behavior: FlashBehavior.floating,
            position: FlashPosition.top,
            horizontalDismissDirection: HorizontalDismissDirection.horizontal,
            child: FlashBar(
              icon: Icon(
                icon ?? (isError ? Icons.error_outline : Icons.check),
                color: Colors.white,
              ),
              title: title != null
                  ? Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15.0,
                      ),
                    )
                  : null,
              content: Text(
                message,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isError ? 18.0 : 15.0,
                ),
              ),
              primaryAction: TextButton(
                onPressed: () => controller.dismiss(null),
                child: Text(
                  S.of(context).close,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
          );
        },
      );
    } catch (_) {
      return null;
    }
  }

  static Future<T?>? errorMessage<T>(
    BuildContext context, {
    IconData? icon,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    return FlashHelper.message(
      context,
      message: message,
      icon: icon,
      duration: duration,
      isError: true,
    );
  }
}

typedef ActionCallback = void Function(FlashController controller);
