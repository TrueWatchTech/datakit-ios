//
//  Path+SVG.swift
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
import Foundation
import SwiftUI

@available(iOS 13.0, tvOS 13.0, *)
extension SwiftUI.Path {
    var ft_svgString: String {
        var d = ""
        forEach { element in
            switch element {
            case let .move(to):
                d += "M \(to.ft_svgString) "
            case let .line(to):
                d += "L \(to.ft_svgString) "
            case let .quadCurve(to, control):
                d += "Q \(control.ft_svgString) \(to.ft_svgString) "
            case let .curve(to, control1, control2):
                d += "C \(control1.ft_svgString) \(control2.ft_svgString) \(to.ft_svgString) "
            case .closeSubpath:
                d += "Z "
            }
        }
        return d.trimmingCharacters(in: .whitespaces)
    }
}

extension CGPoint {
    var ft_svgString: String {
        "\(x.ft_svgString) \(y.ft_svgString)"
    }
}

extension CGFloat {
    var ft_svgString: String {
        String(format: "%.3f", locale: Locale(identifier: "en_US_POSIX"), self)
    }
}

#endif
