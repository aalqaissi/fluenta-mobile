String formatBand(double? n) {
  if (n == null) return '–';
  return n == n.roundToDouble() ? '${n.toInt()}.0' : '$n';
}

String pad2(int n) => n.toString().padLeft(2, '0');

/// Rough IELTS band → CEFR level.
String cefrForBand(double band) {
  if (band >= 8.5) return 'C2';
  if (band >= 7) return 'C1';
  if (band >= 5.5) return 'B2';
  if (band >= 4) return 'B1';
  if (band >= 3) return 'A2';
  return 'A1';
}

String prettyDate(DateTime d) {
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return '${d.day} ${months[d.month - 1]} ${d.year}';
}

String longDate(DateTime d) {
  const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
  return '${days[d.weekday - 1]}, ${months[d.month - 1]} ${d.day}, ${d.year}';
}
