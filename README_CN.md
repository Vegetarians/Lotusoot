# Lotusoot 

![](res/Lotusoot-logo.png)

![](https://img.shields.io/badge/language-swift-orange.svg) ![](https://img.shields.io/cocoapods/l/Lotusoot.svg?style=flat) ![](https://img.shields.io/cocoapods/v/Lotusoot.svg?style=flat) [![](https://img.shields.io/badge/weibo-@小鱼周凌宇-red.svg)](http://weibo.com/coderfish)

Swift 路由和模块通信解耦工具和规范。
可以让模块间无耦合的调用服务、页面跳转。

> [English Introduction](README.md)

## 安装

```
pod 'Lotusoot'
```

## 使用

```
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // 通过 Build 阶段自动生成的 Lotusoot.plist 注册
    LotusootCoordinator.registerAll()
    return true
}
```

### 1. 配置

1. 在 Xcode 中点击工程，选择你的 `Target`，点击 `Buid Phases`，添加 `New Run Script Phase`
2. 将新建的 `Run Script` 拖拽至 `Compile Sources` 上方、`Check Pods Manifest.lock` 下方，并填入以下脚本：

![](res/Lotusoot-01.png)

```bash
python ${PODS_ROOT}/Lotusoot/Lotusoot/Lotusoot.py ${SRC_ROOT} ${SRCROOT} Lotusoot
# 参数1： 扫描路径
# 参数2： ${SRCROOT}，Lotusoot.plist 输出地址
# 参数3： Lotusoot 命名后缀（可省略），省略将会导致脚本执行时间变长
```

3. 编译你的工程，在 Finder 中可以看到，工程目录下生成了 `Lotusoot.plist`，将其拖入工程中，`不要选择 Copy items if needed `。

> Tip: 可以将 `Lotusoot.plist` 放入 `.gitignore` 文件避免不要的冲突。

### 2. 调用

1. 服务调用

```swift
let lotus = s(AccountLotus.self) 
let accountModule: AccountLotus = LotusootCoordinator.lotusoot(lotus: lotus) as! AccountLotus
accountModule.login(username: "admin", password: "wow") { (error) in
    print(error ?? "")
}
```

2. 短链注册

```swift 
let error: NSError? = LotusootRouter.register(route: "newproj://account/login") { (lotusootURL) in
    accountModule.showLoginVC(username: "admin", password: "wow")
}
```

3. 短链调用

```swift
let param: Dictionary = ["username" : "admin",
                                 "password" : "wow"]

// 无回调                                 
LotusootRouter.open(route: "newproj://account/login", params: param)
// 有回调
LotusootRouter.open(route: "newproj://account/login", params: param).completion { (error) in
    print(error ?? "open success")
}
```

```swift
// ⚠️不推荐的用法，用 ?pram0=xxx 这样的形式导致字符串散落在各处，不易管理。
// 但为了保证 Hybrid 项目中 H5 页面的正常跳转，提供了此种调用
LotusootRouter.open(url: "newproj://account/login?username=zhoulingyu").completion { (error) in
    print(error ?? "open success")
}
```

### 3. 注解与规范

`Lotusoot` 的常规用法用例是：

1. 建立 `共用模块`，`共用模块` 中定义了各个模块的 `Lotus`，一个 `Lotus` 协议包含了一个模块的所有的能调用的方法的列表。举例如下：

```swift
public protocol AccountLotus {
    func login(username: String, password: String, complete: (Error?) -> Void)
    func register(username: String, password: String, complete: (Error?) -> Void)
    func email(username: String) -> String
    func showLoginVC(username: String, password: String)
}
```

2. 各个模块中，包含了一个实现 `公共模块` 中对应的 `Lotus`，称为 `Lotusoot`。`Lotusoot` 中具体实现了服务的逻辑，并在 `注解` 中表明了模块的 `命名空间-@NameSpace`、`Lotusoot-@Lotusoot``Lotus-@Lotus`。举例如下：

```swift
// @NameSpace(TestAccountModule)
// @Lotusoot(AccountLotusoot)
// @Lotus(AccountLotus)
class AccountLotusoot: NSObject, AccountLotus {
    
    func email(username: String) -> String {
        return OtherService.email(username: "zhoulingyu")
    }

    func login(username: String, password: String, complete: (Error?) -> Void) {
        LoginService.login(username: username, password: password, complete: complete)
    }
    
    func register(username: String, password: String, complete: (Error?) -> Void) {
        RegisterService.register(username: username, password: password, complete: complete)
    }
    
    func showLoginVC(username: String, password: String) {
        // 可以用你们喜欢的非耦合方式处理跳转
        // 或者传入 rootvc
        // 更好的方式是自己的非耦合 UI 跳转处理模块
        print("show login view controller")
    }
}
```

> Tip: 由于 Swift 的一些限制，目前 `Lotusoot` 必须继承 `NSObject`

3. 在主工程中 `import Lotusoot`、`import ModulePublic` 调用服务和路由。

> Tip: 具体可以查看 [Demo](Demo) -> [DemoProject](Demo/DemoProject)

## Demo

在这里查看 [Demo 工程](Demo/DemoProject)，请记得先编译各个 Scheme。

## TO DO

- [ ] 路由动态下发
- [ ] 根页面保存及统一跳转工具
- [ ] 自定义动画支持

## License

`Lotusoot` 使用 [MIT License](LICENSE)



