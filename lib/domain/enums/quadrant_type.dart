enum QuadrantType { iu, inu, niu, ninu }

extension QuadrantTypeX on QuadrantType {
  String get keyName => name;

  static QuadrantType? tryParse(String? value) {
    if (value == null) {
      return null;
    }
    for (final item in QuadrantType.values) {
      if (item.name == value) {
        return item;
      }
    }
    return null;
  }
}
