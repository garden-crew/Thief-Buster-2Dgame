import UIKit
import CoreHaptics

// Singleton class for managing Core Haptics feedback in the game.
class HapticManager {
    static let shared = HapticManager()
    private var engine: CHHapticEngine?

    private init() {
        prepareHaptics()
    }

    // Initializes and starts the haptic engine if supported by the device.
    private func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("⚠️ Failed to start haptic engine: \(error.localizedDescription)")
        }
    }

    func vibratePowerUp() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        let events = [
            CHHapticEvent(
                eventType: .hapticContinuous,
                parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 1),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
                ],
                relativeTime: 0,
                duration: 0.4
            ),
            CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [],
                relativeTime: 0.4
            ),
            CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [],
                relativeTime: 0.6
            )
        ]

        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("⚠️ Failed to play powerUp haptic: \(error.localizedDescription)")
        }
    }
}
