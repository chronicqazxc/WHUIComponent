//
//  TableViewViewModelTest.swift
//  WHUIComponentsTests
//
//  Created by Hsiao, Wayne on 2019/9/20.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import XCTest
@testable import WHUIComponents
import WHPromise

public class MockTableViewViewModel: TableViewViewModelProtocol {
    
    fileprivate private(set) var indexOfCurrentSelected: IndexPath?
    
    public var page = Page.initialPage()
    
    public private(set) var state = TableViewState()
    public private(set) var data: [TableViewDataModel]
    public var callback: CallBack?
    
    var isLoadingFinished: Bool = true
    
    required public init(_ callback: @escaping CallBack) {
        self.callback = callback
        self.data = [TableViewDataModel]()
    }
    
    public func willCallBack(_ type: TableViewState.LoadingType) {
        state.loadingType = type
        isLoadingFinished = false
        
    }
    
    public func didCallBack(_ type: TableViewState.LoadingType) {
        state.loadingType = nil
        isLoadingFinished = true
    }
    
    public func willCallBack(_ type: TableViewState.LoadingType, data: [TableViewDataModel]?) {
        
    }
    
    public func apiRequest(type: TableViewState.LoadingType, _ completeHandler: @escaping APIRequestComplete) {
        completeHandler(Data(), nil, nil)
    }
    
    public func apiRequest(type: TableViewState.LoadingType) -> Promise<Data> {
        return Promise<Data>(value: Data())
    }
    
    public func parse(_ data: Data) -> [TableViewDataModel]? {
        let mockData = [
            MockTableViewDataModel(title: "BMW", content: "z4", image: nil),
            MockTableViewDataModel(title: "Mecendes Benz", content: "A1", image: nil),
            MockTableViewDataModel(title: "Audi", content: "Q1", image: nil)
        ]
        self.data = mockData
        return mockData
    }
    
    public func selectDataAt(indexPath: IndexPath) {
        indexOfCurrentSelected = indexPath
    }
    
    public func selectedData() -> [TableViewDataModel] {
        guard let index = indexOfCurrentSelected?.row else {
            return []
        }
        return [data[index]]
    }
}

class TableViewViewModelTest: XCTestCase {
    
    var mockTableViewModel: MockTableViewViewModel!
    var exp: XCTestExpectation!

    override func setUp() {
        exp = expectation(description: "SomeService does stuff and runs the callback closure")
        mockTableViewModel = MockTableViewViewModel { [weak self] (type, data, error) in
            guard let strongSelf = self else {
                return
            }
            
            XCTAssertEqual(strongSelf.mockTableViewModel.data.count, 3)
            strongSelf.exp.fulfill()
        }
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testViewModelDidCallback() {
        mockTableViewModel.refresh()
        XCTAssertTrue(mockTableViewModel.isLoadingFinished)
        waitForExpectations(timeout: 5.0) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }

    func testViewModelLoadingType() {
        mockTableViewModel.refresh()
        
        waitForExpectations(timeout: 5.0) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testSelectDataAt() {
        let indexPath = IndexPath(row: 1, section: 0)
        mockTableViewModel.selectDataAt(indexPath: indexPath)
        XCTAssertEqual(mockTableViewModel.indexOfCurrentSelected, indexPath)
        exp.fulfill()
        waitForExpectations(timeout: 5.0) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testSelected() {
        mockTableViewModel.refresh()
        let indexPath = IndexPath(row: 2, section: 0)
        mockTableViewModel.selectDataAt(indexPath: indexPath)
        XCTAssertEqual(mockTableViewModel.selectedData().first as! MockTableViewDataModel,
                       MockTableViewDataModel(title: "Audi", content: "Q1", image: nil))
        waitForExpectations(timeout: 5.0) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }

}
