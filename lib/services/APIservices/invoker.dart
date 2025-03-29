import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:recurring_invoice/services/APIservices/api_service.dart';
import 'package:recurring_invoice/utils/helpers/encrypt_decrypt.dart';
import 'package:recurring_invoice/utils/helpers/returns.dart';

class Invoker extends GetxController {
  final ApiService apiService = ApiService();

  // final SessiontokenController sessiontokenController = Get.find<SessiontokenController>();
  // Future<Map<String, dynamic>?> IAM(Map<String, dynamic> body, String API) async {
  //   final configData = await Returns.loadConfigFile('assets/key.config');
  //   final apiKey = configData['APIkey'];
  //   final secret = configData['Secret'];

  //   final dataToEncrypt = jsonEncode(body);
  //   final encryptedData = AES.encryptWithAES(secret, dataToEncrypt);
  //   final requestData = {"APIkey": apiKey, "Secret": secret, "querystring": encryptedData};
  //   final response = await apiService.postData(API, requestData);

  //   if (response.statusCode == 200) {
  //     final responseData = response.body;
  //     String encryptedResponse = responseData['encryptedResponse'];
  //     final decryptedResponse = AES.decryptWithAES(secret.substring(0, 16), encryptedResponse);
  //     Map<String, dynamic> decodedResponse = jsonDecode(decryptedResponse);
  //     final result = <String, int>{"statusCode": response.statusCode!};
  //     decodedResponse.addEntries(result.entries.map((e) => MapEntry(e.key, e.value)));
  //     return decodedResponse;
  //   } else {
  //     Map<String, dynamic> reply = {"statusCode": response.statusCode, "message": "Server Error"};
  //     return reply;
  //   }
  // }

  Future<Map<String, dynamic>?> GetbyToken(String API) async {
    final configData = await Returns.loadConfigFile('assets/key.config');
    final apiKey = configData['APIkey'];
    final secret = configData['Secret'];
    final requestData = {"STOKEN": secret};
    final response = await apiService.postData(API, requestData);

    if (response.statusCode == 200) {
      final responseData = response.body;
      String encryptedResponse = responseData['encryptedResponse'];
      final decryptedResponse = AES.decryptWithAES(secret, encryptedResponse);
      Map<String, dynamic> decodedResponse = jsonDecode(decryptedResponse);
      final result = <String, int>{"statusCode": response.statusCode!};
      decodedResponse.addEntries(result.entries.map((e) => MapEntry(e.key, e.value)));
      return decodedResponse;
    } else {
      Map<String, dynamic> reply = {"statusCode": response.statusCode, "message": "Server Error"};
      return reply;
    }
  }

  Future<Map<String, dynamic>?> GetbyQueryString(Map<String, dynamic> body, String API) async {
    final configData = await Returns.loadConfigFile('assets/key.config');
    final apiKey = configData['APIkey'];
    final secret = configData['Secret'];
    final dataToEncrypt = jsonEncode(body);
    final encryptedData = AES.encryptWithAES(secret, dataToEncrypt);

    Map<String, dynamic> formData = {"STOKEN": secret, "querystring": encryptedData};
    final response = await apiService.postData(API, formData);

    if (response.statusCode == 200) {
      final responseData = response.body;
      String encryptedResponse = responseData['encryptedResponse'];
      final decryptedResponse = AES.decryptWithAES(secret, encryptedResponse);
      Map<String, dynamic> decodedResponse = jsonDecode(decryptedResponse);
      final result = <String, int>{"statusCode": response.statusCode!};
      decodedResponse.addEntries(result.entries.map((e) => MapEntry(e.key, e.value)));
      return decodedResponse;
    } else {
      Map<String, dynamic> reply = {"statusCode": response.statusCode, "message": "Server Error"};
      return reply;
    }
  }

  Future<Map<String, dynamic>?> multiPart(File file, String API) async {
    final configData = await Returns.loadConfigFile('assets/key.config');
    final apiKey = configData['APIkey'];
    final secret = configData['Secret'];
    FormData formData = FormData({
      "file": MultipartFile(file, filename: file.path.split('/').last), // Attach file
      "STOKEN": secret,
    });
    final response = await apiService.postMulter(API, formData);

    if (response.statusCode == 200) {
      final responseData = response.body;
      String encryptedResponse = responseData['encryptedResponse'];
      final decryptedResponse = AES.decryptWithAES(secret, encryptedResponse);
      Map<String, dynamic> decodedResponse = jsonDecode(decryptedResponse);
      final result = <String, int>{"statusCode": response.statusCode!};
      decodedResponse.addEntries(result.entries.map((e) => MapEntry(e.key, e.value)));

      return decodedResponse;
    } else {
      Map<String, dynamic> reply = {"statusCode": response.statusCode, "message": "Server Error"};
      return reply;
    }
  }

  Future<Map<String, dynamic>> Multer(
    String body,
    List<File> files, // Accept multiple files
    String API,
  ) async {
    // Load config file for API keys
    final configData = await Returns.loadConfigFile('assets/key.config');
    final apiKey = configData['APIkey'];
    final secret = configData['Secret'];
    final encryptedData = AES.encryptWithAES(secret, body);

    // Prepare form data with multiple files
    FormData formData = FormData({"STOKEN": secret, "querystring": encryptedData, "files": files.map((file) => MultipartFile(file, filename: file.path.split('/').last)).toList()});

    // Send request
    final response = await apiService.postMulter(API, formData);

    // Handle response
    if (response.statusCode == 200) {
      final responseData = response.body;
      String encryptedResponse = responseData['encryptedResponse'];
      final decryptedResponse = AES.decryptWithAES(secret, encryptedResponse);
      Map<String, dynamic> decodedResponse = jsonDecode(decryptedResponse);

      // Add statusCode to response
      decodedResponse["statusCode"] = response.statusCode!;
      return decodedResponse;
    } else {
      return {"statusCode": response.statusCode, "message": "Server Error"};
    }
  }

  Future<Map<String, dynamic>> SendByQuerystring(String body, String API) async {
    final configData = await Returns.loadConfigFile('assets/key.config');
    final apiKey = configData['APIkey'];
    final secret = configData['Secret'];
    final encryptedData = AES.encryptWithAES(secret, body);

    final requestData = {"STOKEN": secret, "querystring": encryptedData};

    final response = await apiService.post(API, requestData);

    if (response.statusCode == 200) {
      final responseData = response.body;
      String encryptedResponse = responseData['encryptedResponse'];
      final decryptedResponse = AES.decryptWithAES(secret, encryptedResponse);
      Map<String, dynamic> decodedResponse = jsonDecode(decryptedResponse);
      final result = <String, int>{"statusCode": response.statusCode!};
      decodedResponse.addEntries(result.entries.map((e) => MapEntry(e.key, e.value)));

      return decodedResponse;
    } else {
      Map<String, dynamic> reply = {"statusCode": response.statusCode, "message": "Server Error"};
      return reply;
    }
  }
}
