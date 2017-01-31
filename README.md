# MMOperationQueue
## MMOperationQueue is a wrapper for OperationQueue. It takes care of asynchronous operations and offers a simpler api.

### Example
``` Swift
let operationsQueue = MMOperationsQueue()

let operation1 = MMAsynchronousExampleOperation()!

let operation2 = MMAsynchronousExampleOperation()!
operation2.successDependencies = [operation1]

let operation3 = MMSyncExampleOperation()!
operation3.dependencies = [operation2]

operationsQueue.completionBlock = {
  self.operationsQueue = nil
}

operationsQueue.addOperations(operations: [operation1, operation2, operation3])
```

You can create an asynchronous or sync operation easily. You only need to conform to the protocol and take care that you call finishOperation(), and cancel() if needed:
``` Swift
class MMAsynchronousExampleOperation : MMOperationProtocol {

    var operation: Operation

    var dependencies = [MMOperationProtocol]()
    var successDependencies = [MMOperationProtocol]()

    init?(){
        self.operation = MMAsynchronousOperation()
        (self.operation as! MMAsynchronousOperation).delegate = self
    }

    func execute() {
        let url = URL(string:"")!
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            guard error == nil else {
                print("error")
                self.operation.cancel()
                (self.operation as! MMAsynchronousOperation).finishOperation()
                return
            }

            guard let data = data else {
                print("no data")
                self.operation.cancel()
                (self.operation as! MMAsynchronousOperation).finishOperation()
                return
            }

            _ = try? JSONSerialization.jsonObject(with: data, options:[])

            (self.operation as! MMAsynchronousOperation).finishOperation()
        }

        task.resume()
    }
}

```
