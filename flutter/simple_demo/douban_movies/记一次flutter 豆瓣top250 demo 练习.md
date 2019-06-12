#记一次flutter 豆瓣top250 demo 练习

整体demo仿照[flutter demo](https://limboy.me/tech/2018/12/07/flutter-demo.html)

参照[豆瓣API](https://www.kancloud.cn/movie/doubanapi/1019791) , 因为豆瓣静止申请新的apikey，只能拿别人之前申请的练习

## 目录结构

- lib：按项目整体划分
  - blocs：存放各个业务逻辑的BLoC，类同ViewModel
  - models：存放各个model
  - services：网络层，后续封装的网络层可置放于此，根据demo，也可以在前期添加一层mock数据流，以便更好的前期开发调试
  - widgets：各个页面的组件模块
  - pages：页面模块
  - routes：参照demo的URL注册模块，如果是不需要外部URL跳转到其他页面，其实可以不需要
  - main.dart：主入口，初始化App
  - env.dart：环境配置，当前demo只需要对网络mock和api区分设置，后续可以添加全局变量等配置相关

同理可得，根据模块划分：

- lib
  - main.dart：主入口，初始化App
  - macros：类似全局配置，如全局的文本字体大小、颜色，背景色
  - utils：常用扩展类等功能
  - config：环境配置、App配置等相关(也可以与macro宏全局配置想结合)
  - network：网络层，统一封装的网络层处理
  - module：
    - common：公有模块内容
      - pages：基类page页面
      - widgets：基类组件或者通用组件
      - models：基类model或者通用model
      - blocs：基类bloc或者通用bloc
    - home：首页模块，类似MVVM模式
      - pages：模块下各个页面
      - widgets：模块下各个组件
      - models：模块下各个model
      - blocs：模块下各个bloc
    - mine：我的模块，类似MVVM模式

个人还是喜欢按模块划分目录，也是习惯问题。

但是按此demo先用按项目来划分目录。

## 实施

按此demo已有接口，可以先model，再API，再widgets后pages。

当然一般情况下是先widgets再组合为pages，再根据后端提供的API文档，创建models，再apis，再修改原来的mock逻辑。

### models

书写好各个model，都是单纯的属性定义和model解析。ps：暂不使用json_model处理

### services

可以先mock再API替换测试，所以先定义抽象类，用具体类继承实现，最后替换实现是一种方案。

定义抽象类，定义电影列表和电影详情；再定义具体mock和api来实现相关业务

### blocs

####bloc_base

定义抽象基础bloc，包含关闭流方法，当然具体业务上可以关联更多

#### bloc_provider

定义通过组件的上下文context向上获取组件的继承与bloc_base的bloc实例，具体内容看代码

#### 模块bloc

定义各个组件模块的bloc内容，业务交互都放于此

### widgets

定义界面对应的组件细节内容

### pages

通过widgets组装page，可以根据不同平台(iOS/Android)来做特殊处理

### routes

页面路由注册与跳转处理

### main.dart

主入口初始化，因为用bloc_provider来获取bloc，因而最上层用BlocProvider来嵌套

## 感受

写下来总体感受是对widget组合的不清晰导致业务界面铺的很费力。声明式UI写起来费力，看起来清晰。

bloc和stream配合可以使业务分离。

单纯业务型的话，需要对widget有相当多的积累才能游刃有余。



​	