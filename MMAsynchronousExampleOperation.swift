import Foundation

class MMAsynchronousExampleOperation : MMOperationProtocol {

    var operation: Operation

    var dependencies = [MMOperationProtocol]()
    var successDependencies = [MMOperationProtocol]()

    init?(){
        self.operation = MMAsynchronousOperation()
        (self.operation as! MMAsynchronousOperation).delegate = self
    }

    func execute() {
        let url = URL(string:"http://api.ultralingua.com/api/definitions/de/en/laufen")!
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
