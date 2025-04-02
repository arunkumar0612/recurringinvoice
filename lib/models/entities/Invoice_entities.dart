// ignore_for_file: file_names

import 'dart:io';

import 'package:recurring_invoice/utils/helpers/support_functions.dart';

class Site {
  static int _counter = 1; // Static counter to auto-increment serial numbers
  final String serialNo;
  final String siteName;
  final String address;
  final int siteID;
  final double monthlyCharges;

  Site({required this.siteName, required this.address, required this.siteID, required this.monthlyCharges}) : serialNo = (_counter++).toString(); // Auto-increment serial number

  // Convert List of JSON Maps to List of Site objects
  static List<Site> fromJson(List<Map<String, dynamic>> jsonList) {
    _counter = 1; // Reset counter before parsing a new list

    return jsonList.map((json) {
      return Site(
        siteName: json['sitename'] as String, // Fix key casing
        address: json['address'] as String,
        siteID: json['siteid'] as int,
        monthlyCharges: (json['monthlycharges'] as num).toDouble(),
      );
    }).toList();
  }

  // Convert List of Site objects to JSON List
  static List<Map<String, dynamic>> toJsonList(List<Site> sites) {
    return sites.map((site) => site.toJson()).toList();
  }

  // Convert single Site object to JSON
  Map<String, dynamic> toJson() {
    return {'serialNo': serialNo, 'siteName': siteName, 'address': address, 'siteID': siteID, 'monthlyCharges': monthlyCharges};
  }

  dynamic getIndex(int col) {
    switch (col) {
      case 0:
        return serialNo;
      case 1:
        return siteID;
      case 2:
        return siteName;
      case 3:
        return address;
      case 4:
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
    return Address(
      clientName: json['clientName'] as String,
      clientAddress: json['clientAddress'] as String,
      billingName: json['billingName'] as String,
      billingAddress: json['billingAddress'] as String,
    );
  }

  // Convert Address object to JSON
  Map<String, dynamic> toJson() {
    return {'clientName': clientName, 'clientAddress': clientAddress, 'billingName': billingName, 'billingAddress': billingAddress};
  }
}

class ContactDetails {
  final String email;
  final String phone;

  ContactDetails({required this.email, required this.phone});

  // Convert JSON to Address object
  factory ContactDetails.fromJson(Map<String, dynamic> json) {
    return ContactDetails(email: json['emailid'] as String, phone: json['phoneno'] as String);
  }

  // Convert Address object to JSON
  Map<String, dynamic> toJson() {
    return {'email': email, 'phone': phone};
  }
}

class BillPlanDetails {
  final String planName;
  final String customerType;
  final String planCharges;
  final double internetCharges;
  final String billPeriod;
  final String billDate;
  final String dueDate;
  final int subscriptionBillId;

  BillPlanDetails({
    required this.planName,
    required this.customerType,
    required this.planCharges,
    required this.internetCharges,
    required this.billPeriod,
    required this.billDate,
    required this.dueDate,
    required this.subscriptionBillId,
  });

  // Convert JSON to BillPlanDetails object
  factory BillPlanDetails.fromJson(Map<String, dynamic> json) {
    return BillPlanDetails(
      planName: json['planName'] as String,
      customerType: json['customerType'] as String,
      planCharges: json['planCharges'] as String,
      internetCharges: (json['internetCharges'] as num).toDouble(),
      billPeriod: json['billPeriod'] as String,
      billDate: json['billDate'] as String,
      dueDate: json['dueDate'] as String,
      subscriptionBillId: json['subscription_billid'] as int,
    );
  }

  // Convert BillPlanDetails object to JSON
  Map<String, dynamic> toJson() {
    return {'planName': planName, 'customerType': customerType, 'planCharges': planCharges, 'internetCharges': internetCharges, 'billPeriod': billPeriod, 'billDate': billDate, 'dueDate': dueDate};
  }
}

class CustomerAccountDetails {
  final int customerID;
  final String relationshipId;
  final String billNumber;
  final String customerGSTIN;
  final String hsnSacCode;
  final String customerPO;
  final String contactPerson;
  final String contactNumber;

  CustomerAccountDetails({
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
      customerID: json['customerid'] as int,
      relationshipId: json['relationshipId'] as String,
      billNumber: json['billNumber'] as String,
      customerGSTIN: json['customerGSTIN'] as String,
      hsnSacCode: json['hsnSacCode'] as String,
      customerPO: json['customerPO'] as String,
      contactPerson: json['contactPerson'] as String,
      contactNumber: json['contactNumber'] as String,
    );
  }

  // Convert CustomerAccountDetails object to JSON
  Map<String, dynamic> toJson() {
    return {
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
  });

  // Convert JSON to Invoice object
  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      date: json['date'] as String,
      invoiceNo: json['invoiceNo'] as String,
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
    );
  }
  // PostData(
  //       siteIds: List<int>.from(json["siteids"] ?? []),
  //       subscriptionBillId: json["subscriptionbillid"] ?? "",
  //       clientAddressName: json["clientaddressname"] ?? "",
  //       clientAddress: json["clientaddress"] ?? "",
  //       billingAddressName: json["billingaddressname"] ?? "",
  //       billingAddress: json["billingaddress"] ?? "",
  //       planName: json["planname"] ?? "",
  //       emailId: json["emailid"] ?? "",
  //       ccEmail: json["ccemail"] ?? "",
  //       phoneNo: json["phoneno"] ?? "",
  //       totalAmount: json["totalamount"] ?? "",
  //       invoiceGenId: json["invoicegenid"] ?? "",
  //       date: json["date"] ?? "",
  //       messageType: json["messagetype"] ?? 0,
  //       feedback: json["feedback"] ?? "",
  //     );
  // Convert Invoice object to JSON
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'invoiceNo': invoiceNo,
      'pendingAmount': pendingAmount,
      'gstPercent': gstPercent,
      'billPlanDetails': billPlanDetails.toJson(),
      'contactdetails': contactDetails.toJson(),
      'customerAccDetails': customerAccountDetails.toJson(),
      'siteData': Site.toJsonList(siteData), // Corrected Site List Serialization
      'finalCalc': finalCalc.toJson(),
      'addressDetails': addressDetails.toJson(),
      'notes': notes,
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
    return PendingInvoices(json['invoiceid'] ?? '', json['duedate'] ?? '', json['overduedays'] ?? '', (json['charges'] ?? 0.0).toDouble());
  }

  // Convert PendingInvoices object to JSON (Map)
  Map<String, dynamic> toJson() {
    return {'serialNo': serialNo, 'invoiceid': invoiceid, 'duedate': duedate, 'overduedays': overduedays, 'charges': charges};
  }

  // Convert List<Map<String, dynamic>> to List<PendingInvoices>
  static List<PendingInvoices> fromJsonList(List<Map<String, dynamic>> jsonList) {
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
  final double cgst;
  final double sgst;
  final String roundOff;
  final String differene;
  final double total;
  final double? pendingAmount;
  final double grandTotal;

  FinalCalculation({
    required this.subtotal,
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
    double cgst = (subtotal * (gstPercent / 2)) / 100;
    double sgst = (subtotal * (gstPercent / 2)) / 100;
    double total = subtotal + cgst + sgst;
    double grandTotal = pendingAmount != null ? total + pendingAmount : total;

    return FinalCalculation(
      subtotal: subtotal,
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
    return {'subtotal': subtotal, 'CGST': cgst, 'SGST': sgst, 'roundOff': roundOff, 'difference': differene, 'total': total, 'pendingAmount': pendingAmount, 'grandTotal': grandTotal};
  }
}

class PostData {
  List<int> siteIds;
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

  PostData({
    required this.siteIds,
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
  });
  // Map<String, dynamic> toJson() {
  //     return {
  //       'date': date,
  //       'invoiceNo': invoiceNo,
  //       'pendingAmount': pendingAmount,
  //       'gstPercent': gstPercent,
  //       'billPlanDetails': billPlanDetails.toJson(),
  //       'customerAccDetails': customerAccountDetails.toJson(),
  //       'siteData': Site.toJsonList(siteData), // Corrected Site List Serialization
  //       'finalCalc': finalCalc.toJson(),
  //       'addressDetails': addressDetails.toJson(),
  //       'notes': notes,
  //     };
  //   }
  factory PostData.fromJson(Invoice data) {
    List<int> ids = [];
    for (var site in data.siteData) {
      ids.add(site.siteID);
    }

    return PostData(
      siteIds: ids,
      subscriptionBillId: data.billPlanDetails.subscriptionBillId,
      customerID: data.customerAccountDetails.customerID,
      clientAddressName: data.addressDetails.clientName,
      clientAddress: data.addressDetails.clientAddress,
      billingAddressName: data.addressDetails.billingName,
      billingAddress: data.addressDetails.billingName,
      planName: data.billPlanDetails.planName,
      emailId: data.contactDetails.email,
      ccEmail: data.contactDetails.email,
      phoneNo: data.contactDetails.phone,
      totalAmount: data.finalCalc.grandTotal.toString(),
      invoiceGenId: data.invoiceNo,
      date: data.date,
      messageType: 3,
      feedback: "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "siteids": siteIds,
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
    };
  }
}

class InvoiceResult {
  final List<File> files;
  final Invoice invoice;

  InvoiceResult({required this.files, required this.invoice});
}
