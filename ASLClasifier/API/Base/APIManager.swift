//
//  APIManager.swift
//  ASLClasifier
//
//  Created by Irfan Dary Sujatmiko on 15/08/23.
//

import Foundation
import Alamofire
public class APIManager {
public static let shared = APIManager()
public typealias FailureMessage = String
  
  func callAPI(path: String, method: HTTPMethod = .get, headers: HTTPHeaders? = nil, parameters: Parameters? = nil, success: @escaping ((AFDataResponse<Any>) -> Void), failure: @escaping ((FailureMessage) -> Void)) {
    
      guard var url = URLComponents(string: "\(BaseApi().baseUrl)\(path)") else {
      failure("Invalid URL")
      return
    }

    AF.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
      .responseJSON { response in
        switch response.result {
        case .success:
          success(response)
        case let .failure(error):
          failure(error.localizedDescription)
        }
      }
  }
}
