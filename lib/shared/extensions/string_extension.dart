extension StringToNumberParser on String {
  int? parseInt() {
    try {
      return int.parse(this);
    } catch (e) {
      // Return null if parsing fails
      return null;
    }
  }

  double? parseDouble() {
    try {
      return double.parse(this);
    } catch (_) {
      // Return null if parsing fails
      return null;
    }
  }
}
