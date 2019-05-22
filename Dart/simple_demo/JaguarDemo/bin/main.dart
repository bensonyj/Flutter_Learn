import 'dart:async';
import 'dart:io';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_query_postgres/jaguar_query_postgres.dart';
import 'package:JaguarDemo/entity/user.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:JaguarDemo/ApiJson.dart';

//main() => new Jaguar()..staticFile('/', 'static/index.html')
//    ..staticFiles('/static/*', 'static')
//    ..log.onRecord.listen(print)
//    ..serve(logRequests: true);

//connect() async{
//  final PgAdapter pgAdapter = new PgAdapter('yingjian', username: 'postgres', password: '123456');
//  await pgAdapter.connect();
//
//  UserBean userBean = UserBean(pgAdapter);
//  await userBean.createTable();
//
//  User user = User();
//  user.id = "1";
//  user.username = "yingjian";
//  user.password = "123456";
//  user.avatarPath = "static/admin.png";
//  user.avatar = "http://localhost:8080/static/admin.png";
//  user.email = "923427954@qq.com";
//  user.role = "0";
//  user.phoneNumber = "123455678901";
//  await userBean.insert(user);
//}

//main() => new Jaguar(errorWriter: new YJErrorWrite(),)
//    ..get('/api/UserInfo', (ctx) async{
//      final PgAdapter pgAdapter = new PgAdapter('yingjian', username: 'postgres', password: '123456');
//      await pgAdapter.connect();
//
//      UserBean userBean = UserBean(pgAdapter);
//      await userBean.createTable();
//
//      User user = User();
//      user.id = "1";
//      user.username = "yingjian";
//      user.password = "123456";
//      user.avatarPath = "static/admin.png";
//      user.avatar = "http://localhost:8080/static/admin.png";
//      user.email = "923427954#qq.com";
//      user.role = "0";
//      user.phoneNumber = "123455678901";
//      await userBean.insert(user);
//
//      User selectOne = await userBean.find('1');
//      return Response(selectOne.toString());
//    })
//    ..get('/api/test', (cxt) => "test");

final key = "yingjian12313";

main() => new Jaguar(errorWriter: new YJErrorWrite(),)
    ..get('/api/doGet', (ctx) {
      throw Exception('发生异常');
    })
  ..get('/api/UserId/get', (ctx) {
    String id = ctx.query.get('id');
    ctx.response = Response('query ID:$id');
  })
  ..post('/api/User/login', (ctx) async{
    Map<String, String> params = await ctx.bodyAsUrlEncodedForm();
    String userName = params['username'];
    String password = params['password'];
//    ctx.response = Response('UserName:$userName\nPassword:$password');
    if (userName.isEmpty|| password.isEmpty) {
      return Response.json(apiJson.errorMsgA(-1, '用户名或密码不能为空!').toMap());
    }else {
      // 数据库查找
      if (password != "123456") {
        return Response.json(apiJson.errorMsg(-2, "密码错误！"));
      }else {
        final JwtClaim jwtClaim = JwtClaim(
          subject: "yingjian",
          issuer: "jaguar",
          issuedAt: DateTime(2019,4,29, 9, 9),
          expiry: DateTime(2019, 5, 2, 2, 2),
          jwtId: "1",
          audience: ["ben","jack"],
          payload: {'user':'test', 'password': "123456"},
        );

        String token = issueJwtHS256(jwtClaim, key);
        return Response.json(apiJson.successResultA(token).toMap());
      }
    }
  })
  ..get('/api/u/i', (ctx) async{
    Map<String, String> params = await ctx.bodyAsUrlEncodedForm();
    String token = params["token"];
    final jwtClaim = verifyJwtHS256Signature(token, key);
    return Response.json(jwtClaim.payload);
  })
  ..postJson('/api/User/json', (ctx) async{
    Map context = await ctx.bodyAsJson();
    ctx.response = Response('Json Content: ${context.toString()}');
//  User user = await ctx.bodyAsJson(convert: User.forMap);
//  ctx.response = Response('User\nUserName:${user.username}\nPassword:${user.password}');
  })
  ..postJson('/api/User/jsons', (ctx) async{
//    List<User> users = await ctx.bodyAsJsonList(convert: User.forMap);
//    String info = "";
//    for (User user in users) {
//      info += 'User\nUserName:${user.username}\nPassword:${user.password}';
//    }
//    ctx.response = Response(info);
  })
  ..postJson('/api/User/avatar', (ctx) async{
    Stream<List<int>> image = await ctx.bodyAsStream;
    File file = await new File('image.png').create();
    await image.listen(file.writeAsBytes);
    ctx.response = Response('Success');
  })
  ..post('/api/User/Info', (ctx) async{
    Map<String, FormField> params = await ctx.bodyAsFormData();
    FormField username = params['username'];
    FormField userDescript = params['userDescript'];
    FormField avatar = params['avatar'];

    if(username is StringFormField) {
      await new Directory(username.value).create(recursive: true);
    }
    if(userDescript is TextFileFormField) {
      Stream<String> value = userDescript.value;
      userDescript.writeTo('${username.value}/Descript.txt');
    }
    if(avatar is BinaryFileFormField) {
      Stream<List<int>> value = avatar.value;
      avatar.writeTo('${username.value}/avatar.png');
    }
    ctx.response = Response('Form Success');
  })
  ..get('/api/UserInfo', (ctx) async{
//    ctx.response = Response("test");
    final PgAdapter pgAdapter = new PgAdapter('yingjian', username: 'postgres', password: '123456');
    await pgAdapter.connect();

    UserBean userBean = UserBean(pgAdapter);
    await userBean.createTable();

    User user = User();
    user.id = "1";
    user.username = "yingjian";
    user.password = "123456";
    user.avatarPath = "static/admin.png";
    user.avatar = "http://localhost:8080/static/admin.png";
    user.email = "923427954#qq.com";
    user.role = "0";
    user.phoneNumber = "123455678901";
    await userBean.insert(user);

    User selectOne = await userBean.find('1');
    ctx.response = Response(selectOne.toString());
  })
    ..getJson('/api/doGetJson', (ctx) => '{"id":123}')
    ..post('/api/doPost', (ctx) => ctx.bodyAsJson())
    ..postJson('/api/doPostJson', (ctx) => '{"id": 321}')
    ..delete('/api/doDetele', (ctx) => 'detele')
    ..deleteJson('/api/doDelete', (ctx) => '{"id":12}')
    ..put('/api/doPut', (ctx) => 'put')
    ..postJson('/api/doPutJson', (ctx) => '{"id":21}')
    ..options('/api/doOptions', (ctx) => 'options')
    ..patch('/api/doPatch', (ctx) => 'patch')
    ..html('/api/doHtml', (ctx) => '''
    <!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>
<h1>Hello Jaguar!</h1>
</body>
</html>
    ''')
    ..json('/api/doJson', (ctx) => '{"id":"3dada"}')
    ..serve(logRequests: true);



class YJErrorWrite extends ErrorWriter {
  @override
  FutureOr<Response> make404(Context ctx) {
    final html = '''
    <!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>
404
</body>
</html>
    ''';
    final resp = Response(html, statusCode: HttpStatus.notFound);
    resp.headers.contentType = ContentType.html;
    ctx.response = resp;

    return resp;
  }

  @override
  FutureOr<Response> make500(Context ctx, Object error, [StackTrace stack]) {
    final html = '''
    <!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>
500
</body>
</html>
    ''';
    final resp = Response(html, statusCode: HttpStatus.internalServerError);
    resp.headers.contentType = ContentType.html;
    ctx.response = resp;

    return resp;
  }
}
