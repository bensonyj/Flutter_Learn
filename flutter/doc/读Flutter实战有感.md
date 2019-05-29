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

##### CheckBox

#####Switch

##### TextField

```dart
const TextField({
  ...
  TextEditingController controller, 
  FocusNode focusNode,
  InputDecoration decoration = const InputDecoration(),
  TextInputType keyboardType,
  TextInputAction textInputAction,
  TextStyle style,
  TextAlign textAlign = TextAlign.start,
  bool autofocus = false,
  bool obscureText = false,
  int maxLines = 1,
  int maxLength,
  bool maxLengthEnforced = true,
  ValueChanged<String> onChanged,
  VoidCallback onEditingComplete,
  ValueChanged<String> onSubmitted,
  List<TextInputFormatter> inputFormatters,
  bool enabled,
  this.cursorWidth = 2.0,
  this.cursorRadius,
  this.cursorColor,
  ...
})
```

- controller：编辑框的控制器，通过它可以设置/获取编辑框的内容、选择编辑内容、监听编辑文本改变事件。大多数情况下我们都需要显式提供一个controller来与文本框交互。如果没有提供controller，则TextField内部会自动创建一个。

- focusNode：用于控制TextField是否占有当前键盘的输入焦点。它是我们和键盘交互的一个handle。

- InputDecoration：用于控制TextField的外观显示，如提示文本、背景颜色、边框等。

- keyboardType：用于设置该输入框默认的键盘输入类型，取值如下：

  | TextInputType枚举值 | 含义                                                |
  | ------------------- | --------------------------------------------------- |
  | text                | 文本输入键盘                                        |
  | multiline           | 多行文本，需和maxLines配合使用(设为null或大于1)     |
  | number              | 数字；会弹出数字键盘                                |
  | phone               | 优化后的电话号码输入键盘；会弹出数字键盘并显示"* #" |
  | datetime            | 优化后的日期输入键盘；Android上会显示“: -”          |
  | emailAddress        | 优化后的电子邮件地址；会显示“@ .”                   |
  | url                 | 优化后的url输入键盘； 会显示“/ .”                   |

- textInputAction：键盘动作按钮图标(即回车键位图标)，它是一个枚举值，有多个可选值，全部的取值列表读者可以查看API文档，下面是当值为`TextInputAction.search`时，原生Android系统下键盘样式：

- style：正在编辑的文本样式。

- textAlign: 输入框内编辑文本在水平方向的对齐方式。

- autofocus: 是否自动获取焦点。

- obscureText：是否隐藏正在编辑的文本，如用于输入密码的场景等，文本内容会用“•”替换。

- maxLines：输入框的最大行数，默认为1；如果为`null`，则无行数限制。

- maxLength和maxLengthEnforced ：maxLength代表输入框文本的最大长度，设置后输入框右下角会显示输入的文本计数。maxLengthEnforced决定当输入文本长度超过maxLength时是否阻止输入，为true时会阻止输入，为false时不会阻止输入但输入框会变红。

- onChange：输入框内容改变时的回调函数；注：内容改变事件也可以通过controller来监听。

- onEditingComplete和onSubmitted：这两个回调都是在输入框输入完成时触发，比如按了键盘的完成键（对号图标）或搜索键（🔍图标）。不同的是两个回调签名不同，onSubmitted回调是`ValueChanged<String>`类型，它接收当前输入内容做为参数，而onEditingComplete不接收参数。

- inputFormatters：用于指定输入格式；当用户输入内容改变时，会根据指定的格式来校验。

- enable：如果为`false`，则输入框会被禁用，禁用状态不接收输入和事件，同时显示禁用态样式（在其decoration中定义）。

- cursorWidth、cursorRadius和cursorColor：这三个属性是用于自定义输入框光标宽度、圆角和颜色的。

##### 表单Form

```dart
Form({
  @required Widget child,
  bool autovalidate = false,
  WillPopCallback onWillPop,
  VoidCallback onChanged,
})
```



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

#### ImageProvider

`ImageProvider` 是一个抽象类，主要定义了图片数据获取的接口`load()`，从不同的数据源获取图片需要实现不同的`ImageProvider`

#### Image

`Image` widget有一个必选的`image`参数，它对应一个ImageProvider

##### 从asset中加载图片

```dart
Image(
  image: AssetImage("images/avatar.png"),
  width: 100.0
);
// or
Image.asset("images/avatar.png",
  width: 100.0,
)
```

##### 从网络加载图片

```dart
Image(
  image: NetworkImage(
      "https://avatars2.githubusercontent.com/u/20411648?s=460&v=4"),
  width: 100.0,
)
// or
Image.network(
  "https://avatars2.githubusercontent.com/u/20411648?s=460&v=4",
  width: 100.0,
)
```

#### Image 参数

```dart
const Image({
  ...
  this.width, //图片的宽
  this.height, //图片高度
  this.color, //图片的混合色值
  this.colorBlendMode, //混合模式
  this.fit,//缩放模式
  this.alignment = Alignment.center, //对齐方式
  this.repeat = ImageRepeat.noRepeat, //重复方式
  ...
})
```

- `width`、`height`：用于设置图片的宽、高，当不指定宽高时，图片会根据当前父容器的限制，尽可能的显示其原始大小，如果只设置`width`、`height`的其中一个，那么另一个属性默认会按比例缩放，但可以通过下面介绍的`fit`属性来指定适应规则。

- `fit`：该属性用于在图片的显示空间和图片本身大小不同时指定图片的适应模式。适应模式是在`BoxFit`中定义，它是一个枚举类型，有如下值：

  - `fill`：会拉伸填充满显示空间，图片本身长宽比会发生变化，图片会变形。
  - `cover`：会按图片的长宽比放大后居中填满显示空间，图片不会变形，超出显示空间部分会被剪裁。
  - `contain`：这是图片的默认适应规则，图片会在保证图片本身长宽比不变的情况下缩放以适应当前显示空间，图片不会变形。
  - `fitWidth`：图片的宽度会缩放到显示空间的宽度，高度会按比例缩放，然后居中显示，图片不会变形，超出显示空间部分会被剪裁。
  - `fitHeight`：图片的高度会缩放到显示空间的高度，宽度会按比例缩放，然后居中显示，图片不会变形，超出显示空间部分会被剪裁。
  - `none`：图片没有适应策略，会在显示空间内显示图片，如果图片比显示空间大，则显示空间只会显示图片中间部分

- `color`和 `colorBlendMode`：在图片绘制时可以对每一个像素进行颜色混合处理，`color`指定混合色，而`colorBlendMode`指定混合模式，下面是一个简单的示例：

  ```dart
  Image(
    image: AssetImage("images/avatar.png"),
    width: 100.0,
    color: Colors.blue,
    colorBlendMode: BlendMode.difference,
  );
  ```

- `repeat`：当图片本身大小小于显示空间时，指定图片的重复规则。简单示例如下：

  ```dart
  Image(
    image: AssetImage("images/avatar.png"),
    width: 100.0,
    height: 200.0,
    repeat: ImageRepeat.repeatY ,
  )
  ```

#### Icon

可以像web开发一样使用iconfont，iconfont即“字体图标”，它是将图标做成字体文件，然后通过指定不同的字符而显示不同的图片

在Flutter开发中，iconfont和图片相比有如下优势：

1. 体积小：可以减小安装包大小。
2. 矢量的：iconfont都是矢量图标，放大不会影响其清晰度。
3. 可以应用文本样式：可以像文本一样改变字体图标的颜色、大小对齐等。
4. 可以通过TextSpan和文本混用。

## 布局类Widgets

布局类Widget都会包含一个或多个子widget，不同的布局类Widget对子widget排版(layout)方式不同。我们在前面说过Element树才是最终的绘制树，Element树是通过widget树来创建的（通过`Widget.createElement()`），widget其实就是Element的配置数据。Flutter中，根据Widget是否需要包含子节点将Widget分为了三类，分别对应三种Element，如下表：

| Widget                        | 对应的Element                  | 用途                                                         |
| ----------------------------- | ------------------------------ | ------------------------------------------------------------ |
| LeafRenderObjectWidget        | LeafRenderObjectElement        | Widget树的叶子节点，用于没有子节点的widget，通常基础widget都属于这一类，如Text、Image。 |
| SingleChildRenderObjectWidget | SingleChildRenderObjectElement | 包含一个子Widget，如：ConstrainedBox、DecoratedBox等         |
| MultiChildRenderObjectWidget  | MultiChildRenderObjectElement  | 包含多个子Widget，一般都有一个children参数，接受一个Widget数组。如Row、Column、Stack等 |

### 线性布局Row、Column

#### 主轴和纵轴

如果布局是沿水平方向，那么主轴就是指水平方向，而纵轴即垂直方向；如果布局沿垂直方向，那么主轴就是指垂直方向，而纵轴就是水平方向。在线性布局中，有两个定义对齐方式的枚举类MainAxisAlignment和CrossAxisAlignment，分别代表主轴对齐和纵轴对齐

#### Row

Row可以在水平方向排列其子widget

```dart
Row({
  ...  
  TextDirection textDirection,    
  MainAxisSize mainAxisSize = MainAxisSize.max,    
  MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
  VerticalDirection verticalDirection = VerticalDirection.down,  
  CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  List<Widget> children = const <Widget>[],
})
```

- textDirection：表示水平方向子widget的布局顺序(是从左往右还是从右往左)，默认为系统当前Locale环境的文本方向(如中文、英语都是从左往右，而阿拉伯语是从右往左)。
- mainAxisSize：表示Row在主轴(水平)方向占用的空间，默认是`MainAxisSize.max`，表示尽可能多的占用水平方向的空间，此时无论子widgets实际占用多少水平空间，Row的宽度始终等于水平方向的最大宽度；而`MainAxisSize.min`表示尽可能少的占用水平空间，当子widgets没有占满水平剩余空间，则Row的实际宽度等于所有子widgets占用的的水平空间；
- mainAxisAlignment：表示子Widgets在Row所占用的水平空间内对齐方式，如果mainAxisSize值为`MainAxisSize.min`，则此属性无意义，因为子widgets的宽度等于Row的宽度。只有当mainAxisSize的值为`MainAxisSize.max`时，此属性才有意义，`MainAxisAlignment.start`表示沿textDirection的初始方向对齐，如textDirection取值为`TextDirection.ltr`时，则`MainAxisAlignment.start`表示左对齐，textDirection取值为`TextDirection.rtl`时表示从右对齐。而`MainAxisAlignment.end`和`MainAxisAlignment.start`正好相反；`MainAxisAlignment.center`表示居中对齐。读者可以这么理解：textDirection是mainAxisAlignment的参考系。
- verticalDirection：表示Row纵轴（垂直）的对齐方向，默认是`VerticalDirection.down`，表示从上到下。
- crossAxisAlignment：表示子Widgets在纵轴方向的对齐方式，Row的高度等于子Widgets中最高的子元素高度，它的取值和MainAxisAlignment一样(包含`start`、`end`、 `center`三个值)，不同的是crossAxisAlignment的参考系是verticalDirection，即verticalDirection值为`VerticalDirection.down`时`crossAxisAlignment.start`指顶部对齐，verticalDirection值为`VerticalDirection.up`时，`crossAxisAlignment.start`指底部对齐；而`crossAxisAlignment.end`和`crossAxisAlignment.start`正好相反；
- children ：子Widgets数组。

#### Column

Column可以在垂直方向排列其子widget。参数和Row一样，不同的是布局方向为垂直，主轴纵轴正好相反，读者可类比Row来理解

###弹性布局Flex

弹性布局允许子widget按照一定比例来分配父容器空间，Flutter中的弹性布局主要通过Flex和Expanded来配合实现

#### Flex

Flex可以沿着水平或垂直方向排列子widget，如果你知道主轴方向，使用Row或Column会方便一些，因为Row和Column都继承自Flex，参数基本相同，所以能使用Flex的地方一定可以使用Row或Column

```dart
Flex({
  ...
  @required this.direction, //弹性布局的方向, Row默认为水平方向，Column默认为垂直方向
  List<Widget> children = const <Widget>[],
})
```

Flex继承自MultiChildRenderObjectWidget，对应的RenderObject为RenderFlex，RenderFlex中实现了其布局算法。

#### Expanded

可以按比例“扩伸”Row、Column和Flex子widget所占用的空间。

```dart
const Expanded({
  int flex = 1, 
  @required Widget child,
})
```

flex为弹性系数，如果为0或null，则child是没有弹性的，即不会被扩伸占用的空间。如果大于0，所有的Expanded按照其flex的比例来分割主轴的全部空闲空间

### 流失布局Wrap、Flow

#### Wrap

```dart
Wrap({
  ...
  this.direction = Axis.horizontal,
  this.alignment = WrapAlignment.start,
  this.spacing = 0.0,
  this.runAlignment = WrapAlignment.start,
  this.runSpacing = 0.0,
  this.crossAxisAlignment = WrapCrossAlignment.start,
  this.textDirection,
  this.verticalDirection = VerticalDirection.down,
  List<Widget> children = const <Widget>[],
})
```

我们可以看到Wrap的很多属性在Row（包括Flex和Column）中也有，如direction、crossAxisAlignment、textDirection、verticalDirection等，这些参数意义是相同的，我们不再重复介绍，读者可以查阅前面介绍Row的部分。读者可以认为Wrap和Flex（包括Row和Column）除了超出显示范围后Wrap会折行外，其它行为基本相同。下面我们看一下Wrap特有的几个属性：

- spacing：主轴方向子widget的间距
- runSpacing：纵轴方向的间距
- runAlignment：纵轴方向的对齐方式

#### Flow

我们一般很少会使用Flow，因为其过于复杂，需要自己实现子widget的位置转换，在很多场景下首先要考虑的是Wrap是否满足需求。Flow主要用于一些需要自定义布局策略或性能要求较高(如动画中)的场景。Flow有如下优点：

- 性能好；Flow是一个对child尺寸以及位置调整非常高效的控件，Flow用转换矩阵（transformation matrices）在对child进行位置调整的时候进行了优化：在Flow定位过后，如果child的尺寸或者位置发生了变化，在FlowDelegate中的`paintChildren()`方法中调用`context.paintChild` 进行重绘，而`context.paintChild`在重绘时使用了转换矩阵（transformation matrices），并没有实际调整Widget位置。
- 灵活；由于我们需要自己实现FlowDelegate的`paintChildren()`方法，所以我们需要自己计算每一个widget的位置，因此，可以自定义布局策略。

缺点：

- 使用复杂.
- 不能自适应子widget大小，必须通过指定父容器大小或实现TestFlowDelegate的`getSize`返回固定大小。

### 层叠布局Stack、Positioned

层叠布局和Web中的绝对定位、Android中的Frame布局是相似的，子widget可以根据到父容器四个角的位置来确定本身的位置。绝对定位允许子widget堆叠（按照代码中声明的顺序）。Flutter中使用Stack和Positioned来实现绝对定位，Stack允许子widget堆叠，而Positioned可以给子widget定位（根据Stack的四个角）。

#### Stack

```dart
Stack({
  this.alignment = AlignmentDirectional.topStart,
  this.textDirection,
  this.fit = StackFit.loose,
  this.overflow = Overflow.clip,
  List<Widget> children = const <Widget>[],
})
```

- alignment：此参数决定如何去对齐没有定位（没有使用Positioned）或部分定位的子widget。所谓部分定位，在这里**特指没有在某一个轴上定位：**left、right为横轴，top、bottom为纵轴，只要包含某个轴上的一个定位属性就算在该轴上有定位。
- textDirection：和Row、Wrap的textDirection功能一样，都用于决定alignment对齐的参考系即：textDirection的值为`TextDirection.ltr`，则alignment的`start`代表左，`end`代表右，即`从左往右`的顺序；textDirection的值为`TextDirection.rtl`，则alignment的`start`代表右，`end`代表左，即`从右往左`的顺序。
- fit：此参数用于决定**没有定位**的子widget如何去适应Stack的大小。`StackFit.loose`表示使用子widget的大小，`StackFit.expand`表示扩伸到Stack的大小。
- overflow：此属性决定如何显示超出Stack显示空间的子widget，值为`Overflow.clip`时，超出部分会被剪裁（隐藏），值为`Overflow.visible` 时则不会。

#### Positioned

```dart
const Positioned({
  Key key,
  this.left, 
  this.top,
  this.right,
  this.bottom,
  this.width,
  this.height,
  @required Widget child,
})
```

left、top 、right、 bottom分别代表离Stack左、上、右、底四边的距离。width和height用于指定定位元素的宽度和高度，注意，此处的width、height 和其它地方的意义稍微有点区别，此处用于配合left、top 、right、 bottom来定位widget，举个例子，在水平方向时，你只能指定left、right、width三个属性中的两个，如指定left和width后，right会自动算出(left+width)，如果同时指定三个属性则会报错，垂直方向同理。

## 容器类Widgets

容器类Widget和布局类Widget都作用于其子Widget，不同的是：

- 布局类Widget一般都需要接收一个widget数组（children），他们直接或间接继承自（或包含）MultiChildRenderObjectWidget ；而容器类Widget一般只需要接收一个子Widget（child），他们直接或间接继承自（或包含）SingleChildRenderObjectWidget。
- 布局类Widget是按照一定的排列方式来对其子Widget进行排列；而容器类Widget一般只是包装其子Widget，对其添加一些修饰（补白或背景色等）、变换(旋转或剪裁等)、或限制(大小等)

### Padding

Padding可以给其子节点添加补白（填充）

```dart
Padding({
  ...
  EdgeInsetsGeometry padding,
  Widget child,
})
```

EdgeInsetsGeometry是一个抽象类，开发中，我们一般都使用EdgeInsets，它是EdgeInsetsGeometry的一个子类，定义了一些设置补白的便捷方法。

#### EdgeInsets

我们看看EdgeInsets提供的便捷方法：

- `fromLTRB(double left, double top, double right, double bottom)`：分别指定四个方向的补白。
- `all(double value)` : 所有方向均使用相同数值的补白。
- `only({left, top, right ,bottom })`：可以设置具体某个方向的补白(可以同时指定多个方向)。
- `symmetric({ vertical, horizontal })`：用于设置对称方向的补白，vertical指top和bottom，horizontal指left和right。

### ConstrainedBox和SizedBox

ConstrainedBox和SizedBox都是通过RenderConstrainedBox来渲染的。SizedBox只是ConstrainedBox的一个定制

####ConstrainedBox

ConstrainedBox用于对子widget添加额外的约束。例如，如果你想让子widget的最小高度是80像素，你可以使用`const BoxConstraints(minHeight: 80.0)`作为子widget的约束。

#### BoxConstraints

BoxConstraints用于设置限制条件，它的定义如下：

```dart
const BoxConstraints({
  this.minWidth = 0.0, //最小宽度
  this.maxWidth = double.infinity, //最大宽度
  this.minHeight = 0.0, //最小高度
  this.maxHeight = double.infinity //最大高度
})
```

BoxConstraints还定义了一些便捷的构造函数，用于快速生成特定限制规则的BoxConstraints，如`BoxConstraints.tight(Size size)`，它可以生成给定大小的限制；`const BoxConstraints.expand()`可以生成一个尽可能大的用以填充另一个容器的BoxConstraints。除此之外还有一些其它的便捷函数，读者可以查看[API文档](https://docs.flutter.io/flutter/rendering/BoxConstraints-class.html)。

#### SizedBox

SizedBox用于给子widget指定固定的宽高，如：

```dart
SizedBox(
  width: 80.0,
  height: 80.0,
  child: redBox
)
```

实际上SizedBox只是ConstrainedBox的一个定制，上面代码等价于：

```dart
ConstrainedBox(
  constraints: BoxConstraints.tightFor(width: 80.0,height: 80.0),
  child: redBox, 
)
```

而`BoxConstraints.tightFor(width: 80.0,height: 80.0)`等价于：

```dart
BoxConstraints(minHeight: 80.0,maxHeight: 80.0,minWidth: 80.0,maxWidth: 80.0)
```

#### 多重约束限制

一个widget多个父层约束时，对同个约束取最大约束值。

#### UnconstrainedBox

UnconstrainedBox不会对子Widget产生任何限制，它允许其子Widget按照其本身大小绘制。一般情况下，我们会很少直接使用此widget，但在"去除"多重限制的时候也许会有帮助，我们看下下面的代码：

```dart
ConstrainedBox(
    constraints: BoxConstraints(minWidth: 60.0, minHeight: 100.0),  //父
    child: UnconstrainedBox( //“去除”父级限制
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 90.0, minHeight: 20.0),//子
        child: redBox,
      ),
    )
)
```

上面代码中，如果没有中间的UnconstrainedBox，那么根据上面所述的多重限制规则，那么最终将显示一个90×100的红色框。但是由于 UnconstrainedBox “去除”了父ConstrainedBox的限制，则最终会按照子ConstrainedBox的限制来绘制redBox，即90×20：

![image-20180910105830808](https://cdn.jsdelivr.net/gh/flutterchina/flutter-in-action@1.0/docs/imgs/image-20180910105830808.png)

但是，读者请注意，UnconstrainedBox对父限制的“去除”并非是真正的去除，上面例子中虽然红色区域大小是90×20，但上方仍然有80的空白空间。也就是说父限制的minHeight(100.0)仍然是生效的，只不过它不影响最终子元素的大小，但仍然还是占有相应的空间，可以认为此时的父ConstrainedBox是作用于子ConstrainedBox上，而renderBox只受子ConstrainedBox限制，这一点请读者务必注意

### 装饰容器DecoratedBox

DecoratedBox可以在其子widget绘制前(或后)绘制一个装饰Decoration（如背景、边框、渐变等）。DecoratedBox定义如下：

```dart
const DecoratedBox({
  Decoration decoration,
  DecorationPosition position = DecorationPosition.background,
  Widget child
})
```

- decoration：代表将要绘制的装饰，它类型为Decoration，Decoration是一个抽象类，它定义了一个接口 `createBoxPainter()`，子类的主要职责是需要通过实现它来创建一个画笔，该画笔用于绘制装饰。
- position：此属性决定在哪里绘制Decoration，它接收DecorationPosition的枚举类型，该枚举类两个值：
  - background：在子widget之后绘制，即背景装饰。
  - foreground：在子widget之上绘制，即前景。

#### BoxDecoration

```dart
BoxDecoration({
  Color color, //颜色
  DecorationImage image,//图片
  BoxBorder border, //边框
  BorderRadiusGeometry borderRadius, //圆角
  List<BoxShadow> boxShadow, //阴影,可以指定多个
  Gradient gradient, //渐变
  BlendMode backgroundBlendMode, //背景混合模式
  BoxShape shape = BoxShape.rectangle, //形状
})
```

### 变换Transform

Transform可以在其子Widget绘制时对其应用一个矩阵变换（transformation），Matrix4是一个4D矩阵，通过它我们可以实现各种矩阵操作。下面是一个例子：

```dart
Container(
  color: Colors.black,
  child: new Transform(
    alignment: Alignment.topRight, //相对于坐标系原点的对齐方式
    transform: new Matrix4.skewY(0.3), //沿Y轴倾斜0.3弧度
    child: new Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.deepOrange,
      child: const Text('Apartment for rent!'),
    ),
  ),
);
```

#### 平移

Transform.translate接收一个offset参数，可以在绘制时沿x、y轴对子widget平移指定的距离。

```dart
DecoratedBox(
  decoration:BoxDecoration(color: Colors.red),
  //默认原点为左上角，左移20像素，向上平移5像素  
  child: Transform.translate(offset: Offset(-20.0, -5.0),
    child: Text("Hello world"),
  ),
)
```

#### 旋转

Transform.rotate可以对子widget进行旋转变换，如：

```dart
DecoratedBox(
  decoration:BoxDecoration(color: Colors.red),
  child: Transform.rotate(
    //旋转90度
    angle:math.pi/2 ,
    child: Text("Hello world"),
  ),
)
```

#### 缩放

Transform.scale可以对子Widget进行缩小或放大，如：

```dart
DecoratedBox(
  decoration:BoxDecoration(color: Colors.red),
  child: Transform.scale(
      scale: 1.5, //放大到1.5倍
      child: Text("Hello world")
  )
);
```

#### 注意

- Transform的变换是应用在绘制阶段，而并不是应用在布局(layout)阶段，所以无论对子widget应用何种变化，其占用空间的大小和在屏幕上的位置都是固定不变的，因为这些是在布局阶段就确定的。下面我们具体说明：

  ```dart
   Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      DecoratedBox(
        decoration:BoxDecoration(color: Colors.red),
        child: Transform.scale(scale: 1.5,
            child: Text("Hello world")
        )
      ),
      Text("你好", style: TextStyle(color: Colors.green, fontSize: 18.0),)
    ],
  )
  ```

  显示效果：

  ![image-20180910164454967](https://cdn.jsdelivr.net/gh/flutterchina/flutter-in-action@1.0/docs/imgs/image-20180910164454967.png)

  由于第一个Text应用变换(放大)后，其在绘制时会放大，但其占用的空间依然为红色部分，所以第二个text会紧挨着红色部分，最终就会出现文字有重合部分。

- 由于矩阵变化只会作用在绘制阶段，所以在某些场景下，在UI需要变化时，可以直接通过矩阵变化来达到视觉上的UI改变，而不需要去重新触发build流程，这样会节省layout的开销，所以性能会比较好。如之前介绍的Flow widget，它内部就是用矩阵变换来更新UI，除此之外，Flutter的动画widget中也大量使用了Transform以提高性能。

#### RotatedBox

RotatedBox和Transform.rotate功能相似，它们都可以对子widget进行旋转变换，但是有一点不同：RotatedBox的变换是在layout阶段，会影响在子widget的位置和大小。我们将上面介绍Transform.rotate时的示例改一下：

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: <Widget>[
    DecoratedBox(
      decoration: BoxDecoration(color: Colors.red),
      //将Transform.rotate换成RotatedBox  
      child: RotatedBox(
        quarterTurns: 1, //旋转90度(1/4圈)
        child: Text("Hello world"),
      ),
    ),
    Text("你好", style: TextStyle(color: Colors.green, fontSize: 18.0),)
  ],
),
```

效果：

![image-20180910170603964](https://cdn.jsdelivr.net/gh/flutterchina/flutter-in-action@1.0/docs/imgs/image-20180910170603964.png)

由于RotatedBox是作用于layout阶段，所以widget会旋转90度（而不只是绘制的内容），decoration会作用到widget所占用的实际空间上，所以就是上图的效果。读者可以和前面Transform.rotate示例对比理解。

### Container容器

它本身不对应具体的RenderObject，它是DecoratedBox、ConstrainedBox、Transform、Padding、Align等widget的一个组合widget。所以我们只需通过一个Container可以实现同时需要装饰、变换、限制的场景。

```dart
Container({
  this.alignment,
  this.padding, //容器内补白，属于decoration的装饰范围
  Color color, // 背景色
  Decoration decoration, // 背景装饰
  Decoration foregroundDecoration, //前景装饰
  double width,//容器的宽度
  double height, //容器的高度
  BoxConstraints constraints, //容器大小的限制条件
  this.margin,//容器外补白，不属于decoration的装饰范围
  this.transform, //变换
  this.child,
})
```

- 容器的大小可以通过`width`、`height`属性来指定，也可以通过`constraints`来指定，如果同时存在时，`width`、`height`优先。实际上Container内部会根据`width`、`height`来生成一个`constraints`。
- `color`和`decoration`是互斥的，实际上，当指定color时，Container内会自动创建一个decoration。

#### Padding和Margin

margin的补白是在容器外部，而padding的补白是在容器内部

```dart
...
Container(
  margin: EdgeInsets.all(20.0), //容器外补白
  color: Colors.orange,
  child: Text("Hello world!"),
),
Container(
  padding: EdgeInsets.all(20.0), //容器内补白
  color: Colors.orange,
  child: Text("Hello world!"),
),
...
```

![image-20180911094807143](https://cdn.jsdelivr.net/gh/flutterchina/flutter-in-action@1.0/docs/imgs/image-20180911094807143.png)

### Scaffold、TabBar、底部导航

Material组件

####Scaffold

```dart
Scaffold({
  Key key,
  this.appBar,	// 设置导航栏
  this.body,		// 设置页面组件
  this.bottomNavigationBar, 	// 设置底部导航栏
  this.floatingActionButton,	// 悬浮按钮
  this.floatingActionButtonLocation, //
  this.floatingActionButtonAnimator, //
  this.backgroundColor, // 页面背景色
  this.bottomSheet,			//
  this.drawer,					// Android抽屉组件
  this.endDrawer,				// 
})
```



#### AppBar

是一个Material风格的导航栏，它可以设置标题、导航栏菜单、底部Tab等。下面我们看看AppBar的定义：

```dart
AppBar({
  Key key,
  this.leading, //导航栏最左侧Widget，常见为抽屉菜单按钮或返回按钮。
  this.automaticallyImplyLeading = true, //如果leading为null，是否自动实现默认的leading按钮
  this.title,// 页面标题
  this.actions, // 导航栏右侧菜单
  this.bottom, // 导航栏底部菜单，通常为Tab按钮组
  this.elevation = 4.0, // 导航栏阴影
  this.centerTitle, //标题是否居中 
  this.backgroundColor,
  ...   //其它属性见源码注释
})
```

#### Tabbar

```dart
Tabbar({
  Key key,
  @required List<Widget> tabs,
  TabController controller,
  bool isScrollable: false,
  Color indicatorColor,
  double indicatorWeight: 2.0, 
  EdgeInsetsGeometry indicatorPadding: EdgeInsets.zero, 
  Decoration indicator, 
  TabBarIndicatorSize indicatorSize, 
  Color labelColor, 
  TextStyle labelStyle, 
  EdgeInsetsGeometry labelPadding, 
  Color unselectedLabelColor, 
  TextStyle unselectedLabelStyle, 
  DragStartBehavior dragStartBehavior: DragStartBehavior.start, 
  ValueChanged<int> onTap
})
```

Tab Widget有三个可选参数，除了可以指定文字外，还可以指定Tab菜单图标，或者直接自定义Widget，定义如下：

```dart
Tab({
  Key key,
  this.text, // 菜单文本
  this.icon, // 菜单图标
  this.child, // 自定义Widget
})
```

#### TabBarView

```dart
TabBarView({
  Key key, 
  @required List<Widget> children, 
  TabController controller, 
  ScrollPhysics physics, 
  DragStartBehavior dragStartBehavior: DragStartBehavior.start 
})
```

#### Drawer 抽屉式菜单

Scaffold的`drawer`和`endDrawer`属性可以分别接受一个Widget作为页面的左、右抽屉菜单，如果开发者提供了抽屉菜单，那么当用户手指从屏幕左/右向里滑动时便可打开抽屉菜单

```dart
Drawer({
  Key key, 
  double elevation: 16.0, 
  Widget child, 
  String semanticLabel 
})
```

#### FloatingActionButton

FloatingActionButton是Material设计规范中的一种特殊Button，通常悬浮在页面的某一个位置作为某种常用动作的快捷入口，如本节示例中页面右下角的"➕"号按钮。我们可以通过Scaffold的`floatingActionButton`属性来设置一个FloatingActionButton，同时通过`floatingActionButtonLocation`属性来指定其在页面中悬浮的位置，这个比较简单，不再赘述。

#### 底部Tab导航

就是tabbar属性

#### 导航栏中间打洞

Material组件库中提供了一个BottomAppBar Widget，可以和FloatingActionButton配合实现这种"打洞"效果。源码如下：

```dart
bottomNavigationBar: BottomAppBar(
  color: Colors.white,
  shape: CircularNotchedRectangle(), // 底部导航栏打一个圆形的洞
  child: Row(
    children: [
      IconButton(icon: Icon(Icons.home)),
      SizedBox(), //中间位置空出
      IconButton(icon: Icon(Icons.business)),
    ],
    mainAxisAlignment: MainAxisAlignment.spaceAround, //均分底部导航栏横向空间
  ),
)
```

可以看到，上面代码中没有控制打洞位置的属性，实际上，打洞的位置取决于FloatingActionButton的位置，上面FloatingActionButton的位置为：

```dart
floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
```

BottomAppBar的`shape`属性决定洞的外形，CircularNotchedRectangle实现了一个圆形的外形，我们也可以自定义外形，比如，Flutter Gallery示例中就有一个”钻石“形状的实现

## 可滚动Widgets

可滚动Widget都直接或间接包含一个Scrollable widget，因此它们包括一些共同的属性，为了避免重复介绍，我们在此统一介绍一下：

```dart
Scrollable({
  ...
  this.axisDirection = AxisDirection.down,
  this.controller,
  this.physics,
  @required this.viewportBuilder, //后面介绍
})
```

- axisDirection：滚动方向。
- physics：此属性接受一个ScrollPhysics对象，它决定可滚动Widget如何响应用户操作，比如用户滑动完抬起手指后，继续执行动画；或者滑动到边界时，如何显示。默认情况下，Flutter会根据具体平台分别使用不同的ScrollPhysics对象，应用不同的显示效果，如当滑动到边界时，继续拖动的话，在iOS上会出现弹性效果，而在Android上会出现微光效果。如果你想在所有平台下使用同一种效果，可以显式指定，Flutter SDK中包含了两个ScrollPhysics的子类可以直接使用：
  - ClampingScrollPhysics：Android下微光效果。
  - BouncingScrollPhysics：iOS下弹性效果。
- controller：此属性接受一个ScrollController对象。ScrollController的主要作用是控制滚动位置和监听滚动事件。默认情况下，widget树中会有一个默认的PrimaryScrollController，如果子树中的可滚动widget没有显式的指定`controller`并且`primary`属性值为`true`时（默认就为`true`），可滚动widget会使用这个默认的PrimaryScrollController，这种机制带来的好处是父widget可以控制子树中可滚动widget的滚动，例如，Scaffold使用这种机制在iOS中实现了"回到顶部"的手势。我们将在本章后面“滚动控制”一节详细介绍ScrollController。

### SingleChildScrollView

SingleChildScrollView类似于Android中的ScrollView，它只能接收一个子Widget。定义如下：

```dart
SingleChildScrollView({
  this.scrollDirection = Axis.vertical, //滚动方向，默认是垂直方向
  this.reverse = false, 
  this.padding, 
  bool primary, 
  this.physics, 
  this.controller,
  this.child,
})
```

除了通用属性，我们重点看一下`reverse`和`primary`两个属性：

- reverse：该属性API文档解释是：是否按照阅读方向相反的方向滑动，如：`scrollDirection`值为`Axis.horizontal`，如果阅读方向是从左到右(取决于语言环境，阿拉伯语就是从右到左)，reverse为`true`时，那么滑动方向就是从右往左。其实此属性本质上是决定可滚动widget的初始滚动位置是在“头”还是“尾”，取`false`时，初始滚动位置在“头”，反之则在“尾”，读者可以自己试验。
- primary：指是否使用widget树中默认的PrimaryScrollController；当滑动方向为垂直方向（`scrollDirection`值为`Axis.vertical`）并且`controller`没有指定时，`primary`默认为`true`.

需要注意的是，通常SingleChildScrollView只应在期望内容适合屏幕的情况下使用，它无法使用基于Sliver的延迟实例化，如果预计视口通常包含超出屏幕尺寸的内容，那么SingleChildScrollView将会非常昂贵。

### ListView

```dart
ListView({
  ...  
  //可滚动widget公共参数
  Axis scrollDirection = Axis.vertical,
  bool reverse = false,
  ScrollController controller,
  bool primary,
  ScrollPhysics physics,
  EdgeInsetsGeometry padding,

  //ListView各个构造函数的共同参数  
  double itemExtent,
  bool shrinkWrap = false,
  bool addAutomaticKeepAlives = true,
  bool addRepaintBoundaries = true,
  double cacheExtent,

  //子widget列表
  List<Widget> children = const <Widget>[],
})
```

上面参数分为两组：第一组是可滚动widget公共参数，前面已经介绍过，不再赘述；第二组是ListView各个构造函数（ListView有多个构造函数）的共同参数，我们重点来看看这些参数，：

- itemExtent：该参数如果不为null，则会强制children的"长度"为itemExtent的值；这里的"长度"是指滚动方向上子widget的长度，即如果滚动方向是垂直方向，则itemExtent代表子widget的高度，如果滚动方向为水平方向，则itemExtent代表子widget的长度。在ListView中，指定itemExtent比让子widget自己决定自身长度会更高效，这是因为指定itemExtent后，滚动系统可以提前知道列表的长度，而不是总是动态去计算，尤其是在滚动位置频繁变化时（滚动系统需要频繁去计算列表高度）。
- shrinkWrap：该属性表示是否根据子widget的总长度来设置ListView的长度，默认值为`false` 。默认情况下，ListView的会在滚动方向尽可能多的占用空间。当ListView在一个无边界(滚动方向上)的容器中时，shrinkWrap必须为`true`。
- addAutomaticKeepAlives：该属性表示是否将列表项（子widget）包裹在AutomaticKeepAlive widget中；典型地，在一个懒加载列表中，如果将列表项包裹在AutomaticKeepAlive中，在该列表项滑出视口时该列表项不会被GC，它会使用KeepAliveNotification来保存其状态。如果列表项自己维护其KeepAlive状态，那么此参数必须置为`false`。
- addRepaintBoundaries：该属性表示是否将列表项（子widget）包裹在RepaintBoundary中。当可滚动widget滚动时，将列表项包裹在RepaintBoundary中可以避免列表项重绘，但是当列表项重绘的开销非常小（如一个颜色块，或者一个较短的文本）时，不添加RepaintBoundary反而会更高效。和addAutomaticKeepAlive一样，如果列表项自己维护其KeepAlive状态，那么此参数必须置为`false`。

#### ListView.builder

`ListView.builder`适合列表项比较多（或者无限）的情况，因为只有当子Widget真正显示的时候才会被创建。下面看一下ListView.builder的核心参数列表：

```dart
ListView.builder({
  // ListView公共参数已省略  
  ...
  @required IndexedWidgetBuilder itemBuilder,
  int itemCount,
  ...
})
```

- itemBuilder：它是列表项的构建器，类型为IndexedWidgetBuilder，返回值为一个widget。当列表滚动到具体的index位置时，会调用该构建器构建列表项。
- itemCount：列表项的数量，如果为null，则为无限列表。

#### ListView.separated

`ListView.separated`可以生成列表项之间的分割器，它除了比`ListView.builder`多了一个`separatorBuilder`参数，该参数是一个分割器生成器

```dart
Widget build(BuildContext context) {
    //下划线widget预定义以供复用。  
    Widget divider1=Divider(color: Colors.blue,);
    Widget divider2=Divider(color: Colors.green);
    return ListView.separated(
        itemCount: 100,
        //列表项构造器
        itemBuilder: (BuildContext context, int index) {
          return ListTile(title: Text("$index"));
        },
        //分割器构造器
        separatorBuilder: (BuildContext context, int index) {
          return index%2==0?divider1:divider2;
        },
    );
  }
```

#### 添加固定表头

可以使用Expanded自动拉伸组件大小的Widget，我们也说过Column是继承自Flex的，所以我们可以直接使用Column+Expanded来实现，代码如下：

```dart
@override
Widget build(BuildContext context) {
  return Column(children: <Widget>[
    ListTile(title:Text("商品列表")),
    Expanded(
      child: ListView.builder(itemBuilder: (BuildContext context, int index) {
        return ListTile(title: Text("$index"));
      }),
    ),
  ]);
}
```

### GridView

GridView可以构建一个二维网格列表，其默认构造函数定义如下：

```dart
GridView({
  Axis scrollDirection = Axis.vertical,
  bool reverse = false,
  ScrollController controller,
  bool primary,
  ScrollPhysics physics,
  bool shrinkWrap = false,
  EdgeInsetsGeometry padding,
  @required SliverGridDelegate gridDelegate, //控制子widget layout的委托
  bool addAutomaticKeepAlives = true,
  bool addRepaintBoundaries = true,
  double cacheExtent,
  List<Widget> children = const <Widget>[],
})
```

####SliverGridDelegateWithFixedCrossAxisCount

该子类实现了一个横轴为固定数量子元素的layout算法，其构造函数为：

```dart
SliverGridDelegateWithFixedCrossAxisCount({
  @required double crossAxisCount, 
  double mainAxisSpacing = 0.0,
  double crossAxisSpacing = 0.0,
  double childAspectRatio = 1.0,
})
```

- crossAxisCount：横轴子元素的数量。此属性值确定后子元素在横轴的长度就确定了,即ViewPort横轴长度/crossAxisCount。
- mainAxisSpacing：主轴方向的间距。
- crossAxisSpacing：横轴方向子元素的间距。
- childAspectRatio：子元素在横轴长度和主轴长度的比例。由于crossAxisCount指定后子元素横轴长度就确定了，然后通过此参数值就可以确定子元素在主轴的长度。

```dart
GridView(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3, //横轴三个子widget
      childAspectRatio: 1.0 //宽高比为1时，子widget
  ),
  children:<Widget>[
    Icon(Icons.ac_unit),
    Icon(Icons.airport_shuttle),
    Icon(Icons.all_inclusive),
    Icon(Icons.beach_access),
    Icon(Icons.cake),
    Icon(Icons.free_breakfast)
  ]
);
```

#### GridView.count

GridView.count构造函数内部使用了SliverGridDelegateWithFixedCrossAxisCount，我们通过它可以快速的创建横轴固定数量子元素的GridView

```dart
GridView.count( 
  crossAxisCount: 3,
  childAspectRatio: 1.0,
  children: <Widget>[
    Icon(Icons.ac_unit),
    Icon(Icons.airport_shuttle),
    Icon(Icons.all_inclusive),
    Icon(Icons.beach_access),
    Icon(Icons.cake),
    Icon(Icons.free_breakfast),
  ],
);
```

#### SliverGridDelegateWithMaxCrossAxisExtent

该子类实现了一个横轴子元素为固定最大长度的layout算法，其构造函数为：

```dart
SliverGridDelegateWithMaxCrossAxisExtent({
  double maxCrossAxisExtent,
  double mainAxisSpacing = 0.0,
  double crossAxisSpacing = 0.0,
  double childAspectRatio = 1.0,
})
```

maxCrossAxisExtent为子元素在横轴上的最大长度，之所以是“最大”长度，是**因为横轴方向每个子元素的长度仍然是等分的**，举个例子，如果ViewPort的横轴长度是450，那么当maxCrossAxisExtent的值在区间[450/4，450/3)内的话，子元素最终实际长度都为112.5，而`childAspectRatio`所指的子元素横轴和主轴的长度比为**最终的长度比**。其它参数和SliverGridDelegateWithFixedCrossAxisCount相同。

```dart
GridView(
  padding: EdgeInsets.zero,
  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
      maxCrossAxisExtent: 120.0,
      childAspectRatio: 2.0 //宽高比为2
  ),
  children: <Widget>[
    Icon(Icons.ac_unit),
    Icon(Icons.airport_shuttle),
    Icon(Icons.all_inclusive),
    Icon(Icons.beach_access),
    Icon(Icons.cake),
    Icon(Icons.free_breakfast),
  ],
);
```

#### GridView.extent

GridView.extent构造函数内部使用了SliverGridDelegateWithMaxCrossAxisExtent，我们通过它可以快速的创建纵轴子元素为固定最大长度的的GridView，上面的示例代码等价于：

```dart
GridView.extent(
   maxCrossAxisExtent: 120.0,
   childAspectRatio: 2.0,
   children: <Widget>[
     Icon(Icons.ac_unit),
     Icon(Icons.airport_shuttle),
     Icon(Icons.all_inclusive),
     Icon(Icons.beach_access),
     Icon(Icons.cake),
     Icon(Icons.free_breakfast),
   ],
 );
```

#### GridView.builder

上面我们介绍的GridView都需要一个Widget数组作为其子元素，这些方式都会提前将所有子widget都构建好，所以只适用于子Widget数量比较少时，当子widget比较多时，我们可以通过`GridView.builder`来动态创建子Widget。`GridView.builder` 必须指定的参数有两个：

```dart
GridView.builder(
 ...
 @required SliverGridDelegate gridDelegate, 
 @required IndexedWidgetBuilder itemBuilder,
)
```

其中itemBuilder为子widget构建器。

### CustomScrollView

CustomScrollView是可以使用sliver来自定义滚动模型（效果）的widget

#### Sliver

可滚动widget，如ListView、GridView等都有对应的Sliver实现如SliverList、SliverGrid等。对于大多数Sliver来说，它们和可滚动Widget最主要的区别是**Sliver不会包含Scrollable Widget，也就是说Sliver本身不包含滚动交互模型** ，正因如此，CustomScrollView才可以将多个Sliver"粘"在一起，这些Sliver共用CustomScrollView的Scrollable，最终实现统一的滑动效果。

### 滚动监听及控制ScrollController

#### ScrollController

```dart
ScrollController({
  double initialScrollOffset = 0.0, //初始滚动位置
  this.keepScrollOffset = true,//是否保存滚动位置
  ...
})
```

- `offset`：可滚动Widget当前滚动的位置。
- `jumpTo(double offset)`、`animateTo(double offset,...)`：这两个方法用于跳转到指定的位置，它们不同之处在于，后者在跳转时会执行一个动画，而前者不会。

#### 滚动监听

ScrollController间接继承自Listenable，我们可以根据ScrollController来监听滚动事件。如：

```dart
controller.addListener(()=>print(controller.offset))
```

#### 滚动位置恢复

[参考](https://book.flutterchina.club/chapter6/scroll_controller.html)

#### ScrollPosition

一个ScrollController可以同时被多个Scrollable Widget使用，ScrollController会为每一个Scrollable Widget创建一个ScrollPosition对象，这些ScrollPosition保存在ScrollController的`positions`属性中（List）。ScrollPosition是真正保存滑动位置信息的对象，`offset`只是一个便捷属性：

```dart
double get offset => position.pixels;
```

ScrollPosition有两个常用方法：`animateTo()` 和 `jumpTo()`，它们是真正来控制跳转滚动位置的方法，ScrollController的这两个同名方法，内部最终都会调用ScrollPosition的。

#### ScrollController控制原理

```dart
ScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition oldPosition);
void attach(ScrollPosition position) ;
void detach(ScrollPosition position) ;
```

当ScrollController和Scrollable Widget关联时，Scrollable Widget首先会调用ScrollController的`createScrollPosition()`方法来创建一个ScrollPosition来存储滚动位置信息，接着，Scrollable Widget会调用`attach()`方法，将创建的ScrollPosition添加到ScrollController的`positions`属性中，这一步称为“注册位置”，只有注册后`animateTo()` 和 `jumpTo()`才可以被调用。当Scrollable Widget销毁时，会调用ScrollController的`detach()`方法，将其ScrollPosition对象从ScrollController的`positions`属性中移除，这一步称为“注销位置”，注销后`animateTo()` 和 `jumpTo()` 将不能再被调用。

需要注意的是，ScrollController的`animateTo()` 和 `jumpTo()`内部会调用所有ScrollPosition的`animateTo()` 和 `jumpTo()`，以实现所有和该ScrollController关联的Scrollable Widget都滚动到指定的位置。

### NotificationListener滚动监听

Flutter Widget树中子Widget可以通过发送通知（Notification）与父(包括祖先)Widget通信。父Widget可以通过NotificationListener Widget来监听自己关注的通知，这种通信方式类似于Web开发中浏览器的事件冒泡，我们在Flutter中沿用“冒泡”这个术语。Scrollable Widget在滚动时会发送ScrollNotification类型的通知，ScrollBar正是通过监听滚动通知来实现的。通过NotificationListener监听滚动事件和通过ScrollController有两个主要的不同：

1. 通过NotificationListener可以在从Scrollable Widget到Widget树根之间任意位置都能监听。而ScrollController只能和具体的Scrollable Widget关联后才可以。
2. 收到滚动事件后获得的信息不同；NotificationListener在收到滚动事件时，通知中会携带当前滚动位置和ViewPort的一些信息，而ScrollController只能获取当前滚动位置。

NotificationListener是一个Widget，模板参数T是想监听的通知类型，如果省略，则所有类型通知都会被监听，如果指定特定类型，则只有该类型的通知会被监听。NotificationListener需要一个onNotification回调函数，用于实现监听处理逻辑，该回调可以返回一个布尔值，代表是否阻止该事件继续向上冒泡，如果为`true`时，则冒泡终止，事件停止向上传播，如果不返回或者返回值为`false` 时，则冒泡继续

## 功能型Widgets

### WillPopScope 导航返回拦截

为了避免用户误触返回按钮而导致APP退出，在很多APP中都拦截了用户点击返回键的按钮，当用户在某一个时间段内点击两次时，才会认为用户是要退出（而非误触）。Flutter中可以通过WillPopScope来实现返回按钮拦截，我们看看WillPopScope的默认构造函数：

```dart
const WillPopScope({
  ...
  @required WillPopCallback onWillPop,
  @required Widget child
})
```

onWillPop是一个回调函数，当用户点击返回按钮时调用（包括导航返回按钮及Android物理返回按钮），该回调需要返回一个Future对象，如果返回的Future最终值为`false`时，则当前路由不出栈(不会返回)，最终值为`true`时，当前路由出栈退出。我们需要提供这个回调来决定是否退出。

### InheritedWidget 数据共享

可以高效的将数据在Widget树中向下传递、共享，这在一些需要在Widget树中共享数据的场景中非常方便，如Flutter中，正是通过InheritedWidget来共享应用主题(Theme)和Locale(当前语言环境)信息的。

#### didChangeDependencies

一般来说，子widget很少会重写此方法，因为在依赖改变后framework也都会调用`build()`方法。但是，如果你需要在依赖改变后执行一些昂贵的操作，比如网络请求，这时最好的方式就是在此方法中执行，这样可以避免每次`build()`都执行这些昂贵操作。

### Theme 主题

Theme Widget可以为Material APP定义主题数据（ThemeData），Material组件库里很多Widget都使用了主题数据，如导航栏颜色、标题字体、Icon样式等。Theme内会使用InheritedWidget来为其子树Widget共享样式数据。

#### ThemeData

ThemeData是Material Design Widget库的主题数据，Material库的Widget需要遵守相应的设计规范，而这些规范可自定义部分都定义在ThemeData，所以我们可以通过ThemeData来自定义应用主题。我们可以通过`Theme.of`方法来获取当前的ThemeData。

```dart
ThemeData({
  Brightness brightness, //深色还是浅色
  MaterialColor primarySwatch, //主题颜色样本，见下面介绍
  Color primaryColor, //主色，决定导航栏颜色
  Color accentColor, //次级色，决定大多数Widget的颜色，如进度条、开关等。
  Color cardColor, //卡片颜色
  Color dividerColor, //分割线颜色
  ButtonThemeData buttonTheme, //按钮主题
  Color cursorColor, //输入框光标颜色
  Color dialogBackgroundColor,//对话框背景颜色
  String fontFamily, //文字字体
  TextTheme textTheme,// 字体主题，包括标题、body等文字样式
  IconThemeData iconTheme, // Icon的默认样式
  TargetPlatform platform, //指定平台，应用特定平台控件风格
  ...
})
```

上面只是ThemeData的一小部分属性，完整列表读者可以查看SDK定义。上面属性中需要说明的是`primarySwatch`，它是主题颜色的一个"样本"，通过这个样本可以在一些条件下生成一些其它的属性，例如，如果没有指定`primaryColor`，并且当前主题不是深色主题，那么`primaryColor`就会默认为`primarySwatch`指定的颜色，还有一些相似的属性如`accentColor` 、`indicatorColor`等也会受`primarySwatch`影响。

## 事件处理与通知

Flutter中的手势系统有两个独立的层。第一层为原始指针(pointer)事件，它描述了屏幕上指针（例如，触摸、鼠标和触控笔）的位置和移动。 第二层为手势，描述由一个或多个指针移动组成的语义动作，如拖动、缩放、双击等

### 原始指针事件处理

当指针按下时，Flutter会对应用程序执行**命中测试(Hit Test)**，以确定指针与屏幕接触的位置存在哪些widget， 指针按下事件（以及该指针的后续事件）然后被分发到由命中测试发现的最内部的widget，然后从那里开始，事件会在widget树中向上冒泡，这些事件会从最内部的widget被分发到widget根的路径上的所有Widget，这和Web开发中浏览器的**事件冒泡**机制相似， 但是Flutter中没有机制取消或停止冒泡过程，而浏览器的冒泡是可以停止的。注意，只有通过命中测试的Widget才能触发事件。

Flutter中可以使用Listener widget来监听原始触摸事件，它也是一个功能性widget。

```dart
Listener({
  Key key,
  this.onPointerDown, //手指按下回调
  this.onPointerMove, //手指移动回调
  this.onPointerUp,//手指抬起回调
  this.onPointerCancel,//触摸事件取消回调
  this.behavior = HitTestBehavior.deferToChild, //在命中测试期间如何表现
  Widget child
})
```

具体[参考](https://book.flutterchina.club/chapter8/listener.html)

### 手势识别GestureDetector

#### 点击、双击、长按

```dart
GestureDetector(
        child: Container(
          alignment: Alignment.center,
          color: Colors.blue,
          width: 200.0, 
          height: 100.0,
          child: Text(_operation,
            style: TextStyle(color: Colors.white),
          ),
        ),
        onTap: () => updateText("Tap"),//点击
        onDoubleTap: () => updateText("DoubleTap"), //双击
        onLongPress: () => updateText("LongPress"), //长按
      ),
    );
```

**注意**： 当同时监听`onTap`和`onDoubleTap`事件时，当用户触发tap事件时，会有200毫秒左右的延时，这是因为当用户点击完之后很可能会再次点击以触发双击事件，所以GestureDetector会等一断时间来确定是否为双击事件。如果用户只监听了`onTap`（没有监听`onDoubleTap`）事件时，则没有延时。

#### 拖动、滑动

GestureDetector对于拖动和滑动事件是没有区分的，他们本质上是一样的

```dart
GestureDetector(
            child: CircleAvatar(child: Text("A")),
            //手指按下时会触发此回调
            onPanDown: (DragDownDetails e) {
              //打印手指按下的位置(相对于屏幕)
              print("用户手指按下：${e.globalPosition}");
            },
            //手指滑动时会触发此回调
            onPanUpdate: (DragUpdateDetails e) {
              //用户手指滑动时，更新偏移，重新构建
              setState(() {
                _left += e.delta.dx;
                _top += e.delta.dy;
              });
            },
            onPanEnd: (DragEndDetails e){
              //打印滑动结束时在x、y轴上的速度
              print(e.velocity);
            },
          ),
```

- `DragDownDetails.globalPosition`：当用户按下时，此属性为用户按下的位置相对于**屏幕**(而非父widget)原点(左上角)的偏移。
- `DragUpdateDetails.delta`：当用户在屏幕上滑动时，会触发多次Update事件，`delta`指一次Update事件的滑动的偏移量。
- `DragEndDetails.velocity`：该属性代表用户抬起手指时的滑动速度(包含x、y两个轴的），示例中并没有处理手指抬起时的速度，常见的效果是根据用户抬起手指时的速度做一个减速动画。

#### 单一方向拖动

在很多场景，我们只需要沿一个方向来拖动，如一个垂直方向的列表，GestureDetector可以只识别特定方向的手势事件

```dart
GestureDetector(
            child: CircleAvatar(child: Text("A")),
            //垂直方向拖动事件
            onVerticalDragUpdate: (DragUpdateDetails details) {
              setState(() {
                _top += details.delta.dy;
              });
            }
          ),
```

#### 缩放

```dart
GestureDetector(
        //指定宽度，高度自适应
        child: Image.asset("./images/sea.png", width: _width),
        onScaleUpdate: (ScaleUpdateDetails details) {
          setState(() {
            //缩放倍数在0.8到10倍之间
            _width=200*details.scale.clamp(.8, 10.0);
          });
```

#### GestureRecognizer

GestureDetector内部是使用一个或多个GestureRecognizer来识别各种手势的，而GestureRecognizer的作用就是通过Listener来将原始指针事件转换为语义手势，GestureDetector直接可以接收一个子Widget。GestureRecognizer是一个抽象类，一种手势的识别器对应一个GestureRecognizer的子类，Flutter实现了丰富的手势识别器，我们可以直接使用。

####手势竞争与冲突

##### 竞争

Flutter中的手势识别引入了一个Arena的概念，Arena直译为“竞技场”的意思，每一个手势识别器（GestureRecognizer）都是一个“竞争者”（GestureArenaMember），当发生滑动事件时，他们都要在“竞技场”去竞争本次事件的处理权，而最终只有一个“竞争者”会胜出(win)

##### 手势冲突

由于手势竞争最终只有一个胜出者，所以，当有多个手势识别器时，可能会产生冲突。假设有一个widget，它可以左右拖动，现在我们也想检测在它上面手指按下和抬起的事件

通过Listener监听原始指针事件就行

手势冲突只是手势级别的，而手势是对原始指针的语义化的识别，所以在遇到复杂的冲突场景时，都可以通过Listener直接识别原始指针事件来解决冲突。

###全局事件总线 -  单例

事件总线通常实现了订阅者模式，订阅者模式包含发布者和订阅者两种角色，可以通过事件总线来触发事件和监听事件

事件总线通常用于Widget之间状态共享，但关于Widget之间状态共享也有一些专门的Package如redux，这和web框架Vue/React是一致的

### 通知Notification

Notification是Flutter中一个重要的机制，在Widget树中，每一个节点都可以分发通知，通知会沿着当前节点（context）向上传递，所有父节点都可以通过NotificationListener来监听通知，Flutter中称这种通知由子向父的传递为“通知冒泡”（Notification Bubbling），这个和用户触摸事件冒泡是相似的，但有一点不同：通知冒泡可以中止，但用户触摸事件不行。

#### 自定义通知

1. 定义一个通知类，要继承自Notification类；

   ```dart
   class MyNotification extends Notification {
     MyNotification(this.msg);
     final String msg;
   }
   ```

2. 分发通知。

   Notification有一个`dispatch(context)`方法，它是用于分发通知的，我们说过context实际上就是操作Element的一个接口，它与Element树上的节点是对应的，通知会从context对应的Element节点向上冒泡。

