abstract class Failure {
  final String message;
  const Failure({required this.message});
  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message: message);
}

class CacheFailure extends Failure {
  const CacheFailure({required String message}) : super(message: message);
}

class NetworkFailure extends Failure {
  const NetworkFailure({required String message}) : super(message: message);
}

class GeneralFailure extends Failure {
  const GeneralFailure({required String message}) : super(message: message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({required String message}) : super(message: message);
}

class ValidationFailure extends Failure {
  const ValidationFailure({required String message}) : super(message: message);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({required String message}) : super(message: message);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({required String message}) : super(message: message);
}
