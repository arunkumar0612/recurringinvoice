import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:recurring_invoice/models/entities/Invoice_entities.dart';
import 'package:recurring_invoice/services/Invoice_services.dart';
import 'package:recurring_invoice/utils/helpers/support_functions.dart';
import 'package:recurring_invoice/views/components/invoice_template..dart';
import 'package:recurring_invoice/views/components/quotation_template.dart';

class Generators {
  // ignore: non_constant_identifier_names
  static Future<void> InvoiceGenerator(jsonResponse) async {
    Invoice invoice = InvoiceServices.parseInvoice(jsonResponse);
    print(invoice.toJson()); // Verify the parsed invoice
    // InvoiceTemplate invoiceTemplate = InvoiceTemplate(instInvoice: invoice);
    // Uint8List pdfData = await invoiceTemplate.buildPdf(PdfPageFormat.a4);
    QuotationTemplate quotationTemplate = QuotationTemplate(instInvoice: invoice);
    Uint8List pdfData = await quotationTemplate.buildPdf(PdfPageFormat.a4);
    // Directory tempDir = await getTemporaryDirectory();
    // String? sanitizedInvoiceNo = replace_Slash_hypen(invoiceController.invoiceModel.Invoice_no.value!);
    String filePath = 'E:/RecurringInvoices/${generateRandomString(6)}.pdf';
    File file = File(filePath);
    await file.writeAsBytes(pdfData);
    if (kDebugMode) {
      print("PDF stored in cache: $filePath");
    }
  }
}
