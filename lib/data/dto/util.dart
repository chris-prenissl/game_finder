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
    return value
        .whereType<Map<String, String>>()
        .map((Map<String, String> e) => e[mappedListKey])
        .whereType<String>().toList();
  }
}

extension IGDBImageUrlFormatter on String {
  String getFormattedImageUrl() {
    return "https:$this";
  }
}
