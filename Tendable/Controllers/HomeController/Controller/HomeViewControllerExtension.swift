//
//  HomeViewControllerExtension.swift
//  Tendable
//
//  Created by Akshay Somkuwar on 7/23/24.
//

import UIKit

// MARK: TableView Delegate and DataSource Methods
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return getNumberOfSection()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getNumberOfRowsIn(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = surveyTableView.dequeueReusableCell(withIdentifier: MCQTableViewCell.identifier, for: indexPath) as! MCQTableViewCell
        cell.mcqDataPassDelegate = self
        cell.populateWith(question: getQuestionFor(indexPath), indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return getTitleForHeaderIn(section: section)
    }
}

// MARK: Protocol methods to pass data
extension HomeViewController: InspectionSurveyMcqDataPassProtocol, PassSurveyFromListProtocol {
    func passed(survey: InspectionDataModel) {
        self.inspectionDataSource = survey
    }
    
    func mcqAnswered(for section: IndexPath, id: Int) {
        guard let surveryDone = self.inspectionDataSource.isSurverySubmitted, !surveryDone else { return }
        self.inspectionDataSource.inspection?.survey?.categories?[section.section].questions?[section.row].selectedAnswerChoiceId = id
    }
}

