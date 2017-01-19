# MMOperationQueue
## Example

let operationsQueue = MMOperationsQueue()

let operation1 = MMAsynchronousExampleOperation()!

let operation2 = MMAsynchronousExampleOperation()!

operation2.successDependencies = [operation1]

let operation3 = MMSyncExampleOperation()!

operation3.dependencies = [operation2]

operationsQueue?.completionBlock = {

  self.operationsQueue = nil
  
}

operationsQueue?.addOperations(operations: [operation1, operation2, operation3])
