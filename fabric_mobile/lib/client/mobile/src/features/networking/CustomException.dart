class CustomException implements Exception {
  final _message;
  final _prefix;

  CustomException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends CustomException {
  FetchDataException([String message])
      : super(message, "Error During Communication: ");
}

class BadRequestParametersException extends CustomException {
  BadRequestParametersException([message]) : super(message, "wrong or missing parameter: ");
}

class EndPointsException extends CustomException {
 EndPointsException([message]) : super(message, "wrong port number");
}


class SessionsExpiredException extends CustomException {
SessionsExpiredException([message]) : super(message, "user must re login to use the app");
}

class InternalServerException extends CustomException {
  InternalServerException([message]) : super(message, "it's just a glitch");
}

class InvalidInputException extends CustomException {
  InvalidInputException([String message]) : super(message, "Invalid Input: ");
}