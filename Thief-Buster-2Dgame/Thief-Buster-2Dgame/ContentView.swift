import SwiftUI
import SpriteKit

struct ContentView: View {
    var scene: SKScene {
        let scene = GameScene()
        scene.size = UIScreen.main.bounds.size // Ukuran scene = ukuran layar
        scene.scaleMode = .resizeFill          // Supaya ikut ukuran device
        return scene
    }

    var body: some View {
        SpriteView(scene: scene)
            .ignoresSafeArea() // Fullscreen
    }
}

#Preview {
    ContentView()
}
