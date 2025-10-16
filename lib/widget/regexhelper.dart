class RegexUtils {
  static String extractEmail(String text) {
    final match = RegExp(
      r"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}",
    ).firstMatch(text);
    return match?.group(0) ?? "Not Found";
  }

  static String extractPhone(String text) {
    final match = RegExp(r"(\+?\d{1,4}[\s-]?)?\d{10}").firstMatch(text);
    return match?.group(0) ?? "Not Found";
  }

  static String extractName(String text) {
    final lines = text.split('\n');
    return lines.isNotEmpty ? lines.first.trim() : "Not Found";
  }
}
