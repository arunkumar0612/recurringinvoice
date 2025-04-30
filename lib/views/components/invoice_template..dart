// ignore_for_file: non_constant_identifier_names

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:recurring_invoice/models/entities/Invoice_entities.dart';
import 'package:recurring_invoice/utils/helpers/support_functions.dart';

class InvoiceTemplate {
  InvoiceTemplate({
    required this.instInvoice,
    // required this.items,
  });
  // final SUBSCRIPTION_CustomPDF_InvoiceController pdfpopup_controller = Get.find<SUBSCRIPTION_CustomPDF_InvoiceController>();

  final Invoice instInvoice;
  PdfColor baseColor = const PdfColor.fromInt(0xFF1F497D);
  final PdfColor accentColor = PdfColors.blueGrey900;
  static const _darkColor = PdfColors.blueGrey800;

  late pw.MemoryImage profileImage;
  late pw.MemoryImage secureshutterImage;
  late double totalDue;
  Future<Uint8List> buildPdf(PdfPageFormat pageFormat) async {
    // Load fonts asynchronously
    Helvetica = await loadFont_regular();
    Helvetica_bold = await loadFont_bold();

    // Load profile image
    final imageData = await rootBundle.load('assets/images/sporadaResized.jpeg');
    profileImage = pw.MemoryImage(imageData.buffer.asUint8List());
    final secureshutterimageData = await rootBundle.load('assets/images/secureshutter.jpeg');
    secureshutterImage = pw.MemoryImage(secureshutterimageData.buffer.asUint8List());
    totalDue =
        ((double.parse(instInvoice.billPlanDetails.pendingPayments) - (double.parse(instInvoice.billPlanDetails.amountPaid) + double.parse(instInvoice.billPlanDetails.tdsDeductions))) +
            instInvoice.finalCalc.total);
    // Create PDF document
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageTheme: const pw.PageTheme(pageFormat: PdfPageFormat.a4, margin: pw.EdgeInsets.only(left: 0, right: 0, bottom: 0)),
        header: (context) => pw.Padding(padding: const pw.EdgeInsets.only(left: 20, right: 20), child: header(context)),
        footer: (context) => footerSpare(context),
        build:
            (context) => [
              // pw.Container(child: to_addr(context)),
              // pw.SizedBox(height: 10),
              pw.Padding(
                padding: const pw.EdgeInsets.only(left: 20, right: 20),
                child: pw.Container(
                  color: baseColor,
                  height: 20,
                  child: pw.Center(child: pw.Text('Your e - Surveillance bill', style: pw.TextStyle(fontSize: 12, color: PdfColors.white, fontWeight: pw.FontWeight.bold))),
                ),
              ),

              pw.SizedBox(height: 5),
              pw.Padding(padding: const pw.EdgeInsets.only(left: 20, right: 20), child: pw.Container(child: to_addr(context))),
              pw.SizedBox(height: 5),
              pw.Padding(
                padding: const pw.EdgeInsets.only(left: 20, right: 20),
                child: pw.Container(
                  color: baseColor,
                  height: 20,
                  child: pw.Center(child: pw.Text('Account Summary', style: pw.TextStyle(fontSize: 12, color: PdfColors.white, fontWeight: pw.FontWeight.bold))),
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Padding(padding: const pw.EdgeInsets.only(left: 20, right: 20), child: pw.Container(child: account_details(context))),
              pw.SizedBox(height: 5),
              pw.Padding(padding: const pw.EdgeInsets.only(left: 20, right: 20), child: TotalcaculationTable()),
              pw.SizedBox(height: 5),
              // tax_table(context),
              pw.Padding(padding: const pw.EdgeInsets.only(left: 20, right: 20), child: Local_tax_table(context)),
              pw.SizedBox(height: 5),
              pw.Center(child: regular('*** This is a system generated invoice hence do not require signature. ***', 12)),
              if (instInvoice.siteData.length > 1) pw.Padding(padding: const pw.EdgeInsets.only(left: 20, right: 20, top: 40), child: contentTable(context)),
              // pw.Divider(height: 1, color: baseColor),
              // pw.Padding(
              //   padding: const pw.EdgeInsets.all(5),
              //   child: pw.Align(
              //       alignment: pw.Alignment.centerRight,
              //       child: pw.SizedBox(
              //           width: 150, child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [bold('Sub total   :', 10), bold(formatzero(instInvoice.finalCalc.subtotal), 10)]))),
              // )
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
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Container(padding: const pw.EdgeInsets.only(bottom: 5, left: 5, top: 10), height: 100, child: pw.Image(profileImage)),
              pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  bold('Sporada Secure India Private Limited', 10),
                  pw.SizedBox(height: 5),
                  regular('687/7, 3rd Floor, Sakthivel tower', 10),
                  pw.SizedBox(height: 5),
                  regular('Trichy road, Ramanathapuram,', 10),
                  pw.SizedBox(height: 5),
                  regular('Coimbatore – 641045', 10),
                  pw.SizedBox(height: 5),
                  regular('Tamilnadu, India', 10),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget account_details(pw.Context context) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Expanded(
          child: pw.Container(
            decoration: pw.BoxDecoration(
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(1)),
              // color: baseColor,
              border: pw.Border.all(color: _darkColor, width: 1),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  // width: 285,
                  height: 20,
                  color: baseColor,
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(
                          // top: 3,
                          left: 10,
                        ),
                        child: pw.Text('BILL PLAN DETAILS', style: pw.TextStyle(font: Helvetica_bold, fontSize: 10, color: PdfColors.white)),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 2,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 10),
                        child: pw.Text('Plan name ', textAlign: pw.TextAlign.start, style: pw.TextStyle(font: Helvetica, fontSize: 10, lineSpacing: 2, color: _darkColor), softWrap: true),
                      ),
                    ),
                    regular('  : ', 12),
                    pw.Expanded(
                      flex: 3,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 0),
                        child: pw.Text(
                          // 'Secure - 360°',
                          instInvoice.billPlanDetails.planName,
                          textAlign: pw.TextAlign.start,
                          style: pw.TextStyle(font: Helvetica_bold, fontSize: 8, lineSpacing: 3, color: _darkColor),
                          softWrap: true, // Ensure text wraps within the container
                        ),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 4),
                pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 2,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 10),
                        child: pw.Text('Customer type', textAlign: pw.TextAlign.start, style: pw.TextStyle(font: Helvetica, fontSize: 10, lineSpacing: 2, color: _darkColor), softWrap: true),
                      ),
                    ),
                    regular('  : ', 12),
                    pw.Expanded(
                      flex: 3,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 0),
                        child: pw.Text(
                          // 'Corporate',
                          instInvoice.billPlanDetails.customerType,
                          textAlign: pw.TextAlign.start,
                          style: pw.TextStyle(font: Helvetica, fontSize: 8, lineSpacing: 3, color: _darkColor),
                          softWrap: true, // Ensure text wraps within the container
                        ),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 4),
                pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 2,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 10),
                        child: pw.Text('Plan charges', textAlign: pw.TextAlign.start, style: pw.TextStyle(font: Helvetica, fontSize: 10, lineSpacing: 2, color: _darkColor), softWrap: true),
                      ),
                    ),
                    regular('  : ', 12),
                    pw.Expanded(
                      flex: 3,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 0),
                        child: pw.Text(
                          // 'Annexed',
                          instInvoice.billPlanDetails.planCharges,
                          textAlign: pw.TextAlign.start,
                          style: pw.TextStyle(font: Helvetica, fontSize: 8, lineSpacing: 3, color: _darkColor),
                          softWrap: true, // Ensure text wraps within the container
                        ),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 4),
                pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 2,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 10),
                        child: pw.Text('Internet charges', textAlign: pw.TextAlign.start, style: pw.TextStyle(font: Helvetica, fontSize: 10, lineSpacing: 2, color: _darkColor), softWrap: true),
                      ),
                    ),
                    regular('  : ', 12),
                    pw.Expanded(
                      flex: 3,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 0),
                        child: pw.Text(
                          // '0.00°',
                          instInvoice.billPlanDetails.internetCharges.toString(),
                          textAlign: pw.TextAlign.start,
                          style: pw.TextStyle(font: Helvetica, fontSize: 8, lineSpacing: 3, color: _darkColor),
                          softWrap: true, // Ensure text wraps within the container
                        ),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 4),
                pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 2,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 10),
                        child: pw.Text('Bill Period', textAlign: pw.TextAlign.start, style: pw.TextStyle(font: Helvetica, fontSize: 10, lineSpacing: 2, color: _darkColor), softWrap: true),
                      ),
                    ),
                    regular('  : ', 12),
                    pw.Expanded(
                      flex: 3,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 0),
                        child: pw.Text(
                          // '01/ 01 / 2025 - 31 / 01 /2025',
                          instInvoice.billPlanDetails.billPeriod,
                          textAlign: pw.TextAlign.start,
                          style: pw.TextStyle(font: Helvetica, fontSize: 8, lineSpacing: 3, color: _darkColor),
                          softWrap: true, // Ensure text wraps within the container
                        ),
                      ),
                    ),
                  ],
                ),
                // pw.SizedBox(height: 4),
                // pw.Row(
                //   children: [
                //     pw.Expanded(
                //       child: pw.Padding(
                //         padding: const pw.EdgeInsets.symmetric(horizontal: 10),
                //         child: pw.Text('Bill date', textAlign: pw.TextAlign.start, style: pw.TextStyle(font: Helvetica_bold, fontSize: 10, lineSpacing: 2, color: _darkColor), softWrap: true),
                //       ),
                //     ),
                //     pw.Expanded(
                //       child: pw.Padding(
                //         padding: const pw.EdgeInsets.symmetric(horizontal: 10),
                //         child: pw.Text(
                //           // '01 / 01 / 2025',
                //           instInvoice.billPlanDetails.billDate,
                //           textAlign: pw.TextAlign.start,
                //           style: pw.TextStyle(font: Helvetica, fontSize: 8, lineSpacing: 3, color: _darkColor),
                //           softWrap: true, // Ensure text wraps within the container
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                pw.SizedBox(height: 4),
                pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 2,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 10),
                        child: pw.Text('Bill date', textAlign: pw.TextAlign.start, style: pw.TextStyle(font: Helvetica, fontSize: 10, lineSpacing: 2, color: _darkColor), softWrap: true),
                      ),
                    ),
                    regular('  : ', 12),
                    pw.Expanded(
                      flex: 3,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 0),
                        child: pw.Text(
                          // '07 / 01 / 2025',
                          instInvoice.date,
                          textAlign: pw.TextAlign.start,
                          style: pw.TextStyle(font: Helvetica, fontSize: 8, lineSpacing: 3, color: _darkColor),
                          softWrap: true, // Ensure text wraps within the container
                        ),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 4),
                pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 2,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 10),
                        child: pw.Text('Due date', textAlign: pw.TextAlign.start, style: pw.TextStyle(font: Helvetica, fontSize: 10, lineSpacing: 2, color: _darkColor), softWrap: true),
                      ),
                    ),
                    regular('  : ', 12),
                    pw.Expanded(
                      flex: 3,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 0),
                        child: pw.Text(
                          // '07 / 01 / 2025',
                          instInvoice.billPlanDetails.dueDate,
                          textAlign: pw.TextAlign.start,
                          style: pw.TextStyle(font: Helvetica, fontSize: 8, lineSpacing: 3, color: _darkColor),
                          softWrap: true, // Ensure text wraps within the container
                        ),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 10),
              ],
            ),
          ),
        ),
        pw.SizedBox(width: 20),
        pw.Expanded(
          child: pw.Container(
            decoration: pw.BoxDecoration(
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(1)),
              // color: baseColor,
              border: pw.Border.all(color: _darkColor, width: 1),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  // width: 285,
                  height: 20,
                  color: baseColor,
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(
                          // top: 3,
                          left: 10,
                        ),
                        child: pw.Text('CUSTOMER ACCOUNT DETAILS', style: pw.TextStyle(font: Helvetica_bold, fontSize: 10, color: PdfColors.white)),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 2,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 10),
                        child: pw.Text('Relationship ID', textAlign: pw.TextAlign.start, style: pw.TextStyle(font: Helvetica, fontSize: 10, lineSpacing: 2, color: _darkColor), softWrap: true),
                      ),
                    ),
                    regular('  : ', 12),
                    pw.Expanded(
                      flex: 3,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 0),
                        child: pw.Text(
                          // 'KV-CI-AR',
                          instInvoice.customerAccountDetails.relationshipId,
                          textAlign: pw.TextAlign.start,
                          style: pw.TextStyle(font: Helvetica_bold, fontSize: 8, lineSpacing: 3, color: _darkColor),
                          softWrap: true, // Ensure text wraps within the container
                        ),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 4),
                pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 2,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 10),
                        child: pw.Text('Bill number', textAlign: pw.TextAlign.start, style: pw.TextStyle(font: Helvetica, fontSize: 10, lineSpacing: 2, color: _darkColor), softWrap: true),
                      ),
                    ),
                    regular('  : ', 12),
                    pw.Expanded(
                      flex: 3,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 0),
                        child: pw.Text(
                          // 'KV-CI-AR',
                          instInvoice.invoiceNo,
                          textAlign: pw.TextAlign.start,
                          style: pw.TextStyle(font: Helvetica_bold, fontSize: 8, lineSpacing: 3, color: _darkColor),
                          softWrap: true, // Ensure text wraps within the container
                        ),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 4),
                // pw.Row(
                //   children: [
                //     pw.Expanded(
                //       child: pw.Padding(
                //         padding: const pw.EdgeInsets.symmetric(horizontal: 10),
                //         child: pw.Text('Bill number', textAlign: pw.TextAlign.start, style: pw.TextStyle(font: Helvetica_bold, fontSize: 10, lineSpacing: 2, color: _darkColor), softWrap: true),
                //       ),
                //     ),
                //     pw.Expanded(
                //       child: pw.Padding(
                //         padding: const pw.EdgeInsets.symmetric(horizontal: 10),
                //         child: pw.Text(
                //           // 'KVCIAR/250101',
                //           instInvoice.customerAccountDetails.billNumber,
                //           textAlign: pw.TextAlign.start,
                //           style: pw.TextStyle(font: Helvetica, fontSize: 8, lineSpacing: 3, color: _darkColor),
                //           softWrap: true, // Ensure text wraps within the container
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                // pw.SizedBox(height: 4),
                pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 2,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 10),
                        child: pw.Text('Customer GSTIN', textAlign: pw.TextAlign.start, style: pw.TextStyle(font: Helvetica, fontSize: 10, lineSpacing: 2, color: _darkColor), softWrap: true),
                      ),
                    ),
                    regular('  : ', 12),
                    pw.Expanded(
                      flex: 3,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 0),
                        child: pw.Text(
                          // '33AADCK2098J1ZF',
                          instInvoice.customerAccountDetails.customerGSTIN,
                          textAlign: pw.TextAlign.start,
                          style: pw.TextStyle(font: Helvetica_bold, fontSize: 8, lineSpacing: 3, color: _darkColor),
                          softWrap: true, // Ensure text wraps within the container
                        ),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 4),
                pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 2,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 10),
                        child: pw.Text('HSN / SAC Code', textAlign: pw.TextAlign.start, style: pw.TextStyle(font: Helvetica, fontSize: 10, lineSpacing: 2, color: _darkColor), softWrap: true),
                      ),
                    ),
                    regular('  : ', 12),
                    pw.Expanded(
                      flex: 3,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 0),
                        child: pw.Text(
                          // '998319',
                          instInvoice.customerAccountDetails.hsnSacCode,
                          textAlign: pw.TextAlign.start,
                          style: pw.TextStyle(font: Helvetica_bold, fontSize: 8, lineSpacing: 3, color: _darkColor),
                          softWrap: true, // Ensure text wraps within the container
                        ),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 4),
                pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 2,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 10),
                        child: pw.Text('Customer PO', textAlign: pw.TextAlign.start, style: pw.TextStyle(font: Helvetica, fontSize: 10, lineSpacing: 2, color: _darkColor), softWrap: true),
                      ),
                    ),
                    regular('  : ', 12),
                    pw.Expanded(
                      flex: 3,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 0),
                        child: pw.Text(
                          // 'AAAAAAAAAAAAAAA',
                          instInvoice.customerAccountDetails.customerPO,
                          textAlign: pw.TextAlign.start,
                          style: pw.TextStyle(font: Helvetica, fontSize: 8, lineSpacing: 3, color: _darkColor),
                          softWrap: true, // Ensure text wraps within the container
                        ),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 4),
                pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 2,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 10),
                        child: pw.Text('Contact person', textAlign: pw.TextAlign.start, style: pw.TextStyle(font: Helvetica, fontSize: 10, lineSpacing: 2, color: _darkColor), softWrap: true),
                      ),
                    ),
                    regular('  : ', 12),
                    pw.Expanded(
                      flex: 3,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 0),
                        child: pw.Text(
                          // ' Mr. Thulasinathan',
                          instInvoice.customerAccountDetails.contactPerson,
                          textAlign: pw.TextAlign.start,
                          style: pw.TextStyle(font: Helvetica, fontSize: 8, lineSpacing: 3, color: _darkColor),
                          softWrap: true, // Ensure text wraps within the container
                        ),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 4),
                pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 2,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 10),
                        child: pw.Text('Contact number', textAlign: pw.TextAlign.start, style: pw.TextStyle(font: Helvetica, fontSize: 10, lineSpacing: 2, color: _darkColor), softWrap: true),
                      ),
                    ),
                    regular('  : ', 12),
                    pw.Expanded(
                      flex: 3,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 0),
                        child: pw.Text(
                          // '+91-984-145-6250',
                          instInvoice.customerAccountDetails.contactNumber,
                          textAlign: pw.TextAlign.start,
                          style: pw.TextStyle(font: Helvetica, fontSize: 8, lineSpacing: 3, color: _darkColor),
                          softWrap: true, // Ensure text wraps within the container
                        ),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget to_addr(pw.Context context) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Expanded(
          child: pw.Container(
            decoration: pw.BoxDecoration(
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(1)),
              // color: baseColor,
              border: pw.Border.all(color: _darkColor, width: 1),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  // width: 285,
                  height: 20,
                  color: baseColor,
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(
                          top: 3,
                          // left: 15,
                        ),
                        child: pw.Text('REGISTERED / BILLING ADDRESS', style: pw.TextStyle(font: Helvetica_bold, fontSize: 10, color: PdfColors.white)),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 10),
                  child: pw.Text(
                    instInvoice.addressDetails.billingName,
                    textAlign: pw.TextAlign.start,
                    style: pw.TextStyle(font: Helvetica_bold, fontSize: 10, lineSpacing: 2, color: _darkColor),
                    softWrap: true,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(left: 10, bottom: 10),
                  child: pw.Text(
                    instInvoice.addressDetails.billingAddress,
                    textAlign: pw.TextAlign.start,
                    style: pw.TextStyle(font: Helvetica, fontSize: 8, lineSpacing: 3, color: _darkColor),
                    softWrap: true, // Ensure text wraps within the container
                  ),
                ),
              ],
            ),
          ),
        ),
        pw.SizedBox(width: 20),
        pw.Expanded(
          child: pw.Container(
            decoration: pw.BoxDecoration(
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(1)),
              // color: baseColor,
              border: pw.Border.all(color: _darkColor, width: 1),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  // width: 285,
                  height: 20,
                  color: baseColor,
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(
                          top: 3,
                          // left: 15,
                        ),
                        child: pw.Text('INSTALLATION / SERVICE ADDRESS', style: pw.TextStyle(font: Helvetica_bold, fontSize: 10, color: PdfColors.white)),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 10),
                  child: pw.Text(
                    // maxLines: 3,
                    instInvoice.addressDetails.clientName,
                    textAlign: pw.TextAlign.start,
                    style: pw.TextStyle(font: Helvetica_bold, fontSize: 10, lineSpacing: 2, color: _darkColor),
                    softWrap: true,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(left: 10, bottom: 10),
                  child: pw.Text(
                    // maxLines: 3,
                    instInvoice.addressDetails.clientAddress,
                    textAlign: pw.TextAlign.start,
                    style: pw.TextStyle(font: Helvetica, fontSize: 8, lineSpacing: 3, color: _darkColor),
                    softWrap: true, // Ensure text wraps within the container
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // pw.Widget title(pw.Context context) {
  //   return pw.Center(child: bold("GSTIN : $GST", 12));
  // }

  pw.Widget contentTable(pw.Context context) {
    const tableHeaders = ['S.No', 'SITE NAME & ADDRESS', 'CUSTOMER ID', 'MONTHLY CHARGES'];

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Main table with full border
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.black, width: 1),
          columnWidths: {0: const pw.FlexColumnWidth(1), 1: const pw.FlexColumnWidth(4), 2: const pw.FlexColumnWidth(2), 3: const pw.FlexColumnWidth(2)},
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFF9EDA67)),
              children:
                  tableHeaders.map((header) {
                    return pw.Container(
                      padding: const pw.EdgeInsets.all(5),
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Text(header, style: pw.TextStyle(font: Helvetica_bold, color: PdfColors.black, fontSize: 10, fontWeight: pw.FontWeight.bold)),
                    );
                  }).toList(),
            ),
            ...List.generate(instInvoice.siteData.length, (row) {
              return pw.TableRow(
                verticalAlignment: pw.TableCellVerticalAlignment.middle,
                decoration: const pw.BoxDecoration(color: PdfColors.white),
                children: List.generate(tableHeaders.length, (col) {
                  final content = instInvoice.siteData[row].getIndex(col);
                  return pw.Container(
                    padding: const pw.EdgeInsets.all(5),
                    alignment: _getAlignment(col),
                    child:
                        col == 1 && content is String && content.contains('||')
                            ? _buildRichSiteText(content)
                            : pw.Text(content.toString(), style: pw.TextStyle(font: Helvetica, color: _darkColor, fontSize: 10)),
                  );
                }),
              );
            }),
          ],
        ),

        // Final row aligned with last two columns
        pw.Row(
          children: [
            pw.Expanded(flex: 5, child: pw.Container()), // Spacer to align
            pw.Expanded(
              flex: 2,
              child: pw.Container(
                padding: const pw.EdgeInsets.all(5),
                decoration: const pw.BoxDecoration(
                  border: pw.Border(
                    left: pw.BorderSide(color: PdfColors.black, width: 1),
                    right: pw.BorderSide(color: PdfColors.black, width: 1),
                    bottom: pw.BorderSide(color: PdfColors.black, width: 1),
                  ),
                ),
                alignment: _getAlignment(2),
                child: pw.Text('TOTAL', style: pw.TextStyle(font: Helvetica_bold, color: _darkColor, fontSize: 10)),
              ),
            ),
            pw.Expanded(
              flex: 2,
              child: pw.Container(
                padding: const pw.EdgeInsets.all(5),
                decoration: const pw.BoxDecoration(
                  border: pw.Border(
                    // left: pw.BorderSide(color: PdfColors.black, width: 1),
                    right: pw.BorderSide(color: PdfColors.black, width: 1),
                    bottom: pw.BorderSide(color: PdfColors.black, width: 1),
                  ),
                ),
                alignment: _getAlignment(3),
                child: pw.Text(formatzero(instInvoice.finalCalc.subtotal), style: pw.TextStyle(font: Helvetica_bold, color: _darkColor, fontSize: 10)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget TotalcaculationTable() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.center,
      children: [
        if (instInvoice.billPlanDetails.showPending == 0)
          pw.Expanded(
            child: pw.Container(
              height: 60,
              decoration: pw.BoxDecoration(border: pw.Border.all(color: _darkColor), borderRadius: pw.BorderRadius.circular(2)),
              // color: Colors.amber,
              child: pw.Padding(
                padding: const pw.EdgeInsets.all(0),
                child: pw.Column(
                  children: [
                    pw.Expanded(
                      child: pw.Center(
                        child: pw.Padding(padding: const pw.EdgeInsets.all(5.0), child: pw.Text('Previous dues', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: _darkColor))),
                      ),
                    ),
                    pw.Container(height: 0.5, color: _darkColor),
                    pw.Expanded(
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.SizedBox(
                          height: 25,
                          child: pw.Text(
                            instInvoice.totalcaculationtable.previousdues,
                            style: const pw.TextStyle(
                              fontSize: 8,
                              // fontWeight: pw.FontWeight.bold,
                              color: _darkColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        // ignore: prefer_const_constructors
        if (instInvoice.billPlanDetails.showPending == 0)
          pw.Padding(padding: const pw.EdgeInsets.all(8.0), child: pw.Text('-', style: pw.TextStyle(color: _darkColor, fontSize: 10, fontWeight: pw.FontWeight.bold))),
        if (instInvoice.billPlanDetails.showPending == 0)
          pw.Expanded(
            child: pw.Container(
              height: 60,
              decoration: pw.BoxDecoration(border: pw.Border.all(color: _darkColor), borderRadius: pw.BorderRadius.circular(2)),
              // color: Colors.amber,
              child: pw.Padding(
                padding: const pw.EdgeInsets.all(0),
                child: pw.Column(
                  children: [
                    pw.Expanded(
                      child: pw.Center(
                        child: pw.Padding(padding: const pw.EdgeInsets.all(5.0), child: pw.Text('Payments', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: _darkColor))),
                      ),
                    ),
                    pw.Container(height: 0.5, color: _darkColor),
                    pw.Expanded(
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          instInvoice.totalcaculationtable.payment,
                          style: const pw.TextStyle(
                            fontSize: 8,
                            // fontWeight: pw.FontWeight.bold,
                            color: _darkColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        // ignore: prefer_const_constructors
        if (instInvoice.billPlanDetails.showPending == 0)
          pw.Padding(padding: const pw.EdgeInsets.all(8.0), child: pw.Text('+', style: pw.TextStyle(color: _darkColor, fontSize: 10, fontWeight: pw.FontWeight.bold))),
        if (instInvoice.billPlanDetails.showPending == 0)
          pw.Expanded(
            child: pw.Container(
              height: 60,
              decoration: pw.BoxDecoration(border: pw.Border.all(color: _darkColor), borderRadius: pw.BorderRadius.circular(2)),
              // color: Colors.amber,
              child: pw.Padding(
                padding: const pw.EdgeInsets.all(0),
                child: pw.Column(
                  children: [
                    pw.Expanded(
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(textAlign: pw.TextAlign.center, 'Adjustments/ Deductions', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: _darkColor)),
                      ),
                    ),
                    pw.Container(height: 0.5, color: _darkColor),
                    pw.Expanded(
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          instInvoice.totalcaculationtable.adjustments_deduction,
                          style: const pw.TextStyle(
                            fontSize: 8,
                            // fontWeight: pw.FontWeight.bold,
                            color: _darkColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        // ignore: prefer_const_constructors
        if (instInvoice.billPlanDetails.showPending == 0)
          pw.Padding(padding: const pw.EdgeInsets.all(8.0), child: pw.Text('+', style: pw.TextStyle(color: _darkColor, fontSize: 10, fontWeight: pw.FontWeight.bold))),

        pw.Expanded(
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Container(
                width: instInvoice.billPlanDetails.showPending == 0 ? null : 200,
                height: 60,
                decoration: pw.BoxDecoration(border: pw.Border.all(color: _darkColor), borderRadius: pw.BorderRadius.circular(2)),
                // color: Colors.amber,
                child: pw.Padding(
                  padding: const pw.EdgeInsets.all(0),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Expanded(
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.all(5.0),
                          child: pw.Align(child: pw.Text(textAlign: pw.TextAlign.center, 'Current Charges', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: _darkColor))),
                        ),
                      ),
                      pw.Container(height: 0.5, color: _darkColor),
                      pw.Expanded(
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.SizedBox(
                            // height: 25,
                            child: pw.Text(
                              textAlign: pw.TextAlign.center,
                              // '156745765476456000',
                              instInvoice.finalCalc.total.toString(),
                              style: pw.TextStyle(fontSize: 8, color: _darkColor, height: 2.3, fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // ignore: prefer_const_constructors
        pw.Padding(padding: const pw.EdgeInsets.all(8.0), child: pw.Text('=', style: pw.TextStyle(color: _darkColor, fontSize: 10, fontWeight: pw.FontWeight.bold))),
        pw.Expanded(
          flex: instInvoice.billPlanDetails.showPending == 0 ? 2 : 1,
          child: pw.Row(
            children: [
              pw.Container(
                width: instInvoice.billPlanDetails.showPending == 0 ? null : 200,
                height: 60,
                decoration: pw.BoxDecoration(border: pw.Border.all(color: _darkColor), borderRadius: pw.BorderRadius.circular(2)),
                // color: Colors.amber,
                child: pw.Padding(
                  padding: const pw.EdgeInsets.all(0),
                  child: pw.Column(
                    children: [
                      pw.Expanded(child: pw.Center(child: pw.Text('Total amount Due', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: _darkColor)))),
                      pw.Container(height: 0.5, color: _darkColor),
                      pw.Expanded(
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.SizedBox(
                            height: 25,
                            child: pw.Text(
                              textAlign: pw.TextAlign.center,
                              formatCurrencyRoundedPaisa(totalDue),
                              // '156745765476456000',
                              style: pw.TextStyle(fontSize: 8, color: _darkColor, height: 2.3, fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // ignore: prefer_const_constructors
      ],
    );
  }

  pw.Alignment _getAlignment(int columnIndex) {
    if (columnIndex == 4) {
      return pw.Alignment.centerRight; // Align Monthly Charges to right
    }
    return pw.Alignment.centerLeft; // Default left alignment
  }

  pw.Widget Local_tax_table(pw.Context context) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Expanded(child: Local_final_amount(context)),
        pw.SizedBox(width: 2),
        pw.Container(
          padding: const pw.EdgeInsets.only(bottom: 0, left: 0),
          height: 270,
          // width: 180,
          child: pw.Image(secureshutterImage),
        ),
      ],
    );
  }

  pw.Widget Local_final_amount(pw.Context context) {
    return pw.Column(
      children: [
        pw.Container(
          height: 100,
          // width: 185, // Define width to ensure bounded constraints
          decoration: pw.BoxDecoration(borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)), border: pw.Border.all(color: _darkColor, width: 1)),
          child: pw.Row(
            children: [
              pw.Expanded(
                flex: 3,
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Container(
                      // width: 285,
                      height: 20,
                      color: const PdfColor.fromInt(0xFF808080),
                      child: pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Expanded(
                            flex: 3,
                            child: pw.Padding(
                              padding: const pw.EdgeInsets.only(
                                // top: 3,
                                left: 10,
                              ),
                              child: pw.Center(child: pw.Text('Current summary of Charges', style: pw.TextStyle(font: Helvetica_bold, fontSize: 10, color: PdfColors.white))),
                            ),
                          ),
                          // pw.Expanded(
                          //   flex: 1,
                          //   child: pw.Padding(
                          //     padding: const pw.EdgeInsets.only(
                          //       // top: 3,
                          //       right: 10,
                          //     ),
                          //     child: pw.Text('Amount', style: pw.TextStyle(font: Helvetica_bold, fontSize: 10, color: PdfColors.white)),
                          //   ),
                          // )
                        ],
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(left: 10, right: 10),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          bold('${instInvoice.billPlanDetails.planName} - Monthly charges', 10),

                          // regular(formatzero(instInvoice.finalCalc.subtotal), 10),
                        ],
                      ),
                    ),
                    pw.Divider(color: accentColor),
                    // pw.SizedBox(height: 8),
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(left: 10, right: 10),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          // bold('CGST       :', 10),
                          // regular(formatzero(instInvoice.finalCalc.cgst), 10),
                        ],
                      ),
                    ),
                    pw.Divider(color: accentColor),
                    // pw.SizedBox(height: 8),
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(left: 10, right: 10),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          // bold('SGST       :', 10),
                          // regular(formatzero(instInvoice.finalCalc.sgst), 10),
                        ],
                      ),
                    ),
                    pw.Divider(color: accentColor),
                    // pw.SizedBox(height: 8),
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(left: 10, right: 10),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          bold('Sub total', 10),
                          // regular(instInvoice.finalCalc.roundOff, 10),
                        ],
                      ),
                    ),

                    pw.SizedBox(height: 10),
                    // pw.SizedBox(height: 8),
                    // pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [regular('Pending', 12), regular("Rs. ${instInvoice.finalCalc.pendingAmount.toString()}", 12)]),
                    // pw.SizedBox(height: 8),
                    // pw.Divider(color: accentColor),
                    // pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [bold('Grand Total', 12), bold("Rs. ${formatCurrencyRoundedPaisa(instInvoice.finalCalc.grandTotal)}", 12)]),
                  ],
                ),
              ),
              pw.Expanded(
                flex: 1,
                child: pw.Container(
                  decoration: const pw.BoxDecoration(border: pw.Border(left: pw.BorderSide(color: _darkColor))),
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.Container(
                        // width: 285,
                        height: 20,
                        color: const PdfColor.fromInt(0xFF808080),
                        child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            // pw.Expanded(
                            //   flex: 3,
                            //   child: pw.Padding(
                            //     padding: const pw.EdgeInsets.only(
                            //       // top: 3,
                            //       left: 10,
                            //     ),
                            //     child: pw.Text('Current summary of Charges', style: pw.TextStyle(font: Helvetica_bold, fontSize: 10, color: PdfColors.white)),
                            //   ),
                            // ),
                            pw.Expanded(
                              flex: 1,
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.only(
                                  // top: 3,
                                  left: 10,
                                ),
                                child: pw.Text('Amount', style: pw.TextStyle(font: Helvetica_bold, fontSize: 10, color: PdfColors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      pw.SizedBox(height: 8),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 10, right: 10),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            // regular('Sub total   :', 10),
                            bold(formatzero(instInvoice.finalCalc.subtotal), 10),
                          ],
                        ),
                      ),
                      pw.Divider(color: accentColor),
                      // pw.SizedBox(height: 8),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 10, right: 10),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            // regular('CGST       :', 10),
                            // bold(formatzero(instInvoice.finalCalc.cgst), 10),
                          ],
                        ),
                      ),
                      pw.Divider(color: accentColor),
                      // pw.SizedBox(height: 8),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 10, right: 10),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            // regular('SGST       :', 10),
                            // bold(formatzero(instInvoice.finalCalc.sgst), 10),
                          ],
                        ),
                      ),
                      pw.Divider(color: accentColor),
                      // pw.SizedBox(height: 8),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 10, right: 10),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            // regular('Round off : ${instInvoice.finalCalc.differene}', 10),
                            bold(formatzero(instInvoice.finalCalc.subtotal), 10),
                          ],
                        ),
                      ),

                      pw.SizedBox(height: 10),
                      // pw.SizedBox(height: 8),
                      // pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [regular('Pending', 12), regular("Rs. ${instInvoice.finalCalc.pendingAmount.toString()}", 12)]),
                      // pw.SizedBox(height: 8),
                      // pw.Divider(color: accentColor),
                      // pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [bold('Grand Total', 12), bold("Rs. ${formatCurrencyRoundedPaisa(instInvoice.finalCalc.grandTotal)}", 12)]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        pw.Container(
          height: isGST_Local(instInvoice.customerAccountDetails.customerGSTIN) ? 120 : 100,
          // width: 185, // Define width to ensure bounded constraints
          decoration: pw.BoxDecoration(borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)), border: pw.Border.all(color: _darkColor, width: 1)),
          child: pw.Row(
            children: [
              pw.Expanded(
                flex: 3,
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Container(
                      // width: 285,
                      height: 20,
                      color: const PdfColor.fromInt(0xFF808080),
                      child: pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Expanded(
                            flex: 3,
                            child: pw.Padding(
                              padding: const pw.EdgeInsets.only(
                                // top: 3,
                                left: 10,
                              ),
                              child: pw.Center(child: pw.Text('Taxes', style: pw.TextStyle(font: Helvetica_bold, fontSize: 10, color: PdfColors.white))),
                            ),
                          ),
                          // pw.Expanded(
                          //   flex: 1,
                          //   child: pw.Padding(
                          //     padding: const pw.EdgeInsets.only(
                          //       // top: 3,
                          //       right: 10,
                          //     ),
                          //     child: pw.Text('Amount', style: pw.TextStyle(font: Helvetica_bold, fontSize: 10, color: PdfColors.white)),
                          //   ),
                          // )
                        ],
                      ),
                    ),
                    pw.SizedBox(height: 8),

                    // pw.SizedBox(height: 8),
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(left: 10, right: 10),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          isGST_Local(instInvoice.customerAccountDetails.customerGSTIN)
                              ? bold('CGST - ${(instInvoice.gstPercent / 2).round().toString()} %', 10)
                              : bold('IGST - ${(instInvoice.gstPercent).round().toString()} %', 10),
                          // regular(formatzero(instInvoice.finalCalc.cgst), 10),
                        ],
                      ),
                    ),
                    if (isGST_Local(instInvoice.customerAccountDetails.customerGSTIN)) pw.Divider(color: accentColor),
                    // pw.SizedBox(height: 8),
                    if (isGST_Local(instInvoice.customerAccountDetails.customerGSTIN))
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 10, right: 10),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            bold('SGST - ${(instInvoice.gstPercent / 2).round().toString()} %', 10),
                            // regular(formatzero(instInvoice.finalCalc.sgst), 10),
                          ],
                        ),
                      ),
                    pw.Divider(color: accentColor),
                    // pw.SizedBox(height: 8),
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(left: 10, right: 10),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          bold('Round off ', 10),
                          // regular(instInvoice.finalCalc.roundOff, 10),
                        ],
                      ),
                    ),
                    pw.Divider(color: accentColor),
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(left: 10, right: 10),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          bold('Total Current Charges', 10),
                          // bold("Rs.${formatCurrencyRoundedPaisa(instInvoice.finalCalc.total)}", 12),
                        ],
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    // pw.SizedBox(height: 8),
                    // pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [regular('Pending', 12), regular("Rs. ${instInvoice.finalCalc.pendingAmount.toString()}", 12)]),
                    // pw.SizedBox(height: 8),
                    // pw.Divider(color: accentColor),
                    // pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [bold('Grand Total', 12), bold("Rs. ${formatCurrencyRoundedPaisa(instInvoice.finalCalc.grandTotal)}", 12)]),
                  ],
                ),
              ),
              pw.Expanded(
                flex: 1,
                child: pw.Container(
                  decoration: const pw.BoxDecoration(border: pw.Border(left: pw.BorderSide(color: _darkColor))),
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.Container(
                        // width: 285,
                        height: 20,
                        color: const PdfColor.fromInt(0xFF808080),
                        child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            // pw.Expanded(
                            //   flex: 3,
                            //   child: pw.Padding(
                            //     padding: const pw.EdgeInsets.only(
                            //       // top: 3,
                            //       left: 10,
                            //     ),
                            //     child: pw.Text('Current summary of Charges', style: pw.TextStyle(font: Helvetica_bold, fontSize: 10, color: PdfColors.white)),
                            //   ),
                            // ),
                            pw.Expanded(
                              flex: 1,
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.only(
                                  // top: 3,
                                  left: 10,
                                ),
                                child: pw.Text('', style: pw.TextStyle(font: Helvetica_bold, fontSize: 10, color: PdfColors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      pw.SizedBox(height: 8),

                      // pw.SizedBox(height: 8),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 10, right: 10),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            // regular('CGST       :', 10),
                            isGST_Local(instInvoice.customerAccountDetails.customerGSTIN) ? bold(formatzero(instInvoice.finalCalc.cgst), 10) : bold(formatzero(instInvoice.finalCalc.igst), 10),
                          ],
                        ),
                      ),
                      if (isGST_Local(instInvoice.customerAccountDetails.customerGSTIN)) pw.Divider(color: accentColor),
                      // pw.SizedBox(height: 8),
                      if (isGST_Local(instInvoice.customerAccountDetails.customerGSTIN))
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(left: 10, right: 10),
                          child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              // regular('SGST       :', 10),
                              bold(formatzero(instInvoice.finalCalc.sgst), 10),
                            ],
                          ),
                        ),
                      pw.Divider(color: accentColor),
                      // pw.SizedBox(height: 8),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 10, right: 10),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            // regular('Round off : ${instInvoice.finalCalc.differene}', 10),
                            bold(instInvoice.finalCalc.differene, 10),
                          ],
                        ),
                      ),
                      pw.Divider(color: accentColor),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 10, right: 10),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            // bold('Total', 12),
                            bold(formatzero(instInvoice.finalCalc.subtotal), 10),
                          ],
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      // pw.SizedBox(height: 8),
                      // pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [regular('Pending', 12), regular("Rs. ${instInvoice.finalCalc.pendingAmount.toString()}", 12)]),
                      // pw.SizedBox(height: 8),
                      // pw.Divider(color: accentColor),
                      // pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [bold('Grand Total', 12), bold("Rs. ${formatCurrencyRoundedPaisa(instInvoice.finalCalc.grandTotal)}", 12)]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        pw.Container(
          height: 50,
          // width: 185, // Define width to ensure bounded constraints
          decoration: pw.BoxDecoration(borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)), border: pw.Border.all(color: _darkColor, width: 1)),
          child: pw.Padding(
            padding: const pw.EdgeInsets.only(left: 10, right: 8, top: 2, bottom: 2),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                regular('This invoice is generated by Sporada Secure India Private Limited  ', 7),
                regular('You can make payment through RTGS / NEFT / IMPS to below bank', 7),
                regular('details : Account name : Sporada Secure India Private Limited     ', 7),
                regular('Account type : Current account Account Number : 257399850001     ', 7),
                regular('IFS Code : INDB0000521 Bank name : IndusInd Bank Limited     ', 7),
                regular('Branch : R.S. Puram branch, Coimbatore.', 7),
              ],
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget footerSpare(pw.Context context) {
    return pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // if (context.pagesCount > 1 && context.pageNumber < context.pagesCount)
        //   pw.Padding(
        //     padding: const pw.EdgeInsets.only(bottom: 10),
        //     child: regular('continue...', 12),
        //   ),
        pw.Container(
          color: const PdfColor.fromInt(0xFF9EDA67), // Lime green background              decoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFF9EDA67)),
          padding: const pw.EdgeInsets.all(5),
          child: pw.Align(
            alignment: pw.Alignment.center,
            child: pw.Column(
              children: [
                pw.Container(
                  padding: const pw.EdgeInsets.only(top: 10, bottom: 2),
                  child: pw.RichText(
                    text: pw.TextSpan(
                      children: [
                        pw.TextSpan(text: 'CIN Number: U30007TZ2020PTC03414 - ', style: pw.TextStyle(font: Helvetica_bold, fontSize: 12, color: PdfColors.black)),
                        pw.WidgetSpan(
                          child: pw.Container(
                            color: PdfColors.yellow,
                            padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                            child: pw.Text('GSTIN: 33ABECS0625B1Z0', style: pw.TextStyle(font: Helvetica_bold, fontSize: 12, color: PdfColors.black)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                footerRegular('Telephone: +91-422-2312363, E-mail: support@ sporadasecure.com, Website: www.sporadasecure.com', 10),
                // footerRegular('Telephone: +91-422-2312363, E-mail: sales@sporadasecure.com, Website: www.sporadasecure.com', 8),
                // pw.SizedBox(height: 2),
                // footerRegular('CIN: U30007TZ2020PTC03414  |  GSTIN: 33ABECS0625B1Z0', 8),
              ],
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildRichSiteText(String combined) {
    final parts = combined.split('||');
    final siteName = parts[0];
    final address = parts.length > 1 ? parts[1] : '';

    return pw.RichText(
      text: pw.TextSpan(
        children: [
          pw.TextSpan(text: siteName, style: pw.TextStyle(font: Helvetica_bold, fontSize: 10, color: _darkColor)),
          pw.TextSpan(text: '\n$address', style: pw.TextStyle(font: Helvetica, fontSize: 10, color: _darkColor)),
        ],
      ),
    );
  }
}
