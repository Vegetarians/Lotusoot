//
//  MainLotusoot.swift
//  DemoProject
//
//  Created by 周凌宇 on 2017/4/30.
//  Copyright © 2017年 周凌宇. All rights reserved.
//  实现对外公布的接口，使外部能够调用到组件内功能

import UIKit

// @NameSpace(DemoProject)
// @Lotusoot(MainLotusoot)
// @Lotus(MainLotus)
class MainLotusoot: NSObject, MainLotus {
    func method1() {
        print("method1")
    }
    func method2() {
        print("method2")
    }
}
