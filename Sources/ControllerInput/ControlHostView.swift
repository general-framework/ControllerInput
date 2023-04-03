import SwiftUI
import GameController

// MARK: - iOS/iPadOS specific implementation

#if canImport(UIKit)
private class ControlEventController<Content: View>: GCEventViewController {

    // MARK: - Properties

    private let content: Content

    // MARK: - Initialization

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lazy properties

    lazy var hostingController: UIHostingController = {
        UIHostingController(rootView: content)
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        embed(viewController: hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

private struct ControlEventView<Content: View>: UIViewControllerRepresentable {

    // MARK: - Properties

    private let content: Content

    // MARK: - Initialization

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    // MARK: - UIViewControllerRepresentable

    func makeUIViewController(context: Context) -> ControlEventController<Content> {
        ControlEventController {
            content
        }
    }

    func updateUIViewController(_ uiViewController: ControlEventController<Content>, context: Context) {

    }
}

// MARK: - UIViewController embedding

extension UIViewController {
    /// Embeds a UIViewController inside of another UIViewController using its view.
    /// - Parameters:
    ///   - Parameter viewController: UIViewController to embed
    ///   - Parameter frame:  A frame to be used. Nil by default and used view's frame.
    func embed(viewController: UIViewController, frame: CGRect? = nil) {

        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.view.frame = view.bounds
        viewController.didMove(toParent: self)
    }

    /// Removes an embedded UIViewController from a UIVIewController
    /// - Parameters:
    ///   - Parameter embeddedViewController: UIViewController to remove
    func remove(embeddedViewController: UIViewController) {
        guard children.contains(embeddedViewController) else {
            return
        }

        embeddedViewController.willMove(toParent: nil)
        embeddedViewController.view.removeFromSuperview()
        embeddedViewController.removeFromParent()
    }
}
#endif

// MARK: - ControlHostView

public struct ControlHostView<Content: View>: View {
    @StateObject private var keyboardController = KeyboardController()
    private let content: Content

    // MARK: - Initialization

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    // MARK: - Private computed properties

    private var eventHost: some View {
#if canImport(UIKit)
        ControlEventView {
            content
        }
#else
        content
#endif
    }

    // MARK: - Body

    public var body: some View {
        eventHost
            .padding()
//            .focusable(true)
            .onAppear {
                setupKeyboardHandling()
            }
    }

    // MARK: - Private methods

    func setupKeyboardHandling() {
#if os(macOS)
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            keyboardController.handleKeyPress(keyCode: event.keyCode, pressed: true)
            if event.keyCode == 123 || event.keyCode == 124 || event.keyCode == 125 || event.keyCode == 126 {
                return nil
            }
            return event
        }
        NSEvent.addLocalMonitorForEvents(matching: .keyUp) { event in
            keyboardController.handleKeyPress(keyCode: event.keyCode, pressed: false)
            if event.keyCode == 123 || event.keyCode == 124 || event.keyCode == 125 || event.keyCode == 126 {
                return nil
            }
            return event
        }
#elseif os(iOS)
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { _ in
            UIApplication.shared.sendAction(#selector(UIResponder.becomeFirstResponder), to: nil, from: nil, for: nil)
        }
#endif
    }
}
