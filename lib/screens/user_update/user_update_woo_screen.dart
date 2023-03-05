import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../common/tools.dart';
import '../../common/tools/flash.dart';
import '../../generated/l10n.dart';
import '../../models/entities/user.dart';
import '../../models/user_model.dart';
import '../../services/index.dart';
import '../../widgets/common/index.dart';
import 'user_update_model.dart';

class UserUpdateWooScreen extends StatefulWidget {
  @override
  State<UserUpdateWooScreen> createState() => _UserUpdateScreenState();
}

class _UserUpdateScreenState extends State<UserUpdateWooScreen> {
  String? avatar;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context, listen: false);
    return ChangeNotifierProvider<UserUpdateModel>(
      create: (_) => UserUpdateModel(user.user),
      lazy: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Consumer<UserUpdateModel>(
          builder: (_, model, __) => FloatingActionButton.extended(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9.0),
            ),
            materialTapTargetSize: MaterialTapTargetSize.padded,
            onPressed: () async {
              try {
                final result = await model.updateProfile();
                if (result == null) {
                  return FlashHelper.errorMessage(
                    context,
                    message: S.of(context).updateFailed,
                    duration: const Duration(seconds: 2),
                  );
                }
                unawaited(
                  FlashHelper.message(
                    context,
                    message: S.of(context).updateSuccess,
                    duration: const Duration(seconds: 2),
                  ),
                );
                user.user = User.fromAuthUser(
                  result as Map<String, dynamic>,
                  user.user!.cookie,
                );
                await user.setUser(user.user);
                if (mounted) {
                  final navigator = Navigator.of(context);
                  if (navigator.canPop()) {
                    navigator.pop();
                  }
                }
              } catch (e) {
                unawaited(
                  FlashHelper.errorMessage(
                    context,
                    message: '$e',
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            label: Text(
              S.of(context).update,
            ),
          ),
        ),
        body: GestureDetector(
          onTap: () {
            Tools.hideKeyboard(context);
          },
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Consumer<UserUpdateModel>(
                    builder: (_, model, __) => SizedBox(
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.height * 0.20,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.elliptical(100, 10),
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black12,
                                      offset: Offset(0, 2),
                                      blurRadius: 8)
                                ]),
                            child: model.avatar == null ||
                                    (model.avatar is String &&
                                        model.avatar.isEmpty)
                                ? const SizedBox()
                                : ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      bottom: Radius.elliptical(100, 10),
                                    ),
                                    child: ImageFiltered(
                                      imageFilter: ImageFilter.blur(
                                        sigmaX: 5,
                                        sigmaY: 5,
                                      ),
                                      child: (model.avatar is AssetEntity)
                                          ? AssetEntityImage(
                                              model.avatar,
                                              height: (MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.20)
                                                  .toDouble(),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width
                                                  .toDouble(),
                                              fit: BoxFit.cover,
                                            )
                                          : FluxImage(
                                              imageUrl: model.avatar,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(150),
                                color: Theme.of(context).primaryColorLight,
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.background,
                                  width: 3,
                                ),
                              ),
                              child: model.avatar == null ||
                                      (model.avatar is String &&
                                          model.avatar.isEmpty)
                                  ? const Icon(
                                      Icons.person,
                                      size: 120,
                                    )
                                  : (model.avatar is AssetEntity)
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(150),
                                          child: AssetEntityImage(model.avatar,
                                              width: 150,
                                              height: 150,
                                              fit: BoxFit.cover),
                                        )
                                      : Hero(
                                          tag: 'user-avatar-${model.avatar}',
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(150),
                                            child: FluxImage(
                                              imageUrl: model.avatar,
                                              fit: BoxFit.cover,
                                              width: 150,
                                              height: 150,
                                            ),
                                          ),
                                        ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              margin: const EdgeInsets.only(left: 75),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(150),
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.background,
                                  width: 2,
                                ),
                              ),
                              height: 40.0,
                              width: 40.0,
                              child: IconButton(
                                iconSize: 18.0,
                                onPressed: () => model.selectImage(context),
                                icon: Icon(
                                  Icons.camera_alt,
                                  color: Theme.of(context).colorScheme.background,
                                ),
                              ),
                            ),
                          ),
                          SafeArea(
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.only(left: 10),
                                child: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(height: 8),
                                Text(
                                    '${S.of(context).email} (or ${S.of(context).username})',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    )),
                                Consumer<UserUpdateModel>(
                                  builder: (_, model, __) => TextField(
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    controller: model.userEmail,
                                    enabled: false,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(S.of(context).displayName,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    )),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                          width: 1.5)),
                                  child: Consumer<UserUpdateModel>(
                                    builder: (_, model, __) => TextField(
                                      decoration: const InputDecoration(
                                          border: InputBorder.none),
                                      controller: model.userDisplayName,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(S.of(context).firstName,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    )),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                          width: 1.5)),
                                  child: Consumer<UserUpdateModel>(
                                    builder: (_, model, __) => TextField(
                                      decoration: const InputDecoration(
                                          border: InputBorder.none),
                                      controller: model.userFirstName,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(S.of(context).lastName,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    )),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                          width: 1.5)),
                                  child: Consumer<UserUpdateModel>(
                                    builder: (_, model, __) => TextField(
                                      decoration: const InputDecoration(
                                          border: InputBorder.none),
                                      controller: model.userLastName,
                                    ),
                                  ),
                                ),
                                if (!ServerConfig().isListingType) ...[
                                  const SizedBox(height: 16),
                                  Text(S.of(context).streetName,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      )),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Consumer<UserUpdateModel>(
                                      builder: (_, model, __) => TextField(
                                        decoration: const InputDecoration(
                                            border: InputBorder.none),
                                        controller: model.shippingAddress1,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(S.of(context).streetNameBlock,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      )),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Consumer<UserUpdateModel>(
                                      builder: (_, model, __) => TextField(
                                        decoration: const InputDecoration(
                                            border: InputBorder.none),
                                        controller: model.shippingAddress2,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(S.of(context).city,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      )),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Consumer<UserUpdateModel>(
                                      builder: (_, model, __) => TextField(
                                        decoration: const InputDecoration(
                                            border: InputBorder.none),
                                        controller: model.shippingCity,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(S.of(context).stateProvince,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      )),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Consumer<UserUpdateModel>(
                                      builder: (_, model, __) => TextField(
                                        decoration: const InputDecoration(
                                            border: InputBorder.none),
                                        controller: model.shippingState,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(S.of(context).country,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      )),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Consumer<UserUpdateModel>(
                                      builder: (_, model, __) => TextField(
                                        decoration: const InputDecoration(
                                            border: InputBorder.none),
                                        controller: model.shippingCountry,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(S.of(context).zipCode,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      )),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Consumer<UserUpdateModel>(
                                      builder: (_, model, __) => TextField(
                                        decoration: const InputDecoration(
                                            border: InputBorder.none),
                                        controller: model.shippingPostcode,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(S.of(context).streetNameApartment,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      )),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Consumer<UserUpdateModel>(
                                      builder: (_, model, __) => TextField(
                                        decoration: const InputDecoration(
                                            border: InputBorder.none),
                                        controller: model.shippingCompany,
                                      ),
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 50),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Consumer<UserUpdateModel>(
                builder: (_, model, __) =>
                    model.state == UserUpdateState.loading
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            color: Colors.black.withOpacity(0.5),
                            child: const Center(
                              child: SpinKitCircle(
                                color: Colors.white,
                                size: 20.0,
                              ),
                            ),
                          )
                        : const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
