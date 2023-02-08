class ClientException implements Exception {
  final String message;

  ClientException(this.message);

  @override
  String toString() {
    return message;
  }
}

class NoConnectionException extends ClientException {
  NoConnectionException(super.message);
}

class NotAcceptableException extends ClientException {
  NotAcceptableException(super.message);
}

class NonProcessableEntityException extends ClientException {
  NonProcessableEntityException(super.message);
}

class ServerUnderMaintenanceException extends ClientException {
  ServerUnderMaintenanceException(super.message);
}

class ResourceNotFoundException extends ClientException {
  ResourceNotFoundException(super.message);
}

class RequestLimitException extends ClientException {
  RequestLimitException(super.message);
}

class UnauthorizedRequestException extends ClientException {
  UnauthorizedRequestException(super.message);
}

class ForbiddenException extends ClientException {
  ForbiddenException(super.message);
}

extension ClientStatusException on int {
  ClientException toStatusException(String message) {
    switch (this) {
      case 401:
        return UnauthorizedRequestException(message);
      case 403:
        return ForbiddenException(message);
      case 404:
        return ResourceNotFoundException(message);
      case 406:
        return NotAcceptableException(message);
      case 422:
        return NonProcessableEntityException(message);
      case 429:
        return RequestLimitException(message);
      case 503:
        return ServerUnderMaintenanceException(message);
      default:
        return ClientException(message);
    }
  }
}
