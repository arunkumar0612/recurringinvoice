// ignore_for_file: file_names

import 'dart:io';

import 'package:recurring_invoice/utils/helpers/support_functions.dart';

class Site {
  static int _counter = 1; // Static counter to auto-increment serial numbers
  final String serialNo;
  final String siteName;
  final String address;
  final int siteID;
  final String branchCode;
  final double monthlyCharges;

  Site({required this.siteName, required this.address, required this.siteID, required this.branchCode, required this.monthlyCharges})
    : serialNo = (_counter++).toString(); // Auto-increment serial number

  // Convert List of JSON Maps to List of Site objects
  static List<Site> fromJson(List<Map<String, dynamic>> jsonList) {
    _counter = 1; // Reset counter before parsing a new list

    return jsonList.map((json) {
      return Site(
        siteName: (json['site_name'] as String).trim(), // Trim applied
        address: (json['address'] as String).trim(), // Trim applied
        siteID: json['site_id'] as int,
        branchCode: json['branchcode'] as String,
        monthlyCharges: (json['monthly_charges'] as num).toDouble(),
      );
    }).toList();
  }

  // Convert List of Site objects to JSON List
  static List<Map<String, dynamic>> toJsonList(List<Site> sites) {
    return sites.map((site) => site.toJson()).toList();
  }

  // Convert single Site object to JSON
  Map<String, dynamic> toJson() {
    return {'serialNo': serialNo, 'siteName': siteName, 'address': address, 'siteID': siteID, 'branchcode': branchCode, 'monthlyCharges': monthlyCharges};
  }

  // dynamic getIndex(int col) {
  //   switch (col) {
  //     case 0:
  //       return serialNo.toString().trim();
  //     case 1:
  //       return siteID.toString().trim();
  //     case 2:
  //       return siteName.trim();
  //     case 3:
  //       return address.trim();
  //     case 4:
  //       return monthlyCharges.toString().trim();
  //     default:
  //       return "";
  //   }
  // }

  dynamic getIndex(int col) {
    switch (col) {
      case 0:
        return serialNo;
      case 1:
        return "$siteName||$address"; // Using '||' as a separator
      case 2:
        return branchCode;
      case 3:
        return monthlyCharges;
      default:
        return "";
    }
  }
}

class Address {
  final String clientName;
  final String clientAddress;
  final String billingName;
  final String billingAddress;

  Address({required this.clientName, required this.clientAddress, required this.billingName, required this.billingAddress});

  // Convert JSON to Address object
  factory Address.fromJson(Map<String, dynamic> json) {
    String clean(String value) => value.trim().replaceAll(RegExp(r',\s+'), ', ');

    return Address(
      clientName: clean(json['clientName'] as String),
      clientAddress: clean(json['clientAddress'] as String),
      billingName: clean(json['billingName'] as String),
      billingAddress: clean(json['billingAddress'] as String),
    );
  }

  // Convert Address object to JSON
  Map<String, dynamic> toJson() {
    return {'clientName': clientName, 'clientAddress': clientAddress, 'billingName': billingName, 'billingAddress': billingAddress};
  }
}

class ContactDetails {
  final String email;
  final String ccEmail;
  final String phone;

  ContactDetails({required this.email, required this.ccEmail, required this.phone});

  // Convert JSON to ContactDetails object
  factory ContactDetails.fromJson(Map<String, dynamic> json) {
    return ContactDetails(email: (json['emailid'] as String).trim(), ccEmail: (json['ccemail'] as String).trim(), phone: (json['phoneno'] as String).trim());
  }

  // Convert ContactDetails object to JSON
  Map<String, dynamic> toJson() {
    return {'email': email, 'ccemail': ccEmail, 'phone': phone};
  }
}

// class TotalcaculationTable {
//   final String previousdues;
//   final String payment;
//   final String adjustments_deduction;
//   final String currentcharges;
//   final String totalamountdue;
//   TotalcaculationTable({required this.previousdues, required this.payment, required this.adjustments_deduction, required this.currentcharges, required this.totalamountdue});

//   // Convert JSON to Address object
//   factory TotalcaculationTable.fromJson(Map<String, dynamic> json) {
//     return TotalcaculationTable(
//       previousdues: json['previousdues'] as String,
//       payment: json['payment'] as String,
//       adjustments_deduction: json['adjustments_deduction'] as String,
//       currentcharges: json['currentcharges'] as String,
//       totalamountdue: json['totalamountdue'] as String,
//     );
//   }

//   // Convert Address object to JSON
//   Map<String, dynamic> toJson() {
//     return {'previousdues': previousdues, 'payment': payment, 'adjustments_deduction': adjustments_deduction, 'currentcharges': currentcharges, 'totalamountdue': totalamountdue};
//   }
// }

class BillPlanDetails {
  final String planName;
  final String customerType;
  final String planCharges;
  final double internetCharges;
  final String billPeriod;
  final String billDate;
  final String dueDate;
  final int subscriptionBillId;
  final String planType;
  final String billMode;
  final String amountPaid;
  final String pendingPayments;
  final String tdsDeductions;
  final int showPending;

  BillPlanDetails({
    required this.planName,
    required this.customerType,
    required this.planCharges,
    required this.internetCharges,
    required this.billPeriod,
    required this.billDate,
    required this.dueDate,
    required this.subscriptionBillId,
    required this.planType,
    required this.billMode,
    required this.amountPaid,
    required this.pendingPayments,
    required this.tdsDeductions,
    required this.showPending,
  });

  // Convert JSON to BillPlanDetails object
  factory BillPlanDetails.fromJson(Map<String, dynamic> json) {
    return BillPlanDetails(
      planName: (json['planName'] as String).trim(),
      customerType: (json['customerType'] as String).trim(),
      planCharges: (json['planCharges'] as String).trim(),
      internetCharges: (json['internetCharges'] as num).toDouble(),
      billPeriod: (json['billPeriod'] as String).trim(),
      billDate: (json['billDate'] as String).trim(),
      dueDate: (json['dueDate'] as String).trim(),
      subscriptionBillId: json['subscription_billid'] as int,
      planType: (json['billmode'] as String).trim(),
      billMode: (json['plantype'] as String).trim(),
      amountPaid: (json['amountpaid'] as String).trim(),
      pendingPayments: (json['pendingpayments'] as String).trim(),
      tdsDeductions: (json['tdsdeductions'] as String).trim(),
      showPending: json['showpending'] as int,
    );
  }

  // Convert BillPlanDetails object to JSON
  Map<String, dynamic> toJson() {
    return {
      'planName': planName,
      'customerType': customerType,
      'planCharges': planCharges,
      'internetCharges': internetCharges,
      'billPeriod': billPeriod,
      'billDate': billDate,
      'dueDate': dueDate,
      'plantype': planType,
      'billmode': billMode,
      'amountpaid': amountPaid,
      'pendingpayments': pendingPayments,
      'tdsdeductions': tdsDeductions,
      'showpending': showPending,
    };
  }
}

class CustomerAccountDetails {
  final String consolidate_email;
  final int customerID;
  final String relationshipId;
  final String billNumber;
  final String customerGSTIN;
  final String hsnSacCode;
  final String customerPO;
  final String contactPerson;
  final String contactNumber;

  CustomerAccountDetails({
    required this.consolidate_email,
    required this.customerID,
    required this.relationshipId,
    required this.billNumber,
    required this.customerGSTIN,
    required this.hsnSacCode,
    required this.customerPO,
    required this.contactPerson,
    required this.contactNumber,
  });

  // Convert JSON to CustomerAccountDetails object
  factory CustomerAccountDetails.fromJson(Map<String, dynamic> json) {
    return CustomerAccountDetails(
      consolidate_email: (json['consolidate_email'] as String).trim(),
      customerID: json['customerid'] as int,
      relationshipId: (json['relationshipId'] as String).trim(),
      billNumber: (json['billNumber'] as String).trim(),
      customerGSTIN: (json['customerGSTIN'] as String).trim(),
      hsnSacCode: (json['hsnSacCode'] as String).trim(),
      customerPO: (json['customerPO'] as String).trim(),
      contactPerson: (json['contactPerson'] as String).trim(),
      contactNumber: (json['contactNumber'] as String).trim(),
    );
  }

  // Convert CustomerAccountDetails object to JSON
  Map<String, dynamic> toJson() {
    return {
      'consolidate_email': consolidate_email,
      'customerid': customerID,
      'relationshipId': relationshipId,
      'billNumber': billNumber,
      'customerGSTIN': customerGSTIN,
      'hsnSacCode': hsnSacCode,
      'customerPO': customerPO,
      'contactPerson': contactPerson,
      'contactNumber': contactNumber,
    };
  }
}

class Invoice {
  final String date;
  final String invoiceNo;
  final double? pendingAmount;
  final int gstPercent;
  final Address addressDetails;
  final BillPlanDetails billPlanDetails;
  final CustomerAccountDetails customerAccountDetails;
  final ContactDetails contactDetails;
  final List<Site> siteData;
  final FinalCalculation finalCalc;
  final List<String> notes;
  final List<PendingInvoices> pendingInvoices;
  // final TotalcaculationTable totalcaculationtable;

  Invoice({
    required this.date,
    required this.invoiceNo,
    required this.gstPercent,
    required this.pendingAmount,
    required this.addressDetails,
    required this.billPlanDetails,
    required this.contactDetails,
    required this.customerAccountDetails,
    required this.siteData,
    required this.finalCalc,
    required this.notes,
    required this.pendingInvoices,
    // required this.totalcaculationtable,
  });

  // Convert JSON to Invoice object
  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      date: (json['date'] as String).trim(),
      invoiceNo: (json['invoiceNo'] as String).trim(),
      gstPercent: json['gstPercent'] as int,
      pendingAmount: json['pendingAmount'] as double,
      addressDetails: Address.fromJson(json['addressDetails']),
      billPlanDetails: BillPlanDetails.fromJson(json['billPlanDetails']),
      contactDetails: ContactDetails.fromJson(json['contactdetails']),
      customerAccountDetails: CustomerAccountDetails.fromJson(json['customerAccDetails']),
      siteData: Site.fromJson(List<Map<String, dynamic>>.from(json['siteData'])),
      finalCalc: FinalCalculation.fromJson(Site.fromJson(List<Map<String, dynamic>>.from(json['siteData'])), json['gstPercent'] as int, json['pendingAmount'] as double),
      notes: ['This is a sample note', 'This is another sample note'],
      pendingInvoices: [],
      // totalcaculationtable: TotalcaculationTable.fromJson(json['totalcaculationtable']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.trim(),
      'invoiceNo': invoiceNo.trim(),
      'pendingAmount': pendingAmount,
      'gstPercent': gstPercent,
      'billPlanDetails': billPlanDetails.toJson(),
      'contactdetails': contactDetails.toJson(),
      'customerAccDetails': customerAccountDetails.toJson(),
      'siteData': Site.toJsonList(siteData),
      'finalCalc': finalCalc.toJson(),
      'addressDetails': addressDetails.toJson(),
      'notes': notes.map((e) => e.trim()).toList(),
      // 'totalcaculationtable': totalcaculationtable,
    };
  }
}

class PendingInvoices {
  static int _counter = 1;
  final String serialNo;
  final String invoiceid;
  final String duedate;
  final String overduedays;
  final double charges;

  PendingInvoices(this.invoiceid, this.duedate, this.overduedays, this.charges) : serialNo = (_counter++).toString();

  // Convert JSON (Map) to PendingInvoices object
  factory PendingInvoices.fromJson(Map<String, dynamic> json) {
    _counter = 1;
    return PendingInvoices(json['invoiceid'] ?? '', json['duedate'] ?? '', json['overduedays'].toString(), double.parse(json['charges'] ?? 0.0));
  }

  // Convert PendingInvoices object to JSON (Map)
  Map<String, dynamic> toJson() {
    return {'serialNo': serialNo, 'invoiceid': invoiceid, 'duedate': duedate, 'overduedays': overduedays, 'charges': charges};
  }

  // Convert List<Map<String, dynamic>> to List<PendingInvoices>
  static List<PendingInvoices> fromJsonList(List<Map<String, dynamic>>? jsonList) {
    if (jsonList == null || jsonList.isEmpty) return [];
    return jsonList.map((json) => PendingInvoices.fromJson(json)).toList();
  }

  dynamic getIndex(int col) {
    switch (col) {
      case 0:
        return serialNo;
      case 1:
        return invoiceid;
      case 2:
        return duedate;
      case 3:
        return overduedays;
      case 4:
        return charges;
      default:
        return "";
    }
  }
}

class FinalCalculation {
  final double subtotal;
  final double igst;
  final double cgst;
  final double sgst;
  final String roundOff;
  final String differene;
  final double total;
  final double? pendingAmount;
  final double grandTotal;

  FinalCalculation({
    required this.subtotal,
    required this.igst,
    required this.cgst,
    required this.sgst,
    required this.roundOff,
    required this.differene,
    required this.total,
    required this.pendingAmount,
    required this.grandTotal,
  });

  factory FinalCalculation.fromJson(List<Site> sites, int gstPercent, double? pendingAmount) {
    double subtotal = sites.fold(0.0, (sum, site) => sum + site.monthlyCharges);
    double igst = (subtotal * gstPercent) / 100;
    double cgst = (subtotal * (gstPercent / 2)) / 100;
    double sgst = (subtotal * (gstPercent / 2)) / 100;
    double total = subtotal + cgst + sgst;
    double grandTotal = pendingAmount != null ? total + pendingAmount : total;

    return FinalCalculation(
      subtotal: subtotal,
      igst: igst,
      cgst: cgst,
      sgst: sgst,
      roundOff: formatCurrencyRoundedPaisa(total),
      differene:
          '${((double.parse(formatCurrencyRoundedPaisa(total).replaceAll(',', '')) - total) >= 0 ? '+' : '')}${(double.parse(formatCurrencyRoundedPaisa(total).replaceAll(',', '')) - total).toStringAsFixed(2)}',
      total: total,
      pendingAmount: pendingAmount,
      grandTotal: grandTotal,
    );
  }

  Map<String, dynamic> toJson() {
    return {'subtotal': subtotal, 'IGST': igst, 'CGST': cgst, 'SGST': sgst, 'roundOff': roundOff, 'difference': differene, 'total': total, 'pendingAmount': pendingAmount, 'grandTotal': grandTotal};
  }
}

class PostData {
  List<int> siteIds;
  List<String> siteNames;
  int subscriptionBillId;
  int customerID;
  String clientAddressName;
  String clientAddress;
  String billingAddressName;
  String billingAddress;
  String planName;
  String emailId;
  String ccEmail;
  String phoneNo;
  String totalAmount;
  String invoiceGenId;
  String date;
  int messageType;
  String feedback;
  String planType;
  String billMode;
  String billPeriod;
  String dueDate;
  String amountpaid;
  String pendingpayments;

  PostData({
    required this.siteIds,
    required this.siteNames,
    required this.subscriptionBillId,
    required this.customerID,
    required this.clientAddressName,
    required this.clientAddress,
    required this.billingAddressName,
    required this.billingAddress,
    required this.planName,
    required this.emailId,
    required this.ccEmail,
    required this.phoneNo,
    required this.totalAmount,
    required this.invoiceGenId,
    required this.date,
    required this.messageType,
    required this.feedback,
    required this.planType,
    required this.billMode,
    required this.billPeriod,
    required this.dueDate,
    required this.amountpaid,
    required this.pendingpayments,
  });

  factory PostData.fromJson(Invoice data) {
    List<int> ids = [];
    List<String> names = [];
    for (var site in data.siteData) {
      ids.add(site.siteID);
      names.add(site.siteName.trim());
    }

    return PostData(
      siteIds: ids,
      siteNames: names,
      subscriptionBillId: data.billPlanDetails.subscriptionBillId,
      customerID: data.customerAccountDetails.customerID,
      clientAddressName: data.addressDetails.clientName.trim(),
      clientAddress: data.addressDetails.clientAddress.trim(),
      billingAddressName: data.addressDetails.billingName.trim(),
      billingAddress: data.addressDetails.billingName.trim(),
      planName: data.billPlanDetails.planName.trim(),
      emailId: data.contactDetails.email.trim(),
      ccEmail: data.contactDetails.ccEmail.trim(),
      phoneNo: data.contactDetails.phone.trim(),
      totalAmount: data.finalCalc.grandTotal.toString().trim(),
      invoiceGenId: data.invoiceNo.trim(),
      date: data.date.trim(),
      messageType: 3,
      feedback: "".trim(),
      planType: data.billPlanDetails.planType.trim(),
      billMode: data.billPlanDetails.billMode.trim(),
      billPeriod: data.billPlanDetails.billPeriod.trim(),
      dueDate: data.billPlanDetails.dueDate.trim(),
      amountpaid: data.billPlanDetails.amountPaid.trim(),
      pendingpayments: data.billPlanDetails.pendingPayments.trim(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "siteids": siteIds,
      "sitenames": siteNames,
      "subscriptionbillid": subscriptionBillId,
      "customerid": customerID,
      "clientaddressname": clientAddressName,
      "clientaddress": clientAddress,
      "billingaddressname": billingAddressName,
      "billingaddress": billingAddress,
      "planname": planName,
      "emailid": emailId,
      "ccemail": ccEmail,
      "phoneno": phoneNo,
      "totalamount": totalAmount,
      "invoicegenid": invoiceGenId,
      "date": date,
      "messagetype": messageType,
      "feedback": feedback,
      "plantype": planType,
      "billmode": billMode,
      "billperiod": billPeriod,
      "duedate": dueDate,
      "amountpaid": amountpaid,
      "pendingpayments": pendingpayments,
    };
  }
}

class InvoiceResult {
  final List<File> files;
  final Invoice invoice;

  InvoiceResult({required this.files, required this.invoice});
}
