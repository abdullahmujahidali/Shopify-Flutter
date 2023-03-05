import 'dart:async';

import 'package:flutter/material.dart';

import '../../services/index.dart';
import '../entities/listing_location.dart';

class ListingLocationModel extends ChangeNotifier {
  List<ListingLocation> locations = [];
  bool isLoading = false;

  void getLocations() async {
    locations =
        await (Services().api.getLocations() as Future<List<ListingLocation>>);
    notifyListeners();
  }
}
