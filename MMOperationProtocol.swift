import Foundation

@objc protocol MMOperationProtocol {

    var operation:Operation { get set }

    var dependencies:[MMOperationProtocol] { get set }

    var successDependencies:[MMOperationProtocol] { get set }

    func execute()

}
