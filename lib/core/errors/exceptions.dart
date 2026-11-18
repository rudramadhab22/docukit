class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => message;
}

class FileException extends AppException {
  const FileException([super.message = 'File operation failed.']);
}

class UnsupportedOperationException extends AppException {
  const UnsupportedOperationException([
    super.message = 'This operation is not available yet.',
  ]);
}
