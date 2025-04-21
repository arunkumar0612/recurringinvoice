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
              Map<String, List<Map<String, dynamic>>> groupedByEmail = {};
              List<String> emails = [];

              // Grouping by email
              for (var site in allSites) {
                final contactDetails = site['contactdetails'] as Map<String, dynamic>?;
                final email = contactDetails?['emailid'] ?? 'unknown';

                if (!groupedByEmail.containsKey(email)) {
                  groupedByEmail[email] = [];
                  emails.add(email);
                }

                groupedByEmail[email]!.add(site);
              }

              for (int i = 0; i < groupedByEmail.length; i++) {
                for (int j = 0; j < groupedByEmail[emails[i]]!.length; j++) {
                  Generators.InvoiceGenerator(groupedByEmail[emails[i]]![j]);
                  await Future.delayed(const Duration(milliseconds: 2000));
                }
                await InvoiceServices.apicall(InvoicesList, mailSenderList);
                await Future.delayed(const Duration(milliseconds: 4000));
                mailSenderList.clear();
                InvoicesList.clear();
              }
              // Generators.InvoiceGenerator(message);
              // Final grouped list of lists
              // List<List<Map<String, dynamic>>> groupedSiteLists = groupedByEmail.values.toList();

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
