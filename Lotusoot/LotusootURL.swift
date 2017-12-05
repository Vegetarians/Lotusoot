//
//  LotusootURL.swift
//  Pods
//
//  Created by 周凌宇 on 2017/5/1.
//
//

import UIKit

@objc public class LotusootURL: NSObject {
    // 使用的 URLSTR 类似 scheme://module/page?param0=xxx&param1=xxx
    // 下面的参数将以
    // myproj://account/login
    // 为例做说明
    
    /// 模板，类似 myproj://account/login
    @objc public var route: String
    /// 保存 param 和其内容的对应关系
    @objc public var params: Dictionary<String, Any>?
    
    @objc public init?(route: String, url: String) {
        // 验证合法性
        guard URL(string: route) != nil else {
            return nil
        }
        // 验证匹配性
        guard let routeOfUrlStr = LotusootURL.route(url: url) else {
            return nil
        }
        guard routeOfUrlStr == route else {
            return nil
        }
        // 设置各个参数
        self.route = route
        self.params = LotusootURL.params(url: url)
    }
    
    @objc convenience public init?(url: String) {
        guard let route = LotusootURL.route(url: url) else {
            return nil
        }
        self.init(route: route, url: url)
    }
    
    /// url 路由解析
    ///
    /// - Parameter url: url string
    /// - Returns: 路由模板
    @objc public static func route(url: String) -> String? {
        guard let u = URL(string: url) else {
            return nil
        }
        let query = u.query ?? ""
        var route = url.replacingOccurrences(of: query, with: "")
        route = route.replacingOccurrences(of: "?", with: "")
        if route.hasSuffix("/") {
            var characterSet = CharacterSet()
            characterSet.insert(charactersIn: "/")
            route = route.trimmingCharacters(in: characterSet)
        }
        return route
    }
    
    /// url 参数解析
    ///
    /// - Parameter url: url string
    /// - Returns: 参数字典
    @objc public static func params(url: String) -> Dictionary<String, String>? {
        let u = URL(string: url)
        guard let query = u?.query else {
            return nil
        }
        var params: Dictionary<String, String> = Dictionary()
        let sections: Array = query.components(separatedBy: "&")
        for section in sections {
            let equalSignRange: Range? = section.range(of: "=")
            if let equalSignRange = equalSignRange {
                let key: String = section.substring(to: equalSignRange.lowerBound)
                if key.isEmpty { continue }
                let value = section.substring(from: equalSignRange.upperBound)
                if value.isEmpty { continue }
                params[key] = value
            } else { continue }
        }
        return params
    }
}
