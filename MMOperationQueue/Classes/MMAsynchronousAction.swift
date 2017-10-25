//
// Created by MIGUEL MOLDES on 25/10/17.
// Copyright (c) 2017 MIGUEL MOLDES. All rights reserved.
//

import Foundation

open class MMAsynchronousAction : MMOperationProtocol {

    public var operation: Operation

    public var dependencies = [MMOperationProtocol]()
    public var successDependencies = [MMOperationProtocol]()

    public init(){
        self.operation = MMAsynchronousOperation()
        (self.operation as! MMAsynchronousOperation).delegate = self
    }

    public func execute() throws {
        throw MMError.notOverriden
    }

}
