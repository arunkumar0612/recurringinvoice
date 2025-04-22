import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:recurring_invoice/models/entities/Invoice_entities.dart';
import 'package:recurring_invoice/services/Invoice_services.dart';
import 'package:recurring_invoice/services/webSocket_services.dart';
import 'package:recurring_invoice/utils/helpers/support_functions.dart';
import 'package:recurring_invoice/views/components/invoice_template..dart';

class Generators {
  // ignore: non_constant_identifier_names
  static Future<InvoiceResult> InvoiceGenerator(Map<String, dynamic> jsonResponse) async {
    // Parse invoice from JSON
    Invoice invoice = InvoiceServices.parseInvoice(jsonResponse);
    // print(invoice.toJson()); // Verify the parsed invoice

    // Define file paths
    String mainFilepath = 'E:/RecurringInvoices/main_${generateRandomString(6)}.pdf';
    File mainFile = File(mainFilepath);
    Uint8List GeneratedInvoice = await InvoiceTemplate(instInvoice: invoice).buildPdf(PdfPageFormat.a4);
    mainFile.writeAsBytes(GeneratedInvoice);
    // String savePath = "$selectedDirectory/$filename.pdf";
    // await mainFile.copy(mainFilepath);
    WebsocketServices.mailSenderList.add(mainFile);
    WebsocketServices.InvoicesList.add(InvoiceResult(files: [mainFile], invoice: invoice));
    // print("*************************************************${WebsocketServices.mailSenderList}");
    InvoiceResult(files: [mainFile], invoice: invoice);

    return InvoiceResult(files: [mainFile], invoice: invoice);
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

