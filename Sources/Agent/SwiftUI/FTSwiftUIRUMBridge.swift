//
//  FTSwiftUIRUMBridge.swift
//  GuanceSDK
//
//  Created by hulilei on 2026/7/2.
//  Copyright © 2026 DataFlux-cn. All rights reserved.
//

#if canImport(UIKit)

import Foundation

@objc(FTSwiftUIRUMViewHandling)
@_spi(Private)
public protocol FTSwiftUIRUMViewHandling: AnyObject {
    @objc(notifyOnAppearWithIdentity:name:property:loadTime:)
    func notifyOnAppear(identity: String, name: String, property: [String: Any]?, loadTime: NSNumber)

    @objc(notifyOnDisappearWithIdentity:)
    func notifyOnDisappear(identity: String)
}

@objc(FTSwiftUIRUMViewBridge)
@_spi(Private)
public final class FTSwiftUIRUMViewBridge: NSObject {
    private final class WeakBox {
        weak var value: FTSwiftUIRUMViewHandling?
    }

    private static let handlerBox = WeakBox()

    @objc public class var handler: FTSwiftUIRUMViewHandling? {
        get {
            objc_sync_enter(self)
            defer { objc_sync_exit(self) }
            return handlerBox.value
        }
        set {
            objc_sync_enter(self)
            handlerBox.value = newValue
            objc_sync_exit(self)
        }
    }
}

@objc(FTSwiftUIRUMActionHandling)
@_spi(Private)
public protocol FTSwiftUIRUMActionHandling: AnyObject {
    @objc(notifySwiftUITapActionWithName:property:)
    func notifySwiftUITapAction(name: String, property: [String: Any]?)
}

@objc(FTSwiftUIRUMActionBridge)
@_spi(Private)
public final class FTSwiftUIRUMActionBridge: NSObject {
    private final class WeakBox {
        weak var value: FTSwiftUIRUMActionHandling?
    }

    private static let handlerBox = WeakBox()

    @objc public class var handler: FTSwiftUIRUMActionHandling? {
        get {
            objc_sync_enter(self)
            defer { objc_sync_exit(self) }
            return handlerBox.value
        }
        set {
            objc_sync_enter(self)
            handlerBox.value = newValue
            objc_sync_exit(self)
        }
    }
}

public enum FTRUMSwiftUI {
    /// Tracks a SwiftUI tap action without adding any extra gesture recognizer.
    ///
    /// Prefer calling this inside a `Button` action or `.onTapGesture` closure when the target view is in a
    /// `List`, `NavigationLink`, scroll view, or already uses custom gestures.
    public static func trackTapAction(name: String, property: [String: Any]? = nil) {
        FTSwiftUIRUMActionBridge.handler?.notifySwiftUITapAction(name: name, property: property)
    }
}

#endif
