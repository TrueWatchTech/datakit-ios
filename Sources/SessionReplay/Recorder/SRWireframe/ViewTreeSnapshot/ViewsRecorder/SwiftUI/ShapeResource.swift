//
//  ShapeResource.swift
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

import CommonCrypto
import Foundation

@available(iOS 13.0, *)
final class FTShapeResource: NSObject {
    let svgString: String
    let mimeType = "image/svg+xml"

    private lazy var identifier = makeIdentifier()
    private lazy var data = makeData()

    init(svgString: String) {
        self.svgString = svgString
    }

    func makePayload() -> FTSwiftUIResourcePayload {
        FTSwiftUIResourcePayload(identifier: identifier, mimeType: mimeType, data: data)
    }

    private func makeIdentifier() -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        data.withUnsafeBytes { buffer in
            _ = CC_MD5(buffer.baseAddress, CC_LONG(buffer.count), &digest)
        }
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }

    private func makeData() -> Data {
        Data(svgString.utf8)
    }
}

#endif
