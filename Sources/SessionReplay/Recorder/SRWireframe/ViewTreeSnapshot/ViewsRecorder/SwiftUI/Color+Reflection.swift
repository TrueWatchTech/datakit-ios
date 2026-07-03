//
//  Color+Reflection.swift
//  FTMobileSDK
//
//  Created by hulilei on 2026/6/8.
//  Copyright 2026 Shanghai Guance Information Technology Co., Ltd.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#if os(iOS)

import SwiftUI

@available(iOS 13.0, tvOS 13.0, *)
extension SwiftUI.Color._Resolved: FTReflection {
    init(from reflector: FTReflector) throws {
        linearRed = try reflector.descendant("linearRed")
        linearGreen = try reflector.descendant("linearGreen")
        linearBlue = try reflector.descendant("linearBlue")
        opacity = try reflector.descendant("opacity")
    }
}

@available(iOS 13.0, tvOS 13.0, *)
extension SwiftUI.Color._ResolvedHDR: FTReflection {
    init(from reflector: FTReflector) throws {
        base = try reflector.descendant("base")
        _headroom = try reflector.descendant("_headroom")
    }
}

@available(iOS 13.0, tvOS 13.0, *)
extension FTColorView: FTReflection {
    init(from reflector: FTReflector) throws {
        color = try reflector.descendant("color")
    }
}

@available(iOS 13.0, tvOS 13.0, *)
extension FTResolvedPaint: FTReflection {
    init(from reflector: FTReflector) throws {
        if #available(iOS 26, tvOS 26, *) {
            paint = reflector.descendantIfPresent(type: FTColorView.self, "paint")?.color.base
        } else {
            paint = reflector.descendantIfPresent("paint")
        }
    }
}

#endif
