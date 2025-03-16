// ignore_for_file: non_constant_identifier_names

import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:recurring_invoice/models/entities/Invoice_entities.dart';
import 'package:recurring_invoice/utils/helpers/support_functions.dart';

class InvoicependingTemplate {
  InvoicependingTemplate({required this.instInvoice});

  final Invoice instInvoice;
  final PdfColor baseColor = PdfColors.green500;
  final PdfColor accentColor = PdfColors.blueGrey900;
  static const _darkColor = PdfColors.blueGrey800;

  late pw.MemoryImage profileImage;

  // Function to build the PDF
  Future<Uint8List> buildPdf(PdfPageFormat pageFormat) async {
    // Load fonts asynchronously
    Helvetica = await loadFont_regular();
    Helvetica_bold = await loadFont_bold();

    // Load profile image
    final imageData = await rootBundle.load('assets/images/sporadaResized.jpeg');
    profileImage = pw.MemoryImage(imageData.buffer.asUint8List());

    // Create PDF document
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(pageFormat: PdfPageFormat.a4, margin: const pw.EdgeInsets.all(20)),
        header: (context) => header(context),
        footer: (context) => footer(context),
        build:
            (context) => [
              contentTable(context),
              pw.SizedBox(height: 10),
              final_amount(context),
              pw.SizedBox(height: 40),
              pw.Align(
                alignment: pw.Alignment.center,
                child: pw.Text(
                  '*** This list was created because there are pending invoices. ***',
                  style: pw.TextStyle(
                    font: Helvetica,
                    fontSize: 12.toDouble(),
                    color: PdfColors.grey500,
                    // fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ],
      ),
    );

    // Return the PDF file as a Uint8List
    return doc.save();
  }

  pw.Widget header(pw.Context context) {
    return pw.Container(
      child: pw.Column(
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              // pw.Align(alignment: pw.Alignment.centerLeft, child: pw.Container(padding: const pw.EdgeInsets.only(bottom: 0, left: 0), height: 80, child: pw.Image(profileImage))),
              pw.Padding(padding: const pw.EdgeInsets.only(left: 30), child: pw.Text('PENDING INVOICES', style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold, color: accentColor))),
              // pw.Align(
              //   alignment: pw.Alignment.centerRight,
              //   child: pw.Container(
              //     height: 120,
              //     child: pw.Row(
              //       children: [
              //         pw.Column(
              //           mainAxisAlignment: pw.MainAxisAlignment.center,
              //           crossAxisAlignment: pw.CrossAxisAlignment.start,
              //           children: [
              //             regular('Date', 10),

              //             // pw.SizedBox(height: 5),
              //             // regular('Relationship ID', 10),
              //           ],
              //         ),
              //         pw.Column(
              //           mainAxisAlignment: pw.MainAxisAlignment.center,
              //           crossAxisAlignment: pw.CrossAxisAlignment.start,
              //           children: [
              //             regular('  :  ', 10),

              //             // pw.SizedBox(height: 5),
              //             // regular('  :  ', 10),
              //           ],
              //         ),
              //         pw.Column(
              //           mainAxisAlignment: pw.MainAxisAlignment.center,
              //           crossAxisAlignment: pw.CrossAxisAlignment.start,
              //           children: [
              //             pw.Container(
              //               child: pw.Align(
              //                 alignment: pw.Alignment.centerLeft,
              //                 child: regular(formatDate(DateTime.now()), 10),
              //                 // formatDate(DateTime.now()), 10
              //               ),
              //             ),

              //             // pw.SizedBox(height: 5),
              //             // pw.Container(
              //             //   child: pw.Align(
              //             //     alignment: pw.Alignment.centerLeft,
              //             //     child: regular("3873870201", 10),
              //             //   ),
              //             // ),
              //           ],
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
          pw.SizedBox(height: 20),
        ],
      ),
    );
  }

  pw.Widget contentTable(pw.Context context) {
    const tableHeaders = ['S.No', 'Invoice ID', 'Due Date', 'Overdue Days', '               Charges'];

    return pw.Table(
      border: null,
      columnWidths: {
        0: const pw.FlexColumnWidth(1), // S.No (Small width)
        1: const pw.FlexColumnWidth(2), // Site Name (Medium width)
        2: const pw.FlexColumnWidth(3), // Address (Larger width)
        3: const pw.FlexColumnWidth(4), // Customer ID (Medium width)
        4: const pw.FlexColumnWidth(2), // Monthly Charges (Medium width)
      },
      children: [
        // Header Row
        pw.TableRow(
          decoration: pw.BoxDecoration(borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)), color: baseColor),
          children:
              tableHeaders.map((header) {
                return pw.Container(
                  padding: const pw.EdgeInsets.all(5),
                  alignment: pw.Alignment.centerLeft,
                  child: pw.Text(header, style: pw.TextStyle(font: Helvetica_bold, color: PdfColors.white, fontSize: 10, fontWeight: pw.FontWeight.bold)),
                );
              }).toList(),
        ),
        // Data Rows
        ...List.generate(instInvoice.pendingInvoices.length, (row) {
          return pw.TableRow(
            decoration: pw.BoxDecoration(
              color: row % 2 == 0 ? PdfColors.green50 : PdfColors.white, // Alternate row colors
            ),
            children: List.generate(
              tableHeaders.length,
              (col) => pw.Container(
                padding: const pw.EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
                alignment: _getAlignment(col),
                child: pw.Text(instInvoice.pendingInvoices[row].getIndex(col).toString(), style: pw.TextStyle(font: Helvetica, color: _darkColor, fontSize: 10)),
              ),
            ),
          );
        }),
      ],
    );
  }

  // Function to set alignment for each column
  pw.Alignment _getAlignment(int columnIndex) {
    if (columnIndex == 4) {
      return pw.Alignment.centerRight; // Align Monthly Charges to right
    }
    return pw.Alignment.centerLeft; // Default left alignment
  }

  pw.Widget final_amount(pw.Context context) {
    return pw.Align(
      alignment: pw.Alignment.centerRight,
      child: pw.Container(
        width: 185, // Define width to ensure bounded constraints
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          children: [
            pw.Padding(padding: pw.EdgeInsets.only(right: 5), child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [bold('Total', 12), bold("Rs.${1000}", 12)])),
          ],
        ),
      ),
    );
  }

  pw.Widget footer(pw.Context context) {
    return pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 20),
        if (context.pagesCount > 1)
          if (context.pageNumber < context.pagesCount) pw.Column(children: [pw.Padding(padding: const pw.EdgeInsets.only(top: 20), child: regular('continue...', 12))]),
        pw.Align(
          alignment: pw.Alignment.center,
          child: pw.Column(
            children: [
              pw.Container(padding: const pw.EdgeInsets.only(top: 10, bottom: 2), child: bold('SPORADA SECURE INDIA PRIVATE LIMITED', 12)),
              regular('687/7, 3rd Floor, Sakthivel Towers, Trichy road, Ramanathapuram, Coimbatore - 641045', 8),
              regular('Telephone: +91-422-2312363, E-mail: sales@sporadasecure.com, Website: www.sporadasecure.com', 8),
              pw.SizedBox(height: 2),
              regular('CIN: U30007TZ2020PTC03414  |  GSTIN: 33ABECS0625B1Z0', 8),
            ],
          ),
        ),
      ],
    );
  }
}
