sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;
}

class AppAuthException extends AppException {
  const AppAuthException(super.message);
}

class NetworkException extends AppException {
  const NetworkException(super.message);
}

class ValidationException extends AppException {
  const ValidationException(super.message);
}
