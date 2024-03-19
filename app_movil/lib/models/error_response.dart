import 'dart:convert';

class ErrorResponse {
  String message;
  Map<String, List<String>> errors;

  ErrorResponse(this.message, this.errors);

  static ErrorResponse fromJson(String jsonString) {
    try {
      final parsedJson = json.decode(jsonString);
      final errorsMap = parsedJson['errors'] as Map<String, dynamic>;

      final errors = errorsMap.map<String, List<String>>((key, value) {
        if (value is List<dynamic>) {
          final stringList = value.cast<String>().toList();
          return MapEntry(key, stringList);
        } else {
          return MapEntry(key, [value.toString()]);
        }
      });
      return ErrorResponse(parsedJson['message'] as String, errors);
    } catch (e) {
      return null;
    }
  }
}
