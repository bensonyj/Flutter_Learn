import 'package:jaguar_orm/jaguar_orm.dart';
import 'dart:async';
part 'user.jorm.dart';

class User{
  @PrimaryKey()
  String id;//id号

  String username;//用户名
  String password;//密码
  String role;//角色
  String phoneNumber;//电话号码
  String email;//邮箱
  @Column(length: 50)
  String avatar;//头像地址
  @Column(length: 50)
  String avatarPath;//文件路径

  static const String tableName='_user';//这里需要注意的是表名开头必须是_否则识别不了

  @override
  String toString() =>"User($id,$username,$password,$role,$phoneNumber,$email,$avatar,$avatarPath)";
}

@GenBean()
class UserBean extends Bean<User> with _UserBean{
  UserBean(Adapter adapter) : super(adapter);

  @override
  String get tableName => User.tableName;
}