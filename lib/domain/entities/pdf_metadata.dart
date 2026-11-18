class PdfMetadata {
  const PdfMetadata({
    required this.fileName,
    required this.filePath,
    required this.sizeBytes,
    required this.pageCount,
    this.title,
    this.author,
    this.subject,
    this.keywords,
    this.creator,
    this.producer,
    this.createdAt,
    this.modifiedAt,
  });

  final String fileName;
  final String filePath;
  final int sizeBytes;
  final int pageCount;
  final String? title;
  final String? author;
  final String? subject;
  final String? keywords;
  final String? creator;
  final String? producer;
  final DateTime? createdAt;
  final DateTime? modifiedAt;

  List<PdfMetadataEntry> get entries => [
        PdfMetadataEntry('File name', fileName),
        PdfMetadataEntry('Path', filePath),
        PdfMetadataEntry('Size', _formatBytes(sizeBytes)),
        PdfMetadataEntry('Pages', '$pageCount'),
        if (_has(title)) PdfMetadataEntry('Title', title!),
        if (_has(author)) PdfMetadataEntry('Author', author!),
        if (_has(subject)) PdfMetadataEntry('Subject', subject!),
        if (_has(keywords)) PdfMetadataEntry('Keywords', keywords!),
        if (_has(creator)) PdfMetadataEntry('Creator', creator!),
        if (_has(producer)) PdfMetadataEntry('Producer', producer!),
        if (createdAt != null)
          PdfMetadataEntry('Created', createdAt!.toLocal().toString()),
        if (modifiedAt != null)
          PdfMetadataEntry('Modified', modifiedAt!.toLocal().toString()),
      ];

  static bool _has(String? value) => value != null && value.trim().isNotEmpty;

  static String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    final kb = bytes / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(1)} KB';
    final mb = kb / 1024;
    return '${mb.toStringAsFixed(2)} MB';
  }
}

class PdfMetadataEntry {
  const PdfMetadataEntry(this.label, this.value);

  final String label;
  final String value;
}
