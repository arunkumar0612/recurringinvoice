import 'dart:io';

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
            print('Received: $message');
            // Generators.InvoiceGenerator(message);
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
