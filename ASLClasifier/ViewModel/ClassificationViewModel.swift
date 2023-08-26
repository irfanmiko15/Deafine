//
//  ClassificationViewModel.swift
//  ASLClasifier
//
//  Created by Irfan Dary Sujatmiko on 14/08/23.
//

import Foundation
import Alamofire
class ClassificationViewModel : ObservableObject{
    @Published var result:[Result]=[]
    @Published var recomendation = RecomendationModel(wordsRecommendation: "")
    
    func deleteLastWord(){
        if(result.count>0){
            result.removeLast()
        }
    }
    func getRecomendation()async{
        var path = "/"
        var tempArray : [String] = []
        for x in result{
            let arr = x.label.components(separatedBy: " ")
            if(arr.count>1){
                for y in arr{
                    tempArray.append(y)
                }
            }
            else{
                
                tempArray.append(x.label)
            }
            
        }
        let body = ["words": tempArray]
        var headers = HTTPHeaders()
            headers["content-type"] = "application/json"
        APIManager.shared.callAPI(path: path, method: .post, headers: headers, parameters: body, success: { response in
              do {
                if let data = response.data {
                  let res = try JSONDecoder().decode(RecomendationModel.self, from: data)
                    self.recomendation=res
                }
              } catch let error as NSError{
                  print(error)
              }
            }, failure: { error in
              print(error)
            })
    }

}
