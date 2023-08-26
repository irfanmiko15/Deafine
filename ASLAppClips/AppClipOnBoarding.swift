//
//  AppClipOnBoarding.swift
//  TemanTuliAppClips
//
//  Created by Nathalia Minoque Kusuma Salma Rasyid Jr. on 16/08/23.
//

import SwiftUI

struct AppClipOnBoarding: View {
    let imageName:[String] = ["person.fill.viewfinder", "message.and.waveform.fill", "person.line.dotted.person.fill"]
    let description:[String] = ["Stand in front of your opponent's camera and perform the sign language of your choice, your opponent will be able to see your gesture.", "Your opponent will instantly receive a message detailing what you've expressed.", "In response to your gesture, you'll receive a message from your opponent directly on your screen."]
    let subtitle:[String] = ["Express Yourself", "Share the Message", "Engage in Conversation"]
    
    var body: some View {
        VStack{
            Spacer()
            Text("Welcome to Deafine")
                .font(.title)
                .bold()
                .padding()
            
            ForEach(0..<3, id: \.self) { i in
                HStack{
                    Image(systemName: "\(imageName[i])")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 32, maxHeight:28)
//                        .aspectRatio(contentMode: )
                        .foregroundColor(.blue)
                        .padding(8)
                    VStack(alignment: .leading){
                        Text("\(subtitle[i])")
                            .bold()
                        Text("\(description[i])")
                    }
                }
                .font(.footnote)
                .padding(.bottom)
            }
            Spacer()
           
            NavigationLink(destination: ContentView(), label: {
                Text("Start").frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(12)
            }
            
            )
            
            
        }
        .padding(36)
    }
}

struct AppClipOnBoarding_Previews: PreviewProvider {
    static var previews: some View {
        AppClipOnBoarding()
    }
}
