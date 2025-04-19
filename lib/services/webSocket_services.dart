import 'dart:convert';
import 'dart:io';

mixin WebsocketServices {
  static void startWebSocketServer() async {
    final server = await HttpServer.bind(InternetAddress.anyIPv4, 8081);
    print('WebSocket server running on ws://${server.address.address}:8081');
    List<Map<String, dynamic>> allSites = [];
    await for (HttpRequest request in server) {
      if (WebSocketTransformer.isUpgradeRequest(request)) {
        WebSocket socket = await WebSocketTransformer.upgrade(request);
        print('Client connected');

        socket.listen(
          (message) {
            // print('Received: $message');

            try {
              final decoded = jsonDecode(message);

              if (decoded is List) {
                allSites = decoded.map<Map<String, dynamic>>((item) => Map<String, dynamic>.from(item)).toList();
                print('Ressssssssssssssssssceived: $allSites');
              } else {
                print('Decoded message is not a list');
              }
            } catch (e) {
              print('Error decoding JSON: $e');
            }
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
