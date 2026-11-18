/// Lightweight Info-dictionary extractor.
/// Keeps Phase 2 free of commercial PDF SDKs while remaining swappable.
class PdfInfoParser {
  const PdfInfoParser();

  Map<String, String> parseInfo(List<int> bytes) {
    final latin = String.fromCharCodes(bytes);
    final infoMatch = RegExp(r'/Info\s+(\d+)\s+(\d+)\s+R').firstMatch(latin);
    if (infoMatch == null) return const {};

    final objNum = infoMatch.group(1)!;
    final genNum = infoMatch.group(2)!;
    final objectPattern = RegExp(
      '$objNum\\s+$genNum\\s+obj(.*?)endobj',
      dotAll: true,
    );
    final objectMatch = objectPattern.firstMatch(latin);
    if (objectMatch == null) return const {};

    final body = objectMatch.group(1)!;
    final info = <String, String>{};
    for (final key in const [
      'Title',
      'Author',
      'Subject',
      'Keywords',
      'Creator',
      'Producer',
      'CreationDate',
      'ModDate',
    ]) {
      final value = _readString(body, key);
      if (value != null) {
        info[key] = value;
      }
    }
    return info;
  }

  String? _readString(String body, String key) {
    final hex = RegExp('/$key\\s*<([0-9A-Fa-f]+)>').firstMatch(body);
    if (hex != null) {
      return _decodeHex(hex.group(1)!);
    }

    final literal = RegExp('/$key\\s*\\(((?:\\\\.|[^\\\\)])*)\\)').firstMatch(body);
    if (literal != null) {
      return _unescapePdfString(literal.group(1)!);
    }

    return null;
  }

  String _unescapePdfString(String value) {
    return value
        .replaceAll(r'\n', '\n')
        .replaceAll(r'\r', '\r')
        .replaceAll(r'\t', '\t')
        .replaceAll(r'\(', '(')
        .replaceAll(r'\)', ')')
        .replaceAll(r'\\', r'\');
  }

  String _decodeHex(String hex) {
    final buffer = StringBuffer();
    final normalized = hex.length.isEven ? hex : '0$hex';
    for (var i = 0; i < normalized.length; i += 2) {
      buffer.writeCharCode(int.parse(normalized.substring(i, i + 2), radix: 16));
    }
    final raw = buffer.toString();
    if (raw.startsWith('\u00fe\u00ff')) {
      final units = <int>[];
      for (var i = 2; i + 1 < raw.length; i += 2) {
        units.add((raw.codeUnitAt(i) << 8) | raw.codeUnitAt(i + 1));
      }
      return String.fromCharCodes(units);
    }
    return raw;
  }

  DateTime? parsePdfDate(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final match = RegExp(
      r'D:(\d{4})(\d{2})?(\d{2})?(\d{2})?(\d{2})?(\d{2})?',
    ).firstMatch(raw);
    if (match == null) return null;

    try {
      return DateTime.utc(
        int.parse(match.group(1)!),
        int.parse(match.group(2) ?? '01'),
        int.parse(match.group(3) ?? '01'),
        int.parse(match.group(4) ?? '00'),
        int.parse(match.group(5) ?? '00'),
        int.parse(match.group(6) ?? '00'),
      );
    } catch (_) {
      return null;
    }
  }
}
