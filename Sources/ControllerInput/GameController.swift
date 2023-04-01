import GameController
import CoreHaptics
import Combine
import SwiftUI
import IdentifiedCollections

public class GameController: ObservableObject{
    @Published public var connected = false
    @Published public var state = GCDeviceBattery.State.unknown
    var number = 0

    public struct ControlElement: Identifiable {
        public var name: String
        public var released: String
        public var pressed: String
        public var state: Bool = false
        public var value: Float = 0
        public var xvalue: Float = 0
        public var yvalue: Float = 0
        public var type: String

        public var id: String {
            return name
        }
    }

    public struct IndicatorColor: Identifiable {
        public var id:Int
        public var name: String
        public var color: GCColor
        public var Color: Color
    }

    @Published public var elements: IdentifiedArrayOf<ControlElement> = [
        ControlElement(name: "left", released: "chevron.left.circle", pressed: "chevron.left.circle.fill", type: "button"),
        ControlElement(name: "up", released: "chevron.up.circle", pressed: "chevron.up.circle.fill", type: "button"),
        ControlElement(name: "right", released: "chevron.right.circle", pressed: "chevron.right.circle.fill", type: "button"),
        ControlElement(name: "down", released: "chevron.down.circle", pressed: "chevron.down.circle.fill", type: "button"),
        ControlElement(name: "square", released: "square.circle", pressed: "square.circle.fill", type: "button"),
        ControlElement(name: "triangle", released: "triangle.circle", pressed: "triangle.circle.fill", type: "button"),
        ControlElement(name: "circle", released: "circle.circle", pressed: "circle.circle.fill", type: "button"),
        ControlElement(name: "cross", released: "multiply.circle", pressed: "multiply.circle.fill", type: "button"),
        ControlElement(name: "share", released: "square.and.arrow.up", pressed: "square.and.arrow.up.fill", type: "button"),
        ControlElement(name: "options", released: "command.circle", pressed: "command.circle.fill", type: "button"),
        ControlElement(name: "l3", released: "dot.arrowtriangles.up.right.down.left.circle", pressed: "record.circle.fill", type: "stick"),
        ControlElement(name: "r3", released: "dot.arrowtriangles.up.right.down.left.circle", pressed: "record.circle.fill", type: "stick"),
        ControlElement(name: "l1", released: "l1.rectangle.roundedbottom", pressed: "l1.rectangle.roundedbottom.fill", type: "button"),
        ControlElement(name: "r1", released: "r1.rectangle.roundedbottom", pressed: "r1.rectangle.roundedbottom.fill", type: "button"),
        ControlElement(name: "l2", released: "l2.rectangle.roundedtop", pressed: "l2.rectangle.roundedtop.fill", type: "trigger"),
        ControlElement(name: "r2", released: "r2.rectangle.roundedtop", pressed: "r2.rectangle.roundedtop.fill", type: "trigger"),
        ControlElement(name: "battery", released: "battery.0", pressed: "battery.100", type: "battery"),
        ControlElement(name: "color", released: "timelapse", pressed: "paintpalette", type: "color"),
        ControlElement(name: "vibration", released: "dot.radiowaves.left.and.right", pressed: "dot.radiowaves.left.and.right", type: "vibration"),
    ]

    @Published public var colors: IdentifiedArrayOf<IndicatorColor> = [
        IndicatorColor(id: 0, name: "green", color: GCColor(red: 0, green: 100, blue: 0), Color: .green),
        IndicatorColor(id: 1, name: "red", color: GCColor(red: 100, green: 0, blue: 0), Color: .red),
        IndicatorColor(id: 2, name: "blue", color: GCColor(red: 0, green: 0, blue: 100), Color: .blue),
        IndicatorColor(id: 3, name: "yellow", color: GCColor(red: 100, green: 100, blue: 0), Color: .yellow),
        IndicatorColor(id: 4, name: "white", color: GCColor(red: 100, green: 100, blue: 100), Color: .white),
        IndicatorColor(id: 5, name: "black", color: GCColor(red: 0, green: 0, blue: 0), Color: .black),
    ]

    public func changeColor(_ id:Int){
        GCController.current?.light?.color = colors[id].color
    }

    public func vibrate(){
        guard let controller = GCController.current else { return }
        guard let engine = createEngine(for: controller, locality: .default) else { return }
        let url = Bundle.main.url(forResource: "hit", withExtension: "ahap")
        do{
            try engine.start()
            try engine.playPattern(from: url!)
        }catch{
            print(error)
        }
    }

    func createEngine(for controller: GCController, locality: GCHapticsLocality) -> CHHapticEngine? {
        guard let engine = controller.haptics?.createEngine(withLocality: locality) else {
            print("failed to create engine.")
            return nil
        }
        engine.stoppedHandler = { reason in
            print("fail")
        }
        engine.resetHandler = {
            print("the engine reset")
            do{
                try engine.start()
            }catch{
                print("failed to restart the engine: \(error)")
            }
        }
        return engine
    }

    public init() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.GCControllerDidConnect, object: nil, queue: nil, using: didConnectController)
        NotificationCenter.default.addObserver(forName: NSNotification.Name.GCControllerDidDisconnect, object: nil, queue: nil, using: didDisconnectController)
        GCController.startWirelessControllerDiscovery{}
    }

    func didConnectController(_ notification: Notification) {
        connected = true
        let controller = notification.object as! GCController
        print("◦ connected \(controller.productCategory)")
        elements[16].value = controller.battery?.batteryLevel ?? 0 * 100
        state = controller.battery?.batteryState ?? .unknown
        controller.extendedGamepad?.dpad.left.pressedChangedHandler = { (button, value, pressed) in self.button(0, pressed) }
        controller.extendedGamepad?.dpad.up.pressedChangedHandler = { (button, value, pressed) in self.button(1, pressed) }
        controller.extendedGamepad?.dpad.right.pressedChangedHandler = { (button, value, pressed) in self.button(2, pressed) }
        controller.extendedGamepad?.dpad.down.pressedChangedHandler = { (button, value, pressed) in self.button(3, pressed) }
        controller.extendedGamepad?.buttonX.pressedChangedHandler = { (button, value, pressed) in self.button(4, pressed) }
        controller.extendedGamepad?.buttonY.pressedChangedHandler = { (button, value, pressed) in self.button(5, pressed) }
        controller.extendedGamepad?.buttonB.pressedChangedHandler = { (button, value, pressed) in self.button(6, pressed) }
        controller.extendedGamepad?.buttonA.pressedChangedHandler = { (button, value, pressed) in self.button(7, pressed) }
        controller.extendedGamepad?.buttonOptions?.pressedChangedHandler = { (button, value, pressed) in self.button(8, pressed) }
        controller.extendedGamepad?.buttonMenu.pressedChangedHandler = { (button, value, pressed) in self.button(9, pressed) }
        controller.extendedGamepad?.leftThumbstickButton?.pressedChangedHandler = { (button, value, pressed) in self.button(10, pressed) }
        controller.extendedGamepad?.rightThumbstickButton?.pressedChangedHandler = { (button, value, pressed) in self.button(11, pressed) }
        controller.extendedGamepad?.leftShoulder.pressedChangedHandler = { (button, value, pressed) in self.button(12, pressed) }
        controller.extendedGamepad?.rightShoulder.pressedChangedHandler = { (button, value, pressed) in self.button(13, pressed) }
        controller.extendedGamepad?.leftTrigger.pressedChangedHandler = { (button, value, pressed) in self.button(14, pressed) }
        controller.extendedGamepad?.rightTrigger.pressedChangedHandler = { (button, value, pressed) in self.button(15, pressed) }
        controller.extendedGamepad?.leftTrigger.valueChangedHandler = { (button, value, pressed) in self.trigger(14, value) }
        controller.extendedGamepad?.rightTrigger.valueChangedHandler = { (button, value, pressed) in self.trigger(15, value) }
        controller.extendedGamepad?.leftThumbstick.valueChangedHandler = { (button, xvalue, yvalue) in self.stick(10, xvalue, yvalue) }
        controller.extendedGamepad?.rightThumbstick.valueChangedHandler = { (button, xvalue, yvalue) in self.stick(11, xvalue, yvalue) }
    }

    func didDisconnectController(_ notification: Notification) {
        connected = false
        elements[16].value = 0
        let controller = notification.object as! GCController
        print("◦ disConnected \(controller.productCategory)")
    }

    func button(_ button: Int, _ pressed: Bool){
        elements[button].state = pressed
    }

    func trigger(_ button: Int, _ value: Float){
        elements[button].value = value
    }

    func stick(_ button: Int, _ xvalue: Float, _ yvalue: Float){
        elements[button].xvalue = xvalue
        elements[button].yvalue = yvalue
    }
}

extension GameController {
    public func connectedStream() -> AsyncStream<Bool> {
        return AsyncStream<Bool> { continuation in
            let cancellable = _connected.projectedValue.sink { value in
                continuation.yield(value)
            }

            continuation.onTermination = { @Sendable _ in
                cancellable.cancel()
            }
        }
    }

    public func stateStream() -> AsyncStream<GCDeviceBattery.State> {
        return AsyncStream<GCDeviceBattery.State> { continuation in
            let cancellable = _state.projectedValue.sink { value in
                continuation.yield(value)
            }

            continuation.onTermination = { @Sendable _ in
                cancellable.cancel()
            }
        }
    }

    public func elementsStream() -> AsyncStream<IdentifiedArrayOf<ControlElement>> {
        return AsyncStream<IdentifiedArrayOf<ControlElement>> { continuation in
            let cancellable = _elements.projectedValue.sink { value in
                continuation.yield(value)
            }

            continuation.onTermination = { @Sendable _ in
                cancellable.cancel()
            }
        }
    }

    public func colorsStream() -> AsyncStream<IdentifiedArrayOf<IndicatorColor>> {
        return AsyncStream<IdentifiedArrayOf<IndicatorColor>> { continuation in
            let cancellable = _colors.projectedValue.sink { value in
                continuation.yield(value)
            }

            continuation.onTermination = { @Sendable _ in
                cancellable.cancel()
            }
        }
    }
}
