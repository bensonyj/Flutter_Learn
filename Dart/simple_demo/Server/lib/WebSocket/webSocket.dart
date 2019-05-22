import 'dart:io';

class WebSocketManager{
  static WebSocketManager manager = new WebSocketManager();
  List<WebSocket> webSockets;

  WebSocketManager() {
    webSockets = [];
  }

  Future serverRequest(HttpRequest request) {
    if(WebSocketTransformer.isUpgradeRequest(request)) {
      return WebSocketTransformer.upgrade(request).then((webSocket) {
        webSockets.add(webSocket);
        webSocket.listen(handMsg);
      });
    }else {
      request.response..statusCode = HttpStatus.notAcceptable
          ..write('该请求应为WebSocket链接')..close();

      return new Future((){});
    }
  }

  void handMsg(dynamic msg) {
    print("收到客户端消息:$msg");

    for(WebSocket webSocket in webSockets) {
      if (webSocket.closeCode == null) {
        webSocket.add("服务器回复: XX: $msg");
      }
    }
  }
}
