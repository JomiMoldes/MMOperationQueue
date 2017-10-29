import Foundation

public class MMAsynchronousActionExample: MMAsynchronousAction {

    override open func execute() throws {
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