import Foundation

class MMSyncOperation : Operation {

    weak var delegate:MMOperationProtocol?

    override func main() {
        do {
            try self.delegate?.execute()
        }catch {
            print("error when trying to execute operation")
        }
        super.main()
    }

}