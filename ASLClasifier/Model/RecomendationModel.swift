//
//  RecomendationModel.swift
//  ASLClasifier
//
//  Created by Irfan Dary Sujatmiko on 15/08/23.
//
import Foundation

// MARK: - RecomendationModel
struct RecomendationModel: Codable {
    var wordsRecommendation: String

    enum CodingKeys: String, CodingKey {
        case wordsRecommendation = "words recommendation"
    }
}

