import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../../common/tools.dart';
import '../../../generated/l10n.dart';
import '../../../models/index.dart'
    show CartModel, PointModel, AppModel, Point, UserModel;

class PointReward extends StatefulWidget {
  // final CartModel model;
  const PointReward();

  @override
  State<PointReward> createState() => _PointRewardState();
}

class _PointRewardState extends State<PointReward> {
  int quantity = 0;
  bool applied = false;

  void applyPoints(Point? point) {
    if (point == null) {
      Tools.showSnackBar(
          ScaffoldMessenger.of(context), S.of(context).pointMsgConfigNotFound);
      return;
    } else if (quantity == 0) {
      Tools.showSnackBar(
          ScaffoldMessenger.of(context), S.of(context).pointMsgEnter);
      return;
    } else if (quantity > point.points!) {
      Tools.showSnackBar(ScaffoldMessenger.of(context),
          '${S.of(context).pointMsgNotEnough} : ${point.points!}');
      return;
    } else if (quantity > point.maxPointDiscount!) {
      Tools.showSnackBar(ScaffoldMessenger.of(context),
          '${S.of(context).pointMsgOverMaximumDiscountPoint}. ${S.of(context).pointMsgMaximumDiscountPoint} : ${point.maxPointDiscount!}');
      return;
    }
    if (!applied) {
      var totalBill = Provider.of<CartModel>(context, listen: false).getTotal();
      var total = quantity * point.cartPriceRate! / point.cartPointsRate!;
      if (total > totalBill!) {
        Tools.showSnackBar(
            ScaffoldMessenger.of(context), S.of(context).pointMsgOverTotalBill);
        return;
      }
      Provider.of<CartModel>(context, listen: false).setRewardTotal(total);
      Tools.showSnackBar(
          ScaffoldMessenger.of(context), S.of(context).pointMsgSuccess);
    } else {
      Provider.of<CartModel>(context, listen: false).setRewardTotal(0);
      setState(() {
        quantity = 0;
      });
      Tools.showSnackBar(
          ScaffoldMessenger.of(context), S.of(context).pointMsgRemove);
    }
    setState(() {
      applied = !applied;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currency = Provider.of<AppModel>(context).currency;
    final currencyRate = Provider.of<AppModel>(context).currencyRate;
    final pointModel = Provider.of<PointModel>(context);
    final userModel = Provider.of<UserModel>(context);

    return ListenableProvider.value(
        value: pointModel,
        child: Consumer<PointModel>(builder: (context, model, child) {
          if (model.point == null ||
              model.point!.points == 0 ||
              userModel.user == null ||
              userModel.user!.cookie == null) {
            return const SizedBox();
          }

          return Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(S.of(context).pointRewardMessage),
                const SizedBox(height: 5.0),
                Text(
                    '${PriceTools.getCurrencyFormatted(model.point!.cartPriceRate, currencyRate, currency: currency)} = ${model.point!.cartPointsRate} Points'),
                const SizedBox(height: 5.0),
                Text(
                  '${S.of(context).pointMsgMaximumDiscountPoint} : ${model.point?.maxPointDiscount}',
                ),
                const SizedBox(height: 5.0),
                Row(
                  children: [
                    PointSelection(
                      enabled: !applied,
                      limit: model.point!.points,
                      value: quantity,
                      onChanged: (val) {
                        setState(() {
                          quantity = val;
                        });
                      },
                    ),
                    const SizedBox(height: 10.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Theme.of(context).primaryColor,
                        backgroundColor: Colors.transparent,
                        elevation: 0.0,
                      ),
                      onPressed: () {
                        applyPoints(model.point);
                      },
                      child: Text(!applied
                          ? S.of(context).apply
                          : S.of(context).remove),
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
                Text(S.of(context).availablePoints(model.point!.points!)),
              ],
            ),
          );
        }));
  }
}

class PointSelection extends StatefulWidget {
  final int? limit;
  final int value;
  final bool? enabled;
  final Function? onChanged;

  const PointSelection(
      {required this.value, this.limit = 100, this.onChanged, this.enabled});

  @override
  State<PointSelection> createState() => _PointSelectionState();
}

class _PointSelectionState extends State<PointSelection> {
  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller!.text = '${widget.value}';
  }

  @override
  void didUpdateWidget(covariant PointSelection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value &&
        '${widget.value}' != _controller!.text) {
      _controller!.text = '${widget.value}';
      _controller!.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller!.text.length));
    }
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 44,
      decoration: BoxDecoration(
        color: !widget.enabled!
            ? Colors.black.withOpacity(0.05)
            : Colors.transparent,
        border: Border.all(width: 1.0, color: kGrey200),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: TextField(
          enabled: widget.enabled,
          controller: _controller,
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          onChanged: (text) {
            widget.onChanged!(int.parse(text));
          },
        ),
      ),
    );
  }
}
