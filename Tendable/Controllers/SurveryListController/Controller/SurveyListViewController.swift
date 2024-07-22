//
//  SurveyListViewController.swift
//  Tendable
//
//  Created by Akshay Somkuwar on 7/22/24.
//

import UIKit

class SurveyListViewController: BaseViewController {
    
    // MARK: - Properties
    private var surveyListTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.systemGroupedBackground
        tv.tableFooterView = UIView()
        return tv
    }()
    
    weak var surveyPassDelegate: PassSurveyFromListProtocol? = nil
    
    var surveyListDataSource: [InspectionDataModel] = [] {
        didSet {
            surveyListTableView.reloadData()
        }
    }
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialSetup()
        handlers()
    }
    
    private func initialSetup() {
        view.backgroundColor = UIColor.systemGroupedBackground
        navigationController?.navigationBar.topItem?.title = "Survey List"
        
        surveyListTableView.dataSource = self
        surveyListTableView.delegate = self
        surveyListTableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
        
        surveyListDataSource = PersistentStorageManager.shared.getSurveyList()
    }
    
    private func setupViews() {
        view.addSubview(surveyListTableView)
        
        surveyListTableView.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(0)
            make.right.equalTo(view.snp.right).offset(0)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(0)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(0)
        }
    }
    
    private func handlers() {
        
    }
    
    // MARK: - Actions
}

extension SurveyListViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return surveyListDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = surveyListTableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath) as! UITableViewCell
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
        cell.textLabel?.text = "Surney Area: \(surveyName)\nId: \(id)\n\(isSurveySubmitted ? "Survey Submitted: Yes" : "Survey Saved: Yes")"
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let headerText = surveyListDataSource.count == 0 ? "No survey to show." : "Click to view survey."
        return headerText
    }
}


