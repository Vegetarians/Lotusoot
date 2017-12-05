//
//  AccountLotusoot.swift
//  TestAccountModule
//
//  Created by 周凌宇 on 2017/4/24.
//  Copyright © 2017年 周凌宇. All rights reserved.
//  实现对外公布的接口，使外部能够调用到组件内功能

import UIKit
import ZLYPublicModule

// @NameSpace(ZLYAccountModule)
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
