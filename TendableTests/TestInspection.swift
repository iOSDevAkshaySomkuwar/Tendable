//
//  TestInspection.swift
//  TendableTests
//
//  Created by Akshay Somkuwar on 7/25/24.
//

import XCTest
@testable import Tendable

final class TestInspection: XCTestCase {
    var networkManager: NetworkManager!
    var inspectionDataModel: InspectionDataModel!
    var storageManager: PersistentStorageManager!

    override func setUpWithError() throws {
        networkManager = NetworkManager()
        inspectionDataModel = InspectionDataModel(inspection: InspectionModel(id: 1))
        storageManager = PersistentStorageManager.shared
    }

    override func tearDownWithError() throws {
        networkManager = nil
        inspectionDataModel = nil
        storageManager = nil
    }
    
    /// This test checks the inspection API with a happy path
    func testInspectionSuccess() {
        let expectation = self.expectation(description: "Starting inspection!")
        networkManager.request(.startInspection, method: .get, parameters: nil) { response in
            expectation.fulfill()
            guard let response = response else {
                XCTFail("Parsing error!")
                return
            }
            switch response {
            case .success(let result, _):
                if let responseCode = result.code {
                    XCTAssertEqual(responseCode, 200, "Expected 200 success code")
                } else {
                    XCTFail("Response code is nil")
                }
            case .failure(let result):
                XCTFail(result.message ?? "Something went wrong, please check local server!")
            }
        } error: { error in
            XCTFail(error.debugDescription)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
    }
    
    /// This test checks the inspection API with an error path
    func testInspectionFailure() {
        let expectation = self.expectation(description: "Getting specific inspection!")
        networkManager.request(.specificInspection, method: .get, parameters: nil) { response in
            expectation.fulfill()
            guard let response = response else {
                XCTFail("Parsing error!")
                return
            }
            switch response {
            case .success(let result, _):
                if let responseCode = result.code {
                    XCTAssertNotEqual(responseCode, 200, "API call should fail and not return 200")
                } else {
                    XCTFail("Response code is nil")
                }
            case .failure(let result):
                if let responseCode = result.code {
                    XCTAssertNotEqual(responseCode, 200, "API call failed!")
                } else {
                    XCTFail(result.message ?? "Something went wrong, please check local server!")
                }
            }
        } error: { error in
            XCTFail(error.debugDescription)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
    }
    
    /// This test checks the inspection API with data decoding
    func testInspectionDataDecoding() {
        let expectation = self.expectation(description: "Starting inspection!")
        networkManager.request(.startInspection, method: .get, parameters: nil) { response in
            expectation.fulfill()
            guard let response = response else {
                XCTFail("Parsing error!")
                return
            }
            switch response {
            case .success(let result, let data):
                if let responseCode = result.code {
                    XCTAssertEqual(responseCode, 200, "Expected 200 success code")
                } else {
                    XCTFail("Response code is nil")
                }
                guard let data = data else {
                    XCTFail("Data is nil")
                    return
                }
                do {
                    let model = try JSONDecoder().decode(InspectionDataModel.self, from: data)
                    XCTAssertNotNil(model, "Decoded model should not be nil")
                    self.inspectionDataModel = model
                    let inspectionTypeName = model.inspection?.type?.name
                    XCTAssertNotNil(inspectionTypeName, "Inspection type name should not be nil")
                } catch let error {
                    XCTFail(error.localizedDescription)
                }
            case .failure(let result):
                XCTFail(result.message ?? "Something went wrong, please check local server!")
            }
        } error: { error in
            XCTFail(error.debugDescription)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
    }
    
    /// Test to check data saving in persistent storage
    func testSaveInspection() {
        let isInspectionDataSaved = storageManager.saveSurvey(data: self.inspectionDataModel)
        XCTAssertTrue(isInspectionDataSaved, "Inspection data should be saved in persistent storage")
    }
    
    /// Test to fetch inspection
    func testFetchInspection() {
        let inspection = storageManager.loadData(id: "1")
        XCTAssertNotNil(inspection, "Inspection should be fetched from persistent storage")
    }
}
