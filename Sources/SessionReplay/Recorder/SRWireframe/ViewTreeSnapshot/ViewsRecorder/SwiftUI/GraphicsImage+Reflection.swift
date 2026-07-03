//
//  GraphicsImage+Reflection.swift
//  SessionReplay
//
//  Created by hulilei on 2026/6/8.
//
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

import CoreGraphics
import SwiftUI

@available(iOS 13.0, tvOS 13.0, *)
extension FTGraphicsImage: FTReflection {
    init(from reflector: FTReflector) throws {
        scale = try reflector.descendant("scale")
        orientation = try reflector.descendant("orientation")
        contents = try reflector.descendant("contents")
        if #available(iOS 26, tvOS 26, *) {
            maskColor = reflector.descendantIfPresent(type: Color._ResolvedHDR.self, "maskColor")?.base
        } else {
            maskColor = reflector.descendantIfPresent("maskColor")
        }
    }
}

@available(iOS 13.0, tvOS 13.0, *)
extension FTGraphicsImage.Contents: FTReflection {
    init(from reflector: FTReflector) throws {
        switch (reflector.displayStyle, reflector.descendantIfPresent(0)) {
        case let (.enum("cgImage"), cgImage as CGImage):
            self = .cgImage(cgImage)
        case let (.enum("vectorLayer"), contents):
            self = try .vectorImage(reflector.reflect(contents))
        default:
            self = .unknown
        }
    }
}

@available(iOS 13.0, tvOS 13.0, *)
extension FTGraphicsImage.Location: FTReflection {
    init(from reflector: FTReflector) throws {
        switch (reflector.displayStyle, reflector.descendantIfPresent(0)) {
        case let (.enum("bundle"), bundle as Bundle):
            self = .bundle(bundle)
        default:
            self = .unknown
        }
    }
}

@available(iOS 13.0, tvOS 13.0, *)
extension FTGraphicsImage.VectorImage: FTReflection {
    init(from reflector: FTReflector) throws {
        location = try reflector.descendant("location")
        name = try reflector.descendant("name")
    }
}

#endif
