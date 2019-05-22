import 'dart:io';
import 'package:http_server/http_server.dart';
import 'package:path/path.dart';
import 'package:YJHOME/logUnit.dart';
import 'package:YJHOME/NetWork/controller.dart';
import 'package:YJHOME/WebSocket/webSocket.dart';

main() async {
  // 获取文件根目录
  var webPath = dirname(dirname(Platform.script.toFilePath())) + '/webApp';
  VirtualDirectory staticFiles = new VirtualDirectory(webPath);
  // 允许目录监听
  staticFiles.allowDirectoryListing = true;
  // 处理访问根目录
  staticFiles.directoryHandler = (dir, request) {
    var indexUri = new Uri.file(dir.path,).resolve('index.html');
    staticFiles.serveFile(new File(indexUri.toFilePath()), request);
  };
  // 处理访问不存在的页面
  staticFiles.errorPageHandler = (request) {
    if (request.uri.pathSegments.last.contains('.html')) {
      staticFiles.serveFile(new File(webPath + '/404.html'), request);
    }else if(request.uri.path == '/mini') {
      WebSocketManager.manager.serverRequest(request).catchError((error) {
        LogUnit.log.warning('webSocket异常', error, error.stackTrace);
      });
    }else if(request.uri.path == '/mini/client') {
      SocketClient();
    }
    else{
      try {
          ControllerManager.manager.requestServer(request);
//        handleMessage(request);
//        throw ArgumentError('Warning happen');
      }catch(e){
        try {
          request.response..statusCode = HttpStatus.internalServerError
              ..close();
        }catch(_) {
          LogUnit.log.warning('请求消息发生异常', e, e.runtimeType == ArgumentError? e.stackTrace : null);
        }
      }
    }
  };

  ControllerManager.manager.addController(UserController());

  var requestServer = await HttpServer.bind(InternetAddress.loopbackIPv6, 8080);
  LogUnit.log.info('服务器启动：http://localhost:${requestServer.port}');

  // 监听请求
  return requestServer.forEach(staticFiles.serveRequest);
}

void SocketClient() async {
  WebSocket client = await WebSocket.connect('ws://localhost:8080/mini');
  client.listen((msg) {
    print('客户端收到消息');
    print(msg);
  });
  client.add('hello server!');
}

void handleMessage(HttpRequest request) {
  try {
    if (request.method == "GET") {
      handleGET(request);
    }else if (request.method == "POST") {
      handlePOST(request);
    }else {
      request.response..statusCode = HttpStatus.methodNotAllowed
          ..write("对不起，不支持${request.method}方法的请求!")..close();
    }
  }catch(e) {
    print("出现一个异常，异常原因为:${e}");
  }finally {
    print("请求处理结束");
  }
}

void handleGET(HttpRequest request) {
  var id = request.uri.queryParameters["id"];
  request.response..statusCode = HttpStatus.ok
  ..write("当前查询的id为$id")..close();
}

void handlePOST(HttpRequest request) {

}