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

    var backgroundPlayer: AVAudioPlayer?
    private var effectPlayer: AVAudioPlayer?
    var startPlayer: AVAudioPlayer?
    private init() {}


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
    
    func playStartMusic(repeatForever: Bool = true) {
        guard let url = Bundle.main.url(forResource: "StartMusic", withExtension: "mp3") else {
            print("❌ Background music is not found.")
            return
        }

        do {
            startPlayer = try AVAudioPlayer(contentsOf: url)
            startPlayer?.numberOfLoops = repeatForever ? -1 : 0
            startPlayer?.volume = 0.3
            startPlayer?.prepareToPlay()
            startPlayer?.play()
        } catch {
            print("❌ Failed to play background music: \(error.localizedDescription)")
        }
    }

    func stopBackgroundMusic() {
        backgroundPlayer?.pause()
    }
    
    func stopStartMusic() {
        startPlayer?.pause()
    }
}
