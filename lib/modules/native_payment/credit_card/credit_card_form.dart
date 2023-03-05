import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart';
import '../../../../models/index.dart' show CreditCard;
import '../../../../screens/index.dart' show BaseScreen;
import 'credit_card_widget.dart';

class CreditCardForm extends StatefulWidget {
  const CreditCardForm(
      {Key? key,
      this.cardNumber,
      this.expiryDate,
      this.cardHolderName,
      this.cvvCode,
      required this.onCreditCardModelChange,
      this.themeColor,
      this.textColor = Colors.black,
      this.cursorColor,
      this.padding})
      : super(key: key);

  final String? cardNumber;
  final String? expiryDate;
  final String? cardHolderName;
  final String? cvvCode;
  final void Function(CreditCard?) onCreditCardModelChange;
  final Color? themeColor;
  final Color? textColor;
  final Color? cursorColor;
  final EdgeInsetsGeometry? padding;

  @override
  BaseScreen<CreditCardForm> createState() => _CreditCardFormState();
}

class _CreditCardFormState extends BaseScreen<CreditCardForm> {
  String? cardNumber;
  String? expiryDate;
  String? cardHolderName;
  String? cvvCode;
  bool isCvvFocused = false;
  Color? themeColor;
  Color? textColor;

  late void Function(CreditCard?) onCreditCardModelChange;
  CreditCard? creditCardModel;

  final MaskedTextController _cardNumberController =
      MaskedTextController(mask: '0000 0000 0000 0000');
  final TextEditingController _expiryDateController =
      MaskedTextController(mask: '00/00');
  final TextEditingController _cardHolderNameController =
      TextEditingController();
  final TextEditingController _cvvCodeController =
      MaskedTextController(mask: '0000');

  FocusNode cvvFocusNode = FocusNode();

  void textFieldFocusDidChange() {
    creditCardModel!.isCvvFocused = cvvFocusNode.hasFocus;
    onCreditCardModelChange(creditCardModel);
  }

  void createCreditCardModel() {
    cardNumber = widget.cardNumber ?? '';
    expiryDate = widget.expiryDate ?? '';
    cardHolderName = widget.cardHolderName ?? '';
    cvvCode = widget.cvvCode ?? '';

    creditCardModel = CreditCard(
      cardNumber: cardNumber,
      expiryDate: expiryDate,
      cardHolderName: cardHolderName,
      cvv: cvvCode,
      isCvvFocused: isCvvFocused,
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    themeColor = widget.themeColor ?? Theme.of(context).primaryColor;
    textColor =
        widget.textColor ?? Theme.of(context).textTheme.bodyMedium!.color;
  }

  @override
  void initState() {
    super.initState();

    createCreditCardModel();

    onCreditCardModelChange = widget.onCreditCardModelChange;

    cvvFocusNode.addListener(textFieldFocusDidChange);

    _cardNumberController.addListener(_cardNumberListener);
    _expiryDateController.addListener(_expiryDateListener);
    _cardHolderNameController.addListener(_cardHolderNameListener);
    _cvvCodeController.addListener(_cvvCodeListener);
  }

  @override
  void dispose() {
    cvvFocusNode.removeListener(textFieldFocusDidChange);
    _cardHolderNameController.removeListener(_cardHolderNameListener);
    _cardNumberController.removeListener(_cardNumberListener);
    _expiryDateController.removeListener(_expiryDateListener);
    _cvvCodeController.removeListener(_cvvCodeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16.0),
      child: Form(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(top: 16),
              child: TextFormField(
                controller: _cardNumberController,
                cursorColor: widget.cursorColor ?? themeColor,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: S.of(context).cardNumber,
                  hintText: 'xxxx xxxx xxxx xxxx',
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(top: 8),
              child: TextFormField(
                controller: _expiryDateController,
                cursorColor: widget.cursorColor ?? themeColor,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: S.of(context).expiredDate,
                  hintText: S.of(context).expiredDateHint,
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(top: 8),
              child: TextField(
                focusNode: cvvFocusNode,
                controller: _cvvCodeController,
                cursorColor: widget.cursorColor ?? themeColor,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: S.of(context).cvv,
                  hintText: 'XXX',
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onChanged: (String text) {
                  setState(() {
                    cvvCode = text;
                  });
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(top: 8),
              child: TextFormField(
                controller: _cardHolderNameController,
                cursorColor: widget.cursorColor ?? themeColor,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: S.of(context).cardHolder,
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _cardNumberListener() {
    setState(() {
      cardNumber = _cardNumberController.text;
      creditCardModel!.cardNumber = cardNumber;
      onCreditCardModelChange(creditCardModel);
    });
  }

  void _expiryDateListener() {
    setState(() {
      expiryDate = _expiryDateController.text;
      creditCardModel!.expiryDate = expiryDate;
      onCreditCardModelChange(creditCardModel);
    });
  }

  void _cardHolderNameListener() {
    setState(() {
      cardHolderName = _cardHolderNameController.text;
      creditCardModel!.cardHolderName = cardHolderName;
      onCreditCardModelChange(creditCardModel);
    });
  }

  void _cvvCodeListener() {
    setState(() {
      cvvCode = _cvvCodeController.text;
      creditCardModel!.cvv = cvvCode;
      onCreditCardModelChange(creditCardModel);
    });
  }
}
