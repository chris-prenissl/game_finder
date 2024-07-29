extension MapParsing on Map<String, dynamic> {
  String? getStringValue(String key) {
    final value = this[key];
    return value is String ? value : null;
  }

  String? getStringMapValue(String key, String mapKey) {
    final value = this[key];
    if (value is Map<String, dynamic>) {
      final mapValue = value[mapKey];
      if (mapValue is String) {
        return mapValue;
      }
    }
    return null;
  }

  List<String> getMappedStringListForKeys(String key, String mappedListKey) {
    final value = this[key];
    if (value == null || value is! Iterable) {
      return [];
    }
    final onlyMapType = value.whereType<Map<String, dynamic>>();
    final iterable = onlyMapType.map(( e) => e[mappedListKey]);
    final onlyStringIterable = iterable.whereType<String>();
    final stringList = onlyStringIterable.toList();
    return stringList;
  }
}

extension IGDBImageUrlFormatter on String {
  String getFormattedImageUrl() {
    return "https:$this";
  }
}
