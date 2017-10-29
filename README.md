# MMOperationQueue
## MMOperationQueue is a wrapper for OperationQueue. It takes care of asynchronous operations and offers a simpler api.

### Example
``` Swift
let operationsQueue = MMOperationsQueue()

let operation1 = MMAsynchronousActionExample()

let operation2 = MMAsynchronousActionExample()
operation2.successDependencies = [operation1]

let operation3 = MMSyncActionExample()
operation3.dependencies = [operation2]

operationsQueue.completionBlock = {
	print("operations done")
}

operationsQueue.addOperations(operations: [operation1, operation2, operation3])
```

You can create an asynchronous or sync operation easily. You only need to inherit from MMAsynchronousAction or MMSynchronousAction and take care that you call finishOperation() and/or cancel() if needed:
``` Swift

class AsynchronousActionExample: MMAsynchronousAction {

    override func execute() throws {
        let url = URL(string:"http://api.ultralingua.com/api/definitions/de/en/laufen")!
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            guard error == nil else {
                print("error")
                self.cancelOperation()
                self.finishOperation()
                return
            }

            guard let data = data else {
                print("no data")
                self.cancelOperation()
                self.finishOperation()
                return
            }

            _ = try? JSONSerialization.jsonObject(with: data, options:[])

            self.finishOperation()
        }

        task.resume()
    }

}

class SynchronousActionExample: MMSynchronousAction {

    override func execute() throws {
        // do stuff
        // no need to finish operation
    }

}

```
