import Foundation

class MMSyncOperation : Operation {

    weak var delegate:MMOperationProtocol?

    override func main() {
        self.delegate?.execute()
        super.main()
    }

}