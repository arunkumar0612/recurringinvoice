import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:recurring_invoice/models/entities/Invoice_entities.dart';
import 'package:recurring_invoice/models/entities/Invoice_entities.dart' as widget;
import 'package:recurring_invoice/services/Invoice_services.dart';
import 'package:recurring_invoice/utils/helpers/support_functions.dart';
import 'package:recurring_invoice/views/components/invoice_template..dart';
import 'package:recurring_invoice/views/components/invoicepending_template.dart';
import 'package:recurring_invoice/views/components/quotation_template.dart';

class Generators {
  // ignore: non_constant_identifier_names
  static Future<InvoiceResult> InvoiceGenerator(dynamic jsonResponse) async {
    // Parse invoice from JSON
    Invoice invoice = InvoiceServices.parseInvoice(jsonResponse);
    print(invoice.toJson()); // Verify the parsed invoice

    // Define file paths
    String mainFilepath = 'E:/RecurringInvoices/main_${generateRandomString(6)}.pdf';
    String pendingFilepath = 'E:/RecurringInvoices/pending_${generateRandomString(6)}.pdf';

    // Generate both PDFs concurrently
    List<Uint8List> pdfDataList = await Future.wait([InvoiceTemplate(instInvoice: invoice).buildPdf(PdfPageFormat.a4), InvoicependingTemplate(instInvoice: invoice).buildPdf(PdfPageFormat.a4)]);

    // Create file objects
    File mainFile = File(mainFilepath);
    File pendingFile = File(pendingFilepath);

    // Write the generated PDFs to files concurrently
    await Future.wait([mainFile.writeAsBytes(pdfDataList[0]), pendingFile.writeAsBytes(pdfDataList[1])]);

    // Debug print paths
    if (kDebugMode) {
      print("Main PDF stored at: $mainFilepath");
      print("Pending PDF stored at: $pendingFilepath");
    }
    InvoiceServices.apicall(InvoiceResult(files: [mainFile, pendingFile], invoice: invoice));
    return InvoiceResult(files: [mainFile, pendingFile], invoice: invoice);
  }
}
