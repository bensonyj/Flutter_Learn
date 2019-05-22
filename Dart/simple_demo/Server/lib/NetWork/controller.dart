import 'dart:io';
import 'dart:mirrors';


// 请求路径
class Controller {
  final String path;
  const Controller({this.path});

  @override
  String toString() => 'Controller';
}

// 请求方式
class Request {
  final String path;
  final String method;

  const Request({this.path, this.method});

  @override
  String toString() {
    return "Request";
  }
}

class Get extends Request {
  final String path;
  const Get({this.path}): super(path:path, method:"GET");

  @override
  String toString() => "GET";
}

class Post extends Request {
  final String path;
  const Post({this.path}) : super(path: path, method: "POST");

  @override
  String toString() => "POST";
}

// 抽象类
abstract class BaseController{

}

// 请求路径
@Controller(path: '/user')
class UserController extends BaseController {
  @Get(path: '/login')
  void login(HttpRequest request) {
    request.response..statusCode = HttpStatus.ok..write('LoginSuccess')..close();
  }

  @Post(path: '/loggot')
  void loggot(HttpRequest request) {
    request.response..statusCode = HttpStatus.ok
        ..write('loggotSuccess')..close();
  }

  @Request(path: 'delete', method: 'DELETE')
  void editUder(HttpRequest request) {
    request.response..statusCode = HttpStatus.ok
        ..write('Success')..close();
  }
}

class ControllerManager{
  static ControllerManager manager = new ControllerManager();

  List<BaseController> controllers = [];
  Map<String, ControllerInfo> urlToMirror = new Map();

  void addController(BaseController controller) {
    if (!controllers.contains(controller)) {
      controllers.add(controller);

      urlToMirror.addAll(getRequestInfo(controller));
    }
  }

  void requestServer(HttpRequest request) {
    String path = request.uri.toString();
    String method = request.method;

    if(urlToMirror.containsKey(path)) {
      ControllerInfo info = urlToMirror[path];
      info.invoke(path, method, request);
    }else {
      request.response..statusCode = HttpStatus.notFound
          ..write("{'code':404, 'message':'NOt found'}")..close();
    }
  }
}

Map<String, ControllerInfo> getRequestInfo(BaseController controller) {
  Map<String, ControllerInfo> info = new Map();
  Map<String, Symbol> urlToMethod = new Map();

  InstanceMirror im = reflect(controller);
  ClassMirror classMirror = im.type;

  List<String> path = [];
  List<String> urlList = [];

  classMirror.metadata.forEach((medata) {
    path.add(medata.reflectee.path);
  });

  classMirror.declarations.forEach((symbol, declarationMirror) {
    if(symbol.toString() != classMirror.simpleName.toString()) {
      declarationMirror.metadata.forEach((medata) {
        String requestPath = path.join() + medata.reflectee.path;
        String method = medata.reflectee.method;

        urlList.add(requestPath);
        urlToMethod.putIfAbsent('$requestPath#$method', () => symbol);
      });
    }
  });

  ControllerInfo controllerInfo = new ControllerInfo(urlToMethod, im);
  urlList.forEach((url) {
    info.putIfAbsent(url, () => controllerInfo);
  });

  return info;
}


class ControllerInfo {
  final Map<String, Symbol> urlToMethod;
  final InstanceMirror instanceMirror;

  ControllerInfo(this.urlToMethod, this.instanceMirror);

  void invoke(String url, String method, HttpRequest request) {
    if(urlToMethod.containsKey('$url#$method')) {
      instanceMirror.invoke(urlToMethod['$url#$method'], [request]);
    }else {
      request.response..statusCode = HttpStatus.methodNotAllowed
          ..write("{'code':405,'message':'请求出错!'}")..close();
    }
  }
}






