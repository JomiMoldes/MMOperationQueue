//
// Created by MIGUEL MOLDES on 25/10/17.
// Copyright (c) 2017 MIGUEL MOLDES. All rights reserved.
//

import Foundation

public class MMSynchronousAction : MMOperationProtocol {

    public var operation: Operation

    public var dependencies = [MMOperationProtocol]()
    public var successDependencies = [MMOperationProtocol]()

    public init(){
        self.operation = MMSyncOperation()
        (self.operation as! MMSyncOperation).delegate = self
    }

    public func execute() throws {
        throw MMError.notOverriden
    }
}
