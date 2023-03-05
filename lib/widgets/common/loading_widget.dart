import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitFadingCube(
        color: Theme.of(context).primaryColor,
        size: 30.0,
      ),
    );
  }
}
