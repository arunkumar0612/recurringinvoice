import 'dart:convert';
import 'package:recurring_invoice/models/entities/Invoice_entities.dart';

mixin InvoiceServices {
  static Invoice parseInvoice(String jsonString) {
    final Map<String, dynamic> jsonData = json.decode(jsonString);

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
    );

    // Parse Customer Account Details
    CustomerAccountDetails customerAccount = CustomerAccountDetails(
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

    return Invoice(
      date: jsonData["date"],
      invoiceNo: jsonData["invoiceNo"],
      gstPercent: jsonData['gstPercent'],
      pendingAmount: pendingAmount,
      addressDetails: address,
      billPlanDetails: billPlan,
      customerAccountDetails: customerAccount,
      siteData: sites,
      finalCalc: finalCalc,
    );
  }
}
