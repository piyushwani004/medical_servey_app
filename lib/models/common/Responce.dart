class Response<T> {
  bool isSuccessful;
  String message;
  T? data;

  Response({this.data, required this.isSuccessful, required this.message});
}
