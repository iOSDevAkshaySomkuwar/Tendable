//
//  SurveyListViewController.swift
//  Tendable
//
//  Created by Akshay Somkuwar on 7/22/24.
//

import UIKit

class SurveyListViewController: BaseViewController {
    
    // MARK: - Properties
    var surveyListTableView: UITableView = {
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
