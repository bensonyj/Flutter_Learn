## 给 iOS 开发者的 Flutter 指南

[原文链接](https://mp.weixin.qq.com/s?__biz=MzUyMjg5NTI3NQ==&mid=2247483737&idx=1&sn=dd55f91bce2fd947a9951488ce39558b&chksm=f9c5ab9dceb2228bc0136d2e7b8155e84e87d6123d0e919e35ed013388c02752adbe67c48679&scene=21#wechat_redirect)

[官网中文链接](https://flutter.cn/docs/get-started/flutter-for/ios-devs#viewcontrollers)

### 一、视图Views

####1.UIView 相当于 Flutter 中的什么？

widget不是视图，不直接绘制任何内容，仅仅是对UI的一种描述。

widget的element类比view。

widget整个生命周期不可变，状态发生改变时，flutter将创建一个新的widget实例构造的树状结构

而view只有在`setNeedsDisplay()`才会重绘。

#### 2.该如何更新 Widgets？

在iOS中可以直接对视图进行修改，但是在flutter中widget是不可变的，必须通过修改widget的state来达到更新视图的目的。

在此区分`StatefulWidget` 、`StatelessWidget`，`StatefulWidget` 和 `StatelessWidget` 最重要的区别就是，`StatefulWidget` 中有一个State 对象，它用来存储一些状态的信息，并在整个生命周期内保持不变。

#### 3.如何对 widget 布局？ Storyboard 在哪？

在iOS中可以通过storyboard与代码中加入约束布局，而在flutter只能通过代码对widget进行组织成一个widget树状结构，具体的可以看widget目录的布局方法。(ps：有时候布局才是拦路虎)

#### 4.如何添加或移除一个组件？

在iOS中一般通过`addSubview()` 、`removeFromSuperview()` 来动态添加或删除视图。

而在flutter中一般通过boolean flag来控制子视图是否存在。

#### 5.如何添加动画？

在iOS中，为视图添加动画可以简单的 `animate(withDuration:animations:)` 创建动画。

在 Flutter 里，通过使用动画库将 widget 封装到 animated widget 中来实现带动画效果。

相比起来其实还是较为复杂和重要的。

flutter更多请参考Animation & Motion widgets， Animations tutorial 以及 Animations overview

#### 6.如何渲染到屏幕上？

在 iOS 里，可以使用 `CoreGraphics` 绘制线条和图形到屏幕上。Flutter 里有一套基于 `Canvas` 实现的 API，有两个类可以帮助你进行绘制：`CustomPaint` 和 `CustomPainter`，后者实现了绘制图形到 canvas 的算法。

#### 7.如何设置视图 Widget 的透明度？

在 iOS 里，视图都有一个 opacity 或者 alpha 属性。而在 Flutter 里，大部分时候你都需要封装 widget 到一个 Opacity widget 中来实现这一功能，也就是在widget再封装一个widget。

#### 8.如何构建自定义 widgets？

在 iOS 里，你可以直接继承 `UIView` 或者使用已经存在的视图，然后重写并实现对应的方法来达到想要的效果。在 Flutter 里，构建自定义 widget 需要通过合成一些小的 widget（而不是对它们进行扩展）来实现。

###二、导航

#### 1.如何在不同页面之间切换？

iOS中一般用`UINavigationController`管理栈，Flutter中一般用`Navigator`和`Routes`来管理，一个 `Routes` 是应用中屏幕或者页面的抽象概念，而一个 `Navigator` 是管多个 `Route` 的 widget。

1.构建由 route 名称组成的 Map（MaterialApp），也称静态路由，不可向下传递参数

2.直接跳转到一个 route（WidgetApp），也称动态路由，可以向下传递参数

两者都能异步接收下个页面返回的参数。

##### 静态路由

```dart
void main() {
  runApp(MaterialApp(
    home: MyAppHome(), // becomes the route named '/'
    routes: <String, WidgetBuilder> {
      '/a': (BuildContext context) => MyPage(title: 'page A'),
      '/b': (BuildContext context) => MyPage(title: 'page B'),
      '/c': (BuildContext context) => MyPage(title: 'page C'),
    },
  ));
}
```

通过把 route 的名称 `push` 给一个 `Navigato` 来跳转：

```dart
Navigator.of(context).pushNamed('/b');
```

##### 动态路由

```dart
Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return new EchoRoute("传入跳转参数");
        }));
```

##### 回调参数

```dart
// 上个页面接收参数
Map coordinates = await Navigator.of(context).pushNamed('/location');
// 下个页面向上传递
Navigator.of(context).pop({"lat":43.821757,"long":-79.226392});
```

#### 2.如何跳转到其他应用？

在iOS中，用URL scheme跳转

在Flutter中，需要创建原生平台的整合层，或者使用已经存在的插件，例如 [`url_launcher`](https://pub.flutter-io.cn/packages/url_launcher)。

#### 3.如何退回到 iOS 原生的 viewcontroller？

在 Dart 代码中调用 `SystemNavigator.pop()` 将会调用下面的 iOS 代码：

```objective-c
UIViewController* viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
  if ([viewController isKindOfClass:[UINavigationController class]]) {
    [((UINavigationController*)viewController) popViewControllerAnimated:NO];
  }
```

也可以创建自己的[平台通道](https://flutter.cn/docs/development/platform-integration/platform-channels)来调用 对应的 iOS 代码。

### 三、线程和异步

#### 1.如何编写异步代码？

Dart 是单线程执行模型，支持 `Isolate`（一种在其他线程运行 Dart 代码的方法）、事件循环和异步编程。 除非生成了 `Isolate`，否则所有 Dart 代码将永远在主 UI 线程运行，并由事件循环驱动。Flutter 中的事件循环类似于 iOS 中的 main loop—，也就是主线程上的 `Looper`。

Dart 的单线程模型并不意味着你需要以阻塞 UI 的形式来执行代码，相反，你更应该使用 Dart 语言提供的异步功能， 比如使用 `async` / `await` 来实现异步操作。

#### 2.如何让你的工作在后台线程执行？

由于 Flutter 是单线程模型，而且执行着一个 event loop（就像 Node.js），你不需要为线程管理或 是开启后台线程操心。如果你在处理 I/O 操作，例如磁盘访问或网络请求，那么你安全地使用 `async` / `await` 就可以了。但是，如果你需要大量的计算来让 CPU 保持忙碌状态，你需要使用 `Isolate` 来防治阻塞 event loop。

然而，有时候你需要处理大量的数据，从而导致 UI 挂起。在 Flutter 里，当处理长期运行或者运算密集的任务时，可以使用 `Isolate` 来发挥出多核 CPU 的优势。

Isolates 是相互隔离的执行线程，并不和主线程共享内存。这意味着你不能够访问主线程的变量，也不能 使用 `setState()` 来更新 UI。Isolates 正如起字面意思是不能共享内存（例如静态变量表）的。

具体实现可参考例子[在 Flutter 中使用多 Isolate](https://reetyo.github.io/2019/02/18/2019-02-18/)

#### 3.如何发起网络请求

在 `pubspec.yaml` 中把它添加 `http` 库依赖，当然也可以使用其他库或者自行封装管理

```dart
loadData() async {
    String dataURL = "https://jsonplaceholder.typicode.com/posts";
    http.Response response = await http.get(dataURL);
    setState(() {
      widgets = json.decode(response.body);
    });
  }
}
```

#### 4.如何展示耗时任务的进度？

在 iOS 中，在后台运行耗时任务时，会使用 `UIProgressView`。

在 Flutter 中，应该使用 `ProgressIndicator`。它在渲染时通过一个 boolean flag 来控制是否显示进度。在耗时任务开始前，告诉 Flutter 去更新状态，并在任务结束后隐藏。例子相对简单，可以直接看官网例子。

### 四、工程结构、本地化、依赖和资源

#### 1.如何在 Flutter 中引入 图片资源？如何处理多分辨率？

在 iOS中，图片和其他资源会被视为不同的资源分别处理，而在 Flutter 中只有资源这一个概念。 iOS 里被放置在 `Images.xcasset` 文件夹的资源在 Flutter 中都被放置到了 assets 文件夹中。 和 iOS 一样，assets 中可以放置任意类型的文件，而不仅仅是图片。 例如，你可以把一个 JSON 文件放置到 `my-assets` 文件夹中。

```yaml
my-assets/data.json
// 其他
images/my_icon.png       // Base: 1.0x image
images/2.0x/my_icon.png  // 2.0x image
images/3.0x/my_icon.png  // 3.0x image
```

在 `pubspec.yaml` 中声明 assets：

```yaml
assets:
 - my-assets/data.json
 - images/my_icon.jpeg
```

你可以用 `AssetImage` 来访问这些图片：

```dart
return AssetImage("images/a_dot_burr.jpeg");
```

或者在 `Image` widget 中直接使用：

```dart
@override
Widget build(BuildContext context) {
  return Image.asset("images/my_image.png");
}
```

关于更多的细节，请参见  [在 Flutter 中添加资源和图片](https://flutter.cn/docs/development/ui/assets-and-images)。

#### 2.字符串存储在哪里？如何处理本地化?

iOS 里有 `Localizable.strings` 文件，而 Flutter 则不同，目前并没有关于字符串的处理系统。

Flutter本地化需要引入 `flutter_localizations` 库， 同时可能还需要添加 `intl` 库来使用 i10n 机制，比如 日期/时间的格式化等。具体国际化内容可以参照官网配置 [internationalization guide](https://flutter.cn/docs/development/accessibility-and-localization/internationalization)。

#### 3.Cocoapods 相当于 Flutter 中的什么？该如何添加依赖？

在 iOS 里，可以通过 `Podfile` 添加依赖。而 Flutter 使用 Dart 构建系统和 Pub 包管理器来处理依赖。这些工具将原生应用的打包任务分发给相应 Android 或 iOS 构建系统。

如果你的 Flutter 项目 iOS 文件夹中存在 Podfile，那么请仅在里面添加原生平台的依赖。总而言之， 在 Flutter 中使用 `pubspec.yaml` 来声明外部依赖。你可以通过 [Pub](https://pub.flutter-io.cn/flutter/packages)来查找一些优秀的 Flutter 第三方包。

### 五、ViewControllers

#### 1.ViewControllers 相当于 Flutter 中的什么？

在 iOS 里，一个 `ViewController` 是用户界面的一部分，通常是作为屏幕或者其中的一部分来使用。 这些组合在一起构成了复杂的用户界面，并以此对应用的 UI 做不断的扩充。 在 Flutter 中，这一任务又落到了 Widget 这里。就像在导航那一章提到的， Flutter 中的屏幕也是使用 Widgets 表示的，因为“万物皆 widget！”。使用 `Naivgator` 在不同的 `Route` 之间切换，而不同的路由则代表了不同的屏幕或页面，或是不同的状态，也可能是渲染相同的数据。

#### 2.如何监听 iOS 中的生命周期？

在 iOS 里，可以重写 `ViewController` 的方法来捕获自身的生命周期，或者在 `AppDelegate` 中注册生命 周期的回调。Flutter 中则没有这两个概念，但是你可以通过在 `WidgetsBinding` 的 observer 中挂钩子，也可以 通过监听 `didChangeAppLifecycleState()` 事件，来实现相应的功能。

可监听的生命周期事件有：

- `inactive` - 应用当前处于不活跃状态，不接收用户输入事件。 这个事件只在 iOS 上有效，Android 中没有类似的状态。
- `paused` - 应用当前处于用户不可见状态，不接收用户输入事件，但仍在后台运行。
- `resumed` - 应用可见，也响应用户输入。
- `suspending` - 应用被挂起，在 iOS 平台没有这一事件。

关于这些状态的更多细节，请参看 [`AppLifecycleStatus` 文档](https://api.flutter.dev/flutter/dart-ui/AppLifecycleState-class.html)。

### 六、布局

#### 1.`UITableView` 和 `UICollectionView` 相当于 Flutter 中的什么？

在 iOS 里，你可能使用 `UITableView` 或者 `UICollectionView` 来展示一个列表。而在 Flutter 里， 你可以使用 `ListView`来达到类似的实现。 在 iOS 中，你通过 delegate 方法来确定显示的行数，相应位置的 cell，以及 cell 的尺寸。

由于 Flutter 中 widget 的不可变特性，你需要向 `ListView` 传递一个 widget 列表，Flutter 会确保滚动 快速而流畅。

#### 2.如何确定列表中被点击的元素？

在 iOS 里，可以通过 `tableView:didSelectRowAtIndexPath:` 代理方法来实现。 而在 Flutter 里，需要通过 widget 传递进来的 touch 响应处理来实现。

#### 3.如何动态更新 `ListView`？

在 iOS 里，可以更新列表的数据，然后通过调用 `reloadData` 方法来通知 tableView 或者 collectionView。

在 Flutter 里，如果你在 `setState()` 中更新了 widget 列表，你会发现展示的数据并不会立刻更新。 这是因为当 `setState()` 被调用时，Flutter 的渲染引擎回去检索 widget 树是否有改变。当它获取到 `ListView`， 会进行 `==` 判断，然后发现两个 `ListView` 是相等的。没发现有改变，所以也就不会进行更新。

一个更新 `ListView` 的简单方法就是，在 `setState()` 创建一个新的 `List`，然后拷贝旧列表中的 所有数据到新列表。这样虽然简单，但是像下面示例一样数据量很大时，并不推荐这样做。

一个推荐的、高效且有效的方法就是使用 `ListView.Builder` 来构建列表。当你的数据量很大， 且需要构建动态列表时，这个方法会非常好用。和创建 `ListVie` 不同，创建 `ListView.Builder` 需要两个关键参数：初始化列表长度和 `ItemBuilder` 函数。

`ItemBuilder` 函数和 iOS 里 tableView 和 collectionView 的 `cellForItemAt` 方法类似， 它接收位置参数，然后返回想要在该位置渲染的 cell。

#### 4.`ScrollView` 相当于 Flutter 中的什么？

在 iOS 里，把视图放在 `ScrollView` 里来允许用户在需要时滚动内容。

在 Flutter 中，最简单的办法就是使用 `ListView` widget。它和 iOS 中的 `ScrollView` 以 及 `TableView` 表现一致，也可以给它的子 widget 做垂直排版。

关于 Flutter 中布局的更多细节，请参看[布局教程](https://flutter.cn/docs/development/ui/widgets/layout)。

### 七、手势检测与 touch 事件处理

#### 1.如何给 Flutter 的 widget 添加点击事件？

在 iOS 里，通过把 `GestureRecognizer` 绑定给 UIView 来处理点击事件。在 Flutter 中， 有两种方法来添加事件监听者：

1. 如果 widget 本身支持事件检测，则直接传递处理函数给它。例如，`RaisedButton` 拥有 一个 `onPressed` 参数
2. 如果 widget 本身不支持事件检测，那么把它封装到一个 GestureDetector 中，并 给它的 `onTap` 参数传递一个函数

#### 2.如何处理 widget 的其他手势？

你可以使用 `GestureDetector` 来监听更多的手势，例如：

- 单击事件
  - `onTapDown` —— 用户在特定区域发生点触屏幕的一个即时操作。
  - `onTapUp` —— 用户在特定区域发生触摸抬起的一个即时操作。
  - `onTap` —— 从点触屏幕之后到触摸抬起之间的单击操作。
  - `onTapCancel` —— 用户在之前触发了 `onTapDown` 时间，但未触发 tap 事件。
- 双击事件
  - `onDoubleTap` —— 用户在同一位置发生快速点击屏幕两次的操作。
- 长按事件
  - `onLongPress` —— 用户在同一位置长时间触摸屏幕的操作。
- 垂直拖动事件
  - `onVerticalDragStart` —— 用户手指接触屏幕，并且将要进行垂直移动事件。
  - `onVerticalDragUpdate` —— 用户手指接触屏幕，已经开始垂直移动，且会持续进行移动。
  - `onVerticalDragEnd` —— 用户之前手指接触了屏幕并发生了垂直移动操作，并且停止接触前还在以一定的速率移动。
- 水平拖动事件
  - `onHorizontalDragStart` —— 用户手指接触屏幕，并且将要进行水平移动事件。
  - `onHorizontalDragUpdate` —— 用户手指接触屏幕，已经开始水平移动，且会持续进行移动。
  - `onHorizontalDragEnd` —— 用户之前手指接触了屏幕并发生了水平移动操作，并且停止接触前还在以一定的速率移动。

### 八、主题和文字

#### 1.如何设置应用主题？

Flutter 实现了一套漂亮的 Material Design 组件,在 iOS 上，可以使 用 [Cupertino library](https://api.flutter.dev/flutter/cupertino/cupertino-library.html) 来 制作遵循 [Human Interface Guidelines](https://developer.apple.com/ios/human-interface-guidelines/overview/themes/) 的 界面。关于这些 widget 的全部集合，可以参看 [Cupertino widgets gallery](https://flutter.cn/docs/development/ui/widgets/cupertino)。

#### 2.如何给 `Text` widget 设置自定义字体？

在 iOS 里，可以在项目中引入任何的 `ttf` 字体文件，并在 `info.plist` 文件中声明并进行引用。 在 Flutter 里，把字体放到一个文件夹中，然后在 `pubspec.yaml` 文件中引用它，就和引用图片一样。

```yaml
fonts:
   - family: MyCustomFont
     fonts:
       - asset: fonts/MyCustomFont.ttf
       - style: italic
```

然后在 `Text` widget 中指定字体：

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Sample App"),
    ),
    body: Center(
      child: Text(
        'This is a custom font text',
        style: TextStyle(fontFamily: 'MyCustomFont'),
      ),
    ),
  );
}
```

#### 3.如何设置 `Text` widget 的样式？

除了字体以外，你也可以自定义 `Text` widget 的其他样式。`Text` widget 接收一个 `TextStyle` 对象 的参数，可以指定很多参数，例如：

- `color`
- `decoration`
- `decorationColor`
- `decorationStyle`
- `fontFamily`
- `fontSize`
- `fontStyle`
- `fontWeight`
- `hashCode`
- `height`
- `inherit`
- `letterSpacing`
- `textBaseline`
- `wordSpacing`

### 九、表单输入

#### 1.Flutter 中如何使用表单？如何获取到用户的输入？

和 Flutter 的其他部分一样，表单处理要通过特定的 widget 来实现。如果你有一个 `TextField` 或者 `TextFormField`， 你可以通过 [`TextEditingController`](https://api.flutter.dev/flutter/widgets/TextEditingController-class.html) 来 获取用户的输入

在 [Flutter Cookbook](https://flutter.cn/docs/cookbook) 的 [Retrieve the value of a text field](https://flutter.cn/docs/cookbook/forms/retrieve-input) 中可以找到更多的相关内容以及详细的代码列表。

#### 2.TextField 中的 placeholder 相当于什么？

在 Flutter 里，通过向 `Text` widget 传递一个 `InputDecoration` 对象，你可以轻易的显示 文本框的提示信息，或是 placeholder。

```dart
body: Center(
  child: TextField(
    decoration: InputDecoration(hintText: "This is a hint"),
  ),
)
```

#### 3.如何展示验证错误信息？

就和显示提示信息一样，你可以通过向 `Text` widget 传递一个 `InputDecoration` 来实现。

然而，你并不想在一开始就显示错误信息。相反，在用户输入非法数据后，应该更新状态，并传递一个新 的 `InputDecoration` 对象。

### 十、和硬件、第三方服务以及系统平台交互

#### 1.如何与系统平台以及平台原生代码进行交互？

Flutter 并不直接在平台上运行代码；而是以 Dart 代码的方式原生运行于设备之上，这算是绕过了平台的 SDK 的限制。 这意味着，例如，你用 Dart 发起了一个网络请求，它会直接在 Dart 的上下文中运行。 你不需要调用写 iOS 或者 Android 原生应用时常用的 API 接口。你的 Flutter 应用仍旧被原生平台 的 `ViewController` 当做一个 view 来管理，但是你不能够直接访问 `ViewController` 自身或是 对应的原生框架。

这并不意味着 Flutter 应用不能够和原生 API，或是原生代码进行交互。Flutter 提供了用来和宿主 `ViewController` 通信 和交换数据的 [platform channels](https://flutter.cn/docs/development/platform-integration/platform-channels)。 platform channels 本质上是一个桥接了 Dart 代码与宿主 `ViewController` 和 iOS 框架的异步通信模型。 你可以通过 platform channels 来执行原生代码的方法，或者获取设备的传感器信息等数据。

除了直接使用 platform channels 之外，也可以使用一系列包含了原生代码和 Dart代码，实现了特定功能的 现有[插件](https://flutter.cn/docs/development/packages-and-plugins/using-packages)。例如，你在 Flutter 中 可以直接使用插件来访问相册或是设备摄像头，而不需要自己重新集成。[Pub](https://pub.flutter-io.cn/packages) 是一个 Dart 和 Flutter 的开源包仓库，你可以在这里找到需要的插件。有些包可能支持集成 iOS 或 Android，或两者皆有。

如果你在 Pub 找不到自己需要的包，你可以[自己写一个](https://flutter.cn/docs/development/packages-and-plugins/developing-packages)， 并[发布到 Pub 上](https://flutter.cn/docs/development/packages-and-plugins/developing-packages#publish)。

#### 2. 如何访问 GPS 传感器？

使用 [`geolocator`](https://pub.flutter-io.cn/packages/geolocator) 插件，这一插件由社区提供。

#### 3.如何访问相机？

[`image_picker`](https://pub.flutter-io.cn/packages/image_picker) 是常用的访问相机的插件。

#### 4.如何使用 Facebook 登录？

登录 Facebook 可以使用 [`flutter_facebook_login`](https://pub.flutter-io.cn/packages/flutter_facebook_login) 插件。

#### 5.如何集成 Firebase 的功能？

大多数的 Firebase 特性都在 [官方维护的插件](https://pub.flutter-io.cn/flutter/packages?q=firebase) 中实现了。 这些插件由 Flutter 官方团队维护：

- 搭配 [`firebase_admob`](https://pub.flutter-io.cn/packages/firebase_admob) 插件来使用 Firebase AdMob
- 搭配 [`firebase_analytics`](https://pub.flutter-io.cn/packages/firebase_analytics) 插件来使用 Firebase Analytics
- 搭配 [`firebase_auth`](https://pub.flutter-io.cn/packages/firebase_auth) 插件来使用 Firebase Auth
- 搭配 [`firebase_core`](https://pub.flutter-io.cn/packages/firebase_core) 插件来使用 Firebase 核心库
- 搭配 [`firebase_database`](https://pub.flutter-io.cn/packages/firebase_database) 插件来使用 Firebase RTDB
- 搭配 [`firebase_storage`](https://pub.flutter-io.cn/packages/firebase_storage) 插件来使用 Firebase Cloud Storage
- 搭配 [`firebase_messaging`](https://pub.flutter-io.cn/packages/firebase_messaging) 插件来使用 Firebase Messaging (FCM)
- 搭配 [`cloud_firestore`](https://pub.flutter-io.cn/packages/cloud_firestore) 插件来使用 Firebase Cloud Firestore

在 Pub 上你也可以找到一些第三方的 Firebase 插件，主要实现了官方插件没有直接实现的功能。

#### 6.如何构建自己的插件？

如果有一些 Flutter 和遗漏的平台特性，可以 根据 [developing packages and plugins](https://flutter.cn/docs/development/packages-and-plugins/developing-packages) 构建 自己的插件。

Flutter 的插件结构，简单来说，更像是 Android 中的 Event bus：你发送一个消息，并让接受者处理并反馈 结果给你。这种情况下，接受者就是在 iOS 或 Android 的原生代码。

### 十一、数据库和本地存储

#### 1.Flutter 中如何访问 `UserDefaults`？

在 iOS 里，可以使用属性列表存储一个键值对的集合，也就是我们所说的 `UserDefaults`。

在 Flutter 里，可以使用 [Shared Preferences 插件](https://pub.flutter-io.cn/packages/shared_preferences) 来实现相同的功能。这个插件封装了 `UserDefaults` 以及 Android 里类似的 `SharedPreferences`。

#### 2.CoreData 相当于 Flutter 中的什么？

在 iOS 里，你可以使用 CoreData 来存储结构化的数据。这是一个基于 SQL 数据库的上层封装，可以使 关联模型的查询变得更加简单。

在 Flutter 里，可以使用 [SQFlite](https://pub.flutter-io.cn/packages/sqflite) 插件来实现这个功能。

### 十二、通知

#### 1.如何设置推送通知？

在 iOS 里，你需要向开发者中心注册来允许推送通知。

在 Flutter 里，使用 `firebase_messaging` 插件来实现这个功能。

关于 Firebase Cloud Messaging API 的更多信息，可以 查看 [`firebase_messaging`](https://pub.flutter-io.cn/packages/firebase_messaging) 插件文档。





