class Response<T> {
  bool isSuccessful;
  String message;
  T? data;

  Response({
    required this.isSuccessful,
    required this.message,
    this.data,
  });

  @override
  String toString() =>
      'Response(isSuccessful: $isSuccessful, message: $message, data: $data)';
}
