## iOS 混编flutter

在处理混编之前先查阅了相关资料。总体来说都是pod集成。

一种是[官网](https://github.com/flutter/flutter/wiki/Add-Flutter-to-existing-apps#experiment-turn-the-flutter-project-into-a-module)的混编，但是侵入性比较强，而且多人开发的话要每台机子都有对应flutter环境才行，但是方便调试，因而觉得单人开发比较适合。

另一种就是组件化集成。也就是pod依赖远程私有库，不需要修改原生代码，运行不依赖flutter环境，但是不方便调试，而且每次更新都需要先更新远程私有库。这次就以该为主题演示当时遇到的情况。

通过参考各个文章内容得知，集成flutter，也就是集成对应编译产物。

###前提

- [x] 本地已有flutter环境，flutter安装看[官网](https://flutter.dev/docs/get-started/install/macos)，注意下环境变量即可
- [x] 开发好对应的flutter module工程或者下载他人开发

### Flutter SDK

####Flutter引擎和业务代码

```shell
# 先用终端跳转到对应flutter module目录中
cd xx/xx/module
# 清理flutter历史编译
{flutter 安装目录}/flutter/bin/flutter clean
# 重新生成plugin索引
{flutter 安装目录}/flutter/bin/flutter packages get
# 生成App.framework和Flutter.framework
{flutter 安装目录}/flutter/bin/flutter build ios --release
```

`cd .ios/`后可以看到

![img_4](/Users/yingjian/Desktop/flutter/file/Flutter_Learn/flutter/doc/iOS_flutter_img/img_4.png)

拷贝出`Flutter/App.framework` 和`Flutter/engine/Flutter.framework` 到pod私有库。

#### 插件

若业务代码中存在插件功能，则看看到`module/build/ios/Release-iphoneos` 有对应静态库文件{plugins_name}.a。

而对应的头文件则在`module/.ios/Pods/`中，具体指`Pods/Header/Public` 各个替身所指向的原身文件。

将对应静态库(.a)和头文件(.h)拷贝至pod私有库中，最后内容如私有库目录所示。

### 远程库

#### 创建远程库

先创建远程仓库，github或者码云或者gitlab创建仓库，然后打开终端创建远程仓库关联

```shell
pod repo add REPO_NAME SOURCE_URL
# REPO_NAME 私人库名称
# SOURCE_URL git地址
# 如下：
pod repo add GTISpec https://192.168.1.1/GTISpecs
```

检查是否安装成功：

```shell
cd ~/.cocoapods/repos/GTISpec
pod repo lint .
# 注意第二个命令后面的 "."不能省。
```

#### 创建pod库

因为打出来的资源都是静态库相关，所以直接创建或者拷贝一个{名称}.podspec，内容如下：

```powershell
Pod::Spec.new do |s|
  s.name             = 'park_flutter_sdk' #名称
  s.version          = '0.3.2'
  s.summary          = 'Flutter 商业模块'
  s.description      = <<-DESC
Flutter provides an easy and productive way to build and deploy high-performance mobile apps for Android and iOS.
                       DESC
  s.homepage         = 'http://192.168.1.215/ios_fluttersdk' # git所在地址即可
  s.license          = { :type => 'MIT' }
  s.author           = { 'xx' => 'xx' }
  s.source           = { :git => "http://192.168.1.215/ios_fluttersdk.git", :tag => s.version.to_s } # git 所在地址
  s.ios.deployment_target = '9.0'
  s.static_framework = true
  # Flutter.framework：flutter的引擎库，App.framework：Dart业务代码
  s.vendored_frameworks = 'Framework/*.framework', 'Framework/engine/*.framework' 
  # Flutter plugins：以静态库形式添加，与.h文件存放一起
  s.vendored_libraries = ['plugins/FlutterPluginRegistrant/libFlutterPluginRegistrant.a', 
    'plugins/FMDB/libFMDB.a', 'plugins/path_provider/libpath_provider.a', 'plugins/sqflite/libsqflite.a']
  s.source_files = 'plugins/**/*.{h,m}'
  s.public_header_files = 'plugins/**/*.h'
end
```

目录如下：

![总目录](/Users/yingjian/Desktop/flutter/file/Flutter_Learn/flutter/doc/iOS_flutter_img/img_1.png)

![Framework——flutter相关库](/Users/yingjian/Desktop/flutter/file/Flutter_Learn/flutter/doc/iOS_flutter_img/img_2.png)

![plugins_插件相关](/Users/yingjian/Desktop/flutter/file/Flutter_Learn/flutter/doc/iOS_flutter_img/img_3.png)

#### 验证仓库

```shell
pob lib lint {park_flutter_sdk.podspec} --allow-warnings
```

因为对应podspec中source git为远端仓库，所以需要每次改动都要先提交到远端

```shell
git add .	
git commit -m 'edit'
git push 

#记得打对应version 的 tag
git tag -a {version} -m '{version} tag'
git push origin {version}

#然后再验证
pob lib lint park_flutter_sdk.podspec --allow-warnings
```

如果是想先本地验证的话，修改podspec中source的git为本地文件夹路径，如`/Users/{name}/Desktop/park` ，这样就不用git 提交再验证了。当然本地要是验证通过了，还是要先修改source地址再执行下提交到远程仓库的操作。

提示：

`ERROR | [iOS] unknown: Encountered an unknown error (Could not find a `ios` simulator (valid values: com.apple.coresimulator.simruntime.ios-10-3, com.apple.coresimulator.simruntime.ios-12-1, com.apple.coresimulator.simruntime.ios-8-1, com.apple.coresimulator.simruntime.tvos-12-1, com.apple.coresimulator.simruntime.watchos-5-1). Ensure that Xcode -> Window -> Devices has at least one `ios` simulator listed or otherwise add one.`

遇到此错误时，更新下Cocoapods

```shell
sudo gem install cocoapods 
```

如果报错先查看是否是gem源过期，`https://ruby.taobao.org/` 淘宝源已在2018.11月过期，使用` https://gems.ruby-china.com/`。

```shell
#查看当前用的镜像
gem source -l
#若有https://ruby.taobao.org/，删除原有镜像
gem sources --remove https://ruby.taobao.org/
# 增加新的镜像
gem sources -a https://gems.ruby-china.com/
# 升级 Cocoapods
sudo gem install -n /usr/local/bin cocoapods --pre
# 再查看下Cocoapods 版本是否大于1.5
pod --version #2019.6.6 version：1.7.1
```

#### 提交到私有远程库

```shell
pod repo push {本地Spec Repo名称} {podspec文件路径}
```

私有库弄好之后，提交到远程私有索引库

```shell
pod repo push GTISpec park_flutter_sdk.podspec --allow-warnings --sources='http://192.168.1.215/ios_fluttersdk, http://192.168.1.215/gtispec'
# sources 为索引库路径和私有库路径
```

提示：

若出现`Your configuration specifies to merge with the ref 'refs/heads/master' from the remote, but no such ref was fetched.` 这是正常的，先`cd ~/.cocoapods/repos/GTISpec`切换到索引库目录中，添加一个文件如readme.md即可，再commit后push即可。

#### 参考

1. [官网](https://guides.cocoapods.org/making/private-cocoapods)
2. [cocoapod创建私有 pods 遇到的问题](https://www.jianshu.com/p/7288685a3ad3)
3. [利用cocoapods创建基于git的私有库Spec Repo](https://www.cnblogs.com/richard-youth/p/6289015.html)
4. [iOS组件化之私有库](https://juejin.im/post/5b87494c51882542e16c0337#heading-8)
5. [CocoaPods 【淘宝源不能用了】](https://blog.csdn.net/felicity294250051/article/details/84168377)

### 集成

#### pod集成

在iOS原生工程中的Podfile中添加如下即可

```shell
source 'https://github.com/CocoaPods/Specs.git'
source 'http://192.168.1.215/gtispec' # 私有索引库
target 'xx' do
 pod 'park_flutter_sdk'
end
```

现在可以直接在Xcode中使用Flutter页面了

#### 使用

```objective-c
// GTIBusinessDetailFlutterViewController 继承FlutterViewController
// 原生跳转至Flutter页面
GTIBusinessDetailFlutterViewController *vc = [[GTIBusinessDetailFlutterViewController alloc] init];
UIView *view = [[UIView alloc] initWithFrame:weakSelf.view.bounds];
view.backgroundColor = [UIColor whiteColor];
vc.splashScreenView = view;
[weakSelf showViewController:vc sender:nil];
```

#### 交互

```objective-c
// pod引入的插件
#import <park_flutter_sdk/GeneratedPluginRegistrant.h>

- (void)viewDidLoad
{
    [super viewDidLoad];
    
  	// 确定跳转的页面
    [self setInitialRoute:@"route2"];
    // 注册Flutter插件
    [GeneratedPluginRegistrant registerWithRegistry:self];
	  // 将原生信息传给flutter
    NSString *eventChannelName = @"com.greentownit.parkmanagement/stream";
    FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:eventChannelName binaryMessenger:self];
    [eventChannel setStreamHandler:self];
	
  	// 原生接收flutter传递的信息
    NSString *methodChannelName = @"com.greentownit.parkmanagement/logout";
    FlutterMethodChannel *methodChannel = [FlutterMethodChannel methodChannelWithName:methodChannelName binaryMessenger:self];
    @weakify(self);
    [methodChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        @strongify(self);
        NSLog(@"flutter send native:\n method = %@, \n arguments = %@", call.method, call.arguments);
        if ([call.method isEqualToString:@"finishNative"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - FlutterStreamHandler

- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    return nil;
}

- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(nonnull FlutterEventSink)events {
    NSLog(@"onListenWithArguments: %@", arguments);
    if (events) {
        NSString *message = @"somethings";
        NSLog(@"native send flutter : %@", message);
        events(message);
    }
    
    return nil;
}
```

#### 内存泄露

直接跳转FlutterViewController，会直接创建flutter引擎，待续。

[如何进一步提高flutter内存表现](https://juejin.im/post/5bbec3d15188255c4322bbee#heading-9)

[手把手教你解决 Flutter engine 内存泄漏](https://juejin.im/post/5c24ad306fb9a049d2361cff?spm=a2c4e.11153987.0.0.3f9147e0HZ0ZQq#heading-7)



#### 原生页面跳转Flutter页面显示启动图

可以设置`splashScreenView  ` 或者继承 `FlutterViewController` 重写 `- (BOOL)loadDefaultSplashScreenView`  。

#### 插件静态库.a architecture x86_64 问题

可以参照闲鱼插件打包为静态库方式，合并architecture。（打出的release只支持真机调试，模拟器会报x86_64错误）

```shell
echo "===生成各个plugin的二进制库文件==="
#cd ios/Pods
#/usr/bin/env xcrun xcodebuild clean
#/usr/bin/env xcrun xcodebuild build -configuration Release ARCHS='arm64 armv7' BUILD_AOT_ONLY=YES VERBOSE_SCRIPT_LOGGING=YES -workspace Runner.xcworkspace -scheme Runner BUILD_DIR=../build/ios -sdk iphoneos
for plugin_name in ${plugin_arr} #// 插件集合
do
    echo "生成lib${plugin_name}.a..."
    /usr/bin/env xcrun xcodebuild build -configuration Release ARCHS='arm64 armv7' -target ${plugin_name} BUILD_DIR=../../build/ios -sdk iphoneos -quiet
    /usr/bin/env xcrun xcodebuild build -configuration Debug ARCHS='x86_64' -target ${plugin_name} BUILD_DIR=../../build/ios -sdk iphonesimulator -quiet
    echo "合并lib${plugin_name}.a..."
    lipo -create "../../build/ios/Debug-iphonesimulator/${plugin_name}/lib${plugin_name}.a" "../../build/ios/Release-iphoneos/${plugin_name}/lib${plugin_name}.a" -o "../../build/ios/Release-iphoneos/${plugin_name}/lib${plugin_name}.a"
done
```

此时可以运行模拟器，但是会报以下错误且界面为空白

```bash
[VERBOSE-2:engine.cc(117)] Engine run configuration was invalid.
[VERBOSE-2:FlutterEngine.mm(308)] Could not launch engine with configuration.
```

其实也是x86问题，按[Flutter混合开发组件化与工程化架构]([http://zhengxiaoyong.com/2018/12/16/Flutter%E6%B7%B7%E5%90%88%E5%BC%80%E5%8F%91%E7%BB%84%E4%BB%B6%E5%8C%96%E4%B8%8E%E5%B7%A5%E7%A8%8B%E5%8C%96%E6%9E%B6%E6%9E%84/](http://zhengxiaoyong.com/2018/12/16/Flutter混合开发组件化与工程化架构/)) 通过`build ios --debug --simulator`的模拟器产物（x86）与`build ios --release`的Release产物进行合成的，这样一来本地构建的Debug包既支持真机也支持模拟器，同时支持x86与arm。



### 参考

1. [官网：Add Flutter to existing apps](https://github.com/flutter/flutter/wiki/Add-Flutter-to-existing-apps)
2. [闲鱼flutter混合工程持续集成最佳实践](https://www.yuque.com/xytech/flutter/pfoy9x)
3. [Flutter新锐专家之路：混合开发篇](https://juejin.im/post/5b764acb51882532dc1812b1)
4. [Flutter 开发 （2）优雅的 Flutter 组件化 混编方案](https://www.jianshu.com/p/969aa7e37827)
5. [iOS Native混编Flutter交互实践](https://juejin.im/post/5bb033515188255c5e66f500?hmsr=joyk.com&utm_source=joyk.com&utm_medium=referral#heading-4)
6. [Flutter混合开发组件化与工程化架构]([http://zhengxiaoyong.com/2018/12/16/Flutter%E6%B7%B7%E5%90%88%E5%BC%80%E5%8F%91%E7%BB%84%E4%BB%B6%E5%8C%96%E4%B8%8E%E5%B7%A5%E7%A8%8B%E5%8C%96%E6%9E%B6%E6%9E%84/](http://zhengxiaoyong.com/2018/12/16/Flutter混合开发组件化与工程化架构/))
7. [Flutter iOS混编方案](https://www.jianshu.com/p/c7d303cde221)
8. [Flutter 实现原理及在马蜂窝的跨平台开发实践](https://mp.weixin.qq.com/s/WBnj_6sOonjR9XUnB-wZPA)
9. [Flutter混编之路——iOS踩坑记录](https://www.jianshu.com/p/bf3002de6a5e)

