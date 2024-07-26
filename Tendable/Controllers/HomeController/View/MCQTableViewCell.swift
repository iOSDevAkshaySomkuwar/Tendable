//
//  MCQTableViewCell.swift
//  Tendable
//
//  Created by Akshay Somkuwar on 7/22/24.
//

import UIKit

class MCQTableViewCell: UITableViewCell {
    private var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .black
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private var answerButtonsStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 5
        sv.distribution = .fillEqually
        sv.alignment = .fill
        return sv
    }()
    
    weak var mcqDataPassDelegate: InspectionSurveyMcqDataPassProtocol? = nil
    var indexPath: IndexPath = IndexPath()
    var answerButtons: [MCQButton] = []
    
    private var dataSource: InspectionSurvey.Question = InspectionSurvey.Question() {
        didSet {
            updateQuestionLabel()
            resetAnswerButtons()
            setupAnswerButtons()
            setupViewsIfNeeded()
        }
    }
    
    private func updateQuestionLabel() {
        questionLabel.text = dataSource.name ?? ""
    }
    
    private func resetAnswerButtons() {
        answerButtons.removeAll()
        answerButtonsStackView.removeAllSubviews()
    }
    
    private func setupAnswerButtons() {
        dataSource.answerChoices?.forEach { answer in
            let button = createMCQButton(for: answer)
            button.button.pressed = { [weak self] sender in
                guard let self = self else { return }
                self.mcqDataPassDelegate?.mcqAnswered(for: self.indexPath, id: button.button.tag)
            }
            answerButtons.append(button)
        }
    }
    
    private func createMCQButton(for answer: InspectionSurvey.AnswerChoice) -> MCQButton {
        let button = MCQButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setup(title: answer.name ?? "", isMCQButtonSelected: answer.isAnswerSelected(self.dataSource.selectedAnswerChoiceId), tag: answer.id)
        return button
    }
    
    private func setupViewsIfNeeded() {
        setupViews()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.backgroundColor = UIColor.clear
        backgroundView?.backgroundColor = UIColor.clear
        self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10000)
        
        answerButtons.forEach { button in
            answerButtonsStackView.addArrangedSubview(button)
        }
        
        contentView.addSubview(bgView)
        bgView.addSubview(questionLabel)
        bgView.addSubview(answerButtonsStackView)
        
        bgView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(10)
            make.right.equalTo(contentView.snp.right).offset(-10)
            make.top.equalTo(contentView.snp.top).offset(10)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
        }
        
        questionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(bgView.snp.left).offset(10)
            make.right.equalTo(bgView.snp.right).offset(-10)
            make.top.equalTo(bgView.snp.top).offset(10)
        }
        
        answerButtonsStackView.snp.makeConstraints { (make) in
            make.left.equalTo(questionLabel.snp.left).offset(0)
            make.right.equalTo(questionLabel.snp.right).offset(0)
            make.top.equalTo(questionLabel.snp.bottom).offset(20)
            make.bottom.equalTo(bgView.snp.bottom).offset(-10)
        }
    }
    
    func populateWith(question: InspectionSurvey.Question?, indexPath: IndexPath) {
        guard let data = question else { return }
        self.indexPath = indexPath
        dataSource = data
    }
}
