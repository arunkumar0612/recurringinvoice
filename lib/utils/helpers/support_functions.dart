// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

dynamic Helvetica;
dynamic Helvetica_bold;
String replace_Slash_hypen(String value) {
  return value.replaceAll("/", "-");
}

Future<void> savePdfToNetwork(Uint8List pdfData) async {
  try {
    const networkPath = '\\\\192.198.0.198\\backup\\Hari\\invoice.pdf';

    final file = File(networkPath);

    await file.writeAsBytes(pdfData);

    if (kDebugMode) {
      print('PDF saved to $networkPath');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error saving PDF: $e');
    }
  }
}

Future<pw.Font> loadFont_regular() async {
  final helvetica = await rootBundle.load('assets/fonts/Helvetica.ttf');
  return pw.Font.ttf(helvetica);
}

Future<pw.Font> loadFont_bold() async {
  final helveticaBold = await rootBundle.load('assets/fonts/Helvetica-Bold.ttf');
  return pw.Font.ttf(helveticaBold);
}

String formatCurrencyRoundedPaisa(double amount) {
  // Round the paisa (decimal) values to the nearest integer
  double roundedAmount = amount.roundToDouble();

  // Format the amount with comma separation and two decimal places
  final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '', decimalDigits: 2);
  return formatter.format(roundedAmount);
}

String formatCurrency(double amount) {
  final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '', decimalDigits: 2);
  return formatter.format(amount);
}

String formatzero(double amount) {
  final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '', decimalDigits: 2);
  return formatter.format(amount);
}

String formatDate(DateTime date) {
  final format = DateFormat.yMMMd('en_US');
  return format.format(date);
}

pw.Widget regular(String value, int size) {
  // loadFont();
  return pw.Text(
    value,
    style: pw.TextStyle(
      font: Helvetica,
      fontSize: size.toDouble(),
      color: PdfColors.blueGrey800,
      // fontWeight: pw.FontWeight.bold,
    ),
  );
}

pw.Widget footerRegular(String value, int size) {
  // loadFont();
  return pw.Text(
    value,
    style: pw.TextStyle(
      font: Helvetica,
      fontSize: size.toDouble(),
      color: PdfColors.black,
      // fontWeight: pw.FontWeight.bold,
    ),
  );
}

pw.Widget footerBold(value, size) {
  // loadFont();
  return pw.Text(
    value,
    style: pw.TextStyle(
      font: Helvetica_bold,
      fontSize: size.toDouble(),
      color: PdfColors.black,
      // fontWeight: pw.FontWeight.bold,
    ),
  );
}

pw.Widget bold(value, size) {
  // loadFont();
  return pw.Text(
    value ?? "",
    style: pw.TextStyle(
      font: Helvetica_bold,
      fontSize: size.toDouble(),
      color: PdfColors.blueGrey800,
      // fontWeight: pw.FontWeight.bold,
    ),
  );
}

String generateRandomString(int length) {
  const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  Random random = Random();

  return List.generate(length, (index) => chars[random.nextInt(chars.length)]).join('');
}

bool isGST_Local(String? gstNumber, String address) {
  // Check GST number validity and state code
  if (gstNumber != null && gstNumber.length >= 2) {
    String stateCode = gstNumber.substring(0, 2);
    return stateCode == '33';
  }

  // If GST is null, fall back to address
  String lowerAddress = address.toLowerCase();

  // Check for keywords like 'tamilnadu' or 'tamil nadu'
  if (lowerAddress.contains('tamilnadu') || lowerAddress.contains('tamil nadu')) {
    return true;
  }

  // Tamil Nadu PIN codes start from 600000 to 649999
  final pinCodeRegex = RegExp(r'\b(60|61|62|63|64|65)\d{4}\b');
  if (pinCodeRegex.hasMatch(lowerAddress)) {
    return true;
  }

  // Default to false if no conditions met
  return false;
}
