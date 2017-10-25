//
// Created by MIGUEL MOLDES on 31/1/17.
// Copyright (c) 2017 MIGUEL MOLDES. All rights reserved.
//

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
