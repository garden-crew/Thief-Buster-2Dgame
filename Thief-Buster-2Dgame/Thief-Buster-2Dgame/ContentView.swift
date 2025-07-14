import SwiftUI
import SpriteKit

struct ContentView: View {
    var scene: SKScene {
        let scene = MyGameScene()
        scene.size = UIScreen.main.bounds.size
        scene.scaleMode = .resizeFill
        return scene
    }

    var body: some View {
        SpriteView(scene: scene)
            .ignoresSafeArea()
    }
}


#Preview {
    ContentView()
}
