import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../core/errors/exceptions.dart';
import '../../domain/entities/picked_document.dart';

/// Low-level file I/O boundary.
abstract class FileLocalDataSource {
  Future<PickedDocument> pickSingle({required List<String> extensions});

  Future<List<PickedDocument>> pickMultiple({
    required List<String> extensions,
  });

  Future<String> outputPathFor(String fileName);
}

class FileLocalDataSourceImpl implements FileLocalDataSource {
  @override
  Future<PickedDocument> pickSingle({required List<String> extensions}) async {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: extensions,
    );

    if (file == null) {
      throw const CancelledException();
    }

    return _toDocument(file);
  }

  @override
  Future<List<PickedDocument>> pickMultiple({
    required List<String> extensions,
  }) async {
    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: extensions,
    );

    if (files.isEmpty) {
      throw const CancelledException();
    }

    final documents = <PickedDocument>[];
    for (final file in files) {
      documents.add(await _toDocument(file));
    }
    return documents;
  }

  @override
  Future<String> outputPathFor(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final outputDir = Directory(p.join(directory.path, 'docukit_output'));
    if (!await outputDir.exists()) {
      await outputDir.create(recursive: true);
    }
    return p.join(outputDir.path, fileName);
  }

  Future<PickedDocument> _toDocument(PlatformFile file) async {
    final localPath = await _ensureLocalPath(file);
    final size = await file.length() ?? File(localPath).lengthSync();

    return PickedDocument(
      path: localPath,
      name: file.name,
      extension: file.extension ?? p.extension(file.name).replaceFirst('.', ''),
      sizeBytes: size,
    );
  }

  /// pdfx and file IO need a filesystem path; content URIs are copied once.
  Future<String> _ensureLocalPath(PlatformFile file) async {
    final directPath = file.path;
    if (directPath != null && directPath.isNotEmpty) {
      return directPath;
    }

    final cacheDir = await getTemporaryDirectory();
    final target = File(
      p.join(cacheDir.path, 'docukit_imports', file.name),
    );
    await target.parent.create(recursive: true);
    await file.xFile.saveTo(target.path);
    return target.path;
  }
}
