class Validators {
  static String? login(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return 'Login is required.';
    }
    if (trimmed.length < 2) {
      return 'Login is too short.';
    }
    return null;
  }
}
