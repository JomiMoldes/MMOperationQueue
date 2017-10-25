import Foundation

enum MMError : Error {
    case notOverriden
}

open class MMOperationsQueue : NSObject {

    private var operationsQueue = OperationQueue()
    private var operationsList = [MMOperationProtocol]()
    public var completionBlock: (() -> ())?

    public func addOperations(operations: [MMOperationProtocol]) {
        let completeOperation = BlockOperation{
            self.operationsList.removeAll()
            self.completionBlock?()
        }
        var list = [Operation]()
        for operation in operations {
            addOperation(operation: operation)
            completeOperation.addDependency(operation.operation)
            list.append(operation.operation)
        }
        list.append(completeOperation)
        operationsQueue.addOperations(list, waitUntilFinished: false)
    }

    private func addOperation(operation:MMOperationProtocol) {
        operationsList.append(operation)
        operation.operation.addObserver(self, forKeyPath: "isCancelled", options:[.new, .old], context: nil)
        let allDependencies = operation.dependencies + operation.successDependencies

        for dependency in allDependencies {
            let exists = operation.operation.dependencies.contains{
                $0 === dependency.operation
            }
            if !exists {
                operation.operation.addDependency(dependency.operation)
            }
        }
    }

    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let newValue = change?[.newKey] as? NSObject {
            if let oldValue = change?[.oldKey] as? NSObject {
                if !newValue.isEqual(oldValue as Any) {
                    switch keyPath! {
                    case "isCancelled":
                        if let operation = object as? Operation {
                            for operationQueued in self.operationsList {
                                if operationQueued.operation == operation {
                                    continue
                                }
                                for dependency in operationQueued.successDependencies {
                                    if dependency.operation == operation {
                                        operationQueued.operation.cancel()
                                    }
                                }
                            }
                        }
                        break
                    default:
                        break
                    }
                }
            }
        }
    }

}