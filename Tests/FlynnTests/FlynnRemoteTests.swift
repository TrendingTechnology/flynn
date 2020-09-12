
// swiftlint:disable line_length

import XCTest

@testable import Flynn

class Echo: RemoteActor {
    private func _bePrint(_ string: String) {
        print("from master: '\(string)'")
    }
    
    private func _beToLower(_ string: String) -> String {
        return string.lowercased()
    }
}

// TODO: FlynnLint will need to be able to autogenerate this...
// FlynnLint needs to be smart enough to autogenerate two things:
// 1. A behavior without a return value
//    This kind of behavior only needs to serialize arguments and send
// 2. A behavior with a return value
//    This kind of behavior needs to serialize arguments, send, but also call a
//    closure on a receiving actor (sender and closure get added as last two arguments
//    on the external behavior.
extension Echo {
    
    public func bePrint(_ string: String) {
        struct Message: Codable {
            let arg0: String
        }
        let msg = Message(arg0: string)
        if let data = try? JSONEncoder().encode(msg) {
            unsafeSendToRemote("Echo", data, nil, nil)
        }else{
            fatalError()
        }
    }
    
    public func beToLower(_ string: String, _ sender: Actor, _ callback: @escaping () -> Void) {
        struct Message: Codable {
            let arg0: String
        }
        let msg = Message(arg0: string)
        if let data = try? JSONEncoder().encode(msg) {
            unsafeSendToRemote("Echo", data, sender, callback)
        }else{
            fatalError()
        }
    }
}

class FlynnRemoteTests: XCTestCase {
    
    override func setUp() {
        Flynn.startup()
        
        Flynn.master("0.0.0.0", 9875)
        Flynn.slave("127.0.0.1", 9875)
    }

    override func tearDown() {
        Flynn.shutdown()
    }

    func testSimpleRemote() {
        let expectation = XCTestExpectation(description: "RemoteActor is run and prints message")
        
        let hw = Echo()
        hw.bePrint("Hello Remote Actor!")
        
        print("A")
        let start = ProcessInfo.processInfo.systemUptime
        while (ProcessInfo.processInfo.systemUptime - start) < 60 { }
        print("B")
        
        expectation.fulfill()
    }

    static var allTests = [
        ("testSimpleRemote", testSimpleRemote),
    ]
}
