class ApiException implements Exception {
  final String message;
  final int statusCode;
  ApiException(this.message, this.statusCode);
  @override
  String toString() => message;
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(String message) : super(message, 401);
}

class NotFoundException extends ApiException {
  NotFoundException(String message) : super(message, 404);
}

class NetworkException extends ApiException {
  NetworkException(String message) : super(message, 0);
}