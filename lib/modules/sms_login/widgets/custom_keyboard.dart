import 'package:flutter/material.dart';

class CustomKeyboard extends StatefulWidget {
  final Function(String) onCallBack;
  final bool isVerifyCode;
  final String? phoneNumber;

  const CustomKeyboard({
    Key? key,
    required this.onCallBack,
    this.isVerifyCode = false,
    this.phoneNumber,
  }) : super(key: key);

  const CustomKeyboard.verifySms({
    Key? key,
    required this.onCallBack,
    this.isVerifyCode = true,
    this.phoneNumber,
  }) : super(key: key);

  @override
  State<CustomKeyboard> createState() => _CustomKeyboardState();
}

class _CustomKeyboardState extends State<CustomKeyboard> {
  var _smsCode = '';

  void _onUpdate(String val) {
    if (!widget.isVerifyCode) {
      if (_smsCode.isEmpty) {
        if (val != '+') {
          /// Stop if wrong phone format
          return;
        }
      }
      if (_smsCode.contains('+') && val == '+') {
        return;
      }
    }

    switch (val) {
      case 'remove_all':
        {
          _smsCode = '';
          break;
        }
      case 'remove':
        {
          if (_smsCode.isNotEmpty) {
            _smsCode = _smsCode.substring(0, _smsCode.length - 1);
          }
          break;
        }
      default:
        {
          if (widget.isVerifyCode) {
            if (_smsCode.length < 6) {
              _smsCode += val;
            }
          } else {
            _smsCode += val;
          }
        }
    }
    widget.onCallBack(_smsCode);
  }

  Widget _numberButton(int number) {
    return InkWell(
      onTap: () => _onUpdate(number.toString()),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Center(
          child: Text(
            number.toString(),
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(fontFamily: 'Roboto'),
          ),
        ),
      ),
    );
  }

  Widget _iconButton({bool plusIcon = false, bool emptyIcon = false}) {
    if (emptyIcon) {
      return const AspectRatio(
        aspectRatio: 1.0,
        child: SizedBox(),
      );
    }
    if (plusIcon) {
      return InkWell(
        onTap: () => _onUpdate('+'),
        child: const AspectRatio(
          aspectRatio: 1.0,
          child: Icon(Icons.add),
        ),
      );
    }
    return InkWell(
      onTap: () => _onUpdate('remove'),
      onLongPress: () => _onUpdate('remove_all'),
      child: const AspectRatio(
        aspectRatio: 1.0,
        child: Icon(Icons.backspace),
      ),
    );
  }

  Widget _buildButtons({List<Widget>? children}) {
    return Expanded(
      child: Row(
        children: List.generate(
            children!.length,
            (index) => Expanded(
                  child: children[index],
                )),
      ),
    );
  }

  @override
  void initState() {
    if (!widget.isVerifyCode && widget.phoneNumber != null) {
      _smsCode = widget.phoneNumber!;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildButtons(
          children: [
            _numberButton(1),
            _numberButton(2),
            _numberButton(3),
          ],
        ),
        _buildButtons(
          children: [
            _numberButton(4),
            _numberButton(5),
            _numberButton(6),
          ],
        ),
        _buildButtons(
          children: [
            _numberButton(7),
            _numberButton(8),
            _numberButton(9),
          ],
        ),
        _buildButtons(
          children: [
            _iconButton(plusIcon: true, emptyIcon: widget.isVerifyCode),
            _numberButton(0),
            _iconButton(),
          ],
        ),
      ],
    );
  }
}
