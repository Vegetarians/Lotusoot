//
//  AccountLotus.swift
//  TestAccountModule
//
//  Created by 周凌宇 on 2017/4/24.
//  Copyright © 2017年 周凌宇. All rights reserved.
//  对外公布 Module 有哪些可掉方法

import UIKit

public let kAccountLotus = "AccountLotus"   // or s(AccountLotus.self) 减少硬编码，使编译可以检测出 error

public protocol AccountLotus {
    func login(username: String, password: String, complete: (Error?) -> Void)
    func register(username: String, password: String, complete: (Error?) -> Void)
    func email(username: String) -> String
    func showLoginVC(username: String, password: String)
}
