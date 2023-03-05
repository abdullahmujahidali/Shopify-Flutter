import 'dart:async';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../../common/tools/flash.dart';
import '../../../generated/l10n.dart';
import '../../../models/index.dart';
import '../../../models/tera_wallet/wallet_transfer_model.dart';
import '../../../widgets/common/custom_text_field.dart';
import '../../../widgets/common/loading_body.dart';
import '../helpers/currency_text_input_formatter.dart';
import '../helpers/wallet_helpers.dart';
import 'transfer_fail_screen.dart';

class TransferArguments {
  final String email;

  const TransferArguments({required this.email});
}

class TransferScreen extends StatefulWidget {
  const TransferScreen({
    Key? key,
    this.email,
  }) : super(key: key);

  final String? email;

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _emailFocusNode = FocusNode();
  final _numberFocusNode = FocusNode();
  final _noteFocusNode = FocusNode();

  final _emailTextController = TextEditingController();
  final _numberTextController = TextEditingController();
  final _noteTextController = TextEditingController();
  final _ownerTextController = TextEditingController();

  late User user;
  late final TextInputFormatter _textFormat;

  NumberFormat get _numberFormat => WalletHelpers.numberFormat;

  @override
  void initState() {
    // _emailTextController.addListener(_resetName);
    super.initState();
    _emailTextController.text = widget.email ?? '';
    _emailFocusNode.addListener(_onUnFocusEmailField);
    _textFormat = CurrencyTextInputFormatter(
      decimalDigits: 0,
      name: _numberFormat.currencyName,
      locale: _numberFormat.locale,
      symbol: _numberFormat.currencySymbol,
    );
    WidgetsBinding.instance.endOfFrame.then((_) {
      if (mounted) {
        Future.delayed(const Duration(milliseconds: 200), () {
          if (_emailTextController.text.isNotEmpty) {
            _numberFocusNode.requestFocus();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _emailFocusNode.removeListener(_onUnFocusEmailField);
    _emailFocusNode.dispose();
    _numberFocusNode.dispose();
    _emailTextController.dispose();
    _numberTextController.dispose();
    FlashHelper.dispose();
    super.dispose();
  }

  WalletTransferModel get _walletTransferModel =>
      context.read<WalletTransferModel>();

  @override
  Widget build(BuildContext context) {
    FlashHelper.init(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0.0,
        title: Text(
          S.of(context).transfer,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: LoadingBody(
        isLoading: context
            .select<WalletTransferModel, bool>((value) => value.isLoading),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomTextField(
                        focusNode: _emailFocusNode,
                        autofocus: true,
                        showCancelIcon: true,
                        onCancel: () {
                          FocusScope.of(context).requestFocus(_emailFocusNode);
                          _resetName();
                        },
                        onChanged: (_) => _resetName(),
                        autofillHints: const [AutofillHints.email],
                        autocorrect: false,
                        nextNode: _numberFocusNode,
                        controller: _emailTextController,
                        onSubmitted: _onCheckValidEmail,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Send to',
                        ),
                      ),
                      ChangeNotifierProvider.value(
                        value: _ownerTextController,
                        builder: (context, child) {
                          return Selector<TextEditingController, String>(
                            selector: (_, textController) =>
                                textController.text,
                            builder: (context, ownerName, child) {
                              if (ownerName.isEmpty) {
                                return const SizedBox();
                              }
                              return Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: TextField(
                                  controller: _ownerTextController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    labelText: S.of(context).name,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 20.0),
                      Selector<WalletTransferModel, bool?>(
                          selector: (_, model) => model.isValidAmount,
                          builder: (context, isValid, child) {
                            final errorMessage = isValid == null
                                ? null
                                : !isValid
                                    ? 'You only have ${WalletHelpers.parseNumberToCurrencyText(_walletTransferModel.currentBalance)} left in your wallet'
                                    : null;
                            return CustomTextField(
                              focusNode: _numberFocusNode,
                              showCancelIcon: true,
                              nextNode: _noteFocusNode,
                              controller: _numberTextController,
                              onChanged: (String numberText) =>
                                  EasyDebounce.debounce(
                                'numberChange',
                                const Duration(milliseconds: 150),
                                () => _checkValidAmount(numberText),
                              ),
                              onCancel: _walletTransferModel.markAmountNotValid,
                              maxLength:
                                  11 + _numberFormat.currencySymbol.length,
                              keyboardType: TextInputType.number,
                              inputFormatters: [_textFormat],
                              decoration: InputDecoration(
                                labelText: S.of(context).amount,
                                counterText: '',
                                contentPadding: EdgeInsets.zero,
                                helperText: errorMessage,
                                helperStyle: TextStyle(
                                    color: Theme.of(context).colorScheme.error),
                              ),
                            );
                          }),
                      const SizedBox(height: 20.0),
                      CustomTextField(
                        focusNode: _noteFocusNode,
                        autocorrect: false,
                        showCancelIcon: true,
                        maxLength: 50,
                        maxLines: 1,
                        minLines: 1,
                        controller: _noteTextController,
                        decoration: InputDecoration(
                          labelText: S.of(context).noteTransfer,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Consumer<WalletTransferModel>(
                  builder: (context, model, child) {
                    final canSubmit =
                        (model.isValidAmount ?? false) && model.isValidEmail;
                    return ElevatedButton(
                      onPressed:
                          canSubmit ? _onBottomSheetConfirmTransfer : null,
                      child: Text(
                        S.of(context).next.toUpperCase(),
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    );
                  },
                  // ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onUnFocusEmailField() {
    if (!_emailFocusNode.hasFocus && _emailTextController.text.isNotEmpty) {
      _onCheckValidEmail(_emailTextController.text);
    }
  }

  Future<void> _onCheckValidEmail(String email) async {
    if (_walletTransferModel.isLoading) return;
    try {
      user = await _walletTransferModel.checkValidEmail(email);
      final loggedInUser = context.read<UserModel>().user;
      final isMe = loggedInUser != null && loggedInUser.id == user.id;
      if (isMe) {
        throw S.of(context).transferErrorMessage;
      }
      _ownerTextController.text = user.fullName;
    } catch (e) {
      unawaited(FlashHelper.errorBar(
        context,
        message: e.toString(),
      ));
      Future.delayed(
        const Duration(milliseconds: 100),
        () => FocusScope.of(context).requestFocus(_emailFocusNode),
      );
      return;
    }
  }

  void _checkValidAmount(String numberText) {
    final amount = WalletHelpers.parseSymbolNumberToNumber(numberText);
    _walletTransferModel.checkValidAmount(amount.toInt());
  }

  void _onBottomSheetConfirmTransfer() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      builder: (bottomSheetContext) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(child: CloseButton()),
                      Expanded(
                        flex: 8,
                        child: Text(
                          S.of(context).transferConfirm,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).primaryTextTheme.titleLarge,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 16),
                        Text(
                          _numberTextController.text,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Transfer money to ${user.fullName}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.creditcard_fill,
                              size: 50,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'TeraWallet',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Balance: ${WalletHelpers.parseNumberToCurrencyText(_walletTransferModel.currentBalance)}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 16,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(bottomSheetContext).pop();
                    _onTransfer();
                  },
                  child: Text(
                    S.of(context).transfer.toUpperCase(),
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  void _onTransfer() async {
    try {
      final amount =
          WalletHelpers.parseSymbolNumberToNumber(_numberTextController.text);

      await _walletTransferModel.transfer(
        email: _emailTextController.text,
        amount: amount.toInt(),
        note: _noteTextController.text,
      );

      unawaited(_walletTransferModel.refreshWallet());

      await Navigator.of(context)
          .pushReplacementNamed(RouteList.teraWalletTransferSuccess);
    } catch (e) {
      await Navigator.of(context).pushReplacementNamed(
        RouteList.teraWalletTransferFail,
        arguments: TransferFailArguments(errorMessage: e.toString()),
      );
    }
  }

  void _resetName() {
    if (_ownerTextController.text.isNotEmpty) {
      _ownerTextController.text = '';
    }
    _walletTransferModel.markEmailNotValid();
  }
}
