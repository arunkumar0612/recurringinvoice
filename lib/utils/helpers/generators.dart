import 'dart:io';
import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:recurring_invoice/models/entities/Invoice_entities.dart';
import 'package:recurring_invoice/services/Invoice_services.dart';
import 'package:recurring_invoice/utils/helpers/support_functions.dart';
import 'package:recurring_invoice/views/components/invoice_template..dart';

class Generators {
  static Future<void> InvoiceGenerator(jsonResponse) async {
    Invoice invoice = InvoiceServices.parseInvoice(jsonResponse);
    print(invoice.toJson()); // Verify the parsed invoice

    InvoiceTemplate invoiceTemplate = InvoiceTemplate(instInvoice: invoice);
    Uint8List pdfData = await invoiceTemplate.buildPdf(PdfPageFormat.a4);
    // Directory tempDir = await getTemporaryDirectory();
    // String? sanitizedInvoiceNo = replace_Slash_hypen(invoiceController.invoiceModel.Invoice_no.value!);
    String filePath = 'E:/RecurringInvoices/${generateRandomString(6)}.pdf';
    File file = File(filePath);
    await file.writeAsBytes(pdfData);
    print("PDF stored in cache: $filePath");
  }
}
