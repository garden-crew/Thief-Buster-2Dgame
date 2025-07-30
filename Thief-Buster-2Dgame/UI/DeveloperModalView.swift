import SwiftUI
import SpriteKit
import SwiftData

struct DeveloperModalView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var highscores: [Highscore]
    let scene: SKScene
    @State private var starterScore: Int = 0
    
    var body: some View {
        NavigationView {
            List {
                Section("Debug Actions") {
                    Button("Reset Highscores") {
                        // Delete all existing highscores
                        highscores.forEach { modelContext.delete($0) }
                        try? modelContext.save()
                    }
                }
            }
            .navigationTitle("Developer Options")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

//#Preview {
//    DeveloperModalView(scene: SKScene())
//}
