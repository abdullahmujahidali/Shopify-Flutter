import 'package:country_code_picker/country_code.dart';
import 'package:country_code_picker/country_codes.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:inspireui/widgets/radio_button.dart';
import 'package:inspireui/widgets/skeleton_widget/skeleton_widget.dart';

import '../../widgets/common/index.dart';

mixin SelectCountryMixin<T extends StatefulWidget> on State<T> {
  late List<CountryCode> elements;
  final ValueNotifier<List<CountryCode>?> _countriesFilters =
      ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      elements = codes.map(CountryCode.fromJson).toList();
      elements = elements.map((e) => e.localize(context)).toList();
    });
  }

  Widget _buildSearchField() {
    return CustomTextField(
      showCancelIcon: true,
      decoration: const InputDecoration(hintText: 'Search'),
      onCancel: () {
        _countriesFilters.value = null;
      },
      onChanged: (String value) {
        EasyDebounce.debounce(
          'search-country',
          const Duration(milliseconds: 300),
          () {
            _countriesFilters.value = elements
                .where((CountryCode country) =>
                    (country.name ?? '')
                        .toLowerCase()
                        .contains(value.toLowerCase()) ||
                    (country.dialCode?.substring(1) ?? '')
                        .startsWith(value.toLowerCase()) ||
                    (country.code ?? '')
                        .toLowerCase()
                        .startsWith(value.toLowerCase()))
                .toList();
          },
        );
      },
    );
  }

  Future<CountryCode?> showModel([String? initCode]) async {
    _countriesFilters.value = null;
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.65,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            color: Colors.white,
          ),
          padding: const EdgeInsets.only(
            top: 8,
            bottom: 8,
            left: 16,
            right: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: const Color(0xFF555555).withOpacity(0.1),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(3.0),
                      child: Icon(Icons.close),
                    ),
                  ),
                ),
              ),
              _buildSearchField(),
              const SizedBox(height: 8),
              Expanded(
                child: ValueListenableBuilder<List<CountryCode>?>(
                    valueListenable: _countriesFilters,
                    builder: (context, countriesFilters, child) {
                      final data = countriesFilters ?? elements;
                      return ListView.separated(
                        itemCount: data.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 16),
                        itemBuilder: (context, i) {
                          final item = data[i];
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop(item);
                            },
                            child: Container(
                              key: ValueKey(item.code),
                              color: Colors.white,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          item.flagUri ?? '',
                                          width: 30,
                                          height: 20,
                                          fit: BoxFit.cover,
                                          package: 'country_code_picker',
                                          errorBuilder: (_, __, ___) {
                                            return const Skeleton(
                                              width: 24,
                                              height: 24,
                                            );
                                          },
                                        ),
                                        const SizedBox(width: 8.0),
                                        Flexible(
                                          child: Text(
                                            item.name ?? '',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8.0),
                                        Text(
                                          '(${item.dialCode ?? 'Unknown'})',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  RadioButton(
                                    radius: 14,
                                    isActive: initCode == null
                                        ? false
                                        : item.code == initCode,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),
              )
            ],
          ),
        );
      },
    );
  }
}
