import Foundation
import XCTest

@testable import MMOperationsQueueWrapper

class MMOperationsQueueTest : XCTestCase {

    var operationQueue : MMOperationsQueueFake!

    override func setUp() {
        super.setUp()
        self.operationQueue = MMOperationsQueueFake()
    }

    override func tearDown() {
        super.tearDown()
        operationQueue.completionExpectation = nil
    }

    func testDependencies() {
        let op1 = FakeAsynchronousOperation(name:"testDependAsync",cancel:false)!
        let op2 = FakeSyncOperation(name:"testDependSync",cancel:false)!
        op2.dependencies = [op1]
        let op3 = FakeSyncOperation(name:"testDependSync",cancel:false)!
        op3.successDependencies = [op2]
        let op4 = FakeSyncOperation(name:"testDependSync",cancel:true)!
        op4.successDependencies = [op3]
        let op5 = FakeSyncOperation(name:"testDependSync",cancel:false)!
        op5.successDependencies = [op4]
        let op6 = FakeSyncOperation(name:"testDependSync",cancel:false)!
        op6.dependencies = [op5]

        let asyncExpectation = expectation(description: "operations depending")
        operationQueue.completionExpectation = asyncExpectation

        operationQueue.addOperations(operations: [op1, op2, op3, op4, op5, op6])

        waitForExpectations(timeout: 2.0){
            error in
            guard error == nil else {
                print("no expectation")
                return
            }

            XCTAssertTrue(op1.done)
            XCTAssertTrue(op2.startTime > op1.endTime!)
            XCTAssertTrue(op2.done)

            XCTAssertTrue(op3.startTime > op2.endTime!)
            XCTAssertTrue(op3.done)

            XCTAssertFalse(op4.done)
            XCTAssertFalse(op5.done)

            XCTAssertTrue(op6.startTime > op3.endTime!)
            XCTAssertTrue(op6.done)
        }
    }

}

class FakeAsynchronousOperation : MMOperationProtocol {

    var operation: Operation
    var dependencies = [MMOperationProtocol]()
    var successDependencies = [MMOperationProtocol]()

    var cancel = false
    var done = false
    let name:String!

    var startTime:Date!
    var endTime:Date?

    init?(name:String, cancel : Bool) {
        self.name = name
        operation = MMAsynchronousOperation()
        (operation as! MMAsynchronousOperation).delegate = self
        self.cancel = cancel
    }

    func execute() {
        self.startTime = Date()
        if self.cancel || operation.isCancelled {
            self.endTime = Date()
            operation.cancel()
            (operation as! MMAsynchronousOperation).finishOperation()
            return
        }

        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.global(qos: .background).asyncAfter(deadline: deadlineTime) {
                    self.done = true
                    self.endTime = Date()
                    (self.operation as! MMAsynchronousOperation).finishOperation()
                }
    }

}

class FakeSyncOperation : MMOperationProtocol {

    var operation: Operation
    var dependencies = [MMOperationProtocol]()
    var successDependencies = [MMOperationProtocol]()

    var cancel = false
    var done = false

    let name:String!

    var startTime:Date!
    var endTime:Date?

    init?(name:String, cancel : Bool) {
        self.name = name
        operation = MMSyncOperation()
        (operation as! MMSyncOperation).delegate = self
        self.cancel = cancel
    }

    func execute() {
        self.startTime = Date()
        self.endTime = Date()
        if self.cancel {
            operation.cancel()
            return
        }
        self.done = true
    }

}
