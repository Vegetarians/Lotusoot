//
//  String+URLVerify.swift
//  Pods
//
//  Created by 周凌宇 on 2017/5/1.
//
//

import UIKit

public extension String {
    init<Subject>(_ instance: Subject) {
        self.init(describing: instance)
    }
}

/// 通过 Subject 快速获取字符串
///
/// - Parameter instance: Subject
/// - Returns: Subject 名
public func s<Subject>(_ instance: Subject) -> String {
    return String(instance)
}
