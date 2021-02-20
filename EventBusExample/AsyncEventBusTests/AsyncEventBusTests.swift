//
//  AsyncEventBusTests.swift
//  AsyncEventBusTests
//
//  Created by ryanhfwang on 2021/2/20.
//  Copyright © 2021 ryanhfwang. All rights reserved.
//

import XCTest
@testable import AsyncEventBus

class AsyncEventBusTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testEventBusReply() throws {
        
        let subscribeTopic: String = "/testTopic"
        let publishTopic: String = "/testTopic"
        let expect: XCTestExpectation = XCTestExpectation.init()

        self.bus.subscribe(topic: subscribeTopic) { (message) in
            message.reply(payload: nil)
        }
        
        self.bus.publish(topic: publishTopic, payload: nil) { (message) in
            expect.fulfill()
        }
        self.wait(for: [expect], timeout: 1)
    }
    
    func testEventBusNotReply() throws {
        
        let subscribeTopic: String = "/testTopic"
        let publishTopic: String = "/testTopic"
        let expect: XCTestExpectation = XCTestExpectation.init()
        expect.isInverted = true
        
        self.bus.subscribe(topic: subscribeTopic) { (message) in
        }
        
        self.bus.publish(topic: publishTopic, payload: nil) { (message) in
            expect.fulfill()
        }
        self.wait(for: [expect], timeout: 1)
    }
    
    func testEventBusReplyDifferentTopic() throws {
        
        let subscribeTopic: String = "/testTopic"
        let publishTopic: String = "/testTopicA"
        let expect: XCTestExpectation = XCTestExpectation.init()
        expect.isInverted = true
        
        self.bus.subscribe(topic: subscribeTopic) { (message) in
            message.reply(payload: nil)
        }
        
        self.bus.publish(topic: publishTopic, payload: nil) { (message) in
            expect.fulfill()
        }
        self.wait(for: [expect], timeout: 1)
    }
    
    
    func testEventBusReplySepcTopic() throws {
        
        let subscribeTopic: String = "/testTopic/#"
        let publishTopic: String = "/testTopic/a"
        let publishTopicShouldReply: String = "/testTopic/b"

        let expectNotCall: XCTestExpectation = XCTestExpectation.init()
        expectNotCall.isInverted = true
        let expectCall: XCTestExpectation = XCTestExpectation.init()
        
        self.bus.subscribe(topic: subscribeTopic) { (message) in
            if message.topic == publishTopicShouldReply {
                message.reply(payload: nil)
            }
        }
        
        self.bus.publish(topic: publishTopic, payload: nil) { (message) in
            expectNotCall.fulfill()
        }
        
        self.bus.publish(topic: publishTopicShouldReply, payload: nil) { (message) in
            expectCall.fulfill()
        }
        self.wait(for: [expectCall, expectNotCall], timeout: 1)
    }
}

