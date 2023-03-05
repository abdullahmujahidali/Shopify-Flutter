import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dialog.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/config.dart';
import '../../../generated/l10n.dart';
import '../../../widgets/common/edit_product_info_widget.dart';
import '../model/vendor_on_boarding_model.dart';
import '../widgets/navigation_buttons.dart';

class VendorAddressInformation extends StatefulWidget {
  final Function(bool isPrev) onCallBack;
  const VendorAddressInformation({Key? key, required this.onCallBack})
      : super(key: key);

  @override
  State<VendorAddressInformation> createState() =>
      _VendorAddressInformationState();
}

class _VendorAddressInformationState extends State<VendorAddressInformation> {
  final _address1Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _postalController = TextEditingController();
  final bool _enable = true;

  Country? _selectedCountry;

  void _showMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).pleaseInputFillAllFields)));
  }

  void _onUpdate() {
    final isRequirementNotMet = _address1Controller.text.isEmpty ||
        _selectedCountry == null ||
        _cityController.text.isEmpty ||
        _stateController.text.isEmpty ||
        _postalController.text.isEmpty;
    if (isRequirementNotMet) {
      _showMessage();
      return;
    }
    final model = Provider.of<VendorOnBoardingModel>(context, listen: false);
    final data = {
      'address': _address1Controller.text,
      'country': _selectedCountry!.isoCode,
      'city': _cityController.text,
      'state': _stateController.text,
      'postal': _postalController.text,
    };
    model.updateAddress(data);
    widget.onCallBack(false);
  }

  @override
  void initState() {
    final model = Provider.of<VendorOnBoardingModel>(context, listen: false);
    _address1Controller.text = model.address;
    _cityController.text = model.city;
    _stateController.text = model.addressState;
    _postalController.text = model.postal;
    _selectedCountry = CountryPickerUtils.getCountryByIsoCode(
        kPaymentConfig.defaultCountryISOCode ?? 'US');
    super.initState();
  }

  void _openCountryPickerDialog() => showDialog(
        context: context,
        builder: (context) => Theme(
            data: Theme.of(context).copyWith(primaryColor: Colors.pink),
            child: CountryPickerDialog(
                titlePadding: const EdgeInsets.all(8.0),
                searchCursorColor: Colors.pinkAccent,
                searchInputDecoration:
                    InputDecoration(hintText: S.of(context).search),
                isSearchable: true,
                title: Text(S.of(context).country),
                onValuePicked: (Country country) => setState(() {
                      _selectedCountry = country;
                    }),
                itemBuilder: (country) {
                  return Row(
                    children: [
                      CountryPickerUtils.getDefaultFlagImage(country),
                      const SizedBox(
                        width: 8.0,
                      ),
                      Expanded(child: Text(country.name)),
                    ],
                  );
                })),
      );

  Widget _buildCountryWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 15,
            right: 15,
            top: 15,
          ),
          child: Text(
            S.of(context).country,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.start,
          ),
        ),
        const SizedBox(height: 5),
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            width: MediaQuery.of(context).size.width,
            height: 45.0,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.circular(9.0),
                border: Border.all(
                  width: 1.0,
                  color: Colors.black54,
                )),
            child: Row(
              children: [
                const SizedBox(
                  width: 10.0,
                ),
                if (_selectedCountry != null)
                  CountryPickerUtils.getDefaultFlagImage(_selectedCountry!),
                const SizedBox(
                  width: 20.0,
                ),
                Text(_selectedCountry?.name ?? ''),
                const Spacer(),
                const Icon(Icons.arrow_drop_down),
                const SizedBox(
                  width: 10.0,
                ),
              ],
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EditProductInfoWidget(
                    controller: _address1Controller,
                    label: S.of(context).address,
                    enable: _enable,
                  ),
                  EditProductInfoWidget(
                    controller: _cityController,
                    label: S.of(context).city,
                    enable: _enable,
                  ),
                  EditProductInfoWidget(
                    controller: _stateController,
                    label: S.of(context).stateProvince,
                    enable: _enable,
                  ),
                  InkWell(
                    onTap: _openCountryPickerDialog,
                    child: _buildCountryWidget(),
                  ),
                  EditProductInfoWidget(
                    controller: _postalController,
                    label: S.of(context).zipCode,
                    enable: _enable,
                  ),
                ],
              ),
            ),
          ),
          NavigationButtons(
            onBack: () {
              widget.onCallBack(true);
            },
            onNext: _onUpdate,
          ),
        ],
      ),
    );
  }
}
