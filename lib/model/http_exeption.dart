class HttpException implements Exception {
  final String message;

  HttpException(this.message);

  String toStrings() {
    return message;
    // return super.toString(); // Instance of HttpException
  }
}
