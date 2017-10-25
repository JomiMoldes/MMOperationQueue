import Foundation

public class MMSyncOperation : Operation {

    weak var delegate:MMOperationProtocol?

    override public func main() {
        do {
            try self.delegate?.execute()
        }catch {
            print("error when trying to execute operation")
        }
        super.main()
    }

}
