// // ignore_for_file: non_constant_identifier_names

// import 'package:flutter/services.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:pdf/pdf.dart';
// import 'package:recurring_invoice/models/entities/Invoice_entities.dart';
// import 'package:recurring_invoice/utils/helpers/support_functions.dart';

// class QuotationTemplate {
//   QuotationTemplate({required this.instInvoice});

//   final Invoice instInvoice;
//   final PdfColor baseColor = PdfColors.green500;
//   final PdfColor accentColor = PdfColors.blueGrey900;
//   static const _darkColor = PdfColors.blueGrey800;

//   late pw.MemoryImage profileImage;

//   // Function to build the PDF
//   Future<Uint8List> buildPdf(PdfPageFormat pageFormat) async {
//     // Load fonts asynchronously
//     Helvetica = await loadFont_regular();
//     Helvetica_bold = await loadFont_bold();

//     // Load profile image
//     final imageData = await rootBundle.load('assets/images/sporadaResized.jpeg');
//     profileImage = pw.MemoryImage(imageData.buffer.asUint8List());

//     // Create PDF document
//     final doc = pw.Document();

//     doc.addPage(
//       pw.MultiPage(
//         pageTheme: pw.PageTheme(pageFormat: PdfPageFormat.a4, margin: const pw.EdgeInsets.only(left: 20, right: 20, bottom: 20)),
//         header: (context) => header(context),
//         footer: (context) => footer(context),
//         build:
//             (context) => [
//               pw.Container(child: to_addr(context)),
//               pw.SizedBox(height: 10),
//               pw.Container(child: account_details(context)),
//               pw.SizedBox(height: 10),
//               contentTable(context),
//               pw.SizedBox(height: 10),
//               tax_table(context),
//             ],
//       ),
//     );

//     // Return the PDF file as a Uint8List
//     return doc.save();
//   }

//   pw.Widget header(pw.Context context) {
//     return pw.Container(
//       child: pw.Column(
//         children: [
//           pw.Row(
//             mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: pw.CrossAxisAlignment.center,
//             children: [
//               pw.Align(alignment: pw.Alignment.centerLeft, child: pw.Container(padding: const pw.EdgeInsets.only(bottom: 0, left: 0), height: 80, child: pw.Image(profileImage))),
//               pw.Padding(padding: const pw.EdgeInsets.only(left: 30), child: pw.Text('INVOICE', style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold, color: accentColor))),
//               pw.Align(
//                 alignment: pw.Alignment.centerRight,
//                 child: pw.Container(
//                   height: 120,
//                   child: pw.Row(
//                     children: [
//                       pw.Column(
//                         mainAxisAlignment: pw.MainAxisAlignment.center,
//                         crossAxisAlignment: pw.CrossAxisAlignment.start,
//                         children: [
//                           regular('Date', 10),
//                           pw.SizedBox(height: 5),
//                           regular('Invoice no', 10),
//                           // pw.SizedBox(height: 5),
//                           // regular('Relationship ID', 10),
//                         ],
//                       ),
//                       pw.Column(
//                         mainAxisAlignment: pw.MainAxisAlignment.center,
//                         crossAxisAlignment: pw.CrossAxisAlignment.start,
//                         children: [
//                           regular('  :  ', 10),
//                           pw.SizedBox(height: 5),
//                           regular('  :  ', 10),
//                           // pw.SizedBox(height: 5),
//                           // regular('  :  ', 10),
//                         ],
//                       ),
//                       pw.Column(
//                         mainAxisAlignment: pw.MainAxisAlignment.center,
//                         crossAxisAlignment: pw.CrossAxisAlignment.start,
//                         children: [
//                           pw.Container(
//                             child: pw.Align(
//                               alignment: pw.Alignment.centerLeft,
//                               child: regular(formatDate(DateTime.now()), 10),
//                               // formatDate(DateTime.now()), 10
//                             ),
//                           ),
//                           pw.SizedBox(height: 5),
//                           pw.Container(child: pw.Align(alignment: pw.Alignment.centerLeft, child: regular(instInvoice.invoiceNo, 10))),
//                           // pw.SizedBox(height: 5),
//                           // pw.Container(
//                           //   child: pw.Align(
//                           //     alignment: pw.Alignment.centerLeft,
//                           //     child: regular("3873870201", 10),
//                           //   ),
//                           // ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   pw.Widget to_addr(pw.Context context) {
//     return pw.Row(
//       crossAxisAlignment: pw.CrossAxisAlignment.start,
//       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//       children: [
//         pw.Expanded(
//           child: pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               pw.Container(
//                 // width: 285,
//                 height: 20,
//                 decoration: pw.BoxDecoration(borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)), color: baseColor, border: pw.Border.all(color: baseColor, width: 1)),
//                 child: pw.Row(
//                   crossAxisAlignment: pw.CrossAxisAlignment.center,
//                   children: [
//                     pw.Padding(
//                       padding: const pw.EdgeInsets.only(
//                         // top: 3,
//                         left: 10,
//                       ),
//                       child: pw.Text('CLIENT ADDRESS', style: pw.TextStyle(font: Helvetica_bold, fontSize: 10, color: PdfColors.white)),
//                     ),
//                   ],
//                 ),
//               ),
//               pw.SizedBox(height: 10),
//               pw.Padding(
//                 padding: const pw.EdgeInsets.symmetric(horizontal: 10),
//                 child: pw.Text(
//                   // 'Khivraj Vahan Private Limited',
//                   instInvoice.addressDetails.clientName,
//                   textAlign: pw.TextAlign.start,
//                   style: pw.TextStyle(font: Helvetica_bold, fontSize: 10, lineSpacing: 2, color: _darkColor),
//                   softWrap: true,
//                 ),
//               ),
//               pw.SizedBox(height: 4),
//               pw.Padding(
//                 padding: const pw.EdgeInsets.symmetric(horizontal: 10),
//                 child: pw.Text(
//                   // 'Plot No: 21, Industrial Estate,Ambattur Chennai - 600 058Tamilnadu',
//                   instInvoice.addressDetails.clientAddress,
//                   textAlign: pw.TextAlign.start,
//                   style: pw.TextStyle(font: Helvetica, fontSize: 8, lineSpacing: 3, color: _darkColor),
//                   softWrap: true, // Ensure text wraps within the container
//                 ),
//               ),
//             ],
//           ),
//         ),
//         pw.SizedBox(width: 10),
//         pw.Expanded(
//           child: pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               pw.Container(
//                 // width: 285,
//                 height: 20,
//                 decoration: pw.BoxDecoration(borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)), color: baseColor, border: pw.Border.all(color: baseColor, width: 1)),
//                 child: pw.Row(
//                   crossAxisAlignment: pw.CrossAxisAlignment.center,
//                   children: [
//                     pw.Padding(
//                       padding: const pw.EdgeInsets.only(
//                         // top: 3,
//                         left: 10,
//                       ),
//                       child: pw.Text('BILLING ADDRESS', style: pw.TextStyle(font: Helvetica_bold, fontSize: 10, color: PdfColors.white)),
//                     ),
//                   ],
//                 ),
//               ),
//               pw.SizedBox(height: 10),
//               pw.Padding(
//                 padding: const pw.EdgeInsets.symmetric(horizontal: 10),
//                 child: pw.Text(
//                   // 'Khivraj Vahan Private Limited',
//                   instInvoice.addressDetails.billingName,
//                   textAlign: pw.TextAlign.start,
//                   style: pw.TextStyle(font: Helvetica_bold, fontSize: 10, lineSpacing: 2, color: _darkColor),
//                   softWrap: true,
//                 ),
//               ),
//               pw.SizedBox(height: 4),
//               pw.Padding(
//                 padding: const pw.EdgeInsets.symmetric(horizontal: 10),
//                 child: pw.Text(
//                   // 'Plot No: 21, Industrial Estate,Ambattur Chennai - 600 058Tamilnadu',
//                   instInvoice.addressDetails.billingAddress,
//                   textAlign: pw.TextAlign.start,
//                   style: pw.TextStyle(font: Helvetica, fontSize: 8, lineSpacing: 2, color: _darkColor),
//                   softWrap: true,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   pw.Widget account_details(pw.Context context) {
//     return pw.Row(
//       crossAxisAlignment: pw.CrossAxisAlignment.start,
//       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//       children: [
//         pw.Expanded(
//           child: pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               pw.Container(
//                 // width: 285,
//                 height: 20,
//                 decoration: pw.BoxDecoration(borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)), color: baseColor, border: pw.Border.all(color: baseColor, width: 1)),
//                 child: pw.Row(
//                   crossAxisAlignment: pw.CrossAxisAlignment.center,
//                   children: [
//                     pw.Padding(
//                       padding: const pw.EdgeInsets.only(
//                         // top: 3,
//                         left: 10,
//                       ),
//                       child: pw.Text('BILL PLAN DETAILS', style: pw.TextStyle(font: Helvetica_bold, fontSize: 10, color: PdfColors.white)),
//                     ),
//                   ],
//                 ),
//               ),
//               pw.SizedBox(height: 10),
//               pw.Row(
//                 children: [
//                   pw.Expanded(
//                     child: pw.Padding(
//                       padding: const pw.EdgeInsets.symmetric(horizontal: 10),
//                       child: pw.Text('Plan name ', textAlign: pw.TextAlign.start, style: pw.TextStyle(font: Helvetica_bold, fontSize: 10, lineSpacing: 2, color: _darkColor), softWrap: true),
//                     ),
//                   ),
//                   pw.Expanded(
//                     child: pw.Padding(
//                       padding: const pw.EdgeInsets.symmetric(horizontal: 10),
//                       child: pw.Text(
//                         // 'Secure - 360°',
//                         instInvoice.billPlanDetails.planName,
//                         textAlign: pw.TextAlign.start,
//                         style: pw.TextStyle(font: Helvetica, fontSize: 8, lineSpacing: 3, color: _darkColor),
//                         softWrap: true, // Ensure text wraps within the container
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               pw.SizedBox(height: 4),
//               pw.Row(
//                 children: [
//                   pw.Expanded(
//                     child: pw.Padding(
//                       padding: const pw.EdgeInsets.symmetric(horizontal: 10),
//                       child: pw.Text('Customer type', textAlign: pw.TextAlign.start, style: pw.TextStyle(font: Helvetica_bold, fontSize: 10, lineSpacing: 2, color: _darkColor), softWrap: true),
//                     ),
//                   ),
//                   pw.Expanded(
//                     child: pw.Padding(
//                       padding: const pw.EdgeInsets.symmetric(horizontal: 10),
//                       child: pw.Text(
//                         // 'Corporate',
//                         instInvoice.billPlanDetails.customerType,
//                         textAlign: pw.TextAlign.start,
//                         style: pw.TextStyle(font: Helvetica, fontSize: 8, lineSpacing: 3, color: _darkColor),
//                         softWrap: true, // Ensure text wraps within the container
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               pw.SizedBox(height: 4),
//               pw.Row(
//                 children: [
//                   pw.Expanded(
//                     child: pw.Padding(
//                       padding: const pw.EdgeInsets.symmetric(horizontal: 10),
//                       child: pw.Text('Plan charges', textAlign: pw.TextAlign.start, style: pw.TextStyle(font: Helvetica_bold, fontSize: 10, lineSpacing: 2, color: _darkColor), softWrap: true),
//                     ),
//                   ),
//                   pw.Expanded(
//                     child: pw.Padding(
//                       padding: const pw.EdgeInsets.symmetric(horizontal: 10),
//                       child: pw.Text(
//                         // 'Annexed',
//                         instInvoice.billPlanDetails.planCharges,
//                         textAlign: pw.TextAlign.start,
//                         style: pw.TextStyle(font: Helvetica, fontSize: 8, lineSpacing: 3, color: _darkColor),
//                         softWrap: true, // Ensure text wraps within the container
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               pw.SizedBox(height: 4),
//               pw.Row(
//                 children: [
//                   pw.Expanded(
//                     child: pw.Padding(
//                       padding: const pw.EdgeInsets.symmetric(horizontal: 10),
//                       child: pw.Text('Internet charges', textAlign: pw.TextAlign.start, style: pw.TextStyle(font: Helvetica_bold, fontSize: 10, lineSpacing: 2, color: _darkColor), softWrap: true),
//                     ),
//                   ),
//                   pw.Expanded(
//                     child: pw.Padding(
//                       padding: const pw.EdgeInsets.symmetric(horizontal: 10),
//                       child: pw.Text(
//                         // '0.00°',
//                         instInvoice.billPlanDetails.internetCharges.toString(),
//                         textAlign: pw.TextAlign.start,
//                         style: pw.TextStyle(font: Helvetica, fontSize: 8, lineSpacing: 3, color: _darkColor),
//                         softWrap: true, // Ensure text wraps within the container
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               pw.SizedBox(height: 4),
//               pw.Row(
//                 children: [
//                   pw.Expanded(
//                     child: pw.Padding(
//                       padding: const pw.EdgeInsets.symmetric(horizontal: 10),
//                       child: pw.Text('Bill Period', textAlign: pw.TextAlign.start, style: pw.TextStyle(font: Helvetica_bold, fontSize: 10, lineSpacing: 2, color: _darkColor), softWrap: true),
//                     ),
//                   ),
//                   pw.Expanded(
//                     child: pw.Padding(
//                       padding: const pw.EdgeInsets.symmetric(horizontal: 10),
//                       child: pw.Text(
//                         // '01/ 01 / 2025 - 31 / 01 /2025',
//                         instInvoice.billPlanDetails.billPeriod,
//                         textAlign: pw.TextAlign.start,
//                         style: pw.TextStyle(font: Helvetica, fontSize: 8, lineSpacing: 3, color: _darkColor),
//                         softWrap: true, // Ensure text wraps within the container
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               pw.SizedBox(height: 4),
//               pw.Row(
//                 children: [
//                   pw.Expanded(
//                     child: pw.Padding(
//                       padding: const pw.EdgeInsets.symmetric(horizontal: 10),
//                       child: pw.Text('Bill date', textAlign: pw.TextAlign.start, style: pw.TextStyle(font: Helvetica_bold, fontSize: 10, lineSpacing: 2, color: _darkColor), softWrap: true),
//                     ),
//                   ),
//                   pw.Expanded(
//                     child: pw.Padding(
//                       padding: const pw.EdgeInsets.symmetric(horizontal: 10),
//                       child: pw.Text(
//                         // '01 / 01 / 2025',
//                         instInvoice.billPlanDetails.billDate,
//                         textAlign: pw.TextAlign.start,
//                         style: pw.TextStyle(font: Helvetica, fontSize: 8, lineSpacing: 3, color: _darkColor),
//                         softWrap: true, // Ensure text wraps within the container
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               pw.SizedBox(height: 4),
//               pw.Row(
//                 children: [
//                   pw.Expanded(
//                     child: pw.Padding(
//                       padding: const pw.EdgeInsets.symmetric(horizontal: 10),
//                       child: pw.Text('Due date', textAlign: pw.TextAlign.start, style: pw.TextStyle(font: Helvetica_bold, fontSize: 10, lineSpacing: 2, color: _darkColor), softWrap: true),
//                     ),
//                   ),
//                   pw.Expanded(
//                     child: pw.Padding(
//                       padding: const pw.EdgeInsets.symmetric(horizontal: 10),
//                       child: pw.Text(
//                         // '07 / 01 / 2025',
//                         instInvoice.billPlanDetails.dueDate,
//                         textAlign: pw.TextAlign.start,
//                         style: pw.TextStyle(font: Helvetica, fontSize: 8, lineSpacing: 3, color: _darkColor),
//                         softWrap: true, // Ensure text wraps within the container
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         pw.SizedBox(width: 10),
//         pw.Expanded(
//           child: pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               pw.Container(
//                 // width: 285,
//                 height: 20,
//                 decoration: pw.BoxDecoration(borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)), color: baseColor, border: pw.Border.all(color: baseColor, width: 1)),
//                 child: pw.Row(
//                   crossAxisAlignment: pw.CrossAxisAlignment.center,
//                   children: [
//                     pw.Padding(
//                       padding: const pw.EdgeInsets.only(
//                         // top: 3,
//                         left: 10,
//                       ),
//                       child: pw.Text('CUSTOMER ACCOUNT DETAILS', style: pw.TextStyle(font: Helvetica_bold, fontSize: 10, color: PdfColors.white)),
//                     ),
//                   ],
//                 ),
//               ),
//               pw.SizedBox(height: 10),
//               pw.Row(
//                 children: [
//                   pw.Expanded(
//                     child: pw.Padding(
//                       padding: const pw.EdgeInsets.symmetric(horizontal: 10),
//                       child: pw.Text('Relationship ID', textAlign: pw.TextAlign.start, style: pw.TextStyle(font: Helvetica_bold, fontSize: 10, lineSpacing: 2, color: _darkColor), softWrap: true),
//                     ),
//                   ),
//                   pw.Expanded(
//                     child: pw.Padding(
//                       padding: const pw.EdgeInsets.symmetric(horizontal: 10),
//                       child: pw.Text(
//                         // 'KV-CI-AR',
//                         instInvoice.customerAccountDetails.relationshipId,
//                         textAlign: pw.TextAlign.start,
//                         style: pw.TextStyle(font: Helvetica, fontSize: 8, lineSpacing: 3, color: _darkColor),
//                         softWrap: true, // Ensure text wraps within the container
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               pw.SizedBox(height: 4),
//               pw.Row(
//                 children: [
//                   pw.Expanded(
//                     child: pw.Padding(
//                       padding: const pw.EdgeInsets.symmetric(horizontal: 10),
//                       child: pw.Text('Bill number', textAlign: pw.TextAlign.start, style: pw.TextStyle(font: Helvetica_bold, fontSize: 10, lineSpacing: 2, color: _darkColor), softWrap: true),
//                     ),
//                   ),
//                   pw.Expanded(
//                     child: pw.Padding(
//                       padding: const pw.EdgeInsets.symmetric(horizontal: 10),
//                       child: pw.Text(
//                         // 'KVCIAR/250101',
//                         instInvoice.customerAccountDetails.billNumber,
//                         textAlign: pw.TextAlign.start,
//                         style: pw.TextStyle(font: Helvetica, fontSize: 8, lineSpacing: 3, color: _darkColor),
//                         softWrap: true, // Ensure text wraps within the container
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               pw.SizedBox(height: 4),
//               pw.Row(
//                 children: [
//                   pw.Expanded(
//                     child: pw.Padding(
//                       padding: const pw.EdgeInsets.symmetric(horizontal: 10),
//                       child: pw.Text('Customer GSTIN', textAlign: pw.TextAlign.start, style: pw.TextStyle(font: Helvetica_bold, fontSize: 10, lineSpacing: 2, color: _darkColor), softWrap: true),
//                     ),
//                   ),
//                   pw.Expanded(
//                     child: pw.Padding(
//                       padding: const pw.EdgeInsets.symmetric(horizontal: 10),
//                       child: pw.Text(
//                         // '33AADCK2098J1ZF',
//                         instInvoice.customerAccountDetails.customerGSTIN,
//                         textAlign: pw.TextAlign.start,
//                         style: pw.TextStyle(font: Helvetica, fontSize: 8, lineSpacing: 3, color: _darkColor),
//                         softWrap: true, // Ensure text wraps within the container
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               pw.SizedBox(height: 4),
//               pw.Row(
//                 children: [
//                   pw.Expanded(
//                     child: pw.Padding(
//                       padding: const pw.EdgeInsets.symmetric(horizontal: 10),
//                       child: pw.Text('HSN / SAC Code', textAlign: pw.TextAlign.start, style: pw.TextStyle(font: Helvetica_bold, fontSize: 10, lineSpacing: 2, color: _darkColor), softWrap: true),
//                     ),
//                   ),
//                   pw.Expanded(
//                     child: pw.Padding(
//                       padding: const pw.EdgeInsets.symmetric(horizontal: 10),
//                       child: pw.Text(
//                         // '998319',
//                         instInvoice.customerAccountDetails.hsnSacCode,
//                         textAlign: pw.TextAlign.start,
//                         style: pw.TextStyle(font: Helvetica, fontSize: 8, lineSpacing: 3, color: _darkColor),
//                         softWrap: true, // Ensure text wraps within the container
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               pw.SizedBox(height: 4),
//               pw.Row(
//                 children: [
//                   pw.Expanded(
//                     child: pw.Padding(
//                       padding: const pw.EdgeInsets.symmetric(horizontal: 10),
//                       child: pw.Text('Customer PO', textAlign: pw.TextAlign.start, style: pw.TextStyle(font: Helvetica_bold, fontSize: 10, lineSpacing: 2, color: _darkColor), softWrap: true),
//                     ),
//                   ),
//                   pw.Expanded(
//                     child: pw.Padding(
//                       padding: const pw.EdgeInsets.symmetric(horizontal: 10),
//                       child: pw.Text(
//                         // 'AAAAAAAAAAAAAAA',
//                         instInvoice.customerAccountDetails.customerPO,
//                         textAlign: pw.TextAlign.start,
//                         style: pw.TextStyle(font: Helvetica, fontSize: 8, lineSpacing: 3, color: _darkColor),
//                         softWrap: true, // Ensure text wraps within the container
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               pw.SizedBox(height: 4),
//               pw.Row(
//                 children: [
//                   pw.Expanded(
//                     child: pw.Padding(
//                       padding: const pw.EdgeInsets.symmetric(horizontal: 10),
//                       child: pw.Text('Contact person', textAlign: pw.TextAlign.start, style: pw.TextStyle(font: Helvetica_bold, fontSize: 10, lineSpacing: 2, color: _darkColor), softWrap: true),
//                     ),
//                   ),
//                   pw.Expanded(
//                     child: pw.Padding(
//                       padding: const pw.EdgeInsets.symmetric(horizontal: 10),
//                       child: pw.Text(
//                         // ' Mr. Thulasinathan',
//                         instInvoice.customerAccountDetails.contactPerson,
//                         textAlign: pw.TextAlign.start,
//                         style: pw.TextStyle(font: Helvetica, fontSize: 8, lineSpacing: 3, color: _darkColor),
//                         softWrap: true, // Ensure text wraps within the container
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               pw.SizedBox(height: 4),
//               pw.Row(
//                 children: [
//                   pw.Expanded(
//                     child: pw.Padding(
//                       padding: const pw.EdgeInsets.symmetric(horizontal: 10),
//                       child: pw.Text('Contact number', textAlign: pw.TextAlign.start, style: pw.TextStyle(font: Helvetica_bold, fontSize: 10, lineSpacing: 2, color: _darkColor), softWrap: true),
//                     ),
//                   ),
//                   pw.Expanded(
//                     child: pw.Padding(
//                       padding: const pw.EdgeInsets.symmetric(horizontal: 10),
//                       child: pw.Text(
//                         // '+91-984-145-6250',
//                         instInvoice.customerAccountDetails.contactNumber,
//                         textAlign: pw.TextAlign.start,
//                         style: pw.TextStyle(font: Helvetica, fontSize: 8, lineSpacing: 3, color: _darkColor),
//                         softWrap: true, // Ensure text wraps within the container
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   pw.Widget contentTable(pw.Context context) {
//     const tableHeaders = ['S.No', 'Site ID', 'Site Name', 'Address', 'Monthly Charges'];

//     return pw.Table(
//       border: null,
//       columnWidths: {
//         0: const pw.FlexColumnWidth(1), // S.No (Small width)
//         1: const pw.FlexColumnWidth(2), // Site Name (Medium width)
//         2: const pw.FlexColumnWidth(3), // Address (Larger width)
//         3: const pw.FlexColumnWidth(4), // Customer ID (Medium width)
//         4: const pw.FlexColumnWidth(2), // Monthly Charges (Medium width)
//       },
//       children: [
//         // Header Row
//         pw.TableRow(
//           decoration: pw.BoxDecoration(borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)), color: baseColor),
//           children:
//               tableHeaders.map((header) {
//                 return pw.Container(
//                   padding: const pw.EdgeInsets.all(5),
//                   alignment: pw.Alignment.centerLeft,
//                   child: pw.Text(header, style: pw.TextStyle(font: Helvetica_bold, color: PdfColors.white, fontSize: 10, fontWeight: pw.FontWeight.bold)),
//                 );
//               }).toList(),
//         ),
//         // Data Rows
//         ...List.generate(instInvoice.siteData.length, (row) {
//           return pw.TableRow(
//             decoration: pw.BoxDecoration(
//               color: row % 2 == 0 ? PdfColors.green50 : PdfColors.white, // Alternate row colors
//             ),
//             children: List.generate(
//               tableHeaders.length,
//               (col) => pw.Container(
//                 padding: const pw.EdgeInsets.all(5),
//                 alignment: _getAlignment(col),
//                 child: pw.Text(instInvoice.siteData[row].getIndex(col).toString(), style: pw.TextStyle(font: Helvetica, color: _darkColor, fontSize: 10)),
//               ),
//             ),
//           );
//         }),
//       ],
//     );
//   }

//   // Function to set alignment for each column
//   pw.Alignment _getAlignment(int columnIndex) {
//     if (columnIndex == 4) {
//       return pw.Alignment.centerRight; // Align Monthly Charges to right
//     }
//     return pw.Alignment.centerLeft; // Default left alignment
//   }

//   pw.Widget tax_table(pw.Context context) {
//     return pw.Column(
//       children: [
//         pw.Row(
//           crossAxisAlignment: pw.CrossAxisAlignment.center,
//           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//           children: [
//             pw.Container(
//               decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey700)),
//               // height: 200,
//               // width: 300, // Ensure the container has a defined width
//               child: pw.Column(
//                 // border: pw.TableBorder.all(color: PdfColors.grey700, width: 1),
//                 children: [
//                   pw.Row(
//                     children: [
//                       pw.Container(
//                         decoration: const pw.BoxDecoration(border: pw.Border(right: pw.BorderSide(color: PdfColors.grey700))),
//                         height: 38,
//                         width: 80,
//                         child: pw.Center(
//                           child: pw.Text(
//                             "Taxable\nvalue",
//                             style: pw.TextStyle(
//                               font: Helvetica,

//                               fontSize: 10,
//                               color: PdfColors.grey700,
//                               // fontWeight: pw.FontWeight.bold,
//                             ),
//                             textAlign: pw.TextAlign.center, // Justifying the text
//                           ),
//                         ),
//                       ),
//                       pw.Container(
//                         height: 38,
//                         child: pw.Column(
//                           children: [
//                             pw.Container(
//                               width: 110,
//                               decoration: const pw.BoxDecoration(border: pw.Border(right: pw.BorderSide(color: PdfColors.grey700))),
//                               height: 19, // Replace Expanded with defined height
//                               child: pw.Center(child: regular('CGST', 10)),
//                             ),
//                             pw.Container(
//                               height: 19, // Define height instead of Expanded
//                               child: pw.Row(
//                                 children: [
//                                   pw.Container(
//                                     width: 40, // Define width instead of Expanded
//                                     decoration: const pw.BoxDecoration(border: pw.Border(top: pw.BorderSide(color: PdfColors.grey700), bottom: pw.BorderSide(color: PdfColors.grey700))),
//                                     child: pw.Center(child: regular('%', 10)),
//                                   ),
//                                   pw.Container(
//                                     width: 70, // Define width instead of Expanded
//                                     decoration: const pw.BoxDecoration(
//                                       border: pw.Border(right: pw.BorderSide(color: PdfColors.grey700), top: pw.BorderSide(color: PdfColors.grey700), left: pw.BorderSide(color: PdfColors.grey700)),
//                                     ),
//                                     child: pw.Center(child: regular('amount', 10)),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       pw.Container(
//                         height: 38,
//                         child: pw.Column(
//                           children: [
//                             pw.Container(
//                               height: 19, // Replace Expanded with defined height
//                               child: pw.Center(child: regular('SGST', 10)),
//                             ),
//                             pw.Container(
//                               height: 19, // Define height instead of Expanded
//                               child: pw.Row(
//                                 children: [
//                                   pw.Container(
//                                     width: 40, // Define width instead of Expanded
//                                     decoration: const pw.BoxDecoration(border: pw.Border(top: pw.BorderSide(color: PdfColors.grey700))),
//                                     child: pw.Center(child: regular('%', 10)),
//                                   ),
//                                   pw.Container(
//                                     width: 70, // Define width instead of Expanded
//                                     decoration: const pw.BoxDecoration(
//                                       border: pw.Border(right: pw.BorderSide(color: PdfColors.grey700), top: pw.BorderSide(color: PdfColors.grey700), left: pw.BorderSide(color: PdfColors.grey700)),
//                                     ),
//                                     child: pw.Center(child: regular('amount', 10)),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),

//                   pw.Row(
//                     children: [
//                       pw.Container(
//                         decoration: const pw.BoxDecoration(border: pw.Border(right: pw.BorderSide(color: PdfColors.grey700), top: pw.BorderSide(color: PdfColors.grey700))),
//                         width: 80,
//                         height: 38,
//                         child: pw.Center(child: regular(formatzero(instInvoice.finalCalc.subtotal), 10)),
//                       ),
//                       pw.Container(
//                         height: 38,
//                         child: pw.Row(
//                           children: [
//                             pw.Container(
//                               decoration: const pw.BoxDecoration(border: pw.Border(top: pw.BorderSide(color: PdfColors.grey700))),
//                               width: 40, // Define width instead of Expanded
//                               child: pw.Center(child: regular((instInvoice.gstPercent / 2).toString(), 10)),
//                             ),
//                             pw.Container(
//                               width: 70, // Define width instead of Expanded
//                               decoration: const pw.BoxDecoration(
//                                 border: pw.Border(right: pw.BorderSide(color: PdfColors.grey700), top: pw.BorderSide(color: PdfColors.grey700), left: pw.BorderSide(color: PdfColors.grey700)),
//                               ),
//                               child: pw.Center(child: regular(formatzero(instInvoice.finalCalc.cgst), 10)),
//                             ),
//                           ],
//                         ),
//                       ),
//                       pw.Container(
//                         height: 38,
//                         child: pw.Row(
//                           children: [
//                             pw.Container(
//                               decoration: const pw.BoxDecoration(border: pw.Border(top: pw.BorderSide(color: PdfColors.grey700))),
//                               width: 40, // Define width instead of Expanded
//                               child: pw.Center(child: regular((instInvoice.gstPercent / 2).toString(), 10)),
//                             ),
//                             pw.Container(
//                               width: 70, // Define width instead of Expanded
//                               decoration: const pw.BoxDecoration(border: pw.Border(left: pw.BorderSide(color: PdfColors.grey700), top: pw.BorderSide(color: PdfColors.grey700))),
//                               child: pw.Center(child: regular(formatzero(instInvoice.finalCalc.sgst), 10)),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),

//                   // pw.ListView.builder(
//                   //   itemCount: invoice_gstTotals.length, // Number of items in the list
//                   //   itemBuilder: (context, index) {
//                   //     return pw.Row(
//                   //       children: [
//                   //         pw.Container(
//                   //           decoration: const pw.BoxDecoration(border: pw.Border(right: pw.BorderSide(color: PdfColors.grey700), top: pw.BorderSide(color: PdfColors.grey700))),
//                   //           width: 80,
//                   //           height: 38,
//                   //           child: pw.Center(child: regular(formatzero(instInvoice.siteData[index].monthlyCharges), 10)),
//                   //         ),
//                   //         pw.Container(
//                   //           height: 38,
//                   //           child: pw.Row(
//                   //             children: [
//                   //               pw.Container(
//                   //                 decoration: const pw.BoxDecoration(border: pw.Border(top: pw.BorderSide(color: PdfColors.grey700))),
//                   //                 width: 40, // Define width instead of Expanded
//                   //                 child: pw.Center(child: regular((invoice_gstTotals[index].gst / 2).toString(), 10)),
//                   //               ),
//                   //               pw.Container(
//                   //                 width: 70, // Define width instead of Expanded
//                   //                 decoration: const pw.BoxDecoration(
//                   //                   border: pw.Border(right: pw.BorderSide(color: PdfColors.grey700), top: pw.BorderSide(color: PdfColors.grey700), left: pw.BorderSide(color: PdfColors.grey700)),
//                   //                 ),
//                   //                 child: pw.Center(child: regular(formatzero(((invoice_gstTotals[index].total.toInt() / 100) * (invoice_gstTotals[index].gst / 2))), 10)),
//                   //               ),
//                   //             ],
//                   //           ),
//                   //         ),
//                   //         pw.Container(
//                   //           height: 38,
//                   //           child: pw.Row(
//                   //             children: [
//                   //               pw.Container(
//                   //                 decoration: const pw.BoxDecoration(border: pw.Border(top: pw.BorderSide(color: PdfColors.grey700))),
//                   //                 width: 40, // Define width instead of Expanded
//                   //                 child: pw.Center(child: regular((invoice_gstTotals[index].gst / 2).toString(), 10)),
//                   //               ),
//                   //               pw.Container(
//                   //                 width: 70, // Define width instead of Expanded
//                   //                 decoration: const pw.BoxDecoration(border: pw.Border(left: pw.BorderSide(color: PdfColors.grey700), top: pw.BorderSide(color: PdfColors.grey700))),
//                   //                 child: pw.Center(child: regular(formatzero(((invoice_gstTotals[index].total.toInt() / 100) * (invoice_gstTotals[index].gst / 2))), 10)),
//                   //               ),
//                   //             ],
//                   //           ),
//                   //         ),
//                   //       ],
//                   //     );
//                   //   },
//                   // ),
//                 ],
//               ),
//             ),
//             pw.Padding(padding: const pw.EdgeInsets.only(right: 5), child: final_amount(context)),
//           ],
//         ),
//         pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [notes(context), pw.SizedBox(width: 100)]),
//       ],
//     );
//   }

//   pw.Widget notes(pw.Context context) {
//     return pw.Container(
//       width: 280,
//       child: pw.Column(
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         children: [
//           pw.SizedBox(height: 30),
//           pw.Padding(child: bold("Note", 12), padding: const pw.EdgeInsets.only(left: 0, bottom: 10)),
//           ...List.generate(instInvoice.notes.length, (index) {
//             return pw.Padding(
//               padding: pw.EdgeInsets.only(left: 0, top: index == 0 ? 0 : 8),
//               child: pw.Row(
//                 crossAxisAlignment: pw.CrossAxisAlignment.start,
//                 children: [
//                   regular("${index + 1}.", 10),
//                   pw.SizedBox(width: 5),
//                   pw.Expanded(
//                     child: pw.Text(instInvoice.notes[index], textAlign: pw.TextAlign.start, style: pw.TextStyle(font: Helvetica, fontSize: 10, lineSpacing: 2, color: PdfColors.blueGrey800)),
//                   ),
//                 ],
//               ),
//             );
//           }),
//           pw.Padding(
//             padding: const pw.EdgeInsets.only(left: 0, top: 5),
//             child: pw.Row(
//               crossAxisAlignment: pw.CrossAxisAlignment.start,
//               children: [
//                 regular("${instInvoice.notes.length + 1}.", 10),
//                 pw.SizedBox(width: 5),
//                 pw.Expanded(
//                   child: pw.Column(
//                     crossAxisAlignment: pw.CrossAxisAlignment.start,
//                     children: [
//                       bold("Bank Account Details:", 10),
//                       pw.SizedBox(height: 5), // Adds a small space between the lines
//                       pw.Row(children: [regular("Current a/c:", 10), pw.SizedBox(width: 5), regular("257399850001", 10)]),
//                       pw.SizedBox(height: 5),
//                       pw.Row(children: [regular("IFSC code:", 10), pw.SizedBox(width: 5), regular("INDB0000521", 10)]),
//                       pw.SizedBox(height: 5),
//                       pw.Row(children: [regular("Bank name:", 10), pw.SizedBox(width: 5), regular(": IndusInd Bank Limited", 10)]),
//                       pw.SizedBox(height: 5),
//                       pw.Row(children: [regular("Branch name:", 10), pw.SizedBox(width: 5), regular("R.S. Puram, Coimbatore.", 10)]),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   pw.Widget final_amount(pw.Context context) {
//     return pw.Container(
//       width: 185, // Define width to ensure bounded constraints
//       child: pw.Column(
//         mainAxisAlignment: pw.MainAxisAlignment.start,
//         children: [
//           pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [regular('Sub total   :', 10), regular(formatzero(instInvoice.finalCalc.subtotal), 10)]),
//           pw.SizedBox(height: 8),
//           pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [regular('CGST       :', 10), regular(formatzero(instInvoice.finalCalc.cgst), 10)]),
//           pw.SizedBox(height: 8),
//           pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [regular('SGST       :', 10), regular(formatzero(instInvoice.finalCalc.sgst), 10)]),
//           pw.SizedBox(height: 8),
//           pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [regular('Round off : ${instInvoice.finalCalc.differene}', 10), regular(instInvoice.finalCalc.roundOff, 10)]),
//           pw.Divider(color: accentColor),
//           pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [regular('Total', 12), regular("Rs.${formatCurrencyRoundedPaisa(instInvoice.finalCalc.total)}", 12)]),
//           pw.SizedBox(height: 8),
//           pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [regular('Pending', 12), regular("Rs. ${instInvoice.finalCalc.pendingAmount.toString()}", 12)]),
//           // pw.SizedBox(height: 8),
//           pw.Divider(color: accentColor),
//           pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [bold('Grand Total', 12), bold("Rs. ${formatCurrencyRoundedPaisa(instInvoice.finalCalc.grandTotal)}", 12)]),
//         ],
//       ),
//     );
//   }

//   pw.Widget footer(pw.Context context) {
//     return pw.Column(
//       mainAxisAlignment: pw.MainAxisAlignment.end,
//       crossAxisAlignment: pw.CrossAxisAlignment.start,
//       children: [
//         pw.SizedBox(height: 20),
//         if (context.pagesCount > 1)
//           if (context.pageNumber < context.pagesCount) pw.Column(children: [pw.Padding(padding: const pw.EdgeInsets.only(top: 20), child: regular('continue...', 12))]),
//         pw.Align(
//           alignment: pw.Alignment.center,
//           child: pw.Column(
//             children: [
//               pw.Container(padding: const pw.EdgeInsets.only(top: 10, bottom: 2), child: bold('SPORADA SECURE INDIA PRIVATE LIMITED', 12)),
//               regular('687/7, 3rd Floor, Sakthivel Towers, Trichy road, Ramanathapuram, Coimbatore - 641045', 8),
//               regular('Telephone: +91-422-2312363, E-mail: sales@sporadasecure.com, Website: www.sporadasecure.com', 8),
//               pw.SizedBox(height: 2),
//               regular('CIN: U30007TZ2020PTC03414  |  GSTIN: 33ABECS0625B1Z0', 8),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
