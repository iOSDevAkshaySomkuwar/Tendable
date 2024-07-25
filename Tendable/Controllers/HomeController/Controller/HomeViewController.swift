//
//  HomeViewController.swift
//  Tendable
//
//  Created by Akshay Somkuwar on 7/22/24.
//

import UIKit

class HomeViewController: BaseViewController {
    
    // MARK: - Properties
    var inspectionDataSource: InspectionDataModel = InspectionDataModel() {
        didSet {
            surveyTableView.reloadData()
            checkActionButtonStatus()
        }
    }
    
    var surveyTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.systemGroupedBackground
        tv.tableFooterView = UIView()
        return tv
    }()
    
    private var actionButtonsStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 10
        sv.distribution = .fillEqually
        sv.alignment = .fill
        return sv
    }()
    
    private var saveButton: TendableButton = {
        let button = TendableButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setup(title: "Save")
        return button
    }()
    
    private var submitButton: TendableButton = {
        let button = TendableButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setup(title: "Submit")
        return button
    }()
    
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialSetup()
        handlers()
    }
    
    private func initialSetup() {
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.topItem?.title = "Home"
        
        let rightBarButton = UIBarButtonItem(title: "Survey List", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.navigateToSurveyList(_:)))
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        let leftBarButton = UIBarButtonItem(title: "New Survey", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.getNewSurvey(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        startInspection()
        
        surveyTableView.delegate = self
        surveyTableView.dataSource = self
        surveyTableView.register(MCQTableViewCell.self, forCellReuseIdentifier: MCQTableViewCell.identifier)
    }
    
    private func setupViews() {
        actionButtonsStackView.addArrangedSubview(saveButton)
        actionButtonsStackView.addArrangedSubview(submitButton)
        
        view.addSubview(surveyTableView)
        view.addSubview(actionButtonsStackView)
        
        surveyTableView.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(0)
            make.right.equalTo(view.snp.right).offset(0)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(0)
            make.bottom.equalTo(actionButtonsStackView.snp.top).offset(0)
        }
        
        actionButtonsStackView.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(10)
            make.right.equalTo(view.snp.right).offset(-10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(0)
            make.height.equalTo(50)
        }
        
        saveButton.snp.makeConstraints { (make) in
            make.height.equalTo(45)
        }
    }
    
    private func handlers() {
        saveButton.button.pressed = { [weak self] (sender) in
            guard let self = self else { return }
            let _ = PersistentStorageManager.shared.saveSurvey(data: self.inspectionDataSource)
            self.showAlert(title: "Survey saved!") {
                self.navigateToSurveyList(self)
            }
        }
        
        submitButton.button.pressed = { [weak self] (sender) in
            guard let self = self else { return }
            self.isSubmitButtonEnabled(false)
            let param = self.inspectionDataSource.dict
            self.submitSurvey(param)
            
        }
    }
    
    // MARK: - Actions
    @objc func navigateToSurveyList(_ sender: Any) {
        let vc = SurveyListViewController()
        vc.surveyPassDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func getNewSurvey(_ sender: Any) {
        self.generateRandomInspectionFromBackend()
    }
    
    private func startInspection() {
        NetworkManager.shared.request(.startInspection, method: .get, parameters: nil) { [weak self] (responseData) in
            guard let self = self, let response = responseData else { return }
            
            switch response {
            case .success(_, let data):
                do {
                    guard let data = data else { return }
                    var inspectionData = try JSONDecoder().decode(InspectionDataModel.self, from: data)
                    let isSurveyAvailable = PersistentStorageManager.shared.isSurveyAvailable(id: inspectionData.inspection?.id)
                    if isSurveyAvailable {
                        if let id = inspectionData.inspection?.id, let surveyData = PersistentStorageManager.shared.loadData(id: String(id)) {
                            self.inspectionDataSource = surveyData
                        }
                    } else {
                        inspectionData.isSurverySubmitted = false
                        self.inspectionDataSource = inspectionData
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                self.showAlert(title: error.message)
            }
            
        } error: { [weak self] (error) in
            guard let self = self else { return }
            self.showAlert(title: error.debugDescription)
        }
    }
    
    private func generateRandomInspectionFromBackend() {
        NetworkManager.shared.request(.generateRandomInspection, method: .get, parameters: nil) { [weak self] (responseData) in
            guard let self = self, let response = responseData else { return }
            
            switch response {
            case .success:
                self.generateNewSurveyFromBackend()
            case .failure(let error):
                self.showAlert(title: error.message)
            }
            
        } error: { [weak self] (error) in
            guard let self = self else { return }
            self.showAlert(title: error.debugDescription)
        }
    }
    
    private func generateNewSurveyFromBackend() {
        NetworkManager.shared.request(.randomInspection, method: .get, parameters: nil) { [weak self] (responseData) in
            guard let self = self, let response = responseData else { return }
            
            switch response {
            case .success(_, let data):
                do {
                    guard let data = data else { return }
                    var inspectionData = try JSONDecoder().decode(InspectionDataModel.self, from: data)
                    let isSurveyAvailable = PersistentStorageManager.shared.isSurveyAvailable(id: inspectionData.inspection?.id)
                    if isSurveyAvailable {
                        if let id = inspectionData.inspection?.id, let surveyData = PersistentStorageManager.shared.loadData(id: String(id)) {
                            self.inspectionDataSource = surveyData
                        }
                    } else {
                        inspectionData.isSurverySubmitted = false
                        self.inspectionDataSource = inspectionData
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                self.showAlert(title: error.message)
            }
            
        } error: { [weak self] (error) in
            guard let self = self else { return }
            self.showAlert(title: error.debugDescription)
        }
    }
    
    private func submitSurvey(_ param: [String: Any]?) {
        NetworkManager.shared.request(.submit, method: .post, parameters: param) { [weak self] (responseData) in
            guard let self = self, let response = responseData else { return }
            
            switch response {
            case .success:
                self.inspectionDataSource.isSurverySubmitted = true
                let _ = PersistentStorageManager.shared.saveSurvey(data: self.inspectionDataSource)
                self.showAlert(title: "Survey Submitted", message: "Your score is \(self.inspectionDataSource.score)") {
                    self.navigateToSurveyList(self)
                    self.startInspection()
                }
            case .failure(let error):
                self.showAlert(title: error.message)
            }
            self.isSubmitButtonEnabled(true)
            
        } error: { [weak self] (error) in
            guard let self = self else { return }
            self.isSubmitButtonEnabled(true)
        }
    }
    
    private func isSubmitButtonEnabled(_ state: Bool) {
        self.submitButton.isEnabled = state
    }
    
    func getNumberOfRowsIn(section: Int) -> Int {
        if let count = inspectionDataSource.inspection?.survey?.categories?[section].questions?.count {
            return count
        } else {
            return 0
        }
    }
    
    func getNumberOfSection() -> Int {
        if let count = inspectionDataSource.inspection?.survey?.categories?.count {
            return count
        } else {
            return 0
        }
    }
    
    func getTitleForHeaderIn(section: Int) -> String {
        if let name = inspectionDataSource.inspection?.survey?.categories?[section].name {
            return name
        } else {
            return ""
        }
    }
    
    func getQuestionFor(_ indexPath: IndexPath) -> InspectionSurvey.Question? {
        if let question = inspectionDataSource.inspection?.survey?.categories?[indexPath.section].questions?[indexPath.row] {
            return question
        } else {
            return nil
        }
    }
    
    private func checkSurveryStatus() -> (isReadyToSave: Bool, isReadyToSubmit: Bool) {
        var isReadyToSave = false
        var isReadyToSubmit = false
        var selectedAnswersCount = 0
        var totalQuestionCount = 0
        self.inspectionDataSource.inspection?.survey?.categories?.forEach({ survery in
            survery.questions?.forEach({ question in
                totalQuestionCount += 1
                if let _ = question.selectedAnswerChoiceId {
                    isReadyToSave = true
                }
            })
        })
        let _ = self.inspectionDataSource.inspection?.survey?.categories?.map { $0.questions?.map { $0.selectedAnswerChoiceId != nil ? (selectedAnswersCount += 1) : nil } }
        isReadyToSubmit = selectedAnswersCount == totalQuestionCount
        return (isReadyToSave, isReadyToSubmit)
    }
    
    private func checkActionButtonStatus() {
        if let surveySubmitted = self.inspectionDataSource.isSurverySubmitted, surveySubmitted {
            self.saveButton.isHidden = true
            self.submitButton.isHidden = true
        } else if checkSurveryStatus().isReadyToSave && checkSurveryStatus().isReadyToSubmit {
            self.saveButton.isHidden = false
            self.submitButton.isHidden = false
        } else if checkSurveryStatus().isReadyToSave && !checkSurveryStatus().isReadyToSubmit {
            self.saveButton.isHidden = false
            self.submitButton.isHidden = true
        } else {
            self.saveButton.isHidden = true
            self.submitButton.isHidden = true
        }
    }
}
