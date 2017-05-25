
# Lotusoot

![](res/Lotusoot-logo.png)

![](https://img.shields.io/badge/language-swift-orange.svg) ![](https://img.shields.io/cocoapods/l/Lotusoot.svg?style=flat) ![](https://img.shields.io/cocoapods/v/Lotusoot.svg?style=flat) [![](https://img.shields.io/badge/weibo-@小鱼周凌宇-red.svg)](http://weibo.com/coderfish)

Lotusoot is a router tool and a decoupling tool of modular project.

> [中文介绍](README_CN.md)

## Installtion

```
pod 'Lotusoot'
```

## How to use

### 1. Configuration

1. In Xcode: Click on your project in the file list, choose your target under `TARGETS`, click the `Build Phases` tab and add a New Run Script Phase by clicking the little plus icon in the top left
2. Drag the new Run Script phase **above** the Compile Sources phase and **below** `Check Pods Manifest.lock`, expand it and paste the following script:

![](res/Lotusoot-01.png)

```bash
python ${PODS_ROOT}/Lotusoot/Lotusoot/Lotusoot.py ${SRC_ROOT} ${SRCROOT} Lotusoot
# parameter1： scan path
# parameter2： ${SRCROOT}, output path of Lotusoot.plist
# parameter3： suffix of Lotusoot(Can bes omited), Omit leads to script execution time
```

3. Build your project, in Finder you will now see a `Lotusoot.plist` in the `$SRCROOT-folder`, add `Lotusoot.plist` into your project and **uncheck Copy items if needed**

> Tip: Add the `Lotusoot.plist` to your .gitignore file to prevent unnecessary conflicts.

### 2. Use

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // register all routes
    LotusootCoordinator.registerAll()
    return true
}
```

1. Call a service

```swift

let lotus = s(AccountLotus.self) 
let accountModule: AccountLotus = LotusootCoordinator.lotusoot(lotus: lotus) as! AccountLotus
accountModule.login(username: "admin", password: "wow") { (error) in
    print(error ?? "")
}
```

2. Register a router

```swift 
let error: NSError? = LotusootRouter.register(route: "newproj://account/login") { (lotusootURL) in
    accountModule.showLoginVC(username: "admin", password: "wow")
}
```

3. Open an URL

```swift
let param: Dictionary = ["username" : "admin",
                                 "password" : "wow"]

// no call back                                 
LotusootRouter.open(route: "newproj://account/login", params: param)
// has call back
LotusootRouter.open(route: "newproj://account/login", params: param).completion { (error) in
    print(error ?? "open success")
}
```

```

// ⚠️Not recommanded, use ?pram0=xxx lead to mismanagement
// This method just for H5 page of Hybrid project
LotusootRouter.open(url: "newproj://account/login?username=zhoulingyu").completion { (error) in
    print(error ?? "open success")
}
```

### 3. Annotation and Suggest

Good usage example of `Lotusoot`：

1. Create `Public module`, where it defines `Lotus` protocol for all modules. A `Lotus` protocol defines all the functionality that open to other modules。For Example：

```swift
public protocol AccountLotus {
    func login(username: String, password: String, complete: (Error?) -> Void)
    func register(username: String, password: String, complete: (Error?) -> Void)
    func email(username: String) -> String
    func showLoginVC(username: String, password: String)
}
```

2. Implement the `Lotus` protocol you have defined in `Public Module`, you can call it `Lotusoot`. In `Lotusoot`, you must add Annotation for current `Lotusoot`, include: `NameSpace-@NameSpace`, `Lotusoot-@Lotusoot`, `Lotus-@Lotus`:


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
        print("show login view controller")
    }
}
```

> `Lotusoot` **MUST**  inherit from `NSObject`

3. In your main project `import Lotusoot`、`import ModulePublic`.  You are free to call all the service and routers now

> Tip: You can refer [Demo](Demo) -> [NewProject](Demo/NewProject)
> 
## Demo

[Demo 工程](Demo/DemoProject)，Please do not forget build every `Scheme` first.

## TO DO

- [ ] Fetch router dynamically
- [ ] Unified way of viewcontroller jump
- [ ] Custom Animation

## License

`Lotusoot` Use [MIT License](LICENSE)

