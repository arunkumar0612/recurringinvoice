// ignore_for_file: file_names

import 'package:recurring_invoice/utils/helpers/support_functions.dart';

class Site {
  static int _counter = 1; // Static counter to auto-increment serial numbers
  final String serialNo;
  final String siteName;
  final String address;
  final String customerId;
  final double monthlyCharges;

  Site({required this.siteName, required this.address, required this.customerId, required this.monthlyCharges}) : serialNo = (_counter++).toString(); // Auto-increment serial number

  // Convert List of JSON Maps to List of Site objects
  static List<Site> fromJson(List<Map<String, dynamic>> jsonList) {
    _counter = 1; // Reset counter before parsing a new list

    return jsonList.map((json) {
      return Site(
        siteName: json['sitename'] as String, // Fix key casing
        address: json['address'] as String,
        customerId: json['customerid'] as String,
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
    return {'serialNo': serialNo, 'siteName': siteName, 'address': address, 'customerId': customerId, 'monthlyCharges': monthlyCharges};
  }

  dynamic getIndex(int col) {
    switch (col) {
      case 0:
        return serialNo;
      case 1:
        return siteName;
      case 2:
        return address;
      case 3:
        return customerId;
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

class BillPlanDetails {
  final String planName;
  final String customerType;
  final String planCharges;
  final double internetCharges;
  final String billPeriod;
  final String billDate;
  final String dueDate;

  BillPlanDetails({
    required this.planName,
    required this.customerType,
    required this.planCharges,
    required this.internetCharges,
    required this.billPeriod,
    required this.billDate,
    required this.dueDate,
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
    );
  }

  // Convert BillPlanDetails object to JSON
  Map<String, dynamic> toJson() {
    return {'planName': planName, 'customerType': customerType, 'planCharges': planCharges, 'internetCharges': internetCharges, 'billPeriod': billPeriod, 'billDate': billDate, 'dueDate': dueDate};
  }
}

class CustomerAccountDetails {
  final String relationshipId;
  final String billNumber;
  final String customerGSTIN;
  final String hsnSacCode;
  final String customerPO;
  final String contactPerson;
  final String contactNumber;

  CustomerAccountDetails({
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
  final List<Site> siteData;
  final FinalCalculation finalCalc;

  Invoice({
    required this.date,
    required this.invoiceNo,
    required this.gstPercent,
    required this.pendingAmount,
    required this.addressDetails,
    required this.billPlanDetails,
    required this.customerAccountDetails,
    required this.siteData,
    required this.finalCalc,
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
      customerAccountDetails: CustomerAccountDetails.fromJson(json['customerAccDetails']),
      siteData: Site.fromJson(List<Map<String, dynamic>>.from(json['siteData'])),
      finalCalc: FinalCalculation.fromJson(Site.fromJson(List<Map<String, dynamic>>.from(json['siteData'])), json['gstPercent'] as int, json['pendingAmount'] as double),
    );
  }

  // Convert Invoice object to JSON
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'invoiceNo': invoiceNo,
      'pendingAmount': pendingAmount,
      'gstPercent': gstPercent,
      'billPlanDetails': billPlanDetails.toJson(),
      'customerAccDetails': customerAccountDetails.toJson(),
      'siteData': Site.toJsonList(siteData), // Corrected Site List Serialization
    };
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
