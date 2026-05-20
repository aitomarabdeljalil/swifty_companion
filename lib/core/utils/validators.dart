class Validators {
  static String? login(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return 'Login is required.';
    }
    final regex = RegExp(r'^[a-zA-Z0-9_-]+$');
    if (!regex.hasMatch(trimmed)) {
      return 'Only letters, numbers, hyphens, and underscores are allowed.';
    }
    if (trimmed.length < 2) {
      return 'Login is too short.';
    }
    return null;
  }
}
