import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/constants.dart';
import '../../services/index.dart';

class PreviewReload extends StatefulWidget {
  final bool isDynamic;
  final String? previewKey;
  final Map<String, dynamic>? configs;
  final builder;

  const PreviewReload({
    this.configs,
    this.isDynamic = false,
    this.previewKey,
    required this.builder,
  }) : assert(builder != null);

  @override
  State<PreviewReload> createState() => _PreviewReloadState();
}

class _PreviewReloadState extends State<PreviewReload> {
  late Map<String, dynamic> configs;

  StreamSubscription? _subReloadConfigs;

  @override
  void initState() {
    if (!ServerConfig().isBuilder) {
      return;
    }

    /// init listener preview configs
    _subReloadConfigs = eventBus.on<EventReloadConfigs>().listen((event) {
      if (event.key != null) {
        if (event.key == widget.previewKey && widget.isDynamic) {
          setState(() {
            configs = event.configs;
          });
        }
      } else if (!widget.isDynamic) {
        setState(() {
          configs = event.configs;
        });
      }
    });
    configs = widget.configs ?? {};
    super.initState();
  }

  @override
  void dispose() {
    _subReloadConfigs?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      ServerConfig().isBuilder ? configs : widget.configs,
    );
  }
}
