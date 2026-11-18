sealed class Failure {
  const Failure(this.message);

  final String message;
}

final class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'Something went wrong.']);
}

final class FileFailure extends Failure {
  const FileFailure([super.message = 'File operation failed.']);
}

final class UnsupportedOperationFailure extends Failure {
  const UnsupportedOperationFailure([
    super.message = 'This operation is not available yet.',
  ]);
}

final class AuthorizationFailure extends Failure {
  const AuthorizationFailure([
    super.message = 'Authorized credentials are required.',
  ]);
}
