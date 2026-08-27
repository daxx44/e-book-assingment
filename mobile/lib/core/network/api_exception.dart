class ApiException implements Exception {
  ApiException({
    required this.code,
    required this.message,
    this.details = const [],
    this.statusCode,
  });

  final String code;
  final String message;
  final List<FieldError> details;
  final int? statusCode;

  @override
  String toString() => 'ApiException($code): $message';
}

class FieldError {
  const FieldError({
    required this.field,
    required this.code,
    required this.message,
  });

  final String field;
  final String code;
  final String message;

  factory FieldError.fromJson(Map<String, dynamic> json) {
    return FieldError(
      field: json['field'] as String? ?? 'base',
      code: json['code'] as String? ?? 'invalid',
      message: json['message'] as String? ?? 'Validation error',
    );
  }
}
