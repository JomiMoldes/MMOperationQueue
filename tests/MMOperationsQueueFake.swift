import Foundation
import XCTest

@testable import MMOperationsQueueWrapper

class MMOperationsQueueFake : MMOperationsQueue {

    var completionExpectation : XCTestExpectation?

    override func addOperations(operations: [MMOperationProtocol]) {
        self.completionBlock = {
            self.completionExpectation?.fulfill()
        }
        super.addOperations(operations: operations)
    }

}
