extension StringExtensions on String {
  String get hardcoded => this;

  String capitalizeFirst() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
