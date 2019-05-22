import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'model/app_state_model.dart';

void main(List<String> args) {
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );

  return runApp(ChangeNotifierProvider<AppStateModel>(
    builder: (conttext) => AppStateModel()..loadProducts(),
    child: CupertinoStoreApp(),
  ));
}