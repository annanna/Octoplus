//
//  MotionManager.swift
//  GameJamMarblePrototype Shared
//
//  Created by Anna Münster  on 09.06.26.
//

import CoreGraphics
import Observation
#if os(iOS)
import CoreMotion
#endif

// MARK: - Multiplayer handoff: swap tilt source with network-received orientation data here
@Observable
final class MotionManager {
    private(set) var currentTilt: CGVector = CGVector(dx: 0, dy: 0)
    var simulatedTilt: CGVector = CGVector(dx: 0, dy: 0)

    #if os(iOS)
    private let cm = CMMotionManager()
    #endif

    init() {
        #if os(iOS) && !targetEnvironment(simulator)
        guard cm.isDeviceMotionAvailable else { return }
        cm.deviceMotionUpdateInterval = 1.0 / 60.0
        cm.startDeviceMotionUpdates(to: .main) { [weak self] motion, _ in
            guard let motion else { return }
            self?.currentTilt = CGVector(dx: motion.gravity.x, dy: motion.gravity.y)
        }
        #endif
    }

    func tiltForFrame() -> CGVector {
        #if targetEnvironment(simulator)
        return simulatedTilt
        #else
        return currentTilt
        #endif
    }
}
