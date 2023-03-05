import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../generated/l10n.dart';
import '../../models/entities/vacation_settings.dart';
import 'store_open_option_model.dart';
import 'widgets/store_vacation_checkbox.dart';
import 'widgets/store_vacation_type.dart';

class StoreOpenOptionIndex extends StatelessWidget {
  final bool isFromMV;
  final String userId;
  final String cookie;
  const StoreOpenOptionIndex(
      {Key? key,
      this.isFromMV = true,
      required this.userId,
      required this.cookie})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StoreOpenOptionModel(userId, cookie),
      child: const StoreOpenOption(
        key: Key('StoreOpenOptionIndex'),
      ),
    );
  }
}

class StoreOpenOption extends StatefulWidget {
  final bool isFromMV;
  const StoreOpenOption({Key? key, this.isFromMV = true}) : super(key: key);

  @override
  State<StoreOpenOption> createState() => _StoreOpenOptionState();
}

class _StoreOpenOptionState extends State<StoreOpenOption> {
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final titleTheme = Theme.of(context)
        .textTheme
        .titleMedium!
        .copyWith(fontWeight: FontWeight.w500, fontFamily: 'Roboto');
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
              iconTheme: Theme.of(context).iconTheme,
              backgroundColor: Theme.of(context).colorScheme.background,
              centerTitle: true,
              title: Text(
                S.of(context).storeVacation.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.w600),
              )),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer<StoreOpenOptionModel>(
                    builder: (_, model, __) => StoreVacationCheckbox(
                        key: UniqueKey(),
                        title: S.of(context).enableVacationMode,
                        value: model.vacationSettings?.vacationMode ?? false,
                        onCallBack: (val) => model.update(vacationMode: val)),
                  ),
                  Consumer<StoreOpenOptionModel>(
                    builder: (_, model, __) => StoreVacationCheckbox(
                        key: UniqueKey(),
                        title: S.of(context).disablePurchase,
                        value:
                            model.vacationSettings?.disableVacationPurchase ??
                                false,
                        onCallBack: (val) =>
                            model.update(disablePurchase: val)),
                  ),
                  Consumer<StoreOpenOptionModel>(
                    builder: (_, model, __) => StoreVacationType(
                      key: UniqueKey(),
                      onCallBack: (val) {
                        if (val is VacationOption) {
                          model.vacationSettings!.vacationOption = val;
                          return;
                        }
                        if (val is List) {
                          if (val.isNotEmpty) {
                            model.vacationSettings!.startDate = val.first;
                            model.vacationSettings!.endDate = val.last;
                          } else {
                            model.vacationSettings!.startDate = null;
                            model.vacationSettings!.endDate = null;
                          }
                        }
                      },
                      option: model.vacationSettings?.vacationOption ??
                          VacationOption.instant,
                      startDate: model.vacationSettings?.startDate,
                      endDate: model.vacationSettings?.endDate,
                    ),
                  ),
                  Text(
                    S.of(context).vacationMessage,
                    style: titleTheme,
                  ),
                  Consumer<StoreOpenOptionModel>(builder: (_, model, __) {
                    _controller.text = model.vacationSettings?.message ?? '';
                    return TextField(
                      controller: _controller,
                      onChanged: (val) {
                        Provider.of<StoreOpenOptionModel>(context,
                                listen: false)
                            .update(msg: val);
                      },
                      maxLines: null,
                    );
                  }),
                  Center(
                    child: TextButton(
                        onPressed: () async {
                          final result =
                              await Provider.of<StoreOpenOptionModel>(context,
                                      listen: false)
                                  .apply();
                          var msg = S.of(context).updateSuccess;
                          if (!result) {
                            msg = S.of(context).updateFailed;
                          }
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(msg),
                            duration: const Duration(seconds: 1),
                          ));
                        },
                        child: Text(S.of(context).apply)),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ),
        ),
        Consumer<StoreOpenOptionModel>(
          builder: (_, model, __) {
            if (model.state == StoreOpenOptionState.loading) {
              final size = MediaQuery.of(context).size;
              return Container(
                width: size.width,
                height: size.height,
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 1.0,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }
}
