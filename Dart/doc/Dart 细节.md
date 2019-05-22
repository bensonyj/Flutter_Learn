## Dart 细节

1.[Dart语言简介, Flutter中文网](<https://book.flutterchina.club/chapter1/dart.html>)

### 变量

- var

  var设置的变量一旦赋值，类型便会确定，则不能再改变为其他类型

- dynamic和Object

  声明的变量可以赋值任意对象. 而`dynamic`与`Object`相同之处在于,他们声明的变量可以在后期改变赋值类型。

  `dynamic`与`Object`不同的是,`dynamic`声明的对象编译器会提供所有可能的组合, 而`Object`声明的对象只能使用Object的属性与方法, 否则编译器会报错

#### 级联

当你要对一个单一的对象进行一系列的操作的时候 可以使用级联操作符

```dart
class Person {
    String name;
    String sex;
    int age;
   setAge(num age) =>this.age=age;

    String toString() => 'Name:$name\nSex:$sex\nage:$age';
}
void main() {
 Person p = new Person();
  p ..name = 'Xq'
     ..sex="nan"
    ..setAge(20);
  print(p);
}
```

### 函数

dart函数声明如果没有显式声明返回值类型时会默认当做`dynamic`处理，注意，函数返回值没有类型推断

```dart
//不指定返回类型，此时默认为dynamic，不是bool
isNoble(int atomicNumber) {
  return _nobleGases[atomicNumber] != null;
}
```

#### 可选参数

命名可选参数和位置可选参数 但两种可选不能同时使用

##### 命名可选参数

命名可选参数使用大括号{}，默认值用冒号

```dart
FunX(a, {b, c:3, d:4, e})
{
  print('$a $b $c $d $e');
}
```

##### 位置可选参数

位置可选参数使用方括号[]，默认值用等号=

```dart
FunY(a, [b, c=3, d=4, e])
{
  print('$a $b $c $d $e');
}
```

```dart
void main()
{
  FunX(1, b:3, d:5);
  FunY(1, 3, 5);
}
```

### Future

`Future`与JavaScript中的`Promise`非常相似，表示一个异步操作的最终完成（或失败）及其结果值的表示。简单来说，它就是用于处理异步操作的，异步处理成功了就执行成功的操作，异步处理失败了就捕获错误或者停止后续操作。一个Future只会对应一个结果，要么成功，要么失败。

请记住，`Future` 的所有API的返回值仍然是一个`Future`对象，所以可以很方便的进行链式调用。

#### then

```dart
Future.delayed(new Duration(seconds: 2),(){
   return "hi world!";
}).then((data){
   print(data);
});
```

#### catchError

```dart
Future.delayed(new Duration(seconds: 2),(){
   //return "hi world!";
   throw AssertionError("Error");  
}).then((data){
   //执行成功会走到这里  
   print("success");
}).catchError((e){
   //执行失败会走到这里  
   print(e);
});

// 但是，并不是只有 catchError回调才能捕获错误，then方法还有一个可选参数onError，我们也可以它来捕获异常：

Future.delayed(new Duration(seconds: 2), () {
    //return "hi world!";
    throw AssertionError("Error");
}).then((data) {
    print("success");
}, onError: (e) {
    print(e);
});
```

#### whenComplete

```dart
Future.delayed(new Duration(seconds: 2),(){
   //return "hi world!";
   throw AssertionError("Error");
}).then((data){
   //执行成功会走到这里 
   print(data);
}).catchError((e){
   //执行失败会走到这里   
   print(e);
}).whenComplete((){
   //无论成功或失败都会走到这里
});
```

#### wait

它接受一个`Future`数组参数，只有数组中所有`Future`都执行成功后，才会触发`then`的成功回调，只要有一个`Future`执行失败，就会触发错误回调。

```dart
Future.wait([
  // 2秒后返回结果  
  Future.delayed(new Duration(seconds: 2), () {
    return "hello";
  }),
  // 4秒后返回结果  
  Future.delayed(new Duration(seconds: 4), () {
    return " world";
  })
]).then((results){
  print(results[0]+results[1]);
}).catchError((e){
  print(e);
});
```

#### 回调地狱

```dart
//先分别定义各个异步任务
Future<String> login(String userName, String pwd){
    ...
    //用户登录
};
Future<String> getUserInfo(String id){
    ...
    //获取用户信息 
};
Future saveUserInfo(String userInfo){
    ...
    // 保存用户信息 
};

login("alice","******").then((id){
 //登录成功后通过，id获取用户信息    
 getUserInfo(id).then((userInfo){
    //获取用户信息后保存 
    saveUserInfo(userInfo).then((){
       //保存用户信息，接下来执行其它操作
        ...
    });
  });
})
```

#### 使用Future消除

```dart
login("alice","******").then((id){
      return getUserInfo(id);
}).then((userInfo){
    return saveUserInfo(userInfo);
}).then((e){
   //执行接下来的操作 
}).catchError((e){
  //错误处理  
  print(e);
});
```

#### 使用async/await消除

```dart
task() async {
   try{
    String id = await login("alice","******");
    String userInfo = await getUserInfo(id);
    await saveUserInfo(userInfo);
    //执行接下来的操作   
   } catch(e){
    //错误处理   
    print(e);   
   }  
}
```

### Stream

`Stream` 也是用于接收异步事件数据，和`Future` 不同的是，它可以接收多个异步操作的结果（成功或失败）。 也就是说，在执行异步任务时，可以通过多次触发成功或失败事件来传递结果数据或错误异常。 `Stream` 常用于会多次读取数据的异步任务场景，如网络内容下载、文件读写等。

```dart
Stream.fromFutures([
  // 1秒后返回结果
  Future.delayed(new Duration(seconds: 1), () {
    return "hello 1";
  }),
  // 抛出一个异常
  Future.delayed(new Duration(seconds: 2),(){
    throw AssertionError("Error");
  }),
  // 3秒后返回结果
  Future.delayed(new Duration(seconds: 3), () {
    return "hello 3";
  })
]).listen((data){
   print(data);
}, onError: (e){
   print(e.message);
},onDone: (){

});

// hello 1
// Error
// hello 3
```

