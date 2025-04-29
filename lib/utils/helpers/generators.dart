import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:recurring_invoice/models/entities/Invoice_entities.dart';
import 'package:recurring_invoice/services/Invoice_services.dart';
import 'package:recurring_invoice/services/webSocket_services.dart';
import 'package:recurring_invoice/views/components/invoice_template..dart';

import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart'; // assuming you're using pdf package

class Generators {
  // ignore: non_constant_identifier_names
  static Future<InvoiceResult> InvoiceGenerator(
    Map<String, dynamic> jsonResponse,
  ) async {
    // Parse invoice from JSON
    Invoice invoice = InvoiceServices.parseInvoice(jsonResponse);

    // Get the system temp directory
    Directory tempDir = await getTemporaryDirectory();
    String tempFilePath = '${tempDir.path}/${invoice.invoiceNo}.pdf';

    // Generate PDF
    Uint8List generatedInvoice = await InvoiceTemplate(
      instInvoice: invoice,
    ).buildPdf(PdfPageFormat.a4);

    // Write to file
    File tempFile = File(tempFilePath);
    await tempFile.writeAsBytes(generatedInvoice);

    // Add to websocket services
    WebsocketServices.mailSenderList.add(tempFile);
    WebsocketServices.InvoicesList.add(
      InvoiceResult(files: [tempFile], invoice: invoice),
    );

    return InvoiceResult(files: [tempFile], invoice: invoice);
  }
}









    // WebsocketServices.mailSenderList["pending"]!.add(pendingFile);
    // String pendingFilepath = 'E:/RecurringInvoices/pending_${generateRandomString(6)}.pdf';

    // Generate both PDFs concurrently
    // List<Uint8List> pdfDataList = await Future.wait([, InvoicependingTemplate(instInvoice: invoice).buildPdf(PdfPageFormat.a4)]);

    // Create file objects

    // File pendingFile = File(pendingFilepath);

    // Write the generated PDFs to files concurrently
    // await Future.wait([mainFile.writeAsBytes(pdfDataList[0]), pendingFile.writeAsBytes(pdfDataList[1])]);

    // Debug print paths
    // if (kDebugMode) {
    //   print("Main PDF stored at: $mainFilepath");
    //   // print("Pending PDF stored at: $pendingFilepath");
    // }

    // final email = invoice.contactDetails.email;

    // if (!WebsocketServices.mailSenderList.containsKey("main")) {
    //   WebsocketServices.mailSenderList["main"] = [];
    // }
    // if (!WebsocketServices.mailSenderList.containsKey("pending")) {
    //   WebsocketServices.mailSenderList["pending"] = [];
    // }

