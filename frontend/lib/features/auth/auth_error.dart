import 'package:dio/dio.dart';

String authErrorMessage(Object error) {
  if (error is DioException) {
    final data = error.response?.data;
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }
    if (data is String && data.isNotEmpty) {
      return data;
    }
    if (error.response?.statusCode == 401) {
      return 'Email or password is incorrect.';
    }
  }
  return 'Action impossible pour le moment.';
}
