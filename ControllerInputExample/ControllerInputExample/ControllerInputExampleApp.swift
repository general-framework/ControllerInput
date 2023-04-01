//
//  ControllerInputExampleApp.swift
//  ControllerInputExample
//
//  Created by Jacob Martin on 3/31/23.
//

import SwiftUI
import GameController

#if canImport(UIKit)
private class ControlEventController: GCEventViewController {

    lazy var hostingController: UIHostingController = {
        UIHostingController(rootView: ContentView())
    }()

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

private struct ControlEventView: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> ControlEventController {
        .init()
    }

    func updateUIViewController(_ uiViewController: ControlEventController, context: Context) {

    }
}

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

@main
struct ControllerInputExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ControlEventView()
        }
    }
}

#else

@main
struct ControllerInputExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

#endif
