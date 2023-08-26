//
//  LivePreviewView.swift
//  ASLClasifier
//
//  Created by Irfan Dary Sujatmiko on 14/08/23.
//

import SwiftUI

extension Animation {
    func `repeat`(while expression: Bool, autoreverses: Bool = true) -> Animation {
        if expression {
            return self.repeatForever(autoreverses: autoreverses)
        } else {
            return self
        }
    }
}

struct LivePreviewView: View {
    @StateObject var speechRecognizer = SpeechRecognizerViewModel()
    @State private var isRecording = false
    @State private var scale = 1.0
    @State var isAnimating = false
    @ObservedObject var vm :ClassificationViewModel
    
    @State var detectionController: DetectionController?
    
    init(vm: ClassificationViewModel) {
        self.vm = vm
    }
    
    var body: some View {
        GeometryReader{geo in
            ZStack{
                DetectionView(
                    configurator: { vc in
                        DispatchQueue.main.async {
                            self.detectionController = vc
                        }
                    },
                    removeLast:  { rl in
                        DispatchQueue.main.async {
                            self.detectionController = rl
                        }
                    },
                              
                    didReceiveArray: { results in
                    vm.result=results
                    if(results.count>=2){
                        Task{
                            await vm.getRecomendation()
                        }
                    }
                    
                })
                .frame(width: geo.size.width,height: geo.size.height).ignoresSafeArea()
                HStack{
                    Spacer()
                    VStack{
                        HStack{
                            VStack(alignment: .leading){
                                HStack{
                                    ForEach(vm.result ,id:\.self){res in
                                        Text("\(res.label)").foregroundColor(.black).font(.system(size: 13))
                                    }
                                }
                                
                                
                                Text(" \(vm.recomendation.wordsRecommendation)").font(.caption2)
                                    .foregroundColor(.blue).italic().onTapGesture {
                                        vm.result=[Result(label:vm.recomendation.wordsRecommendation,prediction: 0.0)]
                                        
                                        vm.recomendation.wordsRecommendation=""
                                    }.padding(.top,10)
                                
                            }
                            .padding()
                            .background(Color("bg-primary"))
                            .cornerRadius(8)
                            Spacer()
                        }
                        .padding(.vertical, 4)
                        .padding(.trailing, 36)
                        HStack{
                            Spacer()
                            VStack(alignment: .leading){
                                Text(speechRecognizer.transcript)
                                    .foregroundColor(.black).font(.system(size: 14))
                            }
                            .padding()
                            .background(Color("bg-primary"))
                            .cornerRadius(8)
                        }
                        .padding(.vertical, 4)
                        .padding(.leading, 36)
                        
                        Spacer()
                        HStack{
                            Button {
                                vm.result=[]
                                if let detection = detectionController {
                                    detection.reset()
                                }
                                detectionController?.reset()
                                vm.recomendation=RecomendationModel(wordsRecommendation: "")
                            } label: {
                                Image(systemName: "arrow.counterclockwise")
                                    .bold()
                            }.padding(15)
                                .foregroundColor(.white)
                                .background(.blue)
                                .clipShape(Circle())
                            ZStack{
                                
                                Image("mic-circle-2")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 88)
                                    .opacity(isAnimating ? 1 : 0.0) // Apply opacity animation
                                    .animation(Animation.easeInOut(duration: 2).repeat(while: isAnimating))
                                
                                Image("mic-circle-1")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 76)
                                    .opacity(isAnimating ? 1 : 0.0) // Apply opacity animation
                                    .animation(Animation.easeInOut(duration: 1).repeat(while: isAnimating))
                                
                                
                                Button {
                                    print(isAnimating)
                                    isAnimating.toggle()
                                    if !isRecording {
                                        speechRecognizer.transcribe()
                                    } else {
                                        speechRecognizer.stopTranscribing()
                                    }
                                } label: {
                                    Image(systemName: "mic")
                                        .bold()
                                }
                                .padding(24)
                                .foregroundColor(.white)
                                .background(.blue)
                                .clipShape(Circle())
                                
                            }
                            Button {
                                vm.deleteLastWord()
                                detectionController?.deleteLast()
                                vm.recomendation=RecomendationModel(wordsRecommendation: "")
                            } label: {
                                Image(systemName: "delete.left")
                                    .bold()
                            }.padding(15)
                                .foregroundColor(.white)
                                .background(.blue)
                                .clipShape(Circle())
                        }
                        
                    }
                    .frame(maxWidth: 240, maxHeight:320)
                    .padding(16)
                    .background(Color("bg-secondary"))
                    .cornerRadius(20)
                }.rotationEffect(.degrees(-90)).offset(x:0,y:-150)
            }
            .ignoresSafeArea()
        }
        

    }
}




struct LivePreviewView_Previews: PreviewProvider {
    static var previews: some View {
        LivePreviewView(vm:ClassificationViewModel())
    }
}
