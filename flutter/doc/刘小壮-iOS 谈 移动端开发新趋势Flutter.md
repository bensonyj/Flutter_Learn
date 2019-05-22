## 刘小壮-iOS 谈 移动端开发新趋势Flutter

[原文链接-简书](<https://www.jianshu.com/p/1a90adc09e99>)

[掘金链接](<https://juejin.im/post/5ca6c66451882543e50fcbd4>)

### 介绍

`Flutter`是`Google`开发的新一代跨平台方案，`Flutter`可以实现写一份代码同时运行在iOS和Android设备上，并且提供很好的性能体验。`Flutter`使用`Dart`作为开发语言，这是一门简洁、强类型的编程语言。`Flutter`对于iOS和Android设备，提供了两套视觉库，可以针对不同的平台有不同的展示效果。

`Flutter`原本是为了解决`Web`开发中的一些问题，而开发的一套精简版`Web`框架，拥有独立的渲染引擎和开发语言，但后来逐渐演变为移动端开发框架。正是由于`Dart`当初的定位是为了替代`JS`成为`Web`框架，所以`Dart`的语法更接近于`JS`语法。例如定义对象构建方法，以及实例化对象的方式等。

在`Google`刚推出`Flutter`时，其发展很缓慢，终于在18年发布第一个Bate版之后迎来了爆发性增长，发布第一个`Release`版时增长速度更快。可以从Github上Star数据看出来这个增长的过程。在19年最新的`Flutter 1.2`版本中，已经开放`Web`支持的Beta版。



![img](https://upload-images.jianshu.io/upload_images/270478-efdde5855938eff8.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp)

增长趋势

目前已经有不少大型项目接入`Flutter`，阿里的咸鱼、头条的抖音、腾讯的NOW直播，都将`Flutter`当做应用程序的开发语言。除此之外，还有一些其他中小型公司也在做。

### 整体架构

`Flutter`可以理解为开发SDK或者工具包，其通过`Dart`作为开发语言，并且提供`Material`和`Cupertino`两套视觉控件，视图或其他和视图相关的类，都以`Widget`的形式表现。`Flutter`有自己的渲染引擎，并不依赖原生平台的渲染。`Flutter`还包含一个用`C++`实现的`Engine`，渲染也是包含在其中的。



![img](https://upload-images.jianshu.io/upload_images/270478-711e6a9c3349abe0.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp)

Flutter整体架构

#### Engine

`Flutter`是一套全新的跨平台方案，`Flutter`并不像`React Native`那样，依赖原生应用的渲染，而是自己有自己的渲染引擎，并使用`Dart`当做`Flutter`的开发语言。`Flutter`整体框架分为两层，底层是通过`C++`实现的引擎部分，`Skia`是`Flutter`的渲染引擎，负责跨平台的图形渲染。`Dart`作为`Flutter`的开发语言，在`C++`引擎上层是`Dart`的`Framework`。

`Flutter`不仅仅提供了一套视觉库，在`Flutter`整体框架中包含各个层级阶段的库。例如实现一个游戏功能，上面一些游戏控件可以用上层视觉库，底层游戏可以直接基于`Flutter`的底层库进行开发，而不需要调用原生应用的底层库。`Flutter`的底层库是基于`Open GL`实现的，所以`Open GL`可以做的`Flutter`都可以。

#### 视觉库

在上层`Framework`中包含两套视觉库，符合`Android`风格的`Material`，和符合iOS风格的`Cupertino`。也可以在此基础上，封装自己风格的系统组件。`Cupertino`是一套iOS风格的视觉库，包含iOS的导航栏、`button`、`alertView`等。

`Flutter`对不同硬件平台有不同的兼容，例如同样的`Material`代码运行在iOS和Android不同平台上，有一些平台特有的显示和交互，`Flutter`依然对其进行了区分适配。例如滑动`ScrollView`时，iOS平台是有回弹效果的，而Android平台则是阻尼效果。例如iOS的导航栏标题是居中的，Android导航栏标题是向左的，等等。这些`Flutter`都做了区分兼容。

除了`Flutter`为我们做的一些适配外，有一些控件是需要我们自己做适配的，例如`AlertView`，在Android和iOS两个平台下的表现就是不同的。这些iOS特性的控件都定义在`Cupertino`中，所以建议在进行App开发时，对一些控件进行上层封装。

例如`AlertView`则对其进行一个二次封装，控件内部进行设备判断并选择不同的视觉库，这样可以保证各个平台的效果。



![img](https://upload-images.jianshu.io/upload_images/270478-34949c1c104ab14c.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/300/format/webp)

iOS风格



![img](https://upload-images.jianshu.io/upload_images/270478-c29decabacb3dbfb.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/300/format/webp)

Android风格

虽然`Flutter`对于iOS和Android两个平台，开发有`cupertino`和`material`两个视觉库，但实际开发过程中的选择，应该使用`material`当做视觉库。因为`Flutter`对iOS的支持并不是很好，主要对Android平台支持比较好，`material`中的UI控件要比`cupertino`多好几倍。

#### Dart

[Dart](https://links.jianshu.com/go?to=https%3A%2F%2Fwww.dartlang.org%2F)是`Google`在2011年推出的一款应用于`Web`开发的编程语言，`Dart`刚推出的时候，定位是替代`JS`做前端开发，后来逐步扩展到移动端和服务端。



![img](https://upload-images.jianshu.io/upload_images/270478-e0d11d4b50357474.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp)

Dart语言

`Dart`是`Flutter`的开发语言，`Flutter`必须遵循`Dart`的语言特性。在此基础上，也会有自己的东西，例如`Flutter`的上层`Framework`，自己的渲染引擎等。可以说，`Dart`只是`Flutter`的一部分。

`Dart`是强类型的，对定义的变量不需要声明其类型，`Flutter`会对其进行类型推导。如果不想使用类型推导，也可以自己声明指定的类型。

### Hot Reload

`Flutter`支持亚秒级热重载，`Android Studio`和`VSCode`都支持`Hot Reload`的特性。但需要区分的是，热重载和热更新是不同的两个概念，热重载是在运行调试状态下，将新代码直接更新到执行中的二进制。而热更新是在上线后，通过`Runtime`或其他方式，改变现有执行逻辑。

#### AOT、JIT

`Flutter`支持`AOT`(`Ahead of time`)和`JIT`(`Just in time`)两种编译模式，`JIT`模式支持在运行过程中进行`Hot Reload`。刷新过程是一个增量的过程，由系统对本次和上次的代码做一次`snapshot`，将新的代码注入到`DartVM`中进行刷新。但有时会不能进行`Hot Reload`，此时进行一次全量的`Hot Reload`即可。

而`AOT`模式则是在运行前预先编译好，这样在每次运行过程中就不需要进行分析、编译，此模式的运行速度是最快的。`Flutter`同时采用了两种方案，在开发阶段采用`JIT`模式进行开发，在`release`阶段采用`AOT`模式，将代码打包为二进制进行发布。

在开发原生应用时，每次修改代码后都需要重新编译，并且运行到硬件设备上。由于`Flutter`支持`Hot Reload`，可以进行热重载，对项目的开发效率有很大的提升。

由于`Flutter`实现机制支持`JIT`的原因，理论上来说是支持热更新以及服务器下发代码的。可以从服务器。但是由于这样会使性能变差，而且还有审核的问题，所以`Flutter`并没有采用这种方案。

#### 实现原理

`Flutter`的热重载是基于`State`的，也就是我们在代码中经常出现的`setState`方法，通过这个来修改后，会执行相应的`build`方法，这就是热重载的基本过程。

`Flutter`的`hot reload`的实现源码在下面路径中，在此路径中包含`run_cold.dart`和`run_hot.dart`两个文件，前者负责冷启动，后者负责热重载。

```
~/flutter/packages/flutter_tools/lib/src/run_hot.dart
```

热重载的代码实现在`run_hot.dart`文件中，有`HotRunner`来负责具体代码执行。当`Flutter`进行热重载时，会调用`restart`函数，函数内部会传入一个`fullRestart`的`bool`类型变量。热重载分为全量和非全量，`fullRestart`参数就是表示是否全量。以非全量热重载为例，函数的`fullRestart`会传入`false`，根据传入`false`参数，下面是部分核心代码。

```dart
Future<OperationResult> restart({ bool fullRestart = false, bool pauseAfterRestart = false, String reason }) async {
    if (fullRestart) {
        // .....
    } else {
        final bool reloadOnTopOfSnapshot = _runningFromSnapshot;
        final String progressPrefix = reloadOnTopOfSnapshot ? 'Initializing' : 'Performing';
        final Status status = logger.startProgress(
            '$progressPrefix hot reload...',
            progressId: 'hot.reload'
        );
        OperationResult result;
        try {
            result = await _reloadSources(pause: pauseAfterRestart, reason: reason);
        } finally {
            status.cancel();
        }
    }
}
```

调用`restart`函数后，内部会调用`_reloadSources`函数，去执行内部逻辑。下面是大概逻辑执行流程。



![img](https://upload-images.jianshu.io/upload_images/270478-e204bb7935e63dc3.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp)

执行流程

在`_reloadSources`函数内部，会调用`_updateDevFS`函数，函数内部会扫描修改的文件，并将文件修改前后进行对比，随后会将被改动的代码生成一个`kernel files`文件。

随后会通过`HTTP Server`将生成的`kernel files`文件发送给`Dart VM`虚拟机，虚拟机拿到`kernel`文件后会调用`_reloadSources`函数进行资源重载，将`kernel`文件注入正在运行的`Dart VM`中。当资源重载完成后，会调用RPC接口触发`Widgets`的重绘。

### 跨平台方案对比

现在市面上RN、Weex的技术方案基本一样，所以这里就以RN来代表类似的跨平台方案。`Flutter`是基于`GPU`进行渲染的，而RN则将渲染交给原生平台，而自己只是负责通过`JSCore`将视图组织起来，并处理业务逻辑。所以在渲染效果和性能这块，`Flutter`的性能比RN要强很多。

跨平台方案一般都需要对各个平台进行平台适配，也就是创建各自平台的适配层，RN的平台适配层要比`Flutter`要大很多。因为从技术实现来说，RN是通过`JSCore`引擎进行原生代码调用的，和原生代码交互很多，所以需要更多的适配。而`Flutter`则只需要对各自平台独有的特性进行适配即可，例如调用系统相册、粘贴板等。

`Flutter`技术实现是基于更底层实现的，对平台依赖度不是很高，相对来说，RN对平台的依赖度是很高的。所以RN未来的技术升级，包括扩展之类的，都会受到很大的限制。而`Flutter`未来的潜力将会很大，可以做很多技术改进。

### Widget

在`Flutter`中将显示以及和显示相关的部分，都统一定义为`widget`，下面列举一些`widget`包含的类型：

1. 用于显示的视图，例如`ListView`、`Text`、`Container`等。
2. 用来操作视图，例如`Transform`等动画相关。
3. 视图布局相关，例如`Center`、`Expanded`、`Column`等。

在`Flutter`中，所有的视图都是由`Widget`组成，`Label`、`AppBar`、`ViewController`等。在`Flutter`的设计中，组合的优先级要大于继承，整体视图类结构继承层级很浅但单层很多类。如果想定制或封装一些控件，也应该以组合为主，而不是继承。

在iOS开发中，我也经常采用这种设计方案，组合大于继承。因为如果继承层级过多的话，一个是不便于阅读代码，还有就是不好维护代码。例如底层需要改一个通用的样式，但这个类的继承层级比较复杂，这样改动的话影响范围就比较大，会将一些不需要改的也改掉，这时候就会发现继承很鸡肋。但在iOS中有`Category`的概念，这也是一种组合的方式，可以通过将一些公共的东西放在`Category`中，使继承的方便性和组合的灵活性达到一个平衡。

`Flutter`中并没有单独的布局文件，例如iOS的XIB这种，代码都在`Widget`中定义。和`UIView`的区别在于，`Widget`只是负责描述视图，并不参与视图的渲染。`UIView`也是负责描述视图，而`UIView`的`layer`则负责渲染操作，这是二者的区别。



![img](https://upload-images.jianshu.io/upload_images/270478-22dc8b308566c614.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp)

Widget结构

#### 了解Widget

在应用程序启动时，`main`方法接收一个`Widget`当做主页面，所以任何一个`Widget`都可以当做根视图。一般都是传一个`MaterialApp`，也可以传一个`Container`当做根视图，这都是被允许的。

在`Flutter`应用中，和界面显示及用户交互的对象都是由`Widget`构成的，例如视图、动画、手势等。`Widget`分为`StatelessWidget`和`StatefulWidget`两种，分别是无状态和有状态的`Widget`。

`StatefulWidget`本质上也是无状态的，其通过`State`来处理`Widget`的状态，以达到有状态，`State`出现在整个`StatefulWidget`的生命周期中。

当构建一个`Widget`时，可以通过其`build`获得构建流程，在构建流程中可以加入自己的定制操作，例如对其设置title或视图等。

```dart
return Scaffold(
  appBar: AppBar(
    title: Text('ListView Demo'),
  ),
  body: ListView.builder(
    itemCount: dataList.length,
    itemBuilder: (BuildContext context, int index) {
      return Text(dataList[index]);
    },
  ),
);
```

有些`Widget`在构建时，也提供一些参数来帮助构建，例如构建一个`ListView`时，会将`index`返回给`build`方法，来区别构建的Cell，以及构建的上下文`context`。

```dart
itemBuilder: (BuildContext context, int index) {
  return Text(dataList[index]);
}
```

#### StatelessWidget

`StatelessWidget`是一种静态`Widget`，即创建后自身就不能再进行改变。在创建一个`StatelessWidget`后，需要重写`build`函数。每个静态`Widget`都会有一个`build`函数，在创建视图对象时会调用此方法。同样的，此函数也接收一个`Widget`类型的返回值。

```dart
class RectangleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center (
        // UI Code
    );
  }
}
```

#### StatefulWidget

`Widget`本质上是不可被改变的，但`StatefulWidget`将状态拆分到`State`中去管理，当数据发生改变时由`State`去处理视图的改变。

下面是创建一个动态`Widget`，当创建一个动态`Widget`需要配合一个`State`，并且需要重写`createState`方法。重写此函数后，指定一个`Widget`对应的`State`并初始化。

下面例子中，在`StatefulWidget`的父类中包含一个Key类型的`key`变量，这是无论静态`Widget`还是动态`Widget`都具备的参数。在动态`Widget`中定义了自己的成员变量title，并在自定义的初始化方法中传入，通过下面`DynamicWidget`类的构造方法，并不需要在内部手动进行title的赋值，title即为传入的值，是由系统完成的。

```dart
class DynamicWidget extends StatefulWidget {
  DynamicWidget({Key key, this.title}) : super (key : key);
  final String title;

  @override
  DynamicWidgetState createState() => new DynamicWidgetState();
}
```

由于上面动态`Widget`定义了初始化方法，在调用动态`Widget`时可以直接用自定义初始化方法即可。

```dart
DynamicWidget(key: 'key', title: 'title');
```

#### State

`StatefulWidget`的改变是由`State`来完成的，`State`中需要重写`build`方法，在`build`中进行视图组织。`StatefulWidget`是一种响应式视图改变的方式，数据源和视图产生绑定关系，由数据源驱动视图的改变。

改变`StatefulWidget`的数据源时，需要调用`setState`方法，并将数据源改变的操作写在里面。使用动态`Widget`后，是不需要我们手动去刷新视图的。系统在`setState`方法调用后，会重新调用对应`Widget`的`build`方法，重新绘制某个`Widget`。

下面的代码示例中添加了一个float按钮，并给按钮设置了一个回调函数`_onPressAction`，这样在每次触发按钮事件时都会调用此函数。`counter`是一个整型变量并和`Text`相关联，当`counter`的值在`setState`方法中改变时，`Text Widget`也会跟着变化。

```dart
class DynamicWidgetState extends State<DynamicWidget> {
  int counter = 0;
  void _onPressAction() {
    setState(() {
      counter++;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Center(
        child: Text('Button tapped $_counter.')
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onPressAction,
        tooltip: 'Increment',
        child: Icon(Icons.add)
      )
    );
  }  
}
```

#### 主要Widget

在iOS中有`UINavigationController`的概念，其并不负责显示，而是负责控制各个页面的跳转操作。在`Flutter`中可以将`MaterialApp`理解为iOS的导航控制器，其包含一个`navigationBar`以及导航栈，这和iOS是一样的。

在iOS中除了用来显示的视图外，视图还有对应的`UIViewController`。在`Flutter`中并没有专门用来管理视图并且和`View`一对一的类，但从显示的角度来说，有类似的类`Scaffold`，其包含控制器的`appBar`，也可以通过`body`设置一个`widget`当做其视图。

#### theme

`theme`是`Flutter`提供的界面风格API，`MaterialApp`提供有`theme`属性，可以在`MaterialApp`中设置全局样式，这样可以统一整个应用的风格。

```dart
new MaterialApp(
  title: title,
  theme: new ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.lightBlue[800],
    accentColor: Colors.cyan[600],
  )
);
```

如果不想使用系统默认主题，可以将对应的控件或试图用`Theme`包起来，并将`Theme`当做`Widget`赋值给其他`Widget`。

```dart
new Theme(
  data: new ThemeData(
    accentColor: Colors.yellow,
  ),
  child: new FloatingActionButton(
    onPressed: () {},
    child: new Icon(Icons.add),
  ),
);
```

有时`MaterialApp`设定的统一风格，并不能满足某个`Widget`的要求，可能还需要有其他的外观变化，可以通过`Theme.of`传入当前的`BuildContext`，来对`theme`进行扩展。

`Flutter`会根据传入的`context`，顺着`Widget`树查找最近的`Theme`，并对`Theme`复制一份防止影响原有的`Theme`，并对其进行扩展。

```dart
new Theme(
  data: Theme.of(context).copyWith(accentColor: Colors.yellow),
  child: new FloatingActionButton(
    onPressed: null,
    child: new Icon(Icons.add),
  ),
);
```

### 网络请求

`Flutter`中可以通过`async`、`await`组合使用，进行网络请求。`Flutter`中的网络请求大体有三种：

1. 系统自带的`HttpClient`网络请求，缺点是代码量相对而言比较多，而且对post请求支持不是很好。
2. 三方库`http.dart`，请求简单。
3. 三方库`dio`，请求简单。

#### http网络库

`http`网络库定义在`http.dart`中，内部代码定义很全，包括`HttpStatus`、`HttpHeaders`、`Cookie`等很多基础信息，有助于我们了解`http`请求协议。

因为是三方库，所以需要在`pubspec.yaml`中加入下面的引用。

```
http: '>=0.11.3+12'
```

下面是`http.dart`的请求示例代码，可以看到请求很简单，真正的请求代码其实就两行。生成一个`Client`请求对象，调用`client`实例的get方法(如果是post则调用post方法)，并用`Response`对象去接收请求结果即可。

通过`async`修饰发起请求的方法，表示这是一个异步操作，并在请求代码的前面加入`await`，修饰这里的代码需要等待数据返回，需要过一段时间后再处理。

请求回来的数据默认是`json`字符串，需要对其进行`decode`并解析为数据对象才可以使用，这里使用系统自带的`convert`库进行解析，并解析为数组。

```dart
import 'package:http/http.dart' as http;

class RequestDemoState extends State<MyHomePage> {
  List dataList = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // 发起网络请求
  loadData() async{
    String requestURL = 'https://jsonplaceholder.typicode.com/posts';
    Client client = Client();
    Response response = await client.get(requestURL);

    String jsonString = response.body;
    setState(() {
      // 数据解析
      dataList = json.decode(jsonString);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title)
      ),
      body: ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (BuildContext context, int index) {
          return Text(dataList[index]['title']);
        },
      ),
    );
  }
}
```

在调用`Client`进行post数据请求时，需要传入一个字典进去，`Client`会通过将字典当做post的`from`表单。

```dart
 void requestData() async {
    var params = Map<String, String>();
    params["username"] = "lxz";
    params["password"] = "123456";

    var client = http.Client();
    var response = await client.post(url_post, body: params);
    _content = response.body;
}
```

#### dio网络库

`dio`库的调用方式和`http`库类似，这里不过多介绍。`dio`库相对于`http`库强大的在于，`dio`库提供了更好的`Cookie`管理、文件的上传下载、`fromData`表单等处理。所以，如果对网络库需求比较复杂的话，还是建议使用`dio`。

```dart
// 引入外部依赖
dio: ^1.0.9
```

### 数据解析

#### convert

系统自带有`convert`解析库，在使用时直接`import`即可。`convert`类似于iOS自带的JSON解析类`NSJSONSerialization`，可以直接将json字符串解析为字典或数组。

```dart
import 'dart:convert';
// 解析代码
dataList = json.decode(jsonString);
```

但是，我们在项目中使用时，一般都不会直接使用字典取值，这是一种很不好的做法。一般都会将字典或数组转换为模型对象，在项目中使用模型对象。可以定义类似`Model.dart`这样的模型类，并在模型类中进行数据解析，对外直接暴露公共变量来让外界获取值。

#### 自动序列化

但如果定义模型类的话，一个是要在代码内部写取值和赋值代码，这些都需要手动完成。另外如果当服务端字段发生改变后，客户端也需要跟着进行改变，所以这种方式并不是很灵活。

可以采用json序列化的三方库`json_serializable`，此库可以将一个类标示为自动JSON序列化的类，并对类提供JSON和对象相互转换的能力。也可以通过命令行开启一个`watch`，当类中的变量定义发生改变时，相关代码自动发生改变。

首先引入下面的三个库，其中包括依赖库一个，以及调试库两个。

```dart
dependencies:
  json_annotation: ^2.0.0

dev_dependencies:
  build_runner: ^1.0.0
  json_serializable: ^2.0.0
```

定义一个模型文件，例如这里叫做`User.dart`文件，并在内部定义一个`User`的模型类。随后引入`json_annotation`的依赖，通过`@JsonSerializable()`标示此类需要被`json_serializable`进行合成。

定义的`User`类包含两部分，实例变量和两个转换函数。在下面定义json转换函数时，需要注意函数命名一定要按照下面格式命名，否则不能正常生成`user.g.dart`文件。

```dart
import 'package:json_annotation/json_annotation.dart';

// 定义合成后的新文件为user.g.dart
part 'user.g.dart';

@JsonSerializable()

class User {
  String name;
  int age;
  String email;
  
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
```

下面就是`user.dart`指定生成的`user.g.dart`文件，其中包含JSON和对象相互转换的代码。

```dart
part of 'user.dart';

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
      json['name'] as String, json['age'] as int, json['email'] as String);
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'name': instance.name,
      'age': instance.age,
      'email': instance.email
    };
```

有的时候服务端返回的参数名和本地的关键字冲突，或者命名不规范，导致本地定义和服务器字段不同的情况。这种情况可以通过`@JsonKey`关键字，来修饰json字段匹配新的本地变量。除此之外，也可以做其他修饰，例如变量不能为空等。

```dart
@JsonKey(name: 'id')
final int user_id;
```

现在项目中依然是报错的，随后我们在`flutter`工程的根目录文件夹下，运行下面命令。

```
flutter packages pub run build_runner watch
```

此命令的好处在于，其会在后台监听模型类的定义，当模型类定义发生改变后，会自动修改本地源码以适配新的定义。以文中`User`类为例，当`User.dart`文件发生改变后，使用`Cmd+s`保存文件，随后VSCode会将自定改变`user.g.dart`文件的定义，以适配新的变量定义。

### 系统文件

#### 主要文件

- iOS文件：iOS工程文件
- Android：Android工程文件
- lib：Flutter的dart代码
- assets：资源文件夹，例如font、image等都可以放在里面
- .gitignore：git忽略文件

#### packages

这是一个系统文件，`Flutter`通过`.packages`文件来管理一些系统依赖库，例如`material`、`cupertino`、`widgets`、`animation`、`gesture`等系统库就在里面，这些主要的系统库由`.packages`下的`flutter`统一管理，源码都在`flutter/lib/scr`目录下。除此之外，还有一些其他的系统库或系统资源都在`.packages`中。

#### yaml文件

在`Flutter`中通过`pubspec.yaml`文件来管理外部引用，包含本地资源文件、字体文件、依赖库等依赖，以及应用的一些配置信息。这些配置在项目中时，需要注意代码对其的问题，否则会导致加载失败。

当修改`yaml`文件的依赖信息后，需要执行`flutter get packages`命令更新本地文件。但并不需要这么麻烦，可以直接`Cmd+s`保存文件，VSCode编译器会自动更新依赖。

```dart
// 项目配置信息
name: WeChat
description: Tencent WeChat App.
version: 1.0.0+1

// 常规依赖
dependencies:
  flutter:125864
    sdk: flutter
    cupertino_icons: ^0.1.2
    english_words: ^3.1.0

// 开发依赖
dev_dependencies:
  flutter_test:
    sdk: flutter
    
flutter:
  uses-material-design: true
  // 图片依赖
  assets:
    - assets/images/ic_file_transfer.png
    - assets/images/ic_fengchao.png

  // 字体依赖
  fonts:
    - family: appIconFont
      fonts:
        - asset: assets/fonts/iconfont.ttf
```

### Flutter开发

#### 启动函数

和大多数编程语言一样，`dart`也包含一个`main`方法，是`Flutter`程序执行的主入口，在`main`方法中写的代码就是在程序启动时执行的代码。`main`方法中会执行`runApp`方法，`runApp`方法类似于iOS的`UIApplicationMain`方法，`runApp`函数接收一个`Widget`用来做应用程序的显示。

```dart
void main() {
    runApp()
    // code
}
```

#### 生命周期

在iOS中通过`AppDelegate`可以获取应用程序的生命周期回调，在`Flutter`中也可以获取到。可以通过向`Binding`添加一个`Observer`，并实现`didChangeAppLifecycleState`方法，来监听指定事件的到来。

但是由于`Flutter`提供的状态有限，在iOS平台只能监听三种状态，下面是示例代码。

```dart
class LifeCycleDemoState extends State<MyHomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.inactive:
        print('Application Lifecycle inactive');
        break;
      case AppLifecycleState.paused:
        print('Application Lifecycle paused');
        break;
      case AppLifecycleState.resumed:
        print('Application Lifecycle resumed');
        break;
      default:
        print('Application Lifecycle other');
    }
  }
}
```

#### 矩阵变换

在`Flutter`中是支持矩阵变化的，例如`rotate`、`scale`等方式。`Flutter`的矩阵变换由`Widget`完成，需要进行矩阵变换的视图，在外面包一层`Transform Widget`即可，内部可以设置其变换方式。

```dart
child: Container(
    child: Transform(
      child: Container(
        child: Text(
          "Lorem ipsum",
          style: TextStyle(color: Colors.orange[300], fontSize: 12.0),
          textAlign: TextAlign.center,
        ),
        decoration: BoxDecoration(
          color: Colors.red[400],
        ),
        padding: EdgeInsets.all(16.0),
      ),
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..rotateZ(15 * 3.1415927 / 180),
    ),
  width: 320.0,
  height: 240.0,
  color: Colors.grey[300],
)
```

在`Transform`中可以通过`transform`指定其矩阵变换方式，通过`alignment`指定变换的锚点。

#### 页面导航

在iOS中可以通过`UINavigationController`对页面进行管理，控制页面间的push、pop跳转。`Flutter`中使用`Navigator`和`Routers`来实现类似`UINavigationController`的功能，`Navigator`负责管理导航栈，包含push、pop的操作，可以把`UIViewController`看做一个`Routers`，`Routers`被`Navigator`管理着。

`Navigator`的跳转方式分为两种，一种是直接跳转到某个`Widget`页面，另一种是为`MaterialApp`构建一个`map`，通过`key`来跳转对应的`Widget`页面。`map`的格式是`key : context`的形式。

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

跳转时通过`pushNamed`指定`map`中的`key`，即可跳转到对应的`Widget`。如果需要从push出来的页面获取参数，可以通过`await`修饰push操作，这样即可在新页面pop的时候将参数返回到当前页面。

```dart
Navigator.of(context).pushNamed('/b');

Map coordinates = await Navigator.of(context).pushNamed('/location');
Navigator.of(context).pop({"lat":43.821757,"long":-79.226392});
```

### 编码规范

VSCode有很好的语法检查，如果有命名不规范等问题，都会以警告的形式表现出来。

1. 驼峰命名法，方法名、变量名等，都以首字母小写的驼峰命名法。类名也是驼峰命名法，但类名首字母大写。
2. 文件名，文件命名以下划线进行区分，不使用驼峰命名法。
3. `Flutter`中创建`Widget`对象，可以用`new`修饰，也可以不用。

```dart
child: new Container(
    child: Text(
      'Hello World',
      style: TextStyle(color: Colors.orange, fontSize: 15.0)
    )
)
```

1. 函数中可以定义可选参数，以及必要参数。

下面是一个函数定义，这里定义了一个必要参数`url`，以及一个`Map`类型的可选参数`headers`。

```dart
Future<Response> get(url, {Map<String, String> headers});
```

1. `Dart`中在函数定义前加下划线，则表示是私有方法或变量。
2. `Dart`通过`import`引入外部引用，除此之外也可以通过下面的语法单独引入文件中的某部分。

```dart
import "dart:collection" show HashMap, IterableBase;
```

#### =>调用

在`Dart`中经常可以看到`=>`的调用方式，这种调用方式类似于一种语法糖，下面是一些常用的调用方式。

当进行函数调用时，可以将普通函数调用转换为`=>`的调用方式，例如下面第一个示例。在此基础上，如果调用函数只有一个参数，可以将其改为第二个示例的方式，也就是可以省略调用的括号，直接写参数名。

```
(单一参数) => {函数声明}
elements.map((element) => {
  return element.length;
});

单一参数 => {函数声明}
elements.map(element => {
 return element.length;
});
```

当只有一个返回值，并且没有逻辑处理时，可以直接省略`return`，返回数值。

```
(参数1, 参数2, …, 参数N) => 表达式
elements.map(element => element.length);
```

当调用的函数中没有参数时，可以直接省略参数，写一对空括号即可。

```
() => {函数实现}
```

### 小技巧

#### 代码重构

VSCode支持对`Dart`语言进行重构，一般作用范围都是在函数内小范围的。

例如在创建`Widget`对象的地方，将鼠标焦点放在这里，当前行的最前面会有提示。点击提示后会有下面两个选项：

- `Extract Local Variable`
  将当前`Widget`及其子`Widget`创建的代码，剥离到一个变量中，并在当前位置使用这个变量。
- `Extract Method`
  将当前`Widget`及其子`Widget`创建的代码，封装到一个函数中，并在当前位置调用此函数。

除此之外，将鼠标焦点放在方法的一行，点击最前面的提示，会出现下面两个选项：

- `Convert to expression body`
  将当前函数转换为一个表达式。
- `Convert to async function body`
  将当前函数转换为一个异步线程中执行的代码。

#### 附加效果

在`Dart`中添加任何附加效果，例如动画效果或矩阵转换，除了直接给`Widget`子类的属性赋值外，就是在被当前`Widget`外面包一层，就可以使当前`Widget`拥有对应的效果。

```dart
// 动画效果
floatingActionButton: FloatingActionButton(
    tooltip: 'Fade',
    child: Icon(Icons.brush),
    onPressed: () {
      controller.forward();
    },
),

// 矩阵转换
Transform(
  child: Container(
    child: Text(
      "Lorem ipsum",
      style: TextStyle(color: Colors.orange[300], fontSize: 12.0),
      textAlign: TextAlign.center,
    )
  ),
  alignment: Alignment.center,
  transform: Matrix4.identity()
    ..rotateZ(15 * 3.1415927 / 180),
),
```

#### 快捷键(VSCode)

- `Cmd + Shift + p`：可以进行快速搜索。需要注意的是，默认是带有一个`>`的，这样搜索结果主要是`dart`代码。如果想搜索其他配置文件，或者安装插件等操作，需要把`>`去掉。
- `Cmd + Shift + o`：可以在某个文件中搜索某个类，但前提是需要提前进入这个文件。例如进入`framework.dart`，搜索`StatefulWidget`类。

### 注意点

- 使用`Flutter`要注意代码缩进，如果缩进有问题可能会影响最后的结果，尤其是在`.yaml`中写配置文件的时候。
- 因为`Flutter`是开源的，所以遇到问题后可以进入源码中，找解决方案。
- 在代码中要注意标点符号的使用，例如第二个创建`Stack`的代码，如果上面是以逗号结尾，则后面的创建会失败，如果上面是以分号结尾则没问题。

```dart
Widget unreadMsgText = Container(
    width: Constants.UnreadMsgNotifyDotSize,
    height: Constants.UnreadMsgNotifyDotSize,
    child: Text(
      conversation.unreadMsgCount.toString(),
      style: TextStyle(
        color: Color(AppColors.UnreadMsgNotifyTextColor),
        fontSize: 12.0
      ),
    ),
  );
  
  avatarContainer = Stack(
    overflow: Overflow.visible,
    children: <Widget>[
      avatar
    ],
  );
```