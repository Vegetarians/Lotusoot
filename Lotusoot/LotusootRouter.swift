//
//  LotusootRouter.swift
//  Pods
//
//  Created by 周凌宇 on 2017/5/1.
//
//

import UIKit

@objc public enum RouterError: Int {
    case RouteInvalid
    case Route404
    case URLInvalid
    case URL404
    case Unmatch
    
    public static let domain = "LotusootRouterErrorDomain"
    
    func error() -> NSError {
        switch self {
        case .RouteInvalid:
            return self.error(info: "Route illegal")
        case .Route404:
            return self.error(info: "Route is illegal or not registration")
        case .URLInvalid:
            return self.error(info: "url invalid")
        case .URL404:
            return self.error(info: "can not open")
        case .Unmatch:
            return self.error(info: "No match for the results")
        }
    }
    
    /// 给定 userInfo 生成 NSError
    func error(info: String) -> NSError {
        let error: NSError = NSError(domain:RouterError.domain,
                                     code: self.rawValue,
                                     userInfo: [NSLocalizedDescriptionKey : info])
        return error
    }
}

@objc public class LotusootRouter: NSObject {
    public typealias CompletionHandler = (NSError?) -> ()
    @objc static let syncQueue: DispatchQueue = DispatchQueue(label: "com.zhoulingyu.lotusoot.syncQueue", attributes: .concurrent)
    @objc public static let sharedInstance = LotusootRouter()
    @objc public var error: NSError?
    
    
    // TODO： 不能暴露，保证写才走啊偶
    private var routeMap: Dictionary<String, (LotusootURL) -> ()> = Dictionary<String, (LotusootURL) -> ()>()
    
    /// 获取所有注册路由
    static func allRoutes() -> Array<String> {
        return Array(sharedInstance.routeMap.keys)
    }
    
    // MARK: - Public
    
    /// 注册路由
    ///
    /// - Parameters:
    ///   - route: 路由模板
    ///   - handler: open url 回调
    /// - Returns: 错误详情
    @objc public static func register(route: String, handler: @escaping (LotusootURL) -> ()) -> NSError? {
        return self.sharedInstance.add(route: route, handler: handler)
    }
    
    /// 注销路由
    ///
    /// - Parameter route: 路由模板
    @objc public static func deregister(route: String) {
        return self.sharedInstance.remove(route: route)
    }
    
    /// 打开 url，该方法尽量用于 H5 的跳转，要尽量避免在 open url 时让 url 带有过多参数
    ///
    /// - Parameter url: url string，可以带参数，
    /// - Returns: LotusootRouter 实例
    @objc public static func open(url: String)  -> LotusootRouter {
        let router = LotusootRouter()
        guard !url.isEmpty else {
            router.error = RouterError.URLInvalid.error()
            return router
        }
        
        guard let lotusootURL = LotusootURL(url: url) else {
            router.error = RouterError.Route404.error()
            return router
        }
        guard let param = lotusootURL.params as? Dictionary<String, String> else {
            return open(route: lotusootURL.route, params: nil)
            
        }
        return open(route: lotusootURL.route, params: param)
    }
    
    /// open url
    /// 建议用该方法
    ///
    /// - Parameters:
    ///   - route: 路由模板
    ///   - params: 参数字典
    /// - Returns: LotusootRouter 实例
    @discardableResult
    @objc public static func open(route: String, params: Dictionary<String, String>?) -> LotusootRouter {
        let router = LotusootRouter()
        // 通过 url 找到对应 route
        // 防止外部传入 route 有多余字符如 ?param=xxx
        guard let route = LotusootURL.route(url: route) else {
            router.error = RouterError.Route404.error()
            return router
        }
        // 通过 route 找到对应 handler
        guard let handler = sharedInstance.routeMap[route] else {
            router.error = RouterError.Route404.error()
            return router
        }
        guard let lotusootURL = LotusootURL(url: route) else {
            router.error = RouterError.Unmatch.error()
            return router
        }
        
        if params == nil {
            handler(lotusootURL)
            return router
        }
        
        lotusootURL.params = Dictionary<String, String>()
        
        for (key, value) in params! {
            lotusootURL.params![key] = value
        }
        
        handler(lotusootURL)
        return router
    }
    
    @objc public func completion(_ completion: @escaping CompletionHandler) {
        completion(error)
    }
    
    // MARK: - Private
    
    private func add(route: String, handler: @escaping (LotusootURL) -> ()) -> NSError? {
        // 提纯操作，确保传入者没有传入 多余的 query 或者 /
        guard let route = LotusootURL.route(url: route) else {
            return RouterError.RouteInvalid.error()
        }
        guard URL(string: route) != nil else {
            return RouterError.RouteInvalid.error()
        }
        _ = LotusootRouter.syncQueue.sync { [weak self] in
            self?.routeMap.updateValue(handler, forKey: route)
        }
        return nil
    }
    
    private func remove(route: String) {
        _ = LotusootRouter.syncQueue.sync { [weak self] in
            self?.routeMap.removeValue(forKey: route)
        }
    }
    
    private override init() {
        
    }
}
