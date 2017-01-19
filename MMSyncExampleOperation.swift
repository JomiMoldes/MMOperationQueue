import Foundation

class MMSyncExampleOperation : MMOperationProtocol {

    var operation: Operation

    var dependencies = [MMOperationProtocol]()
    var successDependencies = [MMOperationProtocol]()

    init?(){
        self.operation = MMSyncOperation()
        (self.operation as! MMSyncOperation).delegate = self
    }

    func execute() {
        print("execute your code here")
    }
}
