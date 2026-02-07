class AppExceptionMessage{
  static const String timeout = 'The request timed out. Please try again later';
  static const String socket = 'Unable to connect to the server. Please check your network connection and try again';
  static const String serverDefault = 'Something went wrong';
  static const String format = 'Data format is incorrect.';
  static const String type = 'Type mismatch occurred.';
  static const String unknown = 'An unknown error occurred.';
}

final RegExp emailRegex = RegExp(
  r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.([a-zA-Z]{2,})+",
);

