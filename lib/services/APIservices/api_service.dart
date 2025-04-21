import 'package:get/get.dart';

class ApiService extends GetConnect {
  ApiService() {
    // ✅ Set timeout for all requests (e.g., 10 seconds)
    httpClient.timeout = const Duration(seconds: 100);
  }

  Future<Response> postData(String url, Map<String, dynamic> body) async {
    try {
      Response response = await post(url, body);
      return response;
    } catch (e) {
      return Response(statusCode: 500, statusText: 'Error: ${e.toString()}');
    }
  }

  Future<Response> postMulter(String url, FormData formData) async {
    try {
      Response response = await post(url, formData);
      return response;
    } catch (e) {
      return Response(statusCode: 500, statusText: 'Error: ${e.toString()}');
    }
  }
}
