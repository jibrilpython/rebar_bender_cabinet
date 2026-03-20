import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rebar_bender_cabinet/models/rebar_tool_model.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Search Provider — filters the collection list
// ─────────────────────────────────────────────────────────────────────────────

class SearchNotifier extends ChangeNotifier {
  String _query = '';

  String get query => _query;

  void setQuery(String value) {
    _query = value.toLowerCase().trim();
    notifyListeners();
  }

  void clear() {
    _query = '';
    notifyListeners();
  }

  List<RebarToolModel> filter(List<RebarToolModel> items) {
    if (_query.isEmpty) return items;

    return items.where((item) {
      final q = _query;
      return (item.toolName?.toLowerCase().contains(q) ?? false) ||
          (item.manufacturer?.toLowerCase().contains(q) ?? false) ||
          (item.catalogueIdentifier?.toLowerCase().contains(q) ?? false) ||
          (item.eraOfProduction?.toLowerCase().contains(q) ?? false) ||
          (item.countryOfOrigin?.toLowerCase().contains(q) ?? false) ||
          (item.toolType?.displayName.toLowerCase().contains(q) ?? false) ||
          (item.tags?.toLowerCase().contains(q) ?? false) ||
          (item.notes?.toLowerCase().contains(q) ?? false);
    }).toList();
  }
}

final searchProvider = ChangeNotifierProvider<SearchNotifier>((ref) {
  return SearchNotifier();
});
