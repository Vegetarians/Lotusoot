//
//  ViewController.swift
//  DemoProject
//
//  Created by 周凌宇 on 2017/5/25.
//  Copyright © 2017年 周凌宇. All rights reserved.
//

import UIKit
import ZLYPublicModule

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // --------- 服务调用 ---------

        // 1. 模块间调用服务
        let lotus = s(AccountLotus.self) // or lotus = kAccountLotus，但需要你管理好 kAccountLotus，尽量不要硬编码
        let accountModule: AccountLotus = LotusootCoordinator.lotusoot(lotus: lotus) as! AccountLotus
        accountModule.login(username: "zhoulingyu", password: "wow") { (error) in
            print(error ?? "")
        }

        // 2. 模块内调用服务
        // 模块内的服务注册在 AppDelegate 中可以手动注册
        // 当然，模块内不通过 Lotusoot 也可以，为了规范统一，也可以要求按照 Lotusoot 规则注册

        let mainModule: MainLotus = LotusootCoordinator.lotusoot(lotus: kMainLotus) as! MainLotus
        mainModule.method1()

        // --------- 页面短链调用 ---------

        let error: NSError? = LotusootRouter.register(route: "newproj://account/login") { (lotusootURL) in
            // 这里作为演示传入 nav 作为跳转，不推荐使用
            accountModule.showLoginVC(username: "admin", password: "wow")
            print(lotusootURL.params ?? "")
        }
        print(error ?? "")

        // ✅推荐用法
        let param: Dictionary = ["username" : "admin",
                                 "password" : "wow"]
        LotusootRouter.open(route: "newproj://account/login", params: param).completion { (error) in
            print(error ?? "open success")
        }

        // ⚠️不推荐的用法，用 ?pram0=xxx 这样的形式导致字符串散落在各处，不易管理
        // 但为了保证 Hybrid 项目中 H5 页面的正常跳转，提供了此种调用
        LotusootRouter.open(url: "newproj://account/login?username=zhoulingyu").completion { (error) in
            print(error ?? "open success")
        }

    }
}

