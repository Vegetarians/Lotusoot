//
//  LoginService.swift
//  TestAccountModule
//
//  Created by 周凌宇 on 2017/4/21.
//  Copyright © 2017年 LPD. All rights reserved.
//

import UIKit

class LoginService: NSObject {
    static func login(username: String, password: String, complete: (Error?) -> Void) {
        print("login success")
        complete(nil)
    }
    
    static func validate(username: String, password: String) -> Bool {
        print("login validate success")
        return true
    }
    
}
