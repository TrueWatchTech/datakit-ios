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

import Darwin
import Foundation
import TrueWatchElectronWebView

struct ElectronChildSession {
    let instanceID: Int
    let process: Process
    let bridgeServer: FTElectronBridgeServer
}

/// Used on the main thread. Each Electron Main owns exactly one bridge endpoint.
final class ElectronProcessController {
    private(set) var children: [Int: ElectronChildSession] = [:]
    private var nextInstanceID = 1
    private let pidFileURL: URL?
    var onExit: ((ElectronChildSession) -> Void)?

    init(pidFileURL: URL? = nil) {
        self.pidFileURL = pidFileURL
    }

    @discardableResult
    func launch(_ process: Process) throws -> ElectronChildSession {
        let instanceID = nextInstanceID
        // Never reuse an ID: an exit callback from a failed launch may be queued.
        nextInstanceID += 1
        let server = FTElectronBridgeServer()
        var childEnvironment = process.environment ?? ProcessInfo.processInfo.environment
        childEnvironment["ORBITDESK_ELECTRON_INSTANCE_ID"] = String(instanceID)
        process.environment = childEnvironment
        do {
            try server.configureElectronProcess(process)
            process.terminationHandler = { [weak self] _ in
                DispatchQueue.main.async {
                    guard let self,
                          let child = self.children.removeValue(forKey: instanceID) else { return }
                    child.bridgeServer.stop()
                    do { try self.writePIDFile() }
                    catch { print("[native-host] Could not update child PID file: \(error)") }
                    self.onExit?(child)
                }
            }
            try process.run()
            let child = ElectronChildSession(
                instanceID: instanceID, process: process, bridgeServer: server
            )
            children[instanceID] = child
            try writePIDFile()
            return child
        } catch {
            process.terminationHandler = nil
            children.removeValue(forKey: instanceID)
            stopProcesses([process])
            server.stop()
            throw error
        }
    }

    func terminateAll() {
        let sessions = Array(children.values)
        // Ignore queued exit callbacks after shutdown, without touching another child.
        children.removeAll()
        for child in sessions { child.process.terminationHandler = nil }
        stopProcesses(sessions.map(\.process))
        for child in sessions { child.bridgeServer.stop() }
        if let pidFileURL { try? FileManager.default.removeItem(at: pidFileURL) }
    }

    private func writePIDFile() throws {
        guard let pidFileURL else { return }
        let pids = children.values.map { $0.process.processIdentifier }.sorted()
        try JSONEncoder().encode(pids).write(to: pidFileURL, options: .atomic)
    }

    private func stopProcesses(_ processes: [Process]) {
        let running = processes.filter(\.isRunning)
        for process in running { process.terminate() }
        if !running.isEmpty { Thread.sleep(forTimeInterval: 0.25) }
        for process in running {
            if process.isRunning { Darwin.kill(process.processIdentifier, SIGKILL) }
            process.waitUntilExit()
        }
    }
}
