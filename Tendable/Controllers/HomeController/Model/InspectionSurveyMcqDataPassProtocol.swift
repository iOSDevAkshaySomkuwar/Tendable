//
//  InspectionSurveyMcqDataPassProtocol.swift
//  Tendable
//
//  Created by Akshay Somkuwar on 7/22/24.
//

import Foundation

protocol InspectionSurveyMcqDataPassProtocol: AnyObject {
    func mcqAnswered(for section: IndexPath, id: Int)
}

protocol PassSurveyFromListProtocol: AnyObject {
    func passed(survey: InspectionDataModel)
}
