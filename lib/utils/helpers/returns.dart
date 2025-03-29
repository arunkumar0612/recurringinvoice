import 'dart:convert';
import 'package:flutter/services.dart';

class Returns {
  static Future<Map<String, dynamic>> loadConfigFile(String path) async {
    final configString = await rootBundle.loadString(path);
    return jsonDecode(configString);
  }

  static String replace_Slash_hypen(String value) {
    return value.replaceAll("/", "-");
  }
}
