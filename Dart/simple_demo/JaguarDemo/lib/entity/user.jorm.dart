// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// BeanGenerator
// **************************************************************************

abstract class _UserBean implements Bean<User> {
  final id = StrField('id');
  final username = StrField('username');
  final password = StrField('password');
  final role = StrField('role');
  final phoneNumber = StrField('phone_number');
  final email = StrField('email');
  final avatar = StrField('avatar');
  final avatarPath = StrField('avatar_path');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        username.name: username,
        password.name: password,
        role.name: role,
        phoneNumber.name: phoneNumber,
        email.name: email,
        avatar.name: avatar,
        avatarPath.name: avatarPath,
      };
  User fromMap(Map map) {
    User model = User();
    model.id = adapter.parseValue(map['id']);
    model.username = adapter.parseValue(map['username']);
    model.password = adapter.parseValue(map['password']);
    model.role = adapter.parseValue(map['role']);
    model.phoneNumber = adapter.parseValue(map['phone_number']);
    model.email = adapter.parseValue(map['email']);
    model.avatar = adapter.parseValue(map['avatar']);
    model.avatarPath = adapter.parseValue(map['avatar_path']);

    return model;
  }

  List<SetColumn> toSetColumns(User model,
      {bool update = false, Set<String> only, bool onlyNonNull = false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      ret.add(id.set(model.id));
      ret.add(username.set(model.username));
      ret.add(password.set(model.password));
      ret.add(role.set(model.role));
      ret.add(phoneNumber.set(model.phoneNumber));
      ret.add(email.set(model.email));
      ret.add(avatar.set(model.avatar));
      ret.add(avatarPath.set(model.avatarPath));
    } else if (only != null) {
      if (only.contains(id.name)) ret.add(id.set(model.id));
      if (only.contains(username.name)) ret.add(username.set(model.username));
      if (only.contains(password.name)) ret.add(password.set(model.password));
      if (only.contains(role.name)) ret.add(role.set(model.role));
      if (only.contains(phoneNumber.name))
        ret.add(phoneNumber.set(model.phoneNumber));
      if (only.contains(email.name)) ret.add(email.set(model.email));
      if (only.contains(avatar.name)) ret.add(avatar.set(model.avatar));
      if (only.contains(avatarPath.name))
        ret.add(avatarPath.set(model.avatarPath));
    } else /* if (onlyNonNull) */ {
      if (model.id != null) {
        ret.add(id.set(model.id));
      }
      if (model.username != null) {
        ret.add(username.set(model.username));
      }
      if (model.password != null) {
        ret.add(password.set(model.password));
      }
      if (model.role != null) {
        ret.add(role.set(model.role));
      }
      if (model.phoneNumber != null) {
        ret.add(phoneNumber.set(model.phoneNumber));
      }
      if (model.email != null) {
        ret.add(email.set(model.email));
      }
      if (model.avatar != null) {
        ret.add(avatar.set(model.avatar));
      }
      if (model.avatarPath != null) {
        ret.add(avatarPath.set(model.avatarPath));
      }
    }

    return ret;
  }

  Future<void> createTable({bool ifNotExists = false}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addStr(id.name, primary: true, isNullable: false);
    st.addStr(username.name, isNullable: false);
    st.addStr(password.name, isNullable: false);
    st.addStr(role.name, isNullable: false);
    st.addStr(phoneNumber.name, isNullable: false);
    st.addStr(email.name, isNullable: false);
    st.addStr(avatar.name, length: 50, isNullable: false);
    st.addStr(avatarPath.name, length: 50, isNullable: false);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(User model,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    final Insert insert = inserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.insert(insert);
  }

  Future<void> insertMany(List<User> models,
      {bool onlyNonNull = false, Set<String> only}) async {
    final List<List<SetColumn>> data = models
        .map((model) =>
            toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
        .toList();
    final InsertMany insert = inserters.addAll(data);
    await adapter.insertMany(insert);
    return;
  }

  Future<dynamic> upsert(User model,
      {bool cascade = false,
      Set<String> only,
      bool onlyNonNull = false}) async {
    final Upsert upsert = upserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.upsert(upsert);
  }

  Future<void> upsertMany(List<User> models,
      {bool onlyNonNull = false, Set<String> only}) async {
    final List<List<SetColumn>> data = [];
    for (var i = 0; i < models.length; ++i) {
      var model = models[i];
      data.add(
          toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
    }
    final UpsertMany upsert = upserters.addAll(data);
    await adapter.upsertMany(upsert);
    return;
  }

  Future<int> update(User model,
      {bool cascade = false,
      bool associate = false,
      Set<String> only,
      bool onlyNonNull = false}) async {
    final Update update = updater
        .where(this.id.eq(model.id))
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.update(update);
  }

  Future<void> updateMany(List<User> models,
      {bool onlyNonNull = false, Set<String> only}) async {
    final List<List<SetColumn>> data = [];
    final List<Expression> where = [];
    for (var i = 0; i < models.length; ++i) {
      var model = models[i];
      data.add(
          toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
      where.add(this.id.eq(model.id));
    }
    final UpdateMany update = updaters.addAll(data, where);
    await adapter.updateMany(update);
    return;
  }

  Future<User> find(String id,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.id.eq(id));
    return await findOne(find);
  }

  Future<int> remove(String id) async {
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove);
  }

  Future<int> removeMany(List<User> models) async {
// Return if models is empty. If this is not done, all records will be removed!
    if (models == null || models.isEmpty) return 0;
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return adapter.remove(remove);
  }
}
