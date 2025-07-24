import AVFoundation

// Defines the available sound effects in the game.
enum SoundType {
    case hitThief
    case powerUp
    case gameOver
    case misshit
    case hitCust
}

// Singleton class responsible for managing all audio in the game, including sound effects and background music.
class SoundManager {
    static let shared = SoundManager()

    private var backgroundPlayer: AVAudioPlayer?
    private var effectPlayer: AVAudioPlayer?
    private init() {}

    // Plays a predefined sound effect based on the given sound type.
    func play(sound: SoundType) {
//        let soundFileName: String
//
//        switch sound {
//        case .hitThief:
//            soundFileName = "Punch"
//        case .powerUp:
//            soundFileName = "PowerUp"
//            backgroundPlayer?.setVolume(0.2, fadeDuration: 0.2)
//                  DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                      self.backgroundPlayer?.setVolume(0.5, fadeDuration: 0.5)
//                  }
//        case .gameOver:
//            soundFileName = "GameOver"
//        case .misshit:
//            soundFileName = "Whoosh"
//        case .hitCust:
//            soundFileName = "hitCust"
//        }
//
//        playEffectSound(named: soundFileName)
    }

    // Loads and plays a short sound effect file from the app bundle.
    private func playEffectSound(named soundName: String) {
//        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
//            print("❗️File '\(soundName).mp3' is not found.")
//            return
//        }
//
//        do {
//            effectPlayer = try AVAudioPlayer(contentsOf: url)
//            effectPlayer?.prepareToPlay()
//            effectPlayer?.play()
//        } catch {
//            print("❌ Failed to play sound effect '\(soundName)': \(error)")
//        }
    }

    // Plays background music from a predefined audio file.
    func playBackgroundMusic(repeatForever: Bool = true) {
        guard let url = Bundle.main.url(forResource: "BackgroundMusic2", withExtension: "mp3") else {
            print("❌ Background music is not found.")
            return
        }

        do {
            backgroundPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundPlayer?.numberOfLoops = repeatForever ? -1 : 0
            backgroundPlayer?.volume = 0.3
            backgroundPlayer?.prepareToPlay()
            backgroundPlayer?.play()
        } catch {
            print("❌ Failed to play background music: \(error.localizedDescription)")
        }
    }

    func stopBackgroundMusic() {
        backgroundPlayer?.stop()
    }
}
