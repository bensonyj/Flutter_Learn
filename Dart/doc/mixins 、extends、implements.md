## mixins 、extends、implements

[Flutter Dart mixins 探究](https://juejin.im/post/5c44382d51882523f0261bb5)

[Flutter Dart语法(1):extends 、 implements 、 with的用法与区别](https://juejin.im/post/5c4881dae51d45098e4d96cf)

1. 继承（关键字 extends）
2. 混入 mixins （关键字 with）
3. 接口实现（关键字 implements）

extends -> mixins -> implements

### extends

用关键词`extends`

1. Flutter中的继承是单继承
2. 构造函数不能继承
3. 子类重写超类的方法，要用`@override`
4. 子类调用超类的方法，要用`super`

###mixins

用关键词`with`

在面向对象的语言中,mixins类是一个可以把自己的方法提供给其他类使用，但却不需要成为其他类的父类。



### implements

关键词`implements`

