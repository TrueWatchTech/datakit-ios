//
//  ImageRenderer.swift
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

import Foundation
import UIKit

@available(iOS 13.0, tvOS 13.0, *)
final class FTImageRenderer {
    private final class Key: NSObject {
        private let contents: FTAnyImageRepresentable

        init(_ contents: FTAnyImageRepresentable) {
            self.contents = contents
        }

        override var hash: Int {
            var hasher = Hasher()
            hasher.combine(contents)
            return hasher.finalize()
        }

        override func isEqual(_ object: Any?) -> Bool {
            guard let other = object as? Key else {
                return false
            }
            return contents == other.contents
        }
    }

    private let cache = NSCache<Key, UIImage>()

    init() {
        cache.countLimit = 20
    }

    func image(for contents: FTAnyImageRepresentable) -> UIImage? {
        let key = Key(contents)
        if let image = cache.object(forKey: key) {
            return image
        }
        guard let image = contents.makeImage() else {
            return nil
        }
        cache.setObject(image, forKey: key)
        return image
    }
}

#endif
