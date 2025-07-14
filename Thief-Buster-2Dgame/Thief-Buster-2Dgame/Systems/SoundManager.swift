import AVFoundation

enum SoundType {
    case hitThief
    case powerUp
    case gameOver
}

class SoundManager {
    static let shared = SoundManager()

    private var backgroundPlayer: AVAudioPlayer?
    private var effectPlayer: AVAudioPlayer?

    private init() {}

    func play(sound: SoundType) {
        let soundFileName: String

        switch sound {
        case .hitThief:
            soundFileName = "Punch"
        case .powerUp:
            soundFileName = "PowerUp"
        case .gameOver:
            soundFileName = "GameOver"
        }

        playEffectSound(named: soundFileName)
    }

    private func playEffectSound(named soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
            print("❗️File '\(soundName).mp3' tidak ditemukan.")
            return
        }

        do {
            effectPlayer = try AVAudioPlayer(contentsOf: url)
            effectPlayer?.prepareToPlay()
            effectPlayer?.play()
        } catch {
            print("❌ Gagal memutar efek suara '\(soundName)': \(error)")
        }
    }

    func playBackgroundMusic(repeatForever: Bool = true) {
        guard let url = Bundle.main.url(forResource: "BackgroundMusic", withExtension: "mp3") else {
            print("❌ Musik latar tidak ditemukan.")
            return
        }

        do {
            backgroundPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundPlayer?.numberOfLoops = repeatForever ? -1 : 0
            backgroundPlayer?.volume = 0.5
            backgroundPlayer?.prepareToPlay()
            backgroundPlayer?.play()
        } catch {
            print("❌ Gagal memutar musik latar: \(error.localizedDescription)")
        }
    }

    func stopBackgroundMusic() {
        backgroundPlayer?.stop()
    }
}
