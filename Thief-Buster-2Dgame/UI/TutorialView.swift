//
//  TutorialView.swift
//  Thief-Buster-2Dgame
//
//  Created by Niken Larasati on 23/07/25.
//

import SwiftUI

struct TutorialView: View {
    @Environment(\.dismiss) var dismiss
    @State private var currentPage = 0

    let images = ["Tutorial1", "Tutorial2", "Tutorial3"]
    
   

    var body: some View {
        ZStack {
            // Background: fullscreen image
            TabView(selection: $currentPage) {
                ForEach(0..<images.count, id: \.self) { index in
                    Image(images[index])
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width,
                               height: UIScreen.main.bounds.height)
                        .ignoresSafeArea()
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

            // Foreground overlay
            VStack {
                // Top bar
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image("BackButton")
                            .resizable()
                            .frame(width: 60, height: 60)
                    }
                    .padding(.leading)

                    Spacer()

                    Text("HOW TO PLAY")
                        .font(.custom("Pixellari", size: 25))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)

                    Spacer()
                    Spacer()
                }
                .padding(.top, 50) // Tambahkan padding agar tidak tertutup notch
                .padding(.horizontal)
                .padding(.bottom, 10)

                Spacer()

                // Caption
             

                // Page Indicator
                HStack(spacing: 8) {
                    ForEach(0..<images.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? Color.white : Color.white.opacity(0.4))
                            .frame(width: 10, height: 10)
                    }
                }
                .padding(.bottom, 30)
            }

            // Navigation Arrows
            HStack {
                Button(action: {
                    if currentPage > 0 {
                        withAnimation {
                            currentPage -= 1
                        }
                    }
                }) {
                    Image("TapLeft")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .padding()
                }
                .disabled(currentPage == 0)
                .opacity(currentPage == 0 ? 0.0 : 1)

                Spacer()

                Button(action: {
                    if currentPage < images.count - 1 {
                        withAnimation {
                            currentPage += 1
                        }
                    }
                }) {
                    Image("TapRight")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .padding()
                }
                .disabled(currentPage == images.count - 1)
                .opacity(currentPage == images.count - 1 ? 0.0 : 1)
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
        }.ignoresSafeArea(.all)
    }
        
}

#Preview {
    TutorialView()
}
