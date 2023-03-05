import 'package:collection/collection.dart' show IterableExtension;
import 'package:country_pickers/country.dart' as picker_country;
import 'package:country_pickers/country_pickers.dart' as picker;
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';

import '../../../common/config.dart';
import '../../../common/config/models/address_field_config.dart';
import '../../../common/constants.dart';
import '../../../common/tools/flash.dart';
import '../../../data/boxes.dart';
import '../../../generated/l10n.dart';
import '../../../models/index.dart'
    show Address, CartModel, City, Country, CountryState, UserModel;
import '../../../services/index.dart';
import '../../../widgets/common/common_safe_area.dart';
import '../../../widgets/common/flux_image.dart';
import '../../../widgets/common/place_picker.dart';
import '../choose_address_screen.dart';

part 'shipping_address_extension.dart';

class ShippingAddress extends StatefulWidget {
  final Function? onNext;

  const ShippingAddress({this.onNext});

  @override
  State<ShippingAddress> createState() => _ShippingAddressState();
}

class _ShippingAddressState extends State<ShippingAddress> {
  final _formKey = GlobalKey<FormState>();

  final Map<int, AddressFieldType> _fieldPosition = {};

  final Map<int, AddressFieldConfig> _configs = {};

  final Map<AddressFieldType, TextEditingController> _textControllers = {
    AddressFieldType.firstName: TextEditingController(),
    AddressFieldType.lastName: TextEditingController(),
    AddressFieldType.phoneNumber: TextEditingController(),
    AddressFieldType.email: TextEditingController(),
    AddressFieldType.country: TextEditingController(),
    AddressFieldType.state: TextEditingController(),
    AddressFieldType.city: TextEditingController(),
    AddressFieldType.apartment: TextEditingController(),
    AddressFieldType.block: TextEditingController(),
    AddressFieldType.street: TextEditingController(),
    AddressFieldType.zipCode: TextEditingController(),
  };

  final Map<AddressFieldType, FocusNode> _focusNodes = {
    AddressFieldType.firstName: FocusNode(),
    AddressFieldType.lastName: FocusNode(),
    AddressFieldType.phoneNumber: FocusNode(),
    AddressFieldType.email: FocusNode(),
    AddressFieldType.state: FocusNode(),
    AddressFieldType.city: FocusNode(),
    AddressFieldType.apartment: FocusNode(),
    AddressFieldType.block: FocusNode(),
    AddressFieldType.street: FocusNode(),
    AddressFieldType.zipCode: FocusNode(),
  };

  Address? address;
  List<Country>? countries = [];
  List<CountryState>? states = [];
  List<City>? cities = [];

  @override
  void dispose() {
    for (var controller in _textControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes.values) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    /// Init field positions.
    for (var config in Configurations.addressFields) {
      final index = _fieldPosition.values.length;
      _configs[index] = config;
      _fieldPosition[index] = config.type;
    }

    /// Pre-fill the address fields.
    WidgetsBinding.instance.endOfFrame.then(
      (_) async {
        /// Load saved addresses.
        final addressValue =
            await Provider.of<CartModel>(context, listen: false).getAddress();
        if (addressValue != null) {
          updateAddress(addressValue);
        } else {
          var user = Provider.of<UserModel>(context, listen: false).user;
          setState(() {
            address = Address(country: kPaymentConfig.defaultCountryISOCode);
            if (kPaymentConfig.defaultStateISOCode != null) {
              address!.state = kPaymentConfig.defaultStateISOCode;
            }
            _textControllers[AddressFieldType.country]?.text =
                address!.country!;
            _textControllers[AddressFieldType.state]?.text = address!.state!;
            if (user != null) {
              address!.firstName = user.firstName;
              address!.lastName = user.lastName;
              address!.email = user.email;
              loadUserInfoFromAddress(address);
            }
          });
        }

        /// Init default fields.
        for (var field in _configs.values) {
          if ([
            AddressFieldType.searchAddress,
            AddressFieldType.selectAddress,
            AddressFieldType.country,
            AddressFieldType.state,
          ].contains(field.type)) {
            /// Not support default value.
            continue;
          }

          /// Replace current value with default value.
          /// Force to use default value for non-editable field.
          if (field.defaultValue.isNotEmpty && !field.editable) {
            _textControllers[field.type]?.text = field.defaultValue;
            onTextFieldSaved(field.defaultValue, field.type);
          }

          /// When the field is editable, replacing only when it's empty.
          if (field.defaultValue.isNotEmpty &&
              field.editable &&
              (_textControllers[field.type]?.text.isEmpty ?? false)) {
            _textControllers[field.type]?.text = field.defaultValue;
            onTextFieldSaved(field.defaultValue, field.type);
          }
        }

        /// Load country list.
        countries = await Services().widget.loadCountries();
        var country = countries!.firstWhereOrNull((element) =>
            element.id == address?.country || element.code == address?.country);
        if (country == null) {
          if (countries!.isNotEmpty) {
            country = countries![0];
            address!.country = countries![0].code;
          } else {
            country = Country.fromConfig(address!.country, null, null, []);
          }
        } else {
          address!.country = country.code;
          address!.countryId = country.id;
        }
        _textControllers[AddressFieldType.country]?.text = country.code!;
        refresh();

        /// Load states.
        states = await Services().widget.loadStates(country);
        refresh();

        /// Load cities.
        var state = states?.firstWhereOrNull(
          (element) =>
              element.id == address?.state || element.code == address?.state,
        );
        if (state != null) {
          cities = await Services().widget.loadCities(country, state);
          var city = cities?.firstWhereOrNull(
            (element) => element.name == address?.city,
          );

          /// Load zipCode
          if (city != null) {
            var zipCode =
                await Services().widget.loadZipCode(country, state, city);
            if (zipCode != null) {
              /// Override the default value with this value
              address!.zipCode = zipCode;
              _textControllers[AddressFieldType.zipCode]?.text = zipCode;
            }
          }
          refresh();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var countryName = S.of(context).country;
    final currentCountry =
        _textControllers[AddressFieldType.country]?.text ?? '';
    if (currentCountry.isNotEmpty) {
      try {
        countryName =
            picker.CountryPickerUtils.getCountryByIsoCode(currentCountry).name;
      } catch (e) {
        countryName = S.of(context).country;
      }
    }

    if (address == null) {
      return SizedBox(height: 100, child: kLoadingWidget(context));
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: 50.0,
              ),
              child: Form(
                key: _formKey,
                child: AutofillGroup(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      _fieldPosition.length,
                      (index) {
                        final isVisible = _configs[index]?.visible ?? true;
                        if (!isVisible) {
                          return const SizedBox();
                        }

                        final currentFieldType =
                            _fieldPosition[index] ?? AddressFieldType.unknown;

                        if (currentFieldType == AddressFieldType.country) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                S.of(context).country,
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.grey),
                              ),
                              (countries!.length == 1)
                                  ? Text(
                                      picker.CountryPickerUtils
                                              .getCountryByIsoCode(
                                                  countries![0].code!)
                                          .name,
                                      style: const TextStyle(fontSize: 18),
                                    )
                                  : GestureDetector(
                                      onTap: _openCountryPickerDialog,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 20),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(countryName,
                                                      style: const TextStyle(
                                                          fontSize: 17.0)),
                                                ),
                                                const Icon(
                                                    Icons.arrow_drop_down)
                                              ],
                                            ),
                                          ),
                                          const Divider(
                                            height: 1,
                                            color: kGrey900,
                                          )
                                        ],
                                      ),
                                    ),
                            ],
                          );
                        }

                        if (currentFieldType == AddressFieldType.state &&
                            (states?.isNotEmpty ?? false)) {
                          return renderStateInput();
                        }

                        if (currentFieldType == AddressFieldType.city &&
                            (cities?.isNotEmpty ?? false)) {
                          return renderCityInput(index);
                        }

                        if (currentFieldType ==
                            AddressFieldType.searchAddress) {
                          if (kPaymentConfig.allowSearchingAddress &&
                              kGoogleApiKey.isNotEmpty) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ButtonTheme(
                                      height: 60,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          backgroundColor: Theme.of(context)
                                              .primaryColorLight,
                                          elevation: 0.0,
                                        ),
                                        onPressed: () async {
                                          final result =
                                              await Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => PlacePicker(
                                                kIsWeb
                                                    ? kGoogleApiKey.web
                                                    : isIos
                                                        ? kGoogleApiKey.ios
                                                        : kGoogleApiKey.android,
                                              ),
                                            ),
                                          );

                                          if (result is LocationResult) {
                                            address!.country = result.country;
                                            address!.street = result.street;
                                            address!.state = result.state;
                                            address!.city = result.city;
                                            address!.zipCode = result.zip;
                                            if (result.latLng?.latitude !=
                                                    null &&
                                                result.latLng?.latitude !=
                                                    null) {
                                              address!.mapUrl =
                                                  'https://maps.google.com/maps?q=${result.latLng?.latitude},${result.latLng?.longitude}&output=embed';
                                              address!.latitude = result
                                                  .latLng?.latitude
                                                  .toString();
                                              address!.longitude = result
                                                  .latLng?.longitude
                                                  .toString();
                                            }

                                            loadAddressFields(address);
                                            final c = Country(
                                                id: result.country,
                                                name: result.country);
                                            states = await Services()
                                                .widget
                                                .loadStates(c);
                                            setState(() {});
                                          }
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            const Icon(
                                              CupertinoIcons
                                                  .arrow_up_right_diamond,
                                              size: 18,
                                            ),
                                            const SizedBox(width: 10.0),
                                            Text(S
                                                .of(context)
                                                .searchingAddress
                                                .toUpperCase()),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return const SizedBox();
                        }

                        if (currentFieldType ==
                            AddressFieldType.selectAddress) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: ButtonTheme(
                              height: 60,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor:
                                      Theme.of(context).colorScheme.secondary,
                                  backgroundColor:
                                      Theme.of(context).primaryColorLight,
                                  elevation: 0.0,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ChooseAddressScreen(updateAddress),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const Icon(
                                      CupertinoIcons.person_crop_square,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 10.0),
                                    Text(
                                      S.of(context).selectAddress.toUpperCase(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }

                        final currentFieldController =
                            _textControllers[currentFieldType];
                        final currentFieldFocusNode =
                            _focusNodes[currentFieldType];

                        var hasNext = false;
                        var nextFieldIndex = index + 1;
                        late var nextFieldType;
                        late var nextFieldFocus;
                        while (nextFieldIndex < _fieldPosition.length) {
                          nextFieldType = _fieldPosition[nextFieldIndex];
                          nextFieldFocus = _focusNodes[nextFieldType];
                          if (nextFieldType == AddressFieldType.country ||
                              (nextFieldType == AddressFieldType.state &&
                                  (states?.isNotEmpty ?? false)) ||
                              (nextFieldType == AddressFieldType.city &&
                                  (cities?.isNotEmpty ?? false))) {
                            hasNext = false;
                            break;
                          }
                          if (nextFieldFocus != null) {
                            hasNext = true;
                            break;
                          }
                          nextFieldIndex++;
                        }

                        if (currentFieldType == AddressFieldType.phoneNumber &&
                            kPhoneNumberConfig.enablePhoneNumberValidation) {
                          return InternationalPhoneNumberInput(
                            /// Auto focus first field if it's empty.
                            autoFocus: index == 0 &&
                                (currentFieldController?.text.isEmpty ?? false),
                            textFieldController: currentFieldController,
                            focusNode: currentFieldFocusNode,
                            isReadOnly: isFieldReadOnly(index),
                            autofillHints: currentFieldType.autofillHint != null
                                ? ['${currentFieldType.autofillHint}']
                                : null,
                            inputDecoration: InputDecoration(
                              labelText: getFieldLabel(currentFieldType),
                            ),
                            keyboardType: getKeyboardType(currentFieldType),
                            keyboardAction: hasNext
                                ? TextInputAction.next
                                : TextInputAction.done,
                            onFieldSubmitted: (_) {
                              if (hasNext) {
                                nextFieldFocus?.requestFocus();
                              }
                            },
                            onSaved: (value) {
                              onTextFieldSaved(
                                value.phoneNumber,
                                currentFieldType,
                              );
                            },
                            onInputChanged: (PhoneNumber number) {},
                            onInputValidated: (value) => {},
                            spaceBetweenSelectorAndTextField: 0,
                            selectorConfig: SelectorConfig(
                              enable: kPhoneNumberConfig.useInternationalFormat,
                              showFlags: kPhoneNumberConfig.showCountryFlag,
                              selectorType: kPhoneNumberConfig.selectorType,
                              setSelectorButtonAsPrefixIcon:
                                  kPhoneNumberConfig.selectorFlagAsPrefixIcon,
                              leadingPadding: 0,
                              trailingSpace: false,
                            ),
                            selectorTextStyle:
                                Theme.of(context).textTheme.titleMedium,
                            ignoreBlank: !(_configs[index]?.required ?? true),
                            initialValue: PhoneNumber(
                              dialCode: kPhoneNumberConfig.dialCodeDefault,
                              isoCode: kPhoneNumberConfig.countryCodeDefault,
                              phoneNumber: currentFieldController?.text,
                            ),
                            formatInput: kPhoneNumberConfig.formatInput,
                            countries: kPhoneNumberConfig.customCountryList,
                          );
                        }

                        return TextFormField(
                          /// Auto focus first field if it's empty.
                          autofocus: index == 0 &&
                              (currentFieldController?.text.isEmpty ?? false),
                          autocorrect: false,
                          controller: currentFieldController,
                          focusNode: currentFieldFocusNode,
                          readOnly: isFieldReadOnly(index),
                          autofillHints: currentFieldType.autofillHint != null
                              ? ['${currentFieldType.autofillHint}']
                              : null,
                          decoration: InputDecoration(
                            labelText: getFieldLabel(currentFieldType),
                          ),
                          keyboardType: getKeyboardType(currentFieldType),
                          textCapitalization: TextCapitalization.words,
                          textInputAction: hasNext
                              ? TextInputAction.next
                              : TextInputAction.done,
                          validator: (val) {
                            final config = _configs[index];
                            if (config == null) {
                              return null;
                            }
                            return validateField(val, config, currentFieldType);
                          },
                          onFieldSubmitted: (_) {
                            if (hasNext) {
                              nextFieldFocus?.requestFocus();
                            }
                          },
                          onSaved: (value) => onTextFieldSaved(
                            value,
                            currentFieldType,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        _buildBottom(),
      ],
    );
  }

  void refresh() {
    if (mounted) {
      setState(() {});
    }
  }
}
