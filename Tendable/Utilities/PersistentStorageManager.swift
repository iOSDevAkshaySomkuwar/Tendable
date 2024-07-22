//
//  PersistentStorageManager.swift
//  Tendable
//
//  Created by Akshay Somkuwar on 7/22/24.
//

import Foundation

class PersistentStorageManager {
    
    private init() {}
    static let shared = PersistentStorageManager()
    
    private let defaults = UserDefaults.standard
    
    /// This area / method can be used to save data in persistent storage, for now we are using UserDefaults but ideally we shold use CoreData

    // MARK: - Save data to persistent storage
    private func saveData(_ data: InspectionDataModel) {
        do {
            let saveData = try JSONEncoder().encode(data)
            guard let id = data.inspection?.id else { return }
            let key = String(id)
            print(key)
            defaults.set(saveData, forKey: key)
            defaults.synchronize()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Load data from persistent storage
    func loadData(id: String) -> InspectionDataModel? {
        if let data = defaults.data(forKey: id) {
            do {
                let result = try JSONDecoder().decode(InspectionDataModel.self, from: data)
                return result
            } catch {
                print(error)
                return nil
            }
        } else {
            return nil
        }
    }
    
    private func isSurveySubmited(id: String) -> Bool {
        return defaults.bool(forKey: id)
    }
    
    func isSurveyAvailable(id: Int?) -> Bool {
        if let inspectionId = id, let _ = loadData(id: String(inspectionId)) {
            return true
        } else {
            return false
        }
    }
    
    func saveSurvey(data surveyData: InspectionDataModel?) {
        guard let survey = surveyData, let id = survey.inspection?.id else { return }
        saveData(survey)
        let key = String(describing: id)
        var surveyIds: [String] = []
        if let surveyArr = defaults.array(forKey: Keys.surveyList.rawValue) as? [String] {
            surveyIds = surveyArr
        }
        surveyIds.append(key)
        defaults.set(surveyIds, forKey: Keys.surveyList.rawValue)
        defaults.synchronize()
    }
    
    func getSurveyList() -> [InspectionDataModel] {
        var surveyList: [InspectionDataModel] = []
        if let idsList = defaults.array(forKey: Keys.surveyList.rawValue) as? [String] {
            idsList.removingDuplicates.forEach { id in
                guard let survey = loadData(id: id) else { return }
                surveyList.append(survey)
            }
            return surveyList
        } else {
            return surveyList
        }
    }
    
    func saveUser(email: String, password: String) {
        defaults.setValue(email, forKey: Keys.email.rawValue)
        defaults.setValue(password, forKey: Keys.password.rawValue)
        defaults.synchronize()
    }
    
    func isUserLoggedIn() -> Bool {
        let email = (defaults.value(forKey: Keys.email.rawValue) as? String) ?? ""
        let password = (defaults.value(forKey: Keys.password.rawValue) as? String) ?? ""
        return (email.isEmpty && password.isEmpty) ? false : true
    }
}
