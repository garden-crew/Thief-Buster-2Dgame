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

    // Plays a short, medium-intensity vibration for a successful hit.
    func vibrateHit() {
        playPattern(intensity: 0.5, sharpness: 0.5, duration: 0.1)
    }

    // Plays a stronger, longer vibration for a failed action (e.g., wrong hit).
    func vibrateMiss() {
        playPattern(intensity: 1.0, sharpness: 1.0, duration: 0.3)
    }

    // Plays a sequence of haptic feedback patterns for collecting a power-up.
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

    // Internal method for playing a simple continuous haptic pattern.
    /// - Parameters:
    ///   - intensity: The intensity of the vibration (0.0 - 1.0).
    ///   - sharpness: The sharpness of the vibration (0.0 - 1.0).
    ///   - duration: How long the vibration lasts, in seconds.
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
