import Foundation

class MMOperationsQueue : NSObject {

    private var operationsQueue = OperationQueue()
    private var operationsList = [MMOperationProtocol]()
    var completionBlock: (() -> ())?

    func addOperations(operations: [MMOperationProtocol]) {
        var list = [Operation]()
        for operation in operations {
            addOperation(operation: operation)
            list.append(operation.operation)
        }
        operationsQueue.addObserver(self, forKeyPath: "operations", options:[.new, .old], context: nil)
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

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
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
                    case "operations":
                        if (newValue as! [Operation]).count == 0 {
                            self.operationsQueue.removeObserver(self, forKeyPath: "operations", context: nil)
                            self.operationsList.removeAll()
                            self.completionBlock?()
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
