abstract class ControlledException {
  String cause;

  @override
  String toString() {
    return this.cause;
  }
}

class ServiceException extends ControlledException implements Exception {
  final String cause;

  ServiceException(this.cause);
}

class AppException extends ControlledException implements Exception {
  final String cause;

  AppException(this.cause);
}

class ValidationException extends ControlledException implements Exception {
  final String cause;

  ValidationException(this.cause);
}
