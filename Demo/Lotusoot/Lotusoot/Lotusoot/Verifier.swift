//
//  Verifier.swift
//  Lotusoot
//
//  Created by 周凌宇 on 2017/5/25.
//  Copyright © 2017年 周凌宇. All rights reserved.
//

import UIKit

public typealias VerificationType = (() -> Bool)

public class Verifier {

    private var verifications: Array<VerificationType> = Array()
    var handler: Handler = Handler()
    var lastHandler: Handler?

    public init() {

    }

    public func verify() {
        handler.handle()
    }

    @discardableResult
    public func append(verification: @escaping VerificationType) -> Self {
        if let _ = lastHandler {
            let handler = Handler()
            handler.verification = verification
            self.lastHandler!.successor = handler
            self.lastHandler = handler
        } else {
            handler.verification = verification
            lastHandler = handler
        }
        return self
    }
}

public class Handler {
    public var successor: Handler?
    public var verification: VerificationType?

    public func handlerRequest(condition: VerificationType) {
        let result: Bool = condition()
        if result {
            print("ConcreteHandler passed")
            self.successor?.handle()
        } else {
            print("ConcreteHandler not passed")
        }
    }

    public func handle() {
        if let verification = verification {
            handlerRequest(condition: verification)
        }
    }
}
