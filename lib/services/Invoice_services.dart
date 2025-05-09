import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:recurring_invoice/models/entities/Invoice_entities.dart';
import 'package:recurring_invoice/services/APIservices/invoker.dart';

class InvoiceServices {
  static final Invoker apiController = Get.find<Invoker>();
  static Invoice parseInvoice(Map<String, dynamic> jsonData) {
    // final Map<String, dynamic> jsonData = json.decode(jsonString);

    // Parse Address
    Address address = Address(
      clientName: jsonData["address"]["client_addressname"],
      clientAddress: jsonData["address"]["client_address"],
      billingName: jsonData["address"]["billing_addressname"],
      billingAddress: jsonData["address"]["billing_address"],
    );

    // Parse Bill Plan Details
    BillPlanDetails billPlan = BillPlanDetails(
      planName: jsonData["billplandetails"]["planname"],
      customerType: jsonData["billplandetails"]["customertype"],
      planCharges: jsonData["billplandetails"]["plancharges"],
      internetCharges: (jsonData["billplandetails"]["internetcharges"] as num).toDouble(),
      billPeriod: jsonData["billplandetails"]["billperiod"],
      billDate: jsonData["billplandetails"]["billdate"],
      dueDate: jsonData["billplandetails"]["duedate"],
      subscriptionBillId: jsonData['billplandetails']['subscription_billid'],
      billMode: jsonData["billplandetails"]["billmode"],
      planType: jsonData["billplandetails"]["plantype"],
      pendingPayments: jsonData["billplandetails"]["pendingpayments"],
      amountPaid: jsonData["billplandetails"]["amountpaid"],
      tdsDeductions: jsonData["billplandetails"]["tdsdeductions"],
      showPending: jsonData["billplandetails"]["showpending"],
    );

    ContactDetails contactDetails = ContactDetails(email: jsonData["contactdetails"]["emailid"], ccEmail: jsonData["contactdetails"]["ccemail"], phone: jsonData["contactdetails"]["phoneno"]);
    // List<Map<String, dynamic>> jsonList = [
    //   {"serialNo": "1", "invoiceid": "8734ADHD", "duedate": "06 Dec 2024", "overduedays": "10 days", "charges": 150},
    //   {"serialNo": "2", "invoiceid": "87332DDH", "duedate": "10 Dec 2024", "overduedays": "8 days", "charges": 200},
    //   {"serialNo": "3", "invoiceid": "87332DDH", "duedate": "06 Dec 2024", "overduedays": "25 days", "charges": 180},
    //   {"serialNo": "4", "invoiceid": "87332DDH", "duedate": "06 Dec 2024", "overduedays": "11 days", "charges": 100},
    //   {"serialNo": "5", "invoiceid": "87332DDH", "duedate": "06 Dec 2024", "overduedays": "15 days", "charges": 250},
    // ];
    List<PendingInvoices> pendingInvoice = [];

    if (jsonData["previousPendingInvoices"] != null) {
      pendingInvoice = PendingInvoices.fromJsonList((jsonData["previousPendingInvoices"] as List<dynamic>).map((e) => Map<String, dynamic>.from(e)).toList());
    }

    // Parse Customer Account Details
    CustomerAccountDetails customerAccount = CustomerAccountDetails(
      consolidate_email: jsonData["customeraccountdetails"]["consolidate_email"],
      customerID: jsonData["customeraccountdetails"]["customerid"],
      relationshipId: jsonData["customeraccountdetails"]["relationshipid"],
      billNumber: jsonData["customeraccountdetails"]["billnumber"],
      customerGSTIN: jsonData["customeraccountdetails"]["customergstin"],
      hsnSacCode: jsonData["customeraccountdetails"]["hsncode"].toString(),
      customerPO: jsonData["customeraccountdetails"]["customerpo"],
      contactPerson: jsonData["customeraccountdetails"]["contactperson"],
      contactNumber: jsonData["customeraccountdetails"]["contactnumber"],
    );

    List<Site> sites = Site.fromJson(
      (jsonData["sitesubscription"] as List)
          .map((site) => site as Map<String, dynamic>) // Explicitly cast each item
          .toList(),
    );

    int gstPercent = jsonData["gstPercent"];
    double? pendingAmount = jsonData["pendingAmount"] != null ? (jsonData["pendingAmount"] as num).toDouble() : null;
    FinalCalculation finalCalc = FinalCalculation.fromJson(sites, gstPercent, pendingAmount);
    var bill = BillDetails(total: finalCalc.total, subtotal: finalCalc.subtotal, gst: GST(IGST: finalCalc.igst, CGST: finalCalc.cgst, SGST: finalCalc.sgst));
    return Invoice(
      date: jsonData["date"].trim(),
      invoiceNo: jsonData["invoiceNo"].trim(),
      gstPercent: jsonData['gstPercent'],
      pendingAmount: pendingAmount,
      addressDetails: address,
      billPlanDetails: billPlan,
      contactDetails: contactDetails,
      customerAccountDetails: customerAccount,
      siteData: sites,
      finalCalc: finalCalc,
      notes: ['This is a system generated invoice hence do not require signature.', 'Please make the payment on or before the due date.'],
      pendingInvoices: pendingInvoice,
      billdetails: bill.toJson(),
      // totalcaculationtable: TotalcaculationTable(previousdues: "15000", payment: "34343", adjustments_deduction: "32", currentcharges: "34", totalamountdue: "34343"),
    );
  }

  static dynamic apicall(List<InvoiceResult> Invoices, List<File> GeneratedInvoices, int count) async {
    try {
      List<PostData> jsonClub = [];

      for (int i = 0; i < Invoices.length; i++) {
        PostData salesData = PostData.fromJson(Invoices[i].invoice);
        jsonClub.add(salesData);
      }
      print("jsonclub : ${jsonClub.length} GeneratedInvoices : ${GeneratedInvoices.length}.................. count : $count");
      if (jsonClub.isNotEmpty && GeneratedInvoices.isNotEmpty && (jsonClub.length == GeneratedInvoices.length)) {
        await send_data(jsonEncode(jsonClub.map((e) => e.toJson()).toList()), GeneratedInvoices);
      } else {
        print("API not triggered!");
      }
    } catch (e) {
      print(e);
      // await Basic_dialog(context: context, title: "POST", content: "$e", onOk: () {}, showCancel: false);
    }
  }

  static dynamic send_data(String jsonData, List<File> GeneratedInvoices) async {
    try {
      Map<String, dynamic>? response = await apiController.Multer(jsonData, GeneratedInvoices, "http://192.168.0.200:8081/subscription/addrecurringinvoice");
      if (response['statusCode'] == 200) {
        print(response['data']);
        // CMDmResponse value = CMDmResponse.fromJson(response);
        // if (value.code) {
        //   await Basic_dialog(context: context, title: "Invoice", content: value.message!, onOk: () {}, showCancel: false);
        //   // Navigator.of(context).pop(true);
        //   // invoiceController.resetData();
        // } else {
        //   await Basic_dialog(context: context, title: 'Processing Invoice', content: value.message ?? "", onOk: () {}, showCancel: false);
        // }
      } else {
        // Basic_dialog(context: context, title: "SERVER DOWN", content: "Please contact administration!", showCancel: false);
      }
    } catch (e) {
      // Basic_dialog(context: context, title: "ERROR", content: "$e", showCancel: false);
    }
  }
}
