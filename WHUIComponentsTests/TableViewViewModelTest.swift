//
//  TableViewViewModelTest.swift
//  WHUIComponentsTests
//
//  Created by Hsiao, Wayne on 2019/9/20.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import XCTest
@testable import WHUIComponents

public class MockTableViewViewModel: TableViewViewModelProtocol {
    public var indexOfCurrentSelected: IndexPath?
    
    public var page = Page.initialPage()
    
    public private(set) var state = TableViewState()
    public private(set) var data: [TableViewDataModel]
    public private(set) var callback: CallBack?
    
    var isLoadingFinished: Bool = true
    
    required public init(_ callback: @escaping CallBack) {
        self.callback = callback
        self.data = [TableViewDataModel]()
    }
    
    public func willCallBack(_ type: TableViewState.LoadingType) {
        state.loadingType = type
        isLoadingFinished = false
        
        switch type {
        case .more:
            data = [
                MockTableViewDataModel(title: "BMW", content: "z4", image: nil),
                MockTableViewDataModel(title: "Mecendes Benz", content: "A1", image: nil)
            ]
        case .refresh:
            data = [
                MockTableViewDataModel(title: "BMW", content: "z4", image: nil),
                MockTableViewDataModel(title: "Mecendes Benz", content: "A1", image: nil),
                MockTableViewDataModel(title: "Audi", content: "Q1", image: nil)
            ]
        }
        
    }
    
    public func didCallBack(_ type: TableViewState.LoadingType) {
        state.loadingType = nil
        isLoadingFinished = true
    }
    
    public func willCallBack(_ type: TableViewState.LoadingType, data: [TableViewDataModel]?) {
        
    }
    
    public func apiRequest(type: TableViewState.LoadingType, _ escapingcompleteHandler: @escaping APIRequestComplete) {
        
    }
    
    public func parse(_ data: Data) -> [TableViewDataModel]? {
        return nil
    }
    
    public func selected(indexPath: IndexPath) {
        
    }
}

class TableViewViewModelTest: XCTestCase {
    
    var mockTableViewModel: MockTableViewViewModel!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testViewModelLoadingType() {
        mockTableViewModel = MockTableViewViewModel { [weak self] (type, data, error) in
            guard let strongSelf = self else {
                return
            }

            switch type {
            case .refresh:
                XCTAssertEqual(strongSelf.mockTableViewModel.data.count, 3)
            case .more:
                XCTAssertEqual(strongSelf.mockTableViewModel.data.count, 2)
            }
        }
        
        mockTableViewModel.getMore()
        mockTableViewModel.refresh()
    }
    
    func testSelected() {
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
