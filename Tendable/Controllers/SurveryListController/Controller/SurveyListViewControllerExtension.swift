//
//  SurveyListViewControllerExtension.swift
//  Tendable
//
//  Created by Akshay Somkuwar on 7/23/24.
//

import UIKit

// MARK: TableView Delegate and DataSource Methods
extension SurveyListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return surveyListDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = surveyListTableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)
        popuplate(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.surveyPassDelegate?.passed(survey: surveyListDataSource[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
    
    func popuplate(cell: UITableViewCell, indexPath: IndexPath) {
        cell.textLabel?.numberOfLines = 0
        let surveyName = surveyListDataSource[indexPath.row].inspection?.area?.name ?? ""
        let id = String(surveyListDataSource[indexPath.row].inspection?.id ?? 0)
        var isSurveySubmitted = false
        if let isSubmitted = surveyListDataSource[indexPath.row].isSurverySubmitted {
            isSurveySubmitted = isSubmitted
        }
        var score = isSurveySubmitted ? (String(surveyListDataSource[indexPath.row].score)) : ("")
        score = score != "" ? "\nScore: \(score)" : ""
        cell.textLabel?.text = "Surney Area: \(surveyName)\nId: \(id)\n\(isSurveySubmitted ? "Survey Submitted: Yes" : "Survey Saved: Yes")\(score)"
        print(surveyListDataSource[indexPath.row].score)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let headerText = surveyListDataSource.count == 0 ? "No survey to show." : "Click to view survey."
        return headerText
    }
}


