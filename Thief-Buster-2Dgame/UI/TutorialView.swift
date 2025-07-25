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
    
    let caption = ["Attack the thief at the stairs using the button to earn points!", "Avoid hitting customers. One wrong hit and it's over!", "Strike the power up to blast away everything in the path!"]

    var body: some View {
        ZStack {
            Color("custom gray")
                .ignoresSafeArea(edges: .all)
            
            VStack(spacing: 0) {
                // Header
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
                        .font(.custom("Pixellari", size: 36))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)

                    Spacer()
                    Spacer()
                }

                Spacer()

                // Tutorial images carousel
                TabView(selection: $currentPage) {
                    ForEach(0..<images.count, id: \.self) { index in
                        ZStack {
                            Image("BorderTutorial")
                                .resizable()
                                .frame(width: 290, height:380)
                                .padding(.bottom, 100)
                            
                            VStack {
                                Image(images[index])
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 260, height:380)
                                    .padding(.bottom, 20)
                                
                                Spacer()
                                Spacer()

                                Text(caption[index])
                                    .font(.custom("Pixellari", size: 24))
                                    .fontWeight(.medium)
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 20)
                                    .padding(.horizontal, 10)
                                    .foregroundColor(.white)
                            }
                            .tag(index)
                        }
                    }
                        
                            
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: 500)
                
                Spacer()

                // Page indicator
                HStack(spacing: 8) {
                    ForEach(0..<images.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? Color.white : Color.gray.opacity(0.4))
                            .frame(width: 10, height: 10)
                    }
                }
                
            }
            
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
                       .frame(width: 40, height: 40)
                       .padding(.horizontal, 8)
                       .padding(.bottom, 28)
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
                       .frame(width: 40, height: 40)
                       .padding(.horizontal, 8)
                       .padding(.bottom, 28)
               }
               .disabled(currentPage == images.count - 1)
               .opacity(currentPage == images.count - 1 ? 0.0 : 1)
           }
//           .padding(.top, 24)
        }
    }
}

#Preview {
    TutorialView()
}
