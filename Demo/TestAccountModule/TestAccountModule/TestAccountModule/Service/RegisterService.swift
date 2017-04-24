//
//  RegisterService.swift
//  TestAccountModule
//
//  Created by 周凌宇 on 2017/4/24.
//  Copyright © 2017年 周凌宇. All rights reserved.
//

import UIKit

class RegisterService: NSObject {
    static func register(username: String, password: String, complete: (Error?) -> Void) {
        print("register success")
        complete(nil)
    }
}
