## flutter国际化

[原文链接](https://flutter.dev/docs/development/accessibility-and-localization/internationalization)

### 最基础方式添加国际化

- 在pubspec.yaml 中dependencies中添加flutter_localizations 架包

- ```dart
  dependencies:
    flutter:
      sdk: flutter
    flutter_localizations:
      sdk: flutter
  ```

- 然后在Main.dart中MeterialApp中添加 localizationsDelegates 和 supportedLocales

- ```dart
  import 'package:flutter_localizations/flutter_localizations.dart';
  
  MaterialApp(
   localizationsDelegates: [
     GlobalMaterialLocalizations.delegate,
     GlobalWidgetsLocalizations.delegate,
   ],
   supportedLocales: [
      const Locale('en', 'US'), // English
      const Locale('zh', 'CN'), // 中文
      // 其他语种
    ],
    // ...
  )
  ```

- 可自定义一个新增文件localizations.dart如下

- ```dart
  import 'package:flutter/foundation.dart' show SynchronousFuture;
  import 'package:flutter/material.dart’;
  import 'dart:async’;
  
  class DemoLocalizations {
      DemoLocalizations(this.locale);
      final Locale locale;
      static DemoLocalizations of(BuildContext context) {
          return Localizations.of<DemoLocalizations>(context, DemoLocalizations);
      }
  
      static Map<String, Map<String, String>> _localozedValues = {
          'en': {
          'title': 'World',
          'login_tip': 'Login',
          'password_tip': 'Password',
          'login_btn': 'comfirm',
          },
          'zh': {
          'title': '世界',
          'login_tip': '登录',
          'password_tip': '密码',
          'login_btn': '确定',
          },
      };
  
    String get title {
    	return _localozedValues[locale.languageCode]['title'];
    }
    String get login_tip {
    	return _localozedValues[locale.languageCode]['login_tip'];
    }
    String get password_tip {
    	return _localozedValues[locale.languageCode]['password_tip'];
    }
  
    String get login_btn {
    	return _localeLange['login_btn'];
    }
  
    Map get _localeLange {
    	return _localozedValues[locale.languageCode];
    }
  }
  
  class DemoLocalizationDelegate extends LocalizationsDelegate<DemoLocalizations> {
    const DemoLocalizationDelegate();
    @override
    bool isSupported(Locale locale) => ['en', 'zh'].contains(locale.languageCode);
    
    @override
    Future<DemoLocalizations> load(Locale locale) {
    	return SynchronousFuture<DemoLocalizations>(DemoLocalizations(locale));
    }
  
    @override
    bool shouldReload(DemoLocalizationDelegate old) => false;
  }
  ```

- 然后在Main.dart中添加

- ```dart
  import  ‘package:(your project name)/(your files)/localizations.dart’;
  …
  
  MaterialApp(
   localizationsDelegates: [
     GlobalMaterialLocalizations.delegate,
     GlobalWidgetsLocalizations.delegate,
     const DemoLocalizationDelegate(), // 自定义相关语种
   ],
   supportedLocales: [
      const Locale('en', 'US'), // English
      const Locale('zh', 'CN'), // 中文
      // 其他语种
    ],
    // ...
  )
  
  // 在需要的地方import语言定义的文件，然后用法如：
  DemoLocalizations.of(context).title
  DemoLocalizations.of(context).login_btn
  ```

- 再根据各个平台设置平台相关设置

  iOS： 

  选中工程目录中ios->Runner->Info.plist 

  可用Xcode打开，添加Localizations，再根据语言添加对应语种 

  或者直接再Info.plist中添加如下格式： 

- ```objective-c
  <key>CFBundleLocalizations</key>
      <array>
          <string>en</string>
          <string>zh</string>
      </array>
  ```

### 使用Intl生成*.arb

具体看官网介绍和项目实践 

(后续完善) 可看[简书介绍](<https://www.jianshu.com/p/b9f830efe1f8>)

- 插件中找到i18n，下载并重启
- 