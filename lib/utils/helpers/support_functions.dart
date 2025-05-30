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

bool isValidGST(String gst) {
  final gstRegex = RegExp(r'^\d{2}[A-Z]{5}\d{4}[A-Z][1-9A-Z]Z[0-9A-Z]$');
  return gstRegex.hasMatch(gst);
}

bool isGST_Local(String? gstNumber, String address) {
  if (gstNumber != null && isValidGST(gstNumber)) {
    String stateCode = gstNumber.substring(0, 2);
    return stateCode == '33'; // Tamil Nadu
  }

  // If GST is null/invalid, fall back to address checks
  String lowerAddress = address.toLowerCase();

  if (lowerAddress.contains('tamilnadu') || lowerAddress.contains('tamil nadu')) {
    return true;
  }

  final pinCodeRegex = RegExp(r'\b(60|61|62|63|64|65)\d{4}\b');
  if (pinCodeRegex.hasMatch(lowerAddress)) {
    return true;
  }

  return false;
}
