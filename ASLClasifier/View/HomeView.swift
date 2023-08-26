//
//  HomeView.swift
//  ASLClasifier
//
//  Created by Irfan Dary Sujatmiko on 20/08/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        GeometryReader{geo in
            NavigationStack{
                ZStack{
                    Image("bg-camera")
                        .frame(width: geo.size.height, height: geo.size.width)
                    HStack{
                        Spacer()
                        VStack(alignment: .leading){
                            Text("Hi!")
                                .bold()
                                .font(.title3).foregroundColor(.black)
                            
                            Text("I want to have a conversation with you").foregroundColor(.black)
                            Text("Please scan this code").foregroundColor(.black)
                            HStack{
                                Spacer()
                                Image("DeafineAppClip")
                                    .resizable()
                                    .frame(width: 160, height: 160)
                                    .padding(.top)
                                Spacer()
                            }
                            HStack{
                                Spacer()
                                NavigationLink(destination: LivePreviewView(vm: ClassificationViewModel() ).navigationBarBackButtonHidden(true)) {
                                    Text("Next").font(.system(size: 15)).frame(width: 80, height: 40, alignment: .center)
                                        .background(Color.blue).cornerRadius(10)
                                        .foregroundColor(Color.white)
                                }
                                Spacer()
                            }
                        }
                        .frame(maxWidth: 240, maxHeight:320)
                        .padding(16)
                        .background(Color.bgSecondary)
                        .cornerRadius(20)
                    }
                }.rotationEffect(.degrees(-90))
            }
            .ignoresSafeArea()
            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
