import 'package:flutter/material.dart';
import 'package:recurring_invoice/services/Invoice_services.dart';
import 'package:recurring_invoice/services/webSocket_services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // runApp(MyApp());
  WebsocketServices.startWebSocketServer();
  // Start WebSocket separately
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: InvoiceScreen());
  }
}

class InvoiceScreen extends StatefulWidget with InvoiceServices {
  const InvoiceScreen({super.key});

  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // startWebSocketServer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Invoice Generator')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Invoice invoice = await widget.returnInvoice();
            // showInvoiceDialog(context, );
          },
          child: Text('Generate Invoice'),
        ),
      ),
    );
  }
}

// ✅ Separate function to run WebSocket server
