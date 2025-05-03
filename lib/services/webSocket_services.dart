import 'dart:convert';
import 'dart:io';

import 'package:recurring_invoice/models/entities/Invoice_entities.dart';
import 'package:recurring_invoice/services/Invoice_services.dart';
import 'package:recurring_invoice/utils/helpers/generators.dart';

class WebsocketServices {
  static List<File> mailSenderList = [];
  static List<InvoiceResult> InvoicesList = [];
  static void startWebSocketServer() async {
    final server = await HttpServer.bind(InternetAddress.anyIPv4, 8081);
    print('WebSocket server running on ws://${server.address.address}:8081');
    List<Map<String, dynamic>> allSites = [];
    await for (HttpRequest request in server) {
      if (WebSocketTransformer.isUpgradeRequest(request)) {
        WebSocket socket = await WebSocketTransformer.upgrade(request);
        print('Client connected');

        socket.listen(
          (message) async {
            // print('Received: $message');

            // try {
            final decoded = jsonDecode(message);

            if (decoded is List) {
              allSites = decoded.map<Map<String, dynamic>>((item) => Map<String, dynamic>.from(item)).toList();
              // print('Ressssssssssssssssssceived: $allSites');
              Map<String, Map<String, List<Map<String, dynamic>>>> groupedbyCompanyid = {};
              List<String> companyIds = [];
              print("Total Sites       :            ${allSites.length}");
              // Grouping by company_ID
              for (var site in allSites) {
                final contactDetails = site['customeraccountdetails'] as Map<String, dynamic>?;
                final companyId = '${contactDetails?['customerid'] ?? 'unknown'}';

                if (!groupedbyCompanyid.containsKey(companyId)) {
                  groupedbyCompanyid[companyId] = {};
                  groupedbyCompanyid[companyId]!['individual'] = [];
                  groupedbyCompanyid[companyId]!['consolidate'] = [];
                  companyIds.add(companyId);
                }
                if (contactDetails!['consolidate_email'] == 'individual') {
                  groupedbyCompanyid[companyId]!['individual']!.add(site);
                } else if (contactDetails['consolidate_email'] == 'consolidate') {
                  groupedbyCompanyid[companyId]!['consolidate']!.add(site);
                }
              }
              int count = 0;
              for (int i = 0; i < groupedbyCompanyid.length; i++) {
                if (groupedbyCompanyid[companyIds[i]]!['individual']!.isNotEmpty) {
                  for (int ind = 0; ind < groupedbyCompanyid[companyIds[i]]!['individual']!.length; ind++) {
                    Generators.InvoiceGenerator(groupedbyCompanyid[companyIds[i]]!['individual']![ind]);
                    await Future.delayed(const Duration(milliseconds: 2000));
                    count++;
                    await InvoiceServices.apicall(InvoicesList, mailSenderList, count);
                    await Future.delayed(const Duration(milliseconds: 2000));
                    mailSenderList.clear();
                    InvoicesList.clear();
                  }
                }

                if (groupedbyCompanyid[companyIds[i]]!['consolidate']!.isNotEmpty) {
                  for (int cons = 0; cons < groupedbyCompanyid[companyIds[i]]!['consolidate']!.length; cons++) {
                    Generators.InvoiceGenerator(groupedbyCompanyid[companyIds[i]]!['consolidate']![cons]);
                    await Future.delayed(const Duration(milliseconds: 2000));
                  }
                  count++;
                  await InvoiceServices.apicall(InvoicesList, mailSenderList, count);
                  await Future.delayed(const Duration(milliseconds: 8000));
                  mailSenderList.clear();
                  InvoicesList.clear();
                }
              }

              // for (int i = 0; i < groupedbyCompanyid.length; i++) {
              //   for (int j = 0; j < groupedbyCompanyid[companyIds[i]]!.length; j++) {
              //     Generators.InvoiceGenerator(groupedbyCompanyid[companyIds[i]]![j]);
              //     await Future.delayed(const Duration(milliseconds: 2000));
              //   }
              //   await InvoiceServices.apicall(InvoicesList, mailSenderList);
              //   await Future.delayed(const Duration(milliseconds: 4000));
              //   mailSenderList.clear();
              //   InvoicesList.clear();
              // }
              // Generators.InvoiceGenerator(message);
              // Final grouped list of lists
              // List<List<Map<String, dynamic>>> groupedSiteLists = groupedBy_companyID.values.toList();

              // print("*************************************************$groupedSiteLists");
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
