//
//  GraphicsImage.swift
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

import CoreGraphics
import SwiftUI
import UIKit

@available(iOS 13.0, tvOS 13.0, *)
struct FTGraphicsImage {
    enum Contents {
        case cgImage(CGImage)
        case vectorImage(VectorImage)
        case unknown
    }

    enum Location {
        case bundle(Bundle)
        case unknown
    }

    struct VectorImage {
        let location: Location
        let name: String

        var bundle: Bundle? {
            if case let .bundle(bundle) = location {
                return bundle
            }
            return nil
        }
    }

    let scale: CGFloat
    let orientation: SwiftUI.Image.Orientation
    let contents: Contents
    let maskColor: Color._Resolved?

    var uiImageOrientation: UIImage.Orientation {
        UIImage.Orientation(orientation)
    }
}

@available(iOS 13.0, tvOS 13.0, *)
extension UIImage.Orientation {
    init(_ orientation: SwiftUI.Image.Orientation) {
        switch orientation {
        case .up:
            self = .up
        case .down:
            self = .down
        case .left:
            self = .left
        case .right:
            self = .right
        case .upMirrored:
            self = .upMirrored
        case .downMirrored:
            self = .downMirrored
        case .leftMirrored:
            self = .leftMirrored
        case .rightMirrored:
            self = .rightMirrored
        @unknown default:
            self = .up
        }
    }
}

#endif
