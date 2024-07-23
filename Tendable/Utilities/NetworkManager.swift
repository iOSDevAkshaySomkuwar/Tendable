//
//  NetworkManager.swift
//  Tendable
//
//  Created by Akshay Somkuwar on 7/20/24.
//

import Foundation
import Alamofire

enum Endpoints: String {
    case register = "register"
    case login = "login"
    case startInspection = "inspections/start"
    case randomInspection = "random_inspection"
    case generateRandomInspection = "generate_random_inspections/5"
    case submit = "inspections/submit"
}

enum EnvironmentUrl: String {
    case development = "http://127.0.0.1:5001/api/"
    case preProduction = "https://preProduction/"
    case production = "https://production/"
}

enum Environment {
    case development
    case preProduction
    case production
    var baseUrl: String {
        switch self {
        case .development:
            return EnvironmentUrl.development.rawValue
        case .preProduction:
            return EnvironmentUrl.preProduction.rawValue
        case .production:
            return EnvironmentUrl.production.rawValue
        }
    }
}

enum NetworkRequestResponse {
    case success(NetworkRequestResult, Data?)
    case failure(NetworkRequestResult)
}

struct NetworkRequestResult {
    var code: Int?
    var success: Bool {
        guard let code = code else { return false }
        switch code {
        case 200:
            return true
        default:
            return false
        }
    }
    var error: String?
    var message: String? {
        let defaultErrorMessage = "We ran into an error, plase try again!"
        guard let code = code else { return defaultErrorMessage }
        switch code {
        case 200:
            return "Request successful!"
        default:
            if let error = error {
                return error
            } else {
                return defaultErrorMessage
            }
        }
    }
}


//MARK:- Network Manager Class
class NetworkManager: NSObject {
    static let shared = NetworkManager()
    
    class func baseUrl() -> String {
        return NetworkManager.domain()
    }
    
    class func domain() -> String {
        return Constant.environment.baseUrl
    }
    
    var header: [String: String] = [
        "Content-Type": "application/json",//"application/x-www-form-urlencoded",
        "Accept": "application/json",
    ]
    
    var authenticatedHeader = [
        "Content-Type": "application/json",
        "Accept": "application/json"
    ]
    
    func request(
        _ endpoint: Endpoints,
        method: Alamofire.HTTPMethod = .post,
        showLoading: Bool = true,
        isJsonEncoding: Bool = true,
        parameters: [String: Any]?,
        _ completion: @escaping (NetworkRequestResponse?) -> Void,
        error: @escaping (NetworkRequestResponse?) -> Void) {
            let headers: HTTPHeaders = HTTPHeaders(self.header)
            guard let url = URL(string: NetworkManager.baseUrl() + endpoint.rawValue) else { return }
            print("URL -> ", url)
            print("PARAMETERS -> ", parameters ?? [:])
            print("CALL STARTED")
            AF.request(url, method: method, parameters: parameters, encoding: isJsonEncoding ? JSONEncoding.default : URLEncoding.default, headers: headers, interceptor: nil, requestModifier: nil).response { response in
                print("CALL ENDED")
                
                // Loader can be handled here
                let statusCode = response.response?.statusCode ?? 400
                switch response.result {
                case .success:
                    switch statusCode {
                    case 200..<300:
                        let requestResult = NetworkRequestResult(code: statusCode)
                        completion(.success(requestResult, response.data))
                    default:
                        var requestResult = NetworkRequestResult(code: statusCode)
                        do {
                            guard let data = response.data else { return }
                            let apiErrorData = try JSONDecoder().decode(APIErrorModel.self, from: data)
                            requestResult.error = apiErrorData.error
                            completion(.failure(requestResult))
                        } catch let error {
                            print(error.localizedDescription)
                            requestResult.error = error.localizedDescription
                            completion(.failure(requestResult))
                        }
                    }
                case .failure:
                    // Loader can be handled here
                    let requestResult = NetworkRequestResult(code: statusCode)
                    completion(.failure(requestResult))
                }
            }
        }
}

