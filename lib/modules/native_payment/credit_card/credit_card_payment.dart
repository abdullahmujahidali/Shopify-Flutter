import 'dart:core';

import 'package:awesome_card/awesome_card.dart';
import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import 'services.dart';

class CreditCardPayment extends StatefulWidget {
  final Map<String, dynamic>? params;
  final Function? onFinish;

  const CreditCardPayment({this.params, this.onFinish});

  @override
  State<StatefulWidget> createState() {
    return CreditCardPaymentState();
  }
}

class CreditCardPaymentState extends State<CreditCardPayment> {
  CreditCardServices services = CreditCardServices();
  String cardNumber = '';
  String cardHolderName = '';
  String expiryDate = '';
  String cvv = '';
  bool showBack = false;

  late final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_focusListener);
  }

  void _focusListener() {
    if (!mounted) {
      return;
    }
    _focusNode.hasFocus ? showBack = true : showBack = false;
    setState(() {});
  }

  @override
  void dispose() {
    _focusNode.removeListener(_focusListener);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: GestureDetector(
          onTap: () {
            widget.onFinish!(null);
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(S.of(context).payment),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 40,
            ),
            CreditCard(
              cardNumber: cardNumber,
              cardExpiry: expiryDate,
              cardHolderName: cardHolderName,
              cvv: cvv,
              bankName: 'Visa Card',
              showBackSide: showBack,
              frontBackground: CardBackgrounds.black,
              backBackground: CardBackgrounds.white,
              showShadow: true,
            ),
            const SizedBox(
              height: 40,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: TextFormField(
                    decoration: const InputDecoration(hintText: 'Card Number'),
                    maxLength: 16,
                    onChanged: (value) {
                      setState(() {
                        cardNumber = value;
                      });
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: TextFormField(
                    decoration: const InputDecoration(hintText: 'Card Expiry'),
                    maxLength: 5,
                    onChanged: (value) {
                      setState(() {
                        expiryDate = value;
                      });
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: TextFormField(
                    decoration:
                        const InputDecoration(hintText: 'Card Holder Name'),
                    onChanged: (value) {
                      setState(() {
                        cardHolderName = value;
                      });
                    },
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                  child: TextFormField(
                    decoration: const InputDecoration(hintText: 'CVV'),
                    maxLength: 3,
                    onChanged: (value) {
                      setState(() {
                        cvv = value;
                      });
                    },
                    focusNode: _focusNode,
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: screenSize.width,
                  child: SizedBox(
                    width: screenSize.width /
                        (2 / (screenSize.height / screenSize.width)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: ButtonTheme(
                              height: 45,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  elevation: 0.1,
                                ),
                                onPressed: () => services.executePayment(
                                    context,
                                    cardNumber,
                                    cardHolderName,
                                    expiryDate,
                                    cvv),
                                child:
                                    Text(S.of(context).checkout.toUpperCase()),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
