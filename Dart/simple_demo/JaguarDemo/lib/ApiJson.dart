import 'dart:convert';

ApiJson apiJson = ApiJson();

class ApiJson {
  String success() =>
      json.encode(new Api()
        ..code = 0
        ..msg = 'success'
        ..data = null,);

  Api successA() =>
      new Api()
        ..code = 0
        ..msg = 'success'
        ..data = null;


  String successResult(Object data) =>
      json.encode(new Api()
        ..code = 0
        ..msg = 'success'
        ..data = data,);

  Api successResultA(Object data) =>
      new Api()
        ..code = 0
        ..msg = 'success'
        ..data = data;


  String error() =>
      json.encode(new Api()
        ..code = -1
        ..msg = '未知错误'
        ..data = null);

  Api errorA() =>
      new Api()
        ..code = -1
        ..msg = '未知错误'
        ..data = null;

  String errorMsg(int code, String msg) =>
      json.encode(new Api()
        ..code = code
        ..msg = msg
        ..data = null);

  Api errorMsgA(int code, String msg) =>
      new Api()
        ..code = code
        ..msg = msg
        ..data = null;
}

class Api<T> {
  int code;
  String msg;
  T data;

  Map toMap() => {
    "code": code,
    "msg": msg,
    "data": data,
  };
}