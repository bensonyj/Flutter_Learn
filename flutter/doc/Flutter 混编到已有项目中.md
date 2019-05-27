#Flutter 混编到已有项目中

## [官网](https://github.com/flutter/flutter/wiki/Add-Flutter-to-existing-apps#experiment-turn-the-flutter-project-into-a-module)

1.需修改native代码

2.侵入性很强

### Flutter 开发 （1）iOS 下超详细集成 Flutter

简书上讲解官网案例[例子](https://www.jianshu.com/p/10237bf13789)

### 闲鱼[FlutterBoost](https://github.com/alibaba/flutter_boost/blob/master/README_CN.md)

前置条件：项目中已集成Flutter



## 组件化方案

### Flutter 开发 （2）优雅的 Flutter 组件化 混编方案

维护一个远程库，其他端只需要引用产出物即可，[例子](https://www.jianshu.com/p/969aa7e37827)

### YHFlutterAdapter

三行代码组件化集成 Flutter！可用于已有 iOS 项目，对原工程无侵入，无需更改原项目配置，集成后可直接以组件形式开发 Flutter 业务。

[参考](https://github.com/jiisd/YHFlutterAdapter)