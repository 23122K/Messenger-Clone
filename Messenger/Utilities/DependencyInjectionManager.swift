//
//  DependencyInjectionManager.swift
//  Messenger
//
//  Created by Antoine van der Lee <3
//

import Foundation

public protocol InjectionKey {
    associatedtype Value
    static var currentValue: Self.Value {get set}
}

struct InjectedValues {
    /// This is only used as an accessor to the computed properties within extensions of `InjectedValues`.
    private static var current = InjectedValues()
    
    /// A static subscript for updating the `currentValue` of `InjectionKey` instances.
    static subscript<K>(key: K.Type) -> K.Value where K : InjectionKey {
        get { key.currentValue }
        set { key.currentValue = newValue }
    }
    
    /// A static subscript accessor for updating and references dependencies directly.
    static subscript<T>(_ keyPath: WritableKeyPath<InjectedValues, T>) -> T {
        get { current[keyPath: keyPath] }
        set { current[keyPath: keyPath] = newValue }
    }
}

@propertyWrapper
struct Injected<T> {
    private let keyPath: WritableKeyPath<InjectedValues, T>
    var wrappedValue: T {
        get { InjectedValues[keyPath] }
        set { InjectedValues[keyPath] = newValue }
    }
    
    init(_ keyPath: WritableKeyPath<InjectedValues, T>) {
        self.keyPath = keyPath
    }
}

//MARK: List ofe depencencies
extension InjectedValues {
    var model: Model {
        get { Self[ModelKey.self] }
        set { Self[ModelKey.self] = newValue }
    }
}


private struct ModelKey: InjectionKey {
    static var currentValue: Model = Model()
}
