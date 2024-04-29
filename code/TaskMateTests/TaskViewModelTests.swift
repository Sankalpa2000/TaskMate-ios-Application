
//  TaskViewModelTests.swift
//  TaskMateTests
//
//  Created by Macbook Pro 2018 on 2024-04-24.


//import XCTest
//@testable import TaskMate // Import your app module
//
//class TaskViewModelTests: XCTestCase {
//    
//    var viewModel: TaskViewModel!
//    
//    override func setUp() {
//        super.setUp()
//        viewModel = TaskViewModel()
//    }
//    
//    override func tearDown() {
//        viewModel = nil
//        super.tearDown()
//    }
//    
//    func testFetchTask() {
//        // Given
//        let expectation = XCTestExpectation(description: "Fetch tasks")
//        
//        // When
//        viewModel.fetchTask()
//        
//        // Then
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            XCTAssertFalse(self.viewModel.tasks.isEmpty)
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 3)
//    }
//}
