import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../common/constants.dart';
import '../../common/tools/flash.dart';
import '../../generated/l10n.dart';
import '../../models/entities/user.dart';
import '../../routes/flux_navigate.dart';
import '../../screens/request/camera_permission.dart';
import '../../services/service_config.dart';
import 'scanner.dart';

class ScannerButton extends StatelessWidget {
  final User? user;
  final IconData? customIcon;

  const ScannerButton({Key? key, this.user, this.customIcon}) : super(key: key);

  Future navigateToScanner() {
    return FluxNavigate.push(
      MaterialPageRoute(
        builder: (_) => Scanner(
          key: UniqueKey(),
          user: user,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!ServerConfig().isWooType || ServerConfig().isListingType) {
      return const SizedBox();
    }
    return IconButton(
        onPressed: () async {
          if (!isIos && !isAndroid) {
            return FluxNavigate.push(
              MaterialPageRoute(builder: (_) => const FakeBarcodeScreen()),
            );
          }
          final hasPermission =
              await Permission.camera.status == PermissionStatus.granted;
          if (!hasPermission) {
            final result = await FluxNavigate.push(
              MaterialPageRoute(
                builder: (_) => CameraPermissionRequestScreen(
                  onAppSettingsCallback: (bool hasPermission) {
                    if (!hasPermission) {
                      unawaited(
                        FlashHelper.errorBar(
                          context,
                          message: S.of(context).noCameraPermissionIsGranted,
                        ),
                      );
                      return;
                    }
                  },
                ),
              ),
            );
            if (result != true) {
              /// User pressed back or denied.
              return;
            }
          }
          return navigateToScanner();
        },
        icon: Icon(customIcon ?? CupertinoIcons.barcode_viewfinder));
  }
}

class FakeBarcodeScreen extends StatelessWidget {
  const FakeBarcodeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: const Center(
        child: Icon(
          CupertinoIcons.barcode_viewfinder,
          size: 200.0,
        ),
      ),
    );
  }
}
