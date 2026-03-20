import 'package:strain_guage_box/models/strain_gauge_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchNotifier extends ChangeNotifier {
  String searchQuery = '';

  void setSearchQuery(String query) {
    searchQuery = query;
    notifyListeners();
  }

  void clearSearchQuery() {
    searchQuery = '';
    notifyListeners();
  }

  List<StrainGaugeModel> filteredList(List<StrainGaugeModel> list) {
    if (searchQuery.isEmpty) {
      return list;
    } else {
      final query = searchQuery.toLowerCase();
      return list
          .where((item) =>
              item.instrumentName.toLowerCase().contains(query) ||
              item.manufacturer.toLowerCase().contains(query) ||
              item.testIdentifier.toLowerCase().contains(query) ||
              item.provenance.toLowerCase().contains(query) ||
              item.model.toLowerCase().contains(query) ||
              item.tags.any((tag) => tag.toLowerCase().contains(query)))
          .toList();
    }
  }
}

final searchProvider = ChangeNotifierProvider((ref) => SearchNotifier());
