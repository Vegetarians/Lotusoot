//
//  LotusootCoordinator.swift
//  LPDBusiness
//
//  Created by 周凌宇 on 2017/4/21.
//  Copyright © 2017年 LPD. All rights reserved.
//

import UIKit

public class LotusootCoordinator: NSObject {
    public static let sharedInstance = LotusootCoordinator()
    
    // lotus（协议） 和 lotusoot（实现） 表
    var lotusootMap: Dictionary = Dictionary<String, Any>()
    
    private override init() {
    }
    
    /// 注册 Lotus 和 Lotusoot
    ///
    /// - Parameters:
    ///   - lotusoot: lotusoot 对象。自动注册的 lotusoot 都必须是集成 NSObject，手动注册不做限制
    ///   - lotusName: lotus 协议名
    public static func register(lotusoot: Any, lotusName: String) {
        sharedInstance.lotusootMap.updateValue(lotusoot, forKey: lotusName)
    }
    
    /// 通过 lotus 名称 获取 lotusoot 实例
    ///
    /// - Parameter lotus: lotus 协议名
    /// - Returns: lotusoot 对象
    public static func lotusoot(lotus: String) -> Any? {
        return sharedInstance.lotusootMap[lotus]
    }
    
    /// 注册所有的 lotusoot
    ///
    /// - Parameter serviceMap: 自定义传入的字典
    public static func registerAll(serviceMap: Dictionary<String, String>) {
        for (lotus, lotusootName) in serviceMap {
            let classStringName = lotusootName
            
            let classType = NSClassFromString(classStringName) as? NSObject.Type
            
            if let type = classType {
                let lotusoot = type.init()
                register(lotusoot: lotusoot, lotusName: lotus)
            }
        }
    }
    
    /// 注册所有的 lotusoot
    /// 使用默认生成的 Lotusoot.plist
    public static func registerAll() {
        let lotusPlistPath = Bundle.main.path(forResource: "Lotusoot", ofType: "plist")
        if let lotusPlistPath = lotusPlistPath {
            let map = NSDictionary(contentsOfFile: lotusPlistPath)
            registerAll(serviceMap: map as! Dictionary<String, String>)
        }
    }
}
