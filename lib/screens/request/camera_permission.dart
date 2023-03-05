import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../generated/l10n.dart';
import '../common/permission_request_mixin.dart';

class CameraPermissionRequestScreen extends StatefulWidget {
  final String? reason;
  final Function(bool) onAppSettingsCallback;

  const CameraPermissionRequestScreen({
    Key? key,
    this.reason,
    required this.onAppSettingsCallback,
  }) : super(key: key);

  @override
  State<CameraPermissionRequestScreen> createState() =>
      _CameraPermissionRequestScreenState();
}

class _CameraPermissionRequestScreenState
    extends State<CameraPermissionRequestScreen>
    with PermissionRequestMixin, WidgetsBindingObserver {
  @override
  IconData get permissionIcon => CupertinoIcons.camera;

  @override
  String get permissionRequestTitle => S.of(context).allowCameraAccess;

  @override
  String get permissionRequestSubtitle =>
      widget.reason ?? S.of(context).weNeedCameraAccessTo;

  @override
  Future<void> onAcceptPermission() async {
    final result = await Permission.camera.request();
    if (result == PermissionStatus.permanentlyDenied) {
      WidgetsBinding.instance.addObserver(this);
      await openAppSettings();
      return;
    }
    var hasPermission = result == PermissionStatus.granted;
    Navigator.of(context).pop(hasPermission);
  }

  @override
  Future<void> onDeclinePermission() async {
    Navigator.of(context).pop();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        final result = await Permission.camera.status;
        var hasPermission = result == PermissionStatus.granted;
        if (mounted && Navigator.of(context).canPop()) {
          Navigator.of(context).pop(hasPermission);
        }
        widget.onAppSettingsCallback.call(hasPermission);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void dispose() {
    try {
      WidgetsBinding.instance.removeObserver(this);
    } catch (_) {}
    super.dispose();
  }
}
