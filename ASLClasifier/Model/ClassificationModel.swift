//
//  ClassificationModel.swift
//  ASLClasifier
//
//  Created by Irfan Dary Sujatmiko on 14/08/23.
//

import Foundation

struct Result: Decodable,Hashable,Encodable {

    var label: String
    var prediction: Double
    init(label: String, prediction: Double) {
        self.label = label
        self.prediction = prediction
    }
}
