//
//  EventBusProtocol.swift
//  EventBusExample
//
//  Created by ryanhfwang on 2020/8/11.
//  Copyright © 2020 ryanhfwang. All rights reserved.
//

import Foundation

typealias EventHandleBlock = (BusMessageRepresentable) -> Void


///用于取消订阅
@objc protocol SubscribeDisposable {
    var topic: String { get }
    var handler: EventHandleBlock? {get }
    
    @objc(unsubscribe)
    func unsubscribe();
}

@objc protocol BusRepresentable {
    
    /// SUBSCRIBE
    /// 返回的subscriber可用于取消订阅
    @discardableResult
    @objc(subscribeTopic: action:)
    func subscribe(topic: String, handler:@escaping EventHandleBlock) -> SubscribeDisposable
    
    
    ///PUBLISH
    @objc(publishTopic:)
    func publish(topic: String)
    
    @objc(publishTopic: payload:)
    func publish(topic: String, payload: Any? )
    
    @objc(publishTopic: payload: replyHandler:)
    func publish(topic: String, payload: Any?, replyHandler: @escaping EventHandleBlock)
}

@objc protocol BusMessageRepresentable {
    var topic: String { get }
    var payload: Any? { get }
    func reply(payload: Any?)
}
