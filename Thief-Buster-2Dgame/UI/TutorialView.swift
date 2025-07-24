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
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .padding(12)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(Circle())
                    }
                    .padding(.leading)

                    Spacer()

                    Text("How to Play")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.trailing)

                    Spacer()
                    Spacer()
                }
                .padding(.top, 50)

                Spacer(minLength: 10)

                // Tutorial images carousel
                TabView(selection: $currentPage) {
                    ForEach(0..<images.count, id: \.self) { index in
                        Image(images[index])
                            .resizable()
                            .scaledToFit()
                            .tag(index)
                            .padding()
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: 400)
                
                Spacer(minLength: 10)

                // Page indicator
                HStack(spacing: 8) {
                    ForEach(0..<images.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? Color.blue : Color.gray.opacity(0.4))
                            .frame(width: 10, height: 10)
                    }
                }
                .padding(.top, 12)

                Spacer()
            }
            
            HStack {
               Button(action: {
                   if currentPage > 0 {
                       withAnimation {
                           currentPage -= 1
                       }
                   }
               }) {
                   Image(systemName: "chevron.left")
                       .font(.title)
                       .padding()
                       .background(Color.gray.opacity(0.2))
                       .clipShape(Circle())
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
                   Image(systemName: "chevron.right")
                       .font(.title)
                       .padding()
                       .background(Color.gray.opacity(0.2))
                       .clipShape(Circle())
               }
               .disabled(currentPage == images.count - 1)
               .opacity(currentPage == images.count - 1 ? 0.0 : 1)
           }
           .padding(.top, 24)
        }
    }
}

#Preview {
    TutorialView()
}

