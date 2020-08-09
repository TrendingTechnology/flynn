
import XCTest

@testable import Flynn

class Counter: Actor, Timerable {
    private var counter: Int = 0

    private func apply(_ value: Int) {
        counter += value
    }

    private func _beTimerFired(_ timer: Flynn.Timer, _ args: TimerArgs) {
        counter += args[x:0]
    }

    private func _beHello(_ string: String) {
        print("hello world from " + string)
    }

    private func _beInc(_ value: Int) {
        self.apply(value)
    }
    private func _beDec(_ value: Int) {
        self.apply(-value)
    }
    private func _beEquals(_ callback: @escaping ((Int) -> Void)) {
        callback(self.counter)
    }
}


// MARK: - Autogenerated by FlynnLint
// Contents of file after this marker will be overwritten as needed

extension Counter {

    @discardableResult
    public func beTimerFired(_ timer: Flynn.Timer, _ args: TimerArgs) -> Self {
        unsafeSend { self._beTimerFired(timer, args) }
        return self
    }
    @discardableResult
    public func beHello(_ string: String) -> Self {
        unsafeSend { self._beHello(string) }
        return self
    }
    @discardableResult
    public func beInc(_ value: Int) -> Self {
        unsafeSend { self._beInc(value) }
        return self
    }
    @discardableResult
    public func beDec(_ value: Int) -> Self {
        unsafeSend { self._beDec(value) }
        return self
    }
    @discardableResult
    public func beEquals(_ callback: @escaping ((Int) -> Void)) -> Self {
        unsafeSend { self._beEquals(callback) }
        return self
    }

}
