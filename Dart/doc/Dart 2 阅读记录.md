# Dart 2 阅读记录

[原文链接](https://www.dartlang.org/guides/language/language-tour)

在线练习工具：[**Open DartPad**](<https://dartpad.dartlang.org/>)

### 变量

1.可以使用 `var` `dynamic` `String`(具体类型)

如 `var firstName = 'xx'; dynamic lastName = 'yy'; String fullName = firstName + lastName;`

2.所有未初始化的变量的默认值是`null`。

3.如果变量不变，则用`final` `const`来修饰不可变常量。`final`常量只初始化一次，`const`是编译时常量。`const`是隐式的`final`，在修饰实例变量的时候使用`final`，`final`实例常量在实例构造函数初始化前就初始化了。

思考：

```dart
var foo = const [];
var baz = final []; // 是否报错
final bar = const [];
foo = [1, 2, 3]; // 是否报错
bar = [1, 2, 3]; // 是否报错
```

###类型

- Numbers

  `int`: 64位，在Dart VM上，取值范围是 -2^63 to 2^63 - 1.

  `double`: 64位双精度

  都可以用 `num` 来表示

- Strings

  Dart 是UTF-16编码，字符串可以通过`+` 组合，用 `==` 比较字符串是否相等。

  用 `'''` `'''`多行文本。用 `r` 表示忽略字符串中的转义字符

  字符串是编译时变量，所以插值可以是`null`、`num`、`bool`、`String` 这4个类型。

- Booleans

  使用`bool` 定义类型，注意未初始化的bool是null，不能直接通过if(nonbooleanValue)来判断。

- Lists

  类似其他语言的数组，有序对象数组。使用`List` 定义类型。用`[]`包含对象。

- Sets

  唯一无序的集合对象。使用`Set`定义类型，用 `{}` 包含对象。

- Maps

  字典类型，用`{key : value}`表示。与其他语言类似`map[key] = value`, 若key不存在则相当于插入键值对。

  因为`Maps`与`Sets`都是用花括号`{}`，所以初始化空时，未指定集合类型，则默认为字典类型。

- Runes

  在Dart中，符号是UTF-32编码。如`\u2665`,如果唱过4位则用`{}`包含，如`u\{1f600}`表示。如下：

  ```dart
  main() {
    var clapping = '\u{1f44f}';
    print(clapping);
    print(clapping.codeUnits);
    print(clapping.runes.toList());
  
    Runes input = new Runes(
        '\u2665  \u{1f605}  \u{1f60e}  \u{1f47b}  \u{1f596}  \u{1f44d}');
    print(new String.fromCharCodes(input));
  }
  
  输出：
  👏
  [55357, 56399]
  [128079]
  ♥  😅  😎  👻  🖖  👍
  ```

- Symbols

  基本不会用到，用 `#` 标志在前缀。

###函数

书写格式：

```dart
bool isNoble(int atomicNumber) {
  return _nobleGases[atomicNumber] != null;
}

isNoble(atomicNumber) {
  return _nobleGases[atomicNumber] != null;
}

bool isNoble(int atomicNumber) => _nobleGases[atomicNumber] != null;
```

=> *expr* 只能一个表达式而不是语句

#### 可选参数

只能是位置参数或者命名参数，不能2者都是可选。

- 命名可选参数

  参数前加`@required` 表示必需参数。

  ```dart
  void enableFlags({bool bold, @required bool hidden}){...};
  ```

- 位置可选参数

  其实所有未加必需标志的都是可选参数

#### main()函数

#### 函数作为其他函数的参数

#### 匿名函数

`lambda 、 closure`，格式如下：

```dart
([[Type] param1[, …]]) { 
  codeBlock; 
};
```

例子：

```dart
var list = ['apples', 'bananas', 'oranges'];
list.forEach((item) {
  print('${list.indexOf(item)}: $item');
});

list.forEach(
    (item) => print('${list.indexOf(item)}: $item'));
```

#### 返回值

所有函数都有返回值，如果没用指定返回值，只是返回了null。

### 操作符

| 说明                     | Operator                                                 |
| ------------------------ | -------------------------------------------------------- |
| 一元后缀                 | `expr++`    `expr--`    `()`    `[]`    `.`    `?.`      |
| unary prefix             | `-expr`    `!expr`    `~expr`    `++expr`    `--expr`    |
| multiplicative           | `*`    `/`    `%`  `~/`                                  |
| additive                 | `+`    `-`                                               |
| shift                    | `<<`    `>>`    `>>>`                                    |
| 位 AND                   | `&`                                                      |
| bitwise XOR              | `^`                                                      |
| bitwise OR               | `|`                                                      |
| relational and type test | `>=`    `>`    `<=`    `<`    `as`    `is`    `is!`      |
| equality                 | `==`    `!=`                                             |
| logical AND              | `&&`                                                     |
| logical OR               | `||`                                                     |
| if null                  | `??`                                                     |
| conditional              | `expr1 ? expr2 : expr3`                                  |
| cascade                  | `..`                                                     |
| assignment               | `=`    `*=`    `/=`   `+=`   `-=`   `&=`   `^=`   *etc.* |

#### 算术运算符

| Operator | Meaning                                                      |
| -------- | ------------------------------------------------------------ |
| `+`      | Add                                                          |
| `–`      | Subtract                                                     |
| `-expr`  | Unary minus, also known as negation (reverse the sign of the expression) |
| `*`      | Multiply                                                     |
| `/`      | Divide                                                       |
| `~/`     | Divide, returning an integer result                          |
| `%`      | Get the remainder of an integer division (modulo)            |

注意`var++ 、++var`的区别

#### 等式关系运算符

| Operator | Meaning                         |
| -------- | ------------------------------- |
| `==`     | Equal; see discussion below     |
| `!=`     | Not equal 等于(!(var1 == var2)) |
| `>`      | Greater than                    |
| `<`      | Less than                       |
| `>=`     | Greater than or equal to        |
| `<=`     | Less than or equal to           |

#### 类型操作符

| Operator | Meaning                                                      |
| -------- | ------------------------------------------------------------ |
| `as`     | Typecast (also used to specify [library prefixes](https://www.dartlang.org/guides/language/language-tour#specifying-a-library-prefix)) |
| `is`     | True if the object has the specified type                    |
| `is!`    | False if the object has the specified type                   |

#### 赋值运算符

| `=`  | `–=` | `/=`  | `%=`  | `>>=` | `^=` |
| ---- | ---- | ----- | ----- | ----- | :--- |
| `+=` | `*=` | `~/=` | `<<=` | `&=`  | `|=` |

`??=` 举例下这个运算符如何操作

#### 逻辑运算符

#### 位运算符

#### 条件运算符

#### 级联

用`..`表示，

```dart
querySelector('#confirm') // Get an object.
  ..text = 'Confirm' // Use its members.
  ..classes.add('important')
  ..onClick.listen((e) => window.alert('Confirmed!'));

var sb = StringBuffer();
sb.write('foo')
  ..write('bar'); // Error: method 'write' isn't defined for 'void'.
```

#### 其他操作符

| Operator | Name                      | Meaning                                                      |
| -------- | ------------------------- | ------------------------------------------------------------ |
| `()`     | Function application      | Represents a function call                                   |
| `[]`     | List access               | Refers to the value at the specified index in the list       |
| `.`      | Member access             | Refers to a property of an expression; example: `foo.bar` selects property `bar` from expression `foo` |
| `?.`     | Conditional member access | Like `.`, but the leftmost operand can be null; example: `foo?.bar` selects property `bar`from expression `foo` unless `foo` is null (in which case the value of `foo?.bar` is null) |

### 控制流

- `if` and `else`
- `for` loops
- `while` and `do`-`while` loops
- `break` and `continue`
- `switch` and `case`
- `assert`

#### if 和 else

#### for 循环

#### while 和 do-While

#### Break 和 continue

#### Switch 和 case

每一个case用break分割，2个case间不写break则贯穿，可以用 `continue`跳转到指定`label`

#### 断言

使用`asset`表示。`asset(bool, message)`.

### 异常

####Throw

```dart
throw FormatException('Expected at least 1 section');
throw 'Out of llamas!';	// 也可以抛出任意对象
```

####Catch

```dart
try {
  breedMoreLlamas();
} on OutOfLlamasException {
  // A specific exception
  buyMoreLlamas();
} on Exception catch (e) {
  // Anything else that is an exception
  print('Unknown exception: $e');
} catch (e, s) {
  // No specified type, handles all
  print('Something really unknown: $e');
}
```

####Finally

### 类

#### 类成员

#### 构造函数

#### 对象运行时类型

```dart
print('The type of a is ${a.runtimeType}');
```

#### 实例变量

#### 构造器

```dart
class Point {
  num x, y;

  Point(num x, num y) {
    // There's a better way to do this, stay tuned.
    this.x = x;
    this.y = y;
  }
}

class Point {
  num x, y;

  // Syntactic sugar for setting x and y
  // before the constructor body runs.
  Point(this.x, this.y);
}
```

- 默认构造器：默认构造函数没有参数，并调用超类中的无参数构造函数

- 构造函数不是继承的

- 命名构造函数：构造函数不是继承的，这意味着超类的命名构造函数不是由子类继承的。如果希望用超类中定义的命名构造函数创建子类，必须在子类中实现该构造函数

  ```dart
  class Point {
    num x, y;
  
    Point(this.x, this.y);
  
    // 命名构造函数
    Point.origin() {
      x = 0;
      y = 0;
    }
  }
  ```

- 调用非默认超类构造函数

  ```dart
  class Person {
    String firstName;
  
    Person.fromJson(Map data) {
      print('in Person');
    }
  }
  
  class Employee extends Person {
    // Person does not have a default constructor;
    // you must call super.fromJson(data).
    Employee.fromJson(Map data) : super.fromJson(data) {
      print('in Employee');
    }
  }
  
  main() {
    var emp = new Employee.fromJson({});
  
    // Prints:
    // in Person
    // in Employee
    if (emp is Person) {
      // Type check
      emp.firstName = 'Bob';
    }
    (emp as Person).firstName = 'Bob';
  }
  
  // 因为超类构造函数的参数是在调用构造函数之前计算的，所以参数可以是表达式，如函数调用
  class Employee extends Person {
    Employee() : super.fromJson(getDefaultData());
    // ···
  }
  ```

- 初始值设定项列表

  ```dart
  // Initializer list sets instance variables before
  // the constructor body runs.
  Point.fromJson(Map<String, num> json)
      : x = json['x'],
        y = json['y'] {
    print('In Point.fromJson(): ($x, $y)');
  }
  
  // 在开发过程中，您可以使用初始值设定项列表中的断言来验证输入。
  Point.withAssert(this.x, this.y) : assert(x >= 0) {
    print('In Point.withAssert(): ($x, $y)');
  }
  ```

- 重定向构造函数

  ```dart
  class Point {
    num x, y;
  
    // The main constructor for this class.
    Point(this.x, this.y);
  
    // Delegates to the main constructor.
    Point.alongXAxis(num x) : this(x, 0);
  }
  ```

- 常量构造函数

  ```dart
  class ImmutablePoint {
    static final ImmutablePoint origin =
        const ImmutablePoint(0, 0);
  
    final num x, y;
  
    const ImmutablePoint(this.x, this.y);
  }
  ```

- 工厂构造函数

  使用`factory` 关键词来实现，注意工厂构造函数不能访问`this`.

  ```dart
  class Logger {
    final String name;
    bool mute = false;
  
    // _cache is library-private, thanks to
    // the _ in front of its name.
    static final Map<String, Logger> _cache =
        <String, Logger>{};
  
    factory Logger(String name) {
      if (_cache.containsKey(name)) {
        return _cache[name];
      } else {
        final logger = Logger._internal(name);
        _cache[name] = logger;
        return logger;
      }
    }
  
    Logger._internal(this.name);
  
    void log(String msg) {
      if (!mute) print(msg);
    }
  }
  ```

#### 方法

方法是为对象提供行为的函数。

- 实例方法

  对象上的实例方法可以访问实例变量

- ```dart
  class Point {
    num x, y;
  
    Point(this.x, this.y);
  
    num distanceTo(Point other) {
      var dx = x - other.x;
      var dy = y - other.y;
      return sqrt(dx * dx + dy * dy);
    }
  }
  ```

- Getters 和 setters

  使用`get` / `set` 关键词来表示

- ```dart
  class Rectangle {
    num left, top, width, height;
  
    Rectangle(this.left, this.top, this.width, this.height);
  
    // Define two calculated properties: right and bottom.
    num get right => left + width;
    set right(num value) => left = value - width;
    num get bottom => top + height;
    set bottom(num value) => top = value - height;
  }
  
  void main() {
    var rect = Rectangle(3, 4, 20, 15);
    assert(rect.left == 3);
    rect.right = 12;
    assert(rect.left == -8);
  }
  ```

- 抽象方法

  使用关键词`abstract` 标志

- ```dart
  abstract class Doer {
    // Define instance variables and methods...
  
    void doSomething(); // Define an abstract method.
  }
  
  class EffectiveDoer extends Doer {
    void doSomething() {
      // Provide an implementation, so the method is not abstract here...
    }
  }
  ```

- #### 抽象类

```dart
// This class is declared abstract and thus
// can't be instantiated.
abstract class AbstractContainer {
  // Define constructors, fields, methods...

  void updateChildren(); // Abstract method.
}
```

####隐式接口

使用`implements` 标识

```dart
// A person. The implicit interface contains greet().
class Person {
  // In the interface, but visible only in this library.
  final _name;

  // Not in the interface, since this is a constructor.
  Person(this._name);

  // In the interface.
  String greet(String who) => 'Hello, $who. I am $_name.';
}

// An implementation of the Person interface.
class Impostor implements Person {
  get _name => '';

  String greet(String who) => 'Hi $who. Do you know who I am?';
}

String greetBob(Person person) => person.greet('Bob');

void main() {
  print(greetBob(Person('Kathy')));
  print(greetBob(Impostor()));
}

// 如果多个实现
class Point implements Comparable, Location {...}
```

#### 扩展一个类

使用`extends`  创建子类，`super`  引用超类

```dart
class Television {
  void turnOn() {
    _illuminateDisplay();
    _activateIrSensor();
  }
  // ···
}

class SmartTelevision extends Television {
  void turnOn() {
    super.turnOn();
    _bootNetworkInterface();
    _initializeMemory();
    _upgradeApps();
  }
  // ···
}
```

- 重写成员

  子类可以重写实例方法、getters和setters，用`override`  标识。

  ```dart
  class SmartTelevision extends Television {
    @override
    void turnOn() {...}
    // ···
  }
  ```

- 重写运算符

  | `<`  | `+`  | `|`  | `[]`  |
  | ---- | ---- | ---- | ----- |
  | `>`  | `/`  | `^`  | `[]=` |
  | `<=` | `~/` | `&`  | `~`   |
  | `>=` | `*`  | `<<` | `==`  |
  | `–`  | `%`  | `>>` |       |

  为什么`!=` 不能重写？

  ```dart
  class Vector {
    final int x, y;
  
    Vector(this.x, this.y);
  
    Vector operator +(Vector v) => Vector(x + v.x, y + v.y);
    Vector operator -(Vector v) => Vector(x - v.x, y - v.y);
  
    // Operator == and hashCode not shown. For details, see note below.
    // ···
  }
  
  void main() {
    final v = Vector(2, 3);
    final w = Vector(2, 2);
  
    assert(v + w == Vector(4, 5));
    assert(v - w == Vector(0, 1));
  }
  ```

  如果重写 `==` ，也要重写`hasCode`的`getter`。

- noSuchMethod()

  ```dart
  class A {
    // Unless you override noSuchMethod, using a
    // non-existent member results in a NoSuchMethodError.
    @override
    void noSuchMethod(Invocation invocation) {
      print('You tried to use a non-existent member: ' +
          '${invocation.memberName}');
    }
  }
  ```

#### 枚举类型

枚举类型，通常称为枚举或枚举，是一种特殊的类，用于表示固定数量的常数值。

- 使用枚举

  使用关键词`enum`，枚举中的每个值都有一个索引获取器，它返回该值在枚举声明中从零开始的位置，使用`values` 返回枚举的数组

  ```dart
  enum Color { red, green, blue }
  
  List<Color> colors = Color.values;
  assert(colors[2] == Color.blue);
  ```

#### 向类添加功能:mixins

mixins是在多个类层次结构中重用类代码的一种方式.

若要使用mixin，请使用with关键字，后跟一个或多个mixin名称

```dart
class Musician extends Performer with Musical {
  // ···
}

class Maestro extends Person
    with Musical, Aggressive, Demented {
  Maestro(String maestroName) {
    name = maestroName;
    canConduct = true;
  }
}
```

若要实现mixin，请创建一个扩展对象并且不声明构造函数的类。除非您希望您的mixin可以用作常规类，否则请使用mixin关键字而不是class。

```dart
mixin Musical {
  bool canPlayPiano = false;
  bool canCompose = false;
  bool canConduct = false;

  void entertainMe() {
    if (canPlayPiano) {
      print('Playing piano');
    } else if (canConduct) {
      print('Waving hands');
    } else {
      print('Humming to self');
    }
  }
}
```

要指定只有某些类型可以使用mixin(例如，这样您的mixin就可以调用它没有定义的方法)，请使用on来指定所需的超类:

```dart
mixin MusicalPerformer on Musician {
  // ···
}
```

#### 类变量和方法

使用static关键字实现类范围的变量和方法。

- 静态变量

  静态变量直到被使用后才被初始化

  ```dart
  class Queue {
    static const initialCapacity = 16;
    // ···
  }
  
  void main() {
    assert(Queue.initialCapacity == 16);
  }
  ```

- 静态方法

  静态方法(类方法)不在实例上操作，因此无法访问该实例(this)

  ```dart
  class Point {
    num x, y;
    Point(this.x, this.y);
  
    static num distanceBetween(Point a, Point b) {
      var dx = a.x - b.x;
      var dy = a.y - b.y;
      return sqrt(dx * dx + dy * dy);
    }
  }
  
  void main() {
    var a = Point(2, 2);
    var b = Point(4, 4);
    var distance = Point.distanceBetween(a, b);
    assert(2.8 < distance && distance < 2.9);
    print(distance);
  }
  ```

### 泛型

按照惯例，大多数类型变量都有单字母名称，如E、T、S、K和V

#### 为什么使用泛型

泛型通常是类型安全所必需的，但是它们比仅仅允许您的代码运行有更多的好处:

 正确指定泛型类型会产生更好的代码。

 您可以使用泛型来减少代码重复

#### 使用集合字面量

list、set和map字面量可以参数化。

#### 在构造函数中使用参数化类型

若要在使用构造函数时指定一个或多个类型，请将这些类型放在尖括号()就在类名之后

```dart
var nameSet = Set<String>.from(names);
var views = Map<int, View>();
```

#### 泛型集合及其包含的类型

```dart
var names = List<String>();
names.addAll(['Seth', 'Kathy', 'Lars']);
print(names is List<String>); // true
```

有别于其他语言，其他语言能判断是否是顶级类型list或者map，但不能判断list<string>类型。

#### 限制参数化类型

实现泛型类型时，您可能希望限制其参数的类型。您可以使用`extends` 来实现这一点

```dart
class Foo<T extends SomeBaseClass> {
  // Implementation goes here...
  String toString() => "Instance of 'Foo<$T>'";
}

class Extender extends SomeBaseClass {...}
```

#### 使用泛型方法

```dart
T first<T>(List<T> ts) {
  // Do some initial work or error checking, then...
  T tmp = ts[0];
  // Do some additional checking or processing...
  return tmp;
}
```

### 库和可见性

#### 使用库

使用`import`  指定一个库的命名空间如何在另一个库的范围内使用.

```dart
import 'dart:html';
import 'package:test/test.dart';
```

- 指定库前缀

  如果导入两个标识符冲突的库，则可以为其中一个或两个库指定前缀

  ```dart
  import 'package:lib1/lib1.dart';
  import 'package:lib2/lib2.dart' as lib2;
  
  // Uses Element from lib1.
  Element element1 = Element();
  
  // Uses Element from lib2.
  lib2.Element element2 = lib2.Element();
  ```

- 仅导入库的一部分

  ```dart
  // Import only foo.
  import 'package:lib1/lib1.dart' show foo;
  
  // Import all names EXCEPT foo.
  import 'package:lib2/lib2.dart' hide foo;
  ```

- 懒加载库

  要延迟加载库，必须首先使用 `deferred as`

  ```dart
  import 'package:greetings/hello.dart' deferred as hello;
  
  Future greet() async {
    await hello.loadLibrary();
    hello.printGreeting();
  }
  ```

#### 实现库

请看 [Create Library Packages](https://www.dartlang.org/guides/libraries/create-library-packages) 

### 异步支持

使用关键字`async` 和 `await`。

#### 处理Futures

```dart
Future checkVersion() async {
  var version = await lookUpVersion();
  // Do something with version
}
```

#### 声明异步函数

异步函数是其主体用`async`修饰符标记的函数。

```dart
Future<String> lookUpVersion() async => '1.0.0';
```

#### 处理Streams

```dart
await for (varOrType identifier in expression) {
  // Executes each time the stream emits a value.
}
```

### 生成器

要实现同步生成器函数，请将函数体标记为sync*，并使用yield语句传递值

```dart
Iterable<int> naturalsTo(int n) sync* {
  int k = 0;
  while (k < n) yield k++;
}
```

要实现异步生成器函数，请将函数体标记为async*，并使用yield语句传递值:

```dart
Stream<int> asynchronousNaturalsTo(int n) async* {
  int k = 0;
  while (k < n) yield k++;
}
```

如果生成器是递归的，可以使用yield*:

```dart
Iterable<int> naturalsDownFrom(int n) sync* {
  if (n > 0) {
    yield n;
    yield* naturalsDownFrom(n - 1);
  }
}
```

### 可调用类

要允许像函数一样调用Dart类，请实现call()方法

```dart
class WannabeFunction {
  call(String a, String b, String c) => '$a $b $c!';
}

main() {
  var wf = new WannabeFunction();
  var out = wf("Hi","there,","gang");
  print('$out');
}

// Hi there, gang!
```

### Isolates

更多信息，请参见[dart:isolate library documentation.](https://api.dartlang.org/stable/dart-isolate)

### 声明类型

```dart
typedef Compare<T> = int Function(T a, T b);

int sort(int a, int b) => a - b;

void main() {
  assert(sort is Compare<int>); // True!
}
```

### 元数据

使用元数据提供关于代码的附加信息。元数据注释以字符@开头，后跟对编译时常数的引用(如`@deprecated`)或对常数构造函数的调用。

```dart
class Television {
  /// _Deprecated: Use [turnOn] instead._
  @deprecated
  void activate() {
    turnOn();
  }

  /// Turns the TV's power on.
  void turnOn() {...}
}

@Todo('seth', 'make this do something')
void doSomething() {
  print('do something');
}
```

### 注释

#### 单行注释

使用`//`

#### 多行注释

使用`/*  */`

#### 文档注释

使用`///`或者 `/**` 



### 关键词

| [abstract](https://www.dartlang.org/guides/language/language-tour#abstract-classes) 2 | [dynamic](https://www.dartlang.org/guides/language/language-tour#important-concepts) 2 | [implements](https://www.dartlang.org/guides/language/language-tour#implicit-interfaces) 2 | [show](https://www.dartlang.org/guides/language/language-tour#importing-only-part-of-a-library) 1 |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| [as](https://www.dartlang.org/guides/language/language-tour#type-test-operators) 2 | [else](https://www.dartlang.org/guides/language/language-tour#if-and-else) | [import](https://www.dartlang.org/guides/language/language-tour#using-libraries) 2 | [static](https://www.dartlang.org/guides/language/language-tour#class-variables-and-methods) 2 |
| [assert](https://www.dartlang.org/guides/language/language-tour#assert) | [enum](https://www.dartlang.org/guides/language/language-tour#enumerated-types) | [in](https://www.dartlang.org/guides/language/language-tour#for-loops) | [super](https://www.dartlang.org/guides/language/language-tour#extending-a-class) |
| [async](https://www.dartlang.org/guides/language/language-tour#asynchrony-support) 1 | [export](https://www.dartlang.org/guides/libraries/create-library-packages) 2 | [interface](https://stackoverflow.com/questions/28595501/was-the-interface-keyword-removed-from-dart) 2 | [switch](https://www.dartlang.org/guides/language/language-tour#switch-and-case) |
| [await](https://www.dartlang.org/guides/language/language-tour#asynchrony-support) 3 | [extends](https://www.dartlang.org/guides/language/language-tour#extending-a-class) | [is](https://www.dartlang.org/guides/language/language-tour#type-test-operators) | [sync](https://www.dartlang.org/guides/language/language-tour#generators) 1 |
| [break](https://www.dartlang.org/guides/language/language-tour#break-and-continue) | [external](https://stackoverflow.com/questions/24929659/what-does-external-mean-in-dart) 2 | [library](https://www.dartlang.org/guides/language/language-tour#libraries-and-visibility) 2 | [this](https://www.dartlang.org/guides/language/language-tour#constructors) |
| [case](https://www.dartlang.org/guides/language/language-tour#switch-and-case) | [factory](https://www.dartlang.org/guides/language/language-tour#factory-constructors) 2 | [mixin](https://www.dartlang.org/guides/language/language-tour#adding-features-to-a-class-mixins) 2 | [throw](https://www.dartlang.org/guides/language/language-tour#throw) |
| [catch](https://www.dartlang.org/guides/language/language-tour#catch) | [false](https://www.dartlang.org/guides/language/language-tour#booleans) | [new](https://www.dartlang.org/guides/language/language-tour#using-constructors) | [true](https://www.dartlang.org/guides/language/language-tour#booleans) |
| [class](https://www.dartlang.org/guides/language/language-tour#instance-variables) | [final](https://www.dartlang.org/guides/language/language-tour#final-and-const) | [null](https://www.dartlang.org/guides/language/language-tour#default-value) | [try](https://www.dartlang.org/guides/language/language-tour#catch) |
| [const](https://www.dartlang.org/guides/language/language-tour#final-and-const) | [finally](https://www.dartlang.org/guides/language/language-tour#finally) | [on](https://www.dartlang.org/guides/language/language-tour#catch) 1 | [typedef](https://www.dartlang.org/guides/language/language-tour#typedefs) 2 |
| [continue](https://www.dartlang.org/guides/language/language-tour#break-and-continue) | [for](https://www.dartlang.org/guides/language/language-tour#for-loops) | [operator](https://www.dartlang.org/guides/language/language-tour#overridable-operators) 2 | [var](https://www.dartlang.org/guides/language/language-tour#variables) |
| [covariant](https://www.dartlang.org/guides/language/sound-problems#the-covariant-keyword) 2 | [Function](https://www.dartlang.org/guides/language/language-tour#functions) 2 | [part](https://www.dartlang.org/guides/libraries/create-library-packages#organizing-a-library-package) 2 | [void](https://medium.com/dartlang/dart-2-legacy-of-the-void-e7afb5f44df0) |
| [default](https://www.dartlang.org/guides/language/language-tour#switch-and-case) | [get](https://www.dartlang.org/guides/language/language-tour#getters-and-setters) 2 | [rethrow](https://www.dartlang.org/guides/language/language-tour#catch) | [while](https://www.dartlang.org/guides/language/language-tour#while-and-do-while) |
| [deferred](https://www.dartlang.org/guides/language/language-tour#lazily-loading-a-library) 2 | [hide](https://www.dartlang.org/guides/language/language-tour#importing-only-part-of-a-library) 1 | [return](https://www.dartlang.org/guides/language/language-tour#functions) | [with](https://www.dartlang.org/guides/language/language-tour#adding-features-to-a-class-mixins) |
| [do](https://www.dartlang.org/guides/language/language-tour#while-and-do-while) | [if](https://www.dartlang.org/guides/language/language-tour#if-and-else) | [set](https://api.dartlang.org/stable/dart-core/Set-class.html) 2 | [yield](https://www.dartlang.org/guides/language/language-tour#generators) 3 |