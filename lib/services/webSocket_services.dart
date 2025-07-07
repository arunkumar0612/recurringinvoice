import 'dart:convert';
import 'dart:io';

import 'package:recurring_invoice/models/entities/Invoice_entities.dart';
import 'package:recurring_invoice/services/Invoice_services.dart';
import 'package:recurring_invoice/utils/helpers/generators.dart';

class WebsocketServices {
  static List<File> mailSenderList = [];
  static List<InvoiceResult> InvoicesList = [];
  static void startWebSocketServer() async {
    final server = await HttpServer.bind(InternetAddress.anyIPv4, 9091);
    print('WebSocket server running on ws://${server.address.address}:9091');
    List<Map<String, dynamic>> allSites = [];
    await for (HttpRequest request in server) {
      if (WebSocketTransformer.isUpgradeRequest(request)) {
        WebSocket socket = await WebSocketTransformer.upgrade(request);
        print('Client connected');
        // ContactDetails contactDetails = ContactDetails(email: jsonData["contactdetails"]["emailid"], ccEmail: jsonData["contactdetails"]["ccemail"], phone: jsonData["contactdetails"]["phoneno"]);

        socket.listen(
          (message) async {
            // print('Received: $message');

            // try {
            final decoded = jsonDecode(message);

            if (decoded is List) {
              allSites = decoded.map<Map<String, dynamic>>((item) => Map<String, dynamic>.from(item)).toList();
              // Map<String, Map<String, List<Map<String, dynamic>>>> groupedbyCompanyid = {};
              List<String> concatinatedMails = [];
              List<String> customerIds = [];
              print("Total Sites       :            ${allSites.length}");

              Map<String, Map<String, List<Map<String, dynamic>>>> groupedByEmail = {};
              int count = 0;
              for (var site in allSites) {
                final contactDetails = site['contactdetails'] as Map<String, dynamic>?;
                // print(site);
                final customerDetails = site['customeraccountdetails'] as Map<String, dynamic>?;
                final customerId = '${customerDetails?['customerid'] ?? 'unknown'}';
                final email = contactDetails?["emailid"] ?? 'no-email';
                final CCemail = contactDetails?["ccemail"] ?? 'no-CCemail';
                final String concatinatedMail = "$email&$CCemail";
                // Initialize email group if needed
                if (!groupedByEmail.containsKey(concatinatedMail)) {
                  groupedByEmail[concatinatedMail] = {};
                  concatinatedMails.add(concatinatedMail);
                }

                // Initialize customer group inside that email
                if (!groupedByEmail[concatinatedMail]!.containsKey(customerId)) {
                  groupedByEmail[concatinatedMail]![customerId] = [];
                  customerIds.add(customerId);
                }

                // Add site to the proper list
                groupedByEmail[concatinatedMail]![customerId]!.add(site);
              }

              for (var mailEntry in groupedByEmail.entries) {
                final String emailAndCC = mailEntry.key;
                final Map<String, List<Map<String, dynamic>>> customers = mailEntry.value;

                print('Email: $emailAndCC');
                print('Customer Count: ${customers.length}');

                for (var customerEntry in customers.entries) {
                  final String customerId = customerEntry.key;
                  final List<Map<String, dynamic>> sites = customerEntry.value;

                  print('  Customer ID: $customerId');
                  print('    Sites: ${sites.length}');

                  for (var site in sites) {
                    Generators.InvoiceGenerator(site);
                    await Future.delayed(const Duration(milliseconds: 2000));
                  }

                  count++;
                  await InvoiceServices.apicall(InvoicesList, mailSenderList, count);
                  await Future.delayed(const Duration(milliseconds: 8000));
                  mailSenderList.clear();
                  InvoicesList.clear();
                  print('************************ SITES ENDED ***********************');
                }
                print('************************ MAIL CLUB ENDED ***********************\n\n\n\n\n\n\n\n');
              }

              // for (var site in allSites) {
              //   final contactDetails = site['customeraccountdetails'] as Map<String, dynamic>?;
              //   final companyId = '${contactDetails?['customerid'] ?? 'unknown'}';
              //   if (!groupedbyCompanyid.containsKey(companyId)) {
              //     groupedbyCompanyid[companyId] = {};
              //     groupedbyCompanyid[companyId]!['individual'] = [];
              //     groupedbyCompanyid[companyId]!['consolidate'] = [];
              //     companyIds.add(companyId);
              //   }
              //   if (contactDetails!['consolidate_email'] == 'individual') {
              //     groupedbyCompanyid[companyId]!['individual']!.add(site);
              //   } else if (contactDetails['consolidate_email'] == 'consolidate') {
              //     groupedbyCompanyid[companyId]!['consolidate']!.add(site);
              //   }
              // }
              // int count = 0;
              // for (int i = 0; i < groupedbyCompanyid.length; i++) {
              //   if (groupedbyCompanyid[companyIds[i]]!['individual']!.isNotEmpty) {
              //     for (int ind = 0; ind < groupedbyCompanyid[companyIds[i]]!['individual']!.length; ind++) {
              //       Generators.InvoiceGenerator(groupedbyCompanyid[companyIds[i]]!['individual']![ind]);
              //       await Future.delayed(const Duration(milliseconds: 2000));
              //       count++;
              //       await InvoiceServices.apicall(InvoicesList, mailSenderList, count);
              //       await Future.delayed(const Duration(milliseconds: 2000));
              //       mailSenderList.clear();
              //       InvoicesList.clear();
              //     }
              //   }
              //   if (groupedbyCompanyid[companyIds[i]]!['consolidate']!.isNotEmpty) {
              //     for (int cons = 0; cons < groupedbyCompanyid[companyIds[i]]!['consolidate']!.length; cons++) {
              //       Generators.InvoiceGenerator(groupedbyCompanyid[companyIds[i]]!['consolidate']![cons]);
              //       await Future.delayed(const Duration(milliseconds: 2000));
              //     }
              //     count++;
              //     await InvoiceServices.apicall(InvoicesList, mailSenderList, count);
              //     await Future.delayed(const Duration(milliseconds: 8000));
              //     mailSenderList.clear();
              //     InvoicesList.clear();
              //   }
              // }
              print("****************************COMPLETED*********************");
            } else {
              print('Decoded message is not a list');
            }
            // } catch (e) {
            //   print('Error decoding JSON: $e');
            // }
            // print('Received: $message');
          },
          onDone: () {
            print('Client disconnected');
          },
        );
      } else {
        request.response
          ..statusCode = HttpStatus.forbidden
          ..write('WebSocket connections only')
          ..close();
      }
    }
  }
}
