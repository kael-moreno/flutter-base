/// Abstract base class for all failures in the application
abstract class Failure {
  final String message;
  final String code;

  const Failure({
    required this.message,
    required this.code,
  });

  @override
  String toString() => 'Failure(message: $message, code: $code)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Failure && other.message == message && other.code == code;
  }

  @override
  int get hashCode => message.hashCode ^ code.hashCode;
}

/// General application failure
class GeneralFailure extends Failure {
  const GeneralFailure({
    required super.message,
    super.code = 'GENERAL_FAILURE',
  });
}

/// Storage-related failure
class StorageFailure extends Failure {
  const StorageFailure({
    required super.message,
    super.code = 'STORAGE_FAILURE',
  });
}

/// Network-related failure
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code = 'NETWORK_FAILURE',
  });
}

/// Validation-related failure
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code = 'VALIDATION_FAILURE',
  });
}
