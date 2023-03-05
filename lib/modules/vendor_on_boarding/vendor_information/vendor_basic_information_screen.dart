import 'dart:io' show File;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../common/extensions/extensions.dart';
import '../../../generated/l10n.dart';
import '../../../widgets/common/edit_product_info_widget.dart';
import '../model/vendor_on_boarding_model.dart';
import '../widgets/navigation_buttons.dart';

class VendorBasicInformation extends StatefulWidget {
  final Function(bool isPrev) onCallBack;

  const VendorBasicInformation({Key? key, required this.onCallBack})
      : super(key: key);

  @override
  State<VendorBasicInformation> createState() => _VendorBasicInformationState();
}

class _VendorBasicInformationState extends State<VendorBasicInformation> {
  final _storeNameController = TextEditingController();
  final _storeSlugController = TextEditingController();
  final _storePhoneController = TextEditingController();
  final _storeEmailController = TextEditingController();

  var _logo;
  var _banner;

  final ImagePicker imagePicker = ImagePicker();

  final bool _enable = true;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _onNext() {
    /// Fields that can't be empty
    final isRequirementNotMet = _storeNameController.text.isEmpty ||
        _storePhoneController.text.isEmpty ||
        _storeEmailController.text.isEmpty ||
        _storeSlugController.text.isEmpty;
    if (isRequirementNotMet) {
      _showMessage(S.of(context).pleaseInputFillAllFields);
      return;
    }
    if (!_storeEmailController.text.trim().isEmail) {
      _showMessage(S.of(context).errorEmailFormat);
      return;
    }

    const patttern = r'(^[0-9]{10,13}$)';
    final regExp = RegExp(patttern);
    if (!regExp.hasMatch(_storePhoneController.text)) {
      _showMessage(S.of(context).invalidPhoneNumber);
      return;
    }

    final model = Provider.of<VendorOnBoardingModel>(context, listen: false);
    final data = {
      'storeName': _storeNameController.text,
      'storeSlug': _storeSlugController.text,
      'storePhone': _storePhoneController.text,
      'storeEmail': _storeEmailController.text,
    };
    model.updateBasicInformation(data);
    widget.onCallBack(false);
  }

  Future<XFile?>? _takeImageFromCamera() async {
    return await imagePicker.pickImage(source: ImageSource.camera);
  }

  Future<XFile?>? _chooseImageFromGallery() async {
    return await imagePicker.pickImage(source: ImageSource.gallery);
  }

  void _showModalBottomSheet({isLogo = false}) {
    final model = Provider.of<VendorOnBoardingModel>(context, listen: false);
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => CupertinoActionSheet(
              actions: [
                CupertinoActionSheetAction(
                    onPressed: () async {
                      Navigator.pop(context);
                      var image = await _takeImageFromCamera();
                      isLogo ? _logo = image : _banner = image;
                      if (image != null) {
                        isLogo ? _logo = image : _banner = image;
                        isLogo
                            ? model.updateImages(logoImage: _logo)
                            : model.updateImages(bannerImage: _banner);
                        setState(() {});
                      }
                    },
                    child: Text(S.of(context).takePicture)),
                CupertinoActionSheetAction(
                    onPressed: () async {
                      Navigator.pop(context);
                      var image = await _chooseImageFromGallery();
                      if (image != null) {
                        isLogo ? _logo = image : _banner = image;
                        isLogo
                            ? model.updateImages(logoImage: _logo)
                            : model.updateImages(bannerImage: _banner);
                        setState(() {});
                      }
                    },
                    child: Text(S.of(context).chooseFromGallery)),
              ],
              cancelButton: CupertinoActionSheetAction(
                onPressed: () => Navigator.of(context).pop(),
                isDefaultAction: true,
                child: Text(S.of(context).cancel),
              ),
            ));
  }

  @override
  void initState() {
    final model = Provider.of<VendorOnBoardingModel>(context, listen: false);
    _storeNameController.text = model.storeName;
    _storeSlugController.text = model.storeSlug;
    _storePhoneController.text = model.storePhone;
    _storeEmailController.text = model.storeEmail;
    _logo = model.logo;
    _banner = model.banner;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: InkWell(
                          onTap: () => _showModalBottomSheet(isLogo: true),
                          child: Container(
                            height: 120,
                            width: 120,
                            margin: const EdgeInsets.only(top: 10.0),
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColorLight,
                                borderRadius: BorderRadius.circular(60.0)),
                            child: _logo != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(50.0),
                                    child: Image.file(
                                      File(_logo.path),
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        CupertinoIcons.plus,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      const SizedBox(height: 5),
                                      Text(S.of(context).storeLogo),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                      EditProductInfoWidget(
                        controller: _storeNameController,
                        label: S.of(context).shopName,
                        enable: _enable,
                      ),
                      EditProductInfoWidget(
                        controller: _storeSlugController,
                        label: S.of(context).shopSlug,
                        enable: _enable,
                      ),
                      EditProductInfoWidget(
                        controller: _storePhoneController,
                        label: S.of(context).phone,
                        enable: _enable,
                        keyboardType: TextInputType.phone,
                      ),
                      EditProductInfoWidget(
                        controller: _storeEmailController,
                        label: S.of(context).storeEmail,
                        enable: _enable,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 15,
                          right: 15,
                          top: 15,
                        ),
                        child: Text(
                          S.of(context).storeBanner,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: AspectRatio(
                          aspectRatio: 1.8,
                          child: InkWell(
                            onTap: _showModalBottomSheet,
                            child: _banner != null
                                ? Image.file(
                                    File(_banner.path),
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 15.0,
                                    ),
                                    decoration: BoxDecoration(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    child: Center(
                                        child: Icon(
                                      Icons.image,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary
                                          .withOpacity(0.5),
                                      size: 50,
                                    )),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 100.0,
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: NavigationButtons(
                    onNext: _onNext,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
