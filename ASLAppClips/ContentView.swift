//
//  ContentView.swift
//  TemanTuliAppClips
//
//  Created by Nathalia Minoque Kusuma Salma Rasyid Jr. on 14/08/23.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationStack{
            VStack{
                HStack{
                    Spacer()
                    VStack(alignment: .leading){
                        Text("Hello, i Adi")
                        //                                .padding(.bottom, 1)
                        //                                .zIndex(1)
                        Text("Did you mean: Hello, i am Adi")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color("bg-primary"))
                    .cornerRadius(8)
                }
                .padding(.vertical, 4)
                .padding(.leading, 36)
                HStack{
                    
                    VStack(alignment: .leading){
                        Text("Hi Adi, nice to meet you")
                            .foregroundColor(.black)
                        //            .padding()
                        //                            Text("Hello Adi, nice to meet you")
                        //                                .padding(.bottom, 1)
                        //                            Text("Did you mean: Hello, i am Adi")
                        //                                .font(.caption2)
                        //                                .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color("bg-primary"))
                    .cornerRadius(8)
                    Spacer()
                }
                .padding(.vertical, 4)
                .padding(.trailing, 36)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(16)
            .padding(.top, 160)
            .background(Color("bg-secondary"))
            .navigationTitle("Deafine")
            .ignoresSafeArea()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
