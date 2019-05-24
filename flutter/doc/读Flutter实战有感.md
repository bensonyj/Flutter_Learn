# [读Flutter实战有感](https://book.flutterchina.club)

## 起步-概念

### 移动开发技术简介

从框架角度对比一下：

| 技术类型            | UI渲染方式      | 性能 | 开发效率        | 动态化     | 框架代表       |
| ------------------- | --------------- | ---- | --------------- | ---------- | -------------- |
| H5+原生             | WebView渲染     | 一般 | 高              | ✔️          | Cordova、Ionic |
| JavaScript+原生渲染 | 原生控件渲染    | 好   | 高              | ✔️          | RN、Weex       |
| 自绘UI+原生         | 调用系统API渲染 | 好   | Flutter高, QT低 | 默认不支持 | QT、Flutter    |

Flutter默认AOT编译Release，不支持动态化，但是JIT模式支持。

### Flutter简介

使用Skia作为其2D渲染引擎，由于Android系统已经内置了Skia，所以Flutter在打包APK(Android应用安装包)时，不需要再将Skia打入APK中，但iOS系统并未内置Skia，所以构建iPA时，也必须将Skia一起打包，这也是为什么Flutter APP的Android安装包比iOS安装包小的主要原因。

#### 高性能

Flutter高性能主要靠两点来保证，首先，Flutter APP采用Dart语言开发。Dart在 JIT（即时编译）模式下，速度与 JavaScript基本持平。但是 Dart支持 AOT，当以 AOT模式运行时，JavaScript便远远追不上了。速度的提升对高帧率下的视图数据计算很有帮助。其次，Flutter使用自己的渲染引擎来绘制UI，布局数据等由Dart语言直接控制，所以在布局过程中不需要像RN那样要在JavaScript和Native之间通信，这在一些滑动和拖动的场景下具有明显优势，因为在滑动和拖动过程往往都会引起布局发生变化，所以JavaScript需要和Native之间不停的同步布局信息，这和在浏览器中要JavaScript频繁操作DOM所带来的问题是相同的，都会带来比较可观的性能开销。

####Flutter框架结构图

![image-20180816160424567](https://cdn.jsdelivr.net/gh/flutterchina/flutter-in-action@1.0/docs/imgs/framework.png)

### 搭建Flutter开发环境

Flutter SDK有多个分支，如beta、dev、master、stable，其中stable分支为稳定分支（日后有新的稳定版本发布后可能也会有新的稳定分支，如1.0.0），dev和master为开发分支

####常用命令

`flutter channel` 查看所有分支

`flutter channel master` 切换分支

`flutter upgrade` 升级flutter

`flutter packages get `   获取项目所有的依赖包

`flutter packages upgrade`  获取项目所有依赖包的最新版本

### 包管理

#### 依赖Pub仓库

官方仓库：https://pub.dartlang.org/ 

依赖如`cupertino_icons: ^0.1.0`

#### 依赖本地包

```yaml
dependencies:
    pkg1://(包名)
        path: ../../code/pkg1  //(路径可以相对也可以绝对)
```

#### 依赖Git

- 依赖存储在Git仓库中的包，如果软件包位于仓库的根目录中

  ```yaml
  dependencies:
    pkg1:
      git:
        url: git://github.com/xxx/pkg1.git
  ```

- 如果不是这种情况，可以使用path参数指定相对位置

  ```yaml
  dependencies:
    package1:
      git:
        url: git://github.com/flutter/packages.git
        path: packages/package1
  ```

### 资源管理

assets是会打包到程序安装包中的，可在运行时访问。常见类型的assets包括静态数据（例如JSON文件）、配置文件、图标和图片（JPEG，WebP，GIF，动画WebP / GIF，PNG，BMP和WBMP）等。

```yaml
flutter:
  assets:
    - assets/my_icon.png
    - assets/background.png
```

每个asset都通过相对于`pubspec.yaml`文件所在位置的显式路径进行标识。asset的声明顺序是无关紧要的。asset的实际目录可以是任意文件夹（在本示例中是assets）。

在构建期间，Flutter将asset放置到称为 *asset bundle* 的特殊存档中，应用程序可以在运行时读取它们（但不能修改）。

#### Asset变体(variant)

例如，如果应用程序目录中有以下文件:

- …/pubspec.yaml
- …/graphics/my_icon.png
- …/graphics/background.png
- …/graphics/dark/background.png
- …etc.

然后`pubspec.yaml`文件中只需包含:

```
flutter:
  assets:
    - graphics/background.png
```

那么这两个`graphics/background.png`和`graphics/dark/background.png` 都将包含在您的asset bundle中。前者被认为是*main asset* （主资源），后者被认为是一种变体（variant）。

在选择匹配当前设备分辨率的图片时，Flutter会使用到asset变体

#### 加载文本

- 通过[`rootBundle`](https://docs.flutter.io/flutter/services/rootBundle.html) 对象加载：每个Flutter应用程序都有一个[`rootBundle`](https://docs.flutter.io/flutter/services/rootBundle.html)对象， 通过它可以轻松访问主资源包，直接使用`package:flutter/services.dart`中全局静态的`rootBundle`对象来加载asset即可。
- 通过 [`DefaultAssetBundle`](https://docs.flutter.io/flutter/widgets/DefaultAssetBundle-class.html) 加载：建议使用 [`DefaultAssetBundle`](https://docs.flutter.io/flutter/widgets/DefaultAssetBundle-class.html) 来获取当前BuildContext的AssetBundle。 这种方法不是使用应用程序构建的默认asset bundle，而是使父级widget在运行时动态替换的不同的AssetBundle，这对于本地化或测试场景很有用。

通常，可以使用`DefaultAssetBundle.of()`在应用运行时来间接加载asset（例如JSON文件），而在widget上下文之外，或其它`AssetBundle`句柄不可用时，可以使用`rootBundle`直接加载这些asset，例如：

```dart
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

Future<String> loadAsset() async {
  return await rootBundle.loadString('assets/config.json');
}
```

#### 加载图片

[`AssetImage`](https://docs.flutter.io/flutter/painting/AssetImage-class.html) 可以将asset的请求逻辑映射到最接近当前设备像素比例(dpi)的asset。为了使这种映射起作用，必须根据特定的目录结构来保存asset：

- …/image.png
- …/**M**x/image.png
- …/**N**x/image.png
- …etc.

其中M和N是数字标识符，对应于其中包含的图像的分辨率，也就是说，它们指定不同设备像素比例的图片。

主资源默认对应于1.0倍的分辨率图片。看一个例子：

- …/my_icon.png
- …/2.0x/my_icon.png
- …/3.0x/my_icon.png

在设备像素比率为1.8的设备上，`.../2.0x/my_icon.png` 将被选择。对于2.7的设备像素比率，`.../3.0x/my_icon.png`将被选择。

如果未在`Image` widget上指定渲染图像的宽度和高度，那么`Image` widget将占用与主资源相同的屏幕空间大小。 也就是说，如果`.../my_icon.png`是72px乘72px，那么`.../3.0x/my_icon.png`应该是216px乘216px; 但如果未指定宽度和高度，它们都将渲染为72像素×72像素（以逻辑像素为单位）。

`pubspec.yaml`中asset部分中的每一项都应与实际文件相对应，但主资源项除外。当主资源缺少某个资源时，会按分辨率从低到高的顺序去选择 ，也就是说1x中没有的话会在2x中找，2x中还没有的话就在3x中找。

要加载图片，可以使用 [`AssetImage`](https://docs.flutter.io/flutter/painting/AssetImage-class.html)类。例如，我们可以从上面的asset声明中加载背景图片：

```dart
Widget build(BuildContext context) {
  return new DecoratedBox(
    decoration: new BoxDecoration(
      image: new DecorationImage(
        image: new AssetImage('graphics/background.png'),
      ),
    ),
  );
}
```

注意，`AssetImage` 并非是一个widget， 它实际上是一个`ImageProvider`，有些时候你可能期望直接得到一个显示图片的widget，那么你可以使用`Image.asset()`方法，如：

```dart
Widget build(BuildContext context) {
  return Image.asset('graphics/background.png');
}
```

使用默认的 asset bundle 加载资源时，内部会自动处理分辨率等，这些处理对开发者来说是无感知的。 (如果使用一些更低级别的类，如 [`ImageStream`](https://docs.flutter.io/flutter/painting/ImageStream-class.html)或 [`ImageCache`](https://docs.flutter.io/flutter/painting/ImageCache-class.html) 时你会注意到有与缩放相关的参数)

#### 加载依赖包中的资源图片

例如，假设您的应用程序依赖于一个名为“my_icons”的包，它具有如下目录结构：

- …/pubspec.yaml
- …/icons/heart.png
- …/icons/1.5x/heart.png
- …/icons/2.0x/heart.png
- …etc.

然后加载图像，使用:

```dart
 new AssetImage('icons/heart.png', package: 'my_icons')
```

或

```dart
new Image.asset('icons/heart.png', package: 'my_icons')
```

**注意：包在使用本身的资源时也应该加上package参数来获取**。

### 调试相关

一般性能调试都是后续进行，或者团队较大有余力操作，[详情](https://book.flutterchina.club/chapter2/flutter_app_debug.html)

### Dart线程模型及异常捕获

![both-queues](https://cdn.jsdelivr.net/gh/flutterchina/flutter-in-action/docs/imgs/both-queues.png)

#### 异常捕获和日志上报

```dart
void collectLog(String line){
    ... //收集日志
}
void reportErrorAndLog(FlutterErrorDetails details){
    ... //上报错误和日志逻辑
}

FlutterErrorDetails makeDetails(Object obj, StackTrace stack){
    ...// 构建错误信息
}

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    reportErrorAndLog(details);
  };
  runZoned(
    () => runApp(MyApp()),
    zoneSpecification: ZoneSpecification(
      print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
        collectLog(line); // 收集日志
      },
    ),
    onError: (Object obj, StackTrace stack) {
      var details = makeDetails(obj, stack);
      reportErrorAndLog(details);
    },
  );
}
```

## 基础Widgets

在Flutter中，Widget的功能是“描述一个UI元素的配置数据”，它就是说，Widget其实并不是表示最终绘制在设备屏幕上的显示元素，而只是显示元素的一个配置数据。实际上，Flutter中真正代表屏幕上显示元素的类是`Element`，也就是说Widget只是描述`Element`的一个配置。

- Widget实际上就是Element的配置数据，Widget树实际上是一个配置树，而真正的UI渲染树是由Element构成；不过，由于Element是通过Widget生成，所以它们之间有对应关系，所以在大多数场景，我们可以宽泛地认为Widget树就是指UI控件树或UI渲染树。
- 一个Widget对象可以对应多个Element对象。这很好理解，根据同一份配置（Widget），可以创建多个实例（Element）。

### 生命周期

![img](https://user-gold-cdn.xitu.io/2019/4/6/169f0af0a1b78bef?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)

- `initState`：当Widget第一次插入到Widget树时会被调用，对于每一个State对象，Flutter framework只会调用一次该回调，所以，通常在该回调中做一些一次性的操作，如状态初始化、订阅子树的事件通知等。不能在该回调中调用`BuildContext.inheritFromWidgetOfExactType`（该方法用于在Widget树上获取离当前widget最近的一个父级`InheritFromWidget`，关于`InheritedWidget`我们将在后面章节介绍），原因是在初始化完成后，Widget树中的`InheritFromWidget`也可能会发生变化，所以正确的做法应该在在`build（）`方法或`didChangeDependencies()`中调用它。
- `didChangeDependencies()`：当State对象的依赖发生变化时会被调用；例如：在之前`build()` 中包含了一个`InheritedWidget`，然后在之后的`build()` 中`InheritedWidget`发生了变化，那么此时`InheritedWidget`的子widget的`didChangeDependencies()`回调都会被调用。典型的场景是当系统语言Locale或应用主题改变时，Flutter framework会通知widget调用此回调。
- `build()`：此回调读者现在应该已经相当熟悉了，它主要是用于构建Widget子树的，会在如下场景被调用：
  1. 在调用`initState()`之后。
  2. 在调用`didUpdateWidget()`之后。
  3. 在调用`setState()`之后。
  4. 在调用`didChangeDependencies()`之后。
  5. 在State对象从树中一个位置移除后（会调用deactivate）又重新插入到树的其它位置之后。
- `reassemble()`：此回调是专门为了开发调试而提供的，在热重载(hot reload)时会被调用，此回调在Release模式下永远不会被调用。
- `didUpdateWidget()`：在widget重新构建时，Flutter framework会调用`Widget.canUpdate`来检测Widget树中同一位置的新旧节点，然后决定是否需要更新，如果`Widget.canUpdate`返回`true`则会调用此回调。正如之前所述，`Widget.canUpdate`会在新旧widget的key和runtimeType同时相等时会返回true，也就是说在在新旧widget的key和runtimeType同时相等时`didUpdateWidget()`就会被调用。
- `deactivate()`：当State对象从树中被移除时，会调用此回调。在一些场景下，Flutter framework会将State对象重新插到树中，如包含此State对象的子树在树的一个位置移动到另一个位置时（可以通过GlobalKey来实现）。如果移除后没有重新插入到树中则紧接着会调用`dispose()`方法。
- `dispose()`：当State对象从树中被永久移除时调用；通常在此回调中释放资源。

### 状态管理

- 如果状态是用户数据，如复选框的选中状态、滑块的位置，则该状态最好由父widget管理。
- 如果状态是有关界面外观效果的，例如颜色、动画，那么状态最好由widget本身来管理。
- 如果某一个状态是不同widget共享的则最好由它们共同的父widget管理。

在widget内部管理状态封装性会好一些，而在父widget中管理会比较灵活。有些时候，如果不确定到底该怎么管理状态，那么推荐的首选是在父widget中管理（灵活会显得更重要一些）

#### 全局状态管理

1. 实现一个全局的事件总线，将语言状态改变对应为一个事件，然后在APP Widget所在的父widget`initState`方法中订阅语言改变的事件，当用户在设置页切换语言后，我们触发语言改变事件，然后APP Widget那边就会收到通知，然后重新`build`一下即可。
2. 使用redux这样的全局状态包，读者可以在pub上查看其详细信息。

### Widgets库介绍

#### 基础Flutter widget

- [`Text`](https://docs.flutter.io/flutter/widgets/Text-class.html)：创建一个带格式的文本。
- [`Row`](https://docs.flutter.io/flutter/widgets/Row-class.html)、 [`Column`](https://docs.flutter.io/flutter/widgets/Column-class.html)： 这些具有弹性空间的布局类Widget可让您在水平（Row）和垂直（Column）方向上创建灵活的布局。其设计是基于web开发中的Flexbox布局模型。
- [`Stack`](https://docs.flutter.io/flutter/widgets/Stack-class.html)： 取代线性布局 (译者语：和Android中的FrameLayout相似)，[`Stack`](https://docs.flutter.io/flutter/widgets/Stack-class.html)允许子 widget 堆叠， 你可以使用 [`Positioned`](https://docs.flutter.io/flutter/widgets/Positioned-class.html) 来定位他们相对于`Stack`的上下左右四条边的位置。Stacks是基于Web开发中的绝对定位（absolute positioning )布局模型设计的。
- [`Container`](https://docs.flutter.io/flutter/widgets/Container-class.html)： [`Container`](https://docs.flutter.io/flutter/widgets/Container-class.html) 可让您创建矩形视觉元素。container 可以装饰一个[`BoxDecoration`](https://docs.flutter.io/flutter/painting/BoxDecoration-class.html), 如 background、一个边框、或者一个阴影。 [`Container`](https://docs.flutter.io/flutter/widgets/Container-class.html) 也可以具有边距（margins）、填充(padding)和应用于其大小的约束(constraints)。另外， [`Container`](https://docs.flutter.io/flutter/widgets/Container-class.html)可以使用矩阵在三维空间中对其进行变换。

#### Material widget



#### Cupertino widget

### Text 文本

- `textAlign`: 文本的[对齐方式](https://api.flutter.dev/flutter/dart-ui/TextAlign-class.html)，可以选择左对齐、右对齐还是居中。TextAlign.center

- `textDirection`: 文本[方向](https://api.flutter.dev/flutter/dart-ui/TextDirection-class.html)

- `maxLines`: 文本显示的最大行数

- `overflow`: 文本截取方式，`clip`:截取，多余的舍弃；`ellipsis`:截取，多余的用…；`fade`: 截取用透明

- `textScaleFactor`: 代表文本相对于当前字体大小的缩放因子，相对于去设置文本的样式`style`属性的`fontSize`，它是调整字体大小的一个快捷方式

- `style`: `TextStyle` 样式表内容

  height: 行高，因子。具体行高为：height * fontSize
  fontFamily: 字体集名称

  fontSize: 字体大小，

  fontWeight:  [文本厚度](https://api.flutter.dev/flutter/dart-ui/FontWeight-class.html)，.bold(粗体)   .normal (常规), 经常使用w300(Light) / w400(Normal / regular / plain) / w500(Medium)

  fontStyle:   .italic(斜体)     .normal (常规) 或者values 常量枚举列表

  backgroundColor: 背景色

  color: 文本颜色

  wordSpacing:单词字间距

  textBaseline: [文本基线](https://api.flutter.dev/flutter/dart-ui/TextBaseline-class.html) 

  debugLabel: 调试时文本

  decoration: 文本边框，[TextDecoration](https://api.flutter.dev/flutter/dart-ui/TextDecoration-class.html)

  decorationColor: 文本边框颜色

  decorationStyle: 文本边框类型，枚举 [TextDecorationStyle](https://api.flutter.dev/flutter/dart-ui/TextDecorationStyle-class.html)

  decorationThickness：文本边框高度因子，默认是fontSize 1倍大小

  shadow: [阴影](https://api.flutter.dev/flutter/dart-ui/Shadow-class.html)

  inherit: 不继承defaultTextStyle

- `softWrap`:https://api.flutter.dev/flutter/widgets/Text/softWrap.html

- `structStyle`: [StrutStyle](https://api.flutter.dev/flutter/painting/StrutStyle-class.html)

- `textSpan`: 对一个Text内容的不同部分按照不同的样式显示，类似iOS的富文本样式，[参考](https://api.flutter.dev/flutter/painting/TextSpan-class.html)

#### 字体

同图片资源类似,先添加

```yaml
flutter:
  fonts:
    - family: Raleway
      fonts:
        - asset: assets/fonts/Raleway-Regular.ttf
        - asset: assets/fonts/Raleway-Medium.ttf
          weight: 500
        - asset: assets/fonts/Raleway-SemiBold.ttf
          weight: 600
    - family: AbrilFatface
      fonts:
        - asset: assets/fonts/abrilfatface/AbrilFatface-Regular.ttf
```

```dart
// 使用
// 声明文本样式
const textStyle = const TextStyle(
  fontFamily: 'Raleway',
);

// 使用文本样式
var buttonText = const Text(
  "Use the font for this text",
  style: textStyle,
);
```

### RichText 富文本[参考](https://api.flutter.dev/flutter/widgets/RichText-class.html)

### 按钮

#### [Material](https://api.flutter.dev/flutter/material/material-library.html) 按钮

- RaisedButton：即"漂浮"按钮，它默认带有阴影和灰色背景。按下后，阴影会变大
- FlatButton：即扁平按钮，默认背景透明并不带阴影。按下后，会有背景色
- OutlineButton：默认有一个边框，不带阴影且背景透明。按下后，边框颜色会变亮、同时出现背景和阴影(较弱)
- IconButton：是一个可点击的Icon，不包括文字，默认没有背景，点击后会出现背景

以FlatButton为例，自定义按钮：

```dart
const FlatButton({
  ...  
  @required this.onPressed, //按钮点击回调
  this.textColor, //按钮文字颜色
  this.disabledTextColor, //按钮禁用时的文字颜色
  this.color, //按钮背景颜色
  this.disabledColor,//按钮禁用时的背景颜色
  this.highlightColor, //按钮按下时的背景颜色
  this.splashColor, //点击时，水波动画中水波的颜色
  this.colorBrightness,//按钮主题，默认是浅色主题 
  this.padding, //按钮的填充
  this.shape, //外形
  @required this.child, //按钮的内容
})
```

### 图片与icon

通过Image来加载并显示图片，Image的数据源可以是asset、文件、内存以及网络







