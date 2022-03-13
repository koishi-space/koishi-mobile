class ApiException {
  int statusCode;
  String message;
  dynamic body;

  ApiException({
    required this.statusCode,
    required this.message,
    required this.body,
  });
}
