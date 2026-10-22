//  Copyright 2026 TRUEWATCH TECHNOLOGY INC PTE. LTD.
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

import XCTest
import TrueWatchSDK

final class FTWebViewLogTimeTests: XCTestCase {
    func testInvalidBrowserDateUsesExplicitIngressTime() throws {
        let ingressTime: Int64 = 1_700_000_000_456_000_000
        let event = try XCTUnwrap(
            FTWebViewLogEventMapper.mapEvent(
                ["message": "invalid-browser-time", "date": "invalid"],
                fallbackNanosecondTime: ingressTime
            )
        )

        XCTAssertEqual(event.time, ingressTime)
    }
}
