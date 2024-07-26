extension ListStringParsing on Map<String, dynamic> {
  List<String> getMappedListForKeys(String key, String mappedListKey) {
    return [
      ...this[key]?.map((e) => e[mappedListKey].toString()).toList() ?? []
    ];
  }
}

extension IGDBImageUrlFormatter on String {
  String getFormattedImageUrl() {
    return "https:$this";
  }
}
