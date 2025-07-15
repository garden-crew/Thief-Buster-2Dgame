import UIKit
import CoreHaptics

class HapticManager {
    static let shared = HapticManager()
    private var engine: CHHapticEngine?

    private init() {
        prepareHaptics()
    }

    private func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("⚠️ Failed to start haptic engine: \(error.localizedDescription)")
        }
    }

    func vibrateHit() {
        playPattern(intensity: 0.5, sharpness: 0.5, duration: 0.1)
    }

    func vibrateMiss() {
        playPattern(intensity: 1.0, sharpness: 1.0, duration: 0.3)
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

    private func playPattern(intensity: Float, sharpness: Float, duration: TimeInterval) {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        let event = CHHapticEvent(
            eventType: .hapticContinuous,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness)
            ],
            relativeTime: 0,
            duration: duration
        )

        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("⚠️ Failed to play pattern: \(error.localizedDescription)")
        }
    }
}
