import Foundation

class MMAsynchronousOperation : Operation {

    weak var delegate:MMOperationProtocol?

    enum State {
        case Ready, Executing, Finished
    }

    var state = State.Ready {
        willSet{
            switch (state, newValue as State) {
            case (.Ready, .Ready):
                break
            case (.Ready, .Executing):
                willChangeValue(forKey: "isExecuting")
            case (.Ready, .Finished):
                willChangeValue(forKey: "isFinished")
            case (.Executing, .Finished):
                willChangeValue(forKey: "isExecuting")
                willChangeValue(forKey: "isFinished")
            default:
                fatalError()
            }
        }
        didSet{
            switch (oldValue as State, state) {
            case (.Ready, .Ready):
                break
            case (.Ready, .Executing):
                didChangeValue(forKey: "isExecuting")
            case (.Ready, .Finished):
                didChangeValue(forKey: "isFinished")
            case (.Executing, .Finished):
                didChangeValue(forKey: "isExecuting")
                didChangeValue(forKey: "isFinished")
            default:
                fatalError()
            }
        }
    }

    override var isExecuting: Bool {
        return state == State.Executing
    }

    override var isFinished: Bool {
        return state == State.Finished
    }

    override var isAsynchronous: Bool {
        return true
    }

    override func start() {
        guard Thread.isMainThread == false else {
            fatalError("you cannot call start from the main thread")
        }

        guard self.isCancelled == false else {
            self.state = .Finished
            return
        }

        self.state = .Ready
        self.main()
    }

    override func main() {
        guard self.isCancelled == false else {
            self.state = .Finished
            return
        }

        self.state = .Executing
        self.executeAsyncCode()
    }

    private func executeAsyncCode() {
        guard self.isCancelled == false else {
            self.state = .Finished
            return
        }
        self.delegate?.execute()
    }

    func finishOperation() {
        self.state = .Finished
    }


}
