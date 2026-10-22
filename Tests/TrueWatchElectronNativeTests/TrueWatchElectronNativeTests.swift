//
//  TrueWatchElectronNativeTests.swift
//  TrueWatchElectronNativeTests
//
//  Copyright 2026 TRUEWATCH TECHNOLOGY INC PTE. LTD.
//

#if os(macOS)
import XCTest
import TrueWatchElectronNative

final class TrueWatchElectronNativeTests: XCTestCase {
    func testCBridgeReturnsFramedErrorForUnsupportedMethod() throws {
        let result = try XCTUnwrap(ft_electron_invoke("unsupported.method", "{}"))
        defer { ft_electron_free_string(result) }

        let response = String(cString: result)
        XCTAssertTrue(response.hasPrefix("1"))
        XCTAssertTrue(response.contains("Unsupported Native method"))
    }

    func testCBridgeExposesWebViewConfiguration() throws {
        let requiredCapacity = ft_electron_bridge_configuration(nil, 0)
        XCTAssertGreaterThan(requiredCapacity, 1)

        var buffer = [CChar](repeating: 0, count: Int(requiredCapacity))
        let written = buffer.withUnsafeMutableBufferPointer { pointer in
            ft_electron_bridge_configuration(pointer.baseAddress, requiredCapacity)
        }
        XCTAssertGreaterThan(written, 0)
        let json = String(cString: buffer)
        XCTAssertTrue(json.hasPrefix("{"))
    }

    func testLoggerConfigurationPublishesWebViewLogCapability() throws {
        let initialize = try invoke(
            "sdk.initialize",
            payload: [
                "datakitUrl": "http://127.0.0.1:9529",
                "autoSync": false,
            ]
        )
        XCTAssertEqual(initialize.first, "0")

        let configure = try invoke(
            "logger.configure",
            payload: [
                "enableCustomLog": false,
                "enableWebViewLog": true,
            ]
        )
        XCTAssertEqual(configure.first, "0")

        let requiredCapacity = ft_electron_bridge_configuration(nil, 0)
        var buffer = [CChar](repeating: 0, count: Int(requiredCapacity))
        let written = buffer.withUnsafeMutableBufferPointer { pointer in
            ft_electron_bridge_configuration(pointer.baseAddress, requiredCapacity)
        }
        XCTAssertGreaterThan(written, 0)
        let data = try XCTUnwrap(String(cString: buffer).data(using: .utf8))
        let configuration = try XCTUnwrap(
            JSONSerialization.jsonObject(with: data) as? [String: Any]
        )
        XCTAssertEqual(configuration["enableWebViewLog"] as? Bool, true)
    }

    private func invoke(
        _ method: String,
        payload: [String: Any]
    ) throws -> String {
        let payloadData = try JSONSerialization.data(withJSONObject: payload)
        let payloadJSON = try XCTUnwrap(
            String(data: payloadData, encoding: .utf8)
        )
        let result = try XCTUnwrap(
            method.withCString { methodPointer in
                payloadJSON.withCString { payloadPointer in
                    ft_electron_invoke(methodPointer, payloadPointer)
                }
            }
        )
        defer { ft_electron_free_string(result) }
        return String(cString: result)
    }
}
#endif
