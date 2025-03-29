import 'dart:io';
import 'package:recurring_invoice/utils/helpers/generators.dart';

mixin WebsocketServices {
  static void startWebSocketServer() async {
    final server = await HttpServer.bind(InternetAddress.anyIPv4, 8081);
    print('WebSocket server running on ws://${server.address.address}:8081');

    await for (HttpRequest request in server) {
      if (WebSocketTransformer.isUpgradeRequest(request)) {
        WebSocket socket = await WebSocketTransformer.upgrade(request);
        print('Client connected');

        socket.listen(
          (message) {
            Generators.InvoiceGenerator(message);
            print('Received: $message');
            socket.add('Echo: $message');
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
