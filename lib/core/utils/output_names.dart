abstract final class OutputNames {
  static String stamp([String suffix = '']) {
    final now = DateTime.now();
    final value =
        '${now.year}${_two(now.month)}${_two(now.day)}_${_two(now.hour)}${_two(now.minute)}${_two(now.second)}';
    return suffix.isEmpty ? value : '${value}_$suffix';
  }

  static String _two(int value) => value.toString().padLeft(2, '0');
}
