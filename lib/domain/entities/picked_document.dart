class PickedDocument {
  const PickedDocument({
    required this.path,
    required this.name,
    required this.extension,
    this.sizeBytes,
  });

  final String path;
  final String name;
  final String extension;
  final int? sizeBytes;

  bool get isPdf => extension.toLowerCase() == 'pdf';
}
