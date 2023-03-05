import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../widgets/navigation_buttons.dart';

class VendorFinish extends StatefulWidget {
  final Function(bool isPrev) onCallBack;
  const VendorFinish({Key? key, required this.onCallBack}) : super(key: key);

  @override
  State<VendorFinish> createState() => _VendorFinishState();
}

class _VendorFinishState extends State<VendorFinish> {
  bool _isAnimationTextFinished = false;

  void _showGetStarted() {
    _isAnimationTextFinished = true;
    setState(() {});
  }

  @override
  void initState() {
    _isAnimationTextFinished = false;
    super.initState();
  }

  Widget _getStartedButton() {
    return InkWell(
      onTap: _isAnimationTextFinished
          ? () {
              widget.onCallBack(false);
            }
          : null,
      child: AnimatedContainer(
        height: _isAnimationTextFinished ? 40 : 0,
        width: 200.0,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(20.0),
        ),
        duration: const Duration(milliseconds: 200),
        child: Center(
            child: Text(
          S.of(context).getStarted,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Colors.white),
        )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          SizedBox(
            width: size.width,
            child: Center(
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.headlineMedium!,
                textAlign: TextAlign.center,
                child: AnimatedTextKit(
                  isRepeatingAnimation: false,
                  animatedTexts: [
                    TypewriterAnimatedText(
                      S.of(context).isEverythingSet,
                    ),
                  ],
                  repeatForever: false,
                  totalRepeatCount: 1,
                  onFinished: _showGetStarted,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30.0,
          ),
          _getStartedButton(),
          const Spacer(),
          NavigationButtons(
            onBack: () {
              widget.onCallBack(true);
            },
          ),
        ],
      ),
    );
  }
}
