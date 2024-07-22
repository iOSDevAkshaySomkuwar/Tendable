//
//  APIDataModels.swift
//  Tendable
//
//  Created by Akshay Somkuwar on 7/21/24.
//

import Foundation

typealias Codable = Decodable & Encodable

struct APIErrorModel: Codable {
    var error: String?
  }

struct InspectionDataModel: Codable {
    var inspection: InspectionModel?
    var isSurverySubmitted: Bool?
}

struct InspectionModel: Codable {
    var id: Int?
    var area: InspectionArea?
    var type: InspectionType?
    var survey: InspectionSurvey?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case area
        case type = "inspectionType"
        case survey
    }
}

struct InspectionArea: Codable {
    var id: Int?
    var name: String?
}

struct InspectionType: Codable {
    var id: Int?
    var name: String?
    var access: String?
}

struct InspectionSurvey: Codable {
    var categories: [Category]?
    
    struct Category: Codable {
        var id: Int?
        var name: String?
        var questions: [Question]?
    }
    
    struct Question: Codable {
        var answerChoices: [AnswerChoice]?
        var id: Int?
        var name: String?
        var selectedAnswerChoiceId: Int?
    }
    
    struct AnswerChoice: Codable, IteratorProtocol, Sequence {
        var id: Int?
        var name: String?
        var score: Float?
        
        func isAnswerSelected(_ selectedId: Int?) -> Bool {
            guard let id = id, let selectedId = selectedId else { return false }
            return id == selectedId
        }
        
        var totalCount: Int?
        mutating func next() -> Int? {
            guard totalCount ?? 0 >= 0 else {
                return nil
            }
            defer { totalCount! -= 1 }
            return totalCount
        }
        var start: Int?
        func makeIterator() -> AnswerChoice {
            AnswerChoice()
        }
    }
}
