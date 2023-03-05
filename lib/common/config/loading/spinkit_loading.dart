import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../models/loading_config.dart';

class SpinkitLoading extends StatelessWidget {
  final LoadingConfig loadingConfig;
  const SpinkitLoading(this.loadingConfig);

  @override
  Widget build(BuildContext context) {
    var size = double.parse((loadingConfig.size ?? 30.0).toString());
    Widget icon;
    var color = Theme.of(context).primaryColor;
    switch (loadingConfig.type) {
      case 'rotatingPlain':
        icon = SpinKitRotatingPlain(
          color: color,
          size: size,
        );
        break;
      case 'doubleBounce':
        icon = SpinKitDoubleBounce(
          color: color,
          size: size,
        );
        break;
      case 'wave':
        icon = SpinKitWave(
          color: color,
          size: size,
        );
        break;
      case 'wanderingCubes':
        icon = SpinKitWanderingCubes(
          color: color,
          size: size,
        );
        break;
      case 'fadingFour':
        icon = SpinKitFadingFour(
          color: color,
          size: size,
        );
        break;
      case 'pulse':
        icon = SpinKitPulse(
          color: color,
          size: size,
        );
        break;
      case 'chasingDots':
        icon = SpinKitChasingDots(
          color: color,
          size: size,
        );
        break;
      case 'threeBounce':
        icon = SpinKitThreeBounce(
          color: color,
          size: size,
        );
        break;
      case 'circle':
        icon = SpinKitCircle(
          color: color,
          size: size,
        );
        break;
      case 'cubeGrid':
        icon = SpinKitCubeGrid(
          color: color,
          size: size,
        );
        break;
      case 'fadingCircle':
        icon = SpinKitFadingCircle(
          color: color,
          size: size,
        );
        break;
      case 'rotatingCircle':
        icon = SpinKitRotatingCircle(
          color: color,
          size: size,
        );
        break;
      case 'foldingCube':
        icon = SpinKitFoldingCube(
          color: color,
          size: size,
        );
        break;
      case 'pumpingHeart':
        icon = SpinKitPumpingHeart(
          color: color,
          size: size,
        );
        break;
      case 'dualRing':
        icon = SpinKitDualRing(
          color: color,
          size: size,
        );
        break;
      case 'hourGlass':
        icon = SpinKitHourGlass(
          color: color,
          size: size,
        );
        break;
      case 'fadingGrid':
        icon = SpinKitFadingGrid(
          color: color,
          size: size,
        );
        break;
      case 'ring':
        icon = SpinKitRing(
          color: color,
          size: size,
        );
        break;
      case 'ripple':
        icon = SpinKitRipple(
          color: color,
          size: size,
        );
        break;
      case 'spinningCircle':
        icon = SpinKitSpinningCircle(
          color: color,
          size: size,
        );
        break;
      case 'squareCircle':
        icon = SpinKitSquareCircle(
          color: color,
          size: size,
        );
        break;
      default:
        icon = SpinKitFadingCube(
          color: color,
          size: size,
        );
    }
    return Center(
      child: icon,
    );
  }
}
