import 'dart:async';

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recurring_invoice/services/APIservices/invoker.dart';
import 'package:recurring_invoice/services/webSocket_services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.lazyPut<Invoker>(() => Invoker());

  // Start WebSocket separately
  WebsocketServices.startWebSocketServer();

  // Call runApp to start the app
  runApp(MyApp());
  DesktopWindow.setMinWindowSize(const Size(309.0, 242.0));
  DesktopWindow.setMaxWindowSize(const Size(309.0, 242.0));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: InvoiceScreen());
  }
}

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  late Timer _timer;
  late Timer _dotTimer;
  Duration _elapsedTime = Duration();
  int _dotCount = 0; // To track how many dots should be shown

  @override
  void initState() {
    super.initState();

    // Start a timer to track how long the app has been running
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedTime = Duration(seconds: timer.tick);
      });
    });

    // Start the dot timer to control how dots appear
    _dotTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        // Control the number of visible dots (1, 2, or 3)
        _dotCount = (_dotCount + 1) % 4; // Cycle through 0 to 3
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    _dotTimer.cancel(); // Cancel the dot timer
    super.dispose();
  }

  String _formatTime(Duration duration) {
    // Format the elapsed time in hours, minutes, and seconds
    int hours = duration.inHours;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60; // Get the remaining seconds
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    // print(MediaQuery.of(context).size.height);
    // print(MediaQuery.of(context).size.width);
    String formattedTime = _formatTime(_elapsedTime);

    return Scaffold(
      appBar: AppBar(title: Text('Recurring Invoice Generator')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [Text('Listening', style: TextStyle(fontSize: 20))])),
                SizedBox(width: 5),
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Conditional dots display based on the _dotCount
                        _dotCount >= 1 ? Text('.', style: TextStyle(fontSize: 24, color: Colors.green)) : Container(),
                        _dotCount >= 2 ? Text('.', style: TextStyle(fontSize: 24, color: Colors.green)) : Container(),
                        _dotCount >= 3 ? Text('.', style: TextStyle(fontSize: 24, color: Colors.green)) : Container(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text('Service Running Time: $formattedTime', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () async {
            //     // Invoice invoice = await widget.returnInvoice();
            //     // showInvoiceDialog(context, );
            //   },
            //   child: Text('Generate Invoice'),
            // ),
          ],
        ),
      ),
    );
  }
}
