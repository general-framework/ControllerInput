import Combine
import Foundation

public class KeyboardController: ObservableObject {
    @Published public var leftPressed: Bool = false
    @Published public var rightPressed: Bool = false
    @Published public var upPressed: Bool = false
    @Published public var downPressed: Bool = false

    private var cancellables = Set<AnyCancellable>()

    public init() { }

    public func handleKeyPress(keyCode: UInt16, pressed: Bool) {
        switch keyCode {
        case 123: // left arrow key
            leftPressed = pressed
        case 124: // right arrow key
            rightPressed = pressed
        case 126: // up arrow key
            upPressed = pressed
        case 125: // down arrow key
            downPressed = pressed
        default:
            break
        }
    }
}
