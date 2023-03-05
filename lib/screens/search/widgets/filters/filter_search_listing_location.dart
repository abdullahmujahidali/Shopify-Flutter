import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/config.dart';
import '../../../../models/entities/listing_location.dart';
import '../../../../models/index.dart' show CategoryModel;
import '../../../../models/listing/listing_location_model.dart';

class FilterSearchListingLocation extends StatefulWidget {
  final Function(List<ListingLocation>, String)? onSelect;
  final List<ListingLocation>? listSelected;

  const FilterSearchListingLocation({
    this.onSelect,
    this.listSelected,
  });

  @override
  State<FilterSearchListingLocation> createState() =>
      _FilterSearchListingLocationState();
}

class _FilterSearchListingLocationState
    extends State<FilterSearchListingLocation> {
  List<ListingLocation> _listSelect = [];

  bool checkAttributeSelected(String? name) {
    return _listSelect.any((element) => name == element.name);
  }

  void _onTapCategory(ListingLocation listingLocation) {
    var isFound = checkAttributeSelected(listingLocation.name);

    _listSelect.clear();
    if (!isFound) {
      _listSelect.add(listingLocation);
    }

    widget.onSelect!(_listSelect, 'listingLocation');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _listSelect = widget.listSelected!.toList();
  }

  @override
  Widget build(BuildContext context) {
    var categories = Provider.of<CategoryModel>(context);

    Color getColorSelectTextButton(bool isSelected) =>
        isSelected ? Colors.white : Theme.of(context).colorScheme.secondary;

    Color getColorSelectBackgroundButton(bool isSelected) => isSelected
        ? Theme.of(context).primaryColor
        : Theme.of(context).primaryColorLight;

    return ListenableProvider.value(
      value: categories,
      child: Consumer<ListingLocationModel>(builder: (context, value, child) {
        if (value.isLoading) {
          return Center(child: kLoadingWidget(context));
        }
        return SizedBox(
          height: 80,
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(width: 30),
                  ...List.generate(
                    value.locations.length,
                    (int index) {
                      return GestureDetector(
                        onTap: () {
                          _onTapCategory(value.locations[index]);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 15),
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            color: getColorSelectBackgroundButton(
                              checkAttributeSelected(
                                value.locations[index].name,
                              ),
                            ),
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                          child: Text(
                            value.locations[index].name.toString(),
                            style: TextStyle(
                              fontSize: 17,
                              color: getColorSelectTextButton(
                                checkAttributeSelected(
                                  value.locations[index].name,
                                ),
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
