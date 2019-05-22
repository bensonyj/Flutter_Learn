# Visual Studio Code 与 Flutter

[原文链接](https://flutter.dev/docs/development/tools/vs-code)

1.每次启动VSCode，都会自动检查本地扩展(extensions)更新，根据要求选择是否更新即可
2.Command Palette：快捷键Mac(`Cmd`+`shift`+`P`)。（Command类同与Ctrl）


## 创建新工程

1. Command Palette
2. 选择 `Flutter: New Project`,再按下enter键
3. 输入工程名称
4. 确定工程目录

## 编辑代码，查看问题

- 鼠标移动到类型声明处，编译器会弹出简略说明，右键选择 **Go to Definition** 或者按住Cmd+左键跳转到源码定义处，(按住Cmd后移动鼠标也可查看详细定义)。查看所有引用类型用法右键选择 **Find All References**
- 查看所有当前源代码问题：**View > Problems** 或者快捷键(`Cmd`+`shift`+`M`)。再按即隐藏或打开

## 运行并调试

调试按 **Debug > Start Debugging** 或者 按(**fn + F5**在mac上)，此模式下默认断点调试。

 **Debug > Start Without Debugging** ，此模式不进入断点调试。

## 调试布局

打开Command Palette

- **Toggle Baseline Painting**: Causes each RenderBox to paint a line at each of its baselines.
- **Toggle Repaint Rainbow**: Show rotating colors on layers when repainting.
- **Toggle Slow Animations**: Slow down animations to enable visual inspection.
- **Toggle Slow-Mode Banner**: Hide the slow mode banner even when running a debug build.

## 代码片段

默认片段：

- Prefix `stless`: Create a new subclass of `StatelessWidget`.
- Prefix `stful`: Create a new subclass of `StatefulWidget` and it’s associated State subclass.
- Prefix `stanim`: Create a new subclass of `StatefulWidget`, and it’s associated State subclass including a field initialized with an `AnimationController`.

打开Command Palette，选择 **Configure User Snippets** 可以操作自定义片段。

这里推荐第三方：Awesome Flutter Snippets

| `statelessW`      | Stateless Widget         | Creates a Stateless widget                                   |
| ----------------- | ------------------------ | ------------------------------------------------------------ |
| `statefulW`       | Stateful Widget          | Creates a Stateful widget                                    |
| `build`           | Build Method             | Describes the part of the user interface represented by the widget. |
| `initS`           | InitState                | Called when this object is inserted into the tree. The framework will call this method exactly once for each State object it creates. |
| `dis`             | Dispose                  | Called when this object is removed from the tree permanently. The framework calls this method when this State object will never build again. |
| `reassemble`      | Reassemble               | Called whenever the application is reassembled during debugging, for example during hot reload. |
| `didChangeD`      | didChangeDependencies    | Called when a dependency of this State object changes        |
| `didUpdateW`      | didUpdateWidget          | Called whenever the widget configuration changes.            |
| `customClipper`   | Custom Clipper           | Used for creating custom shapes                              |
| `customPainter`   | Custom Painter           | Used for creating custom paint                               |
| `listViewB`       | ListView.Builder         | Creates a scrollable, linear array of widgets that are created on demand.Providing a non-null `itemCount` improves the ability of the `ListView` to estimate the maximum scroll extent. |
| `customScrollV`   | Custom ScrollView        | Creates a `ScrollView` that creates custom scroll effects using slivers. If the `primary` argument is true, the `controller` must be null. |
| `streamBldr`      | Stream Builder           | Creates a new `StreamBuilder` that builds itself based on the latest snapshot of interaction with the specified `stream` |
| `animatedBldr`    | Animated Builder         | Creates an Animated Builder. The widget specified to `child` is passed to the `builder` |
| `statefulBldr`    | Stateful Builder         | Creates a widget that both has state and delegates its build to a callback. Useful for rebuilding specific sections of the widget tree. |
| `oriantationBldr` | Orientation Builder      | Creates a builder which allows for the orientation of the device to be specified and referenced |
| `layoutBldr`      | Layout Builder           | Similar to the `Builder` widget except that the framework calls the builder function at layout time and provides the parent widget's constraints. |
| `singleChildSV`   | Single Child Scroll View | Creates a scroll view with a single child                    |
| `futureBldr`      | Future Builder           | Creates a Future Builder. This builds itself based on the latest snapshot of interaction with a Future. |
| `nosm`            | No Such Method           | This method is invoked when a non-existent method or property is accessed. |
| `inheritedW`      | Inherited Widget         | Class used to propagate information down the widget tree.    |
| `mounted`         | Mounted                  | Whether this State object is currently in a tree.            |
| `snk`             | Sink                     | A Sink is the input of a stream.                             |
| `strm`            | Stream                   | A source of asynchronous data events. A stream can be of any data type. |
| `toStr`           | To String                | Returns a string representation of this object.              |
| `debugP`          | Debug Print              | Prints a message to the console, which you can access using the flutter tool's `logs` command (flutter logs). |
| `importM`         | Material Package         | Import Material package.                                     |
| `importC`         | Cupertino Package        | Import Cupertino package.                                    |
| `mateapp`         | Material App             | Create a new Material App.                                   |
| `cupeapp`         | Cupertino Package        | Create a New Cupertino App.                                  |





