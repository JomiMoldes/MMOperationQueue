//
// Created by MIGUEL MOLDES on 25/10/17.
// Copyright (c) 2017 MIGUEL MOLDES. All rights reserved.
//

import Foundation

class MMSynchronousAction : MMOperationProtocol {

    var operation: Operation

    var dependencies = [MMOperationProtocol]()
    var successDependencies = [MMOperationProtocol]()

    init(){
        self.operation = MMSyncOperation()
        (self.operation as! MMSyncOperation).delegate = self
    }

    func execute() throws {
        throw MMError.notOverriden
    }
}
