//
//  ContentView.swift
//  ControllerInputExample
//
//  Created by Jacob Martin on 3/31/23.
//

import SwiftUI
import GameController
import ControllerInput

struct ContentView: View {
    @State var connectedColor = Color.blue
    @State var number = 0
    @State var presented = false
    @ObservedObject var gamepad = GamepadController()

    var body: some View {
        home
            .padding()
        //            .frame(width: 500, height: 350)
    }

    var leftTriggers: some View {
        GeometryReader { proxy in
            let dimension = proxy.size.width/5
            VStack {
                if let l2 = gamepad.elements[id: "l2"] {
                    Image(systemName: l2.state ? l2.pressed : l2.released)
                        .resizable()
                        .frame(width: dimension, height: dimension)
                        .offset(y: CGFloat(l2.value*16)-8).font(.title)
                }
                if let l1 = gamepad.elements[id: "l1"] {
                    Image(systemName: l1.state ? l1.pressed : l1.released)
                        .resizable()
                        .frame(width: dimension, height: dimension)
                        .offset(y: CGFloat(l1.value*16)-8).font(.title)
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
        }
    }

    var rightTriggers: some View {
        GeometryReader { proxy in
            let dimension = proxy.size.width/5
            VStack {
                if let r2 = gamepad.elements[id: "r2"] {
                    Image(systemName: r2.state ? r2.pressed : r2.released)
                        .resizable()
                        .frame(width: dimension, height: dimension)
                        .offset(y: CGFloat(r2.value*16)-8)
                }

                if let r1 = gamepad.elements[id: "r1"] {
                    Image(systemName: r1.state ? r1.pressed : r1.released)
                        .resizable()
                        .frame(width: dimension, height: dimension)
                        .offset(y: CGFloat(r1.value*16)-8)
                }

            }
            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
        }
    }

    var dPad: some View {
        GeometryReader { proxy in
            let dimension = proxy.size.width/5
            Grid {
                GridRow {
                    Spacer()
                    if let up = gamepad.elements[id: "up"] {
                        Image(systemName: up.state ? up.pressed : up.released)
                            .resizable()
                            .frame(width: dimension, height: dimension)
                    }
                    Spacer()
                }
                GridRow {
                    if let left = gamepad.elements[id: "left"] {
                        Image(systemName: left.state ? left.pressed : left.released)
                            .resizable()
                            .frame(width: dimension, height: dimension)
                    }
                    Spacer()
                    if let right = gamepad.elements[id: "right"] {
                        Image(systemName: right.state ? right.pressed : right.released)
                            .resizable()
                            .frame(width: dimension, height: dimension)
                    }
                }
                GridRow {
                    Spacer()
                    if let down = gamepad.elements[id: "down"] {
                        Image(systemName: down.state ? down.pressed : down.released)
                            .resizable()
                            .frame(width: dimension, height: dimension)
                    }
                    Spacer()
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
        }
    }

    var shapes: some View {
        GeometryReader { proxy in
            let dimension = proxy.size.width/5
            Grid {
                GridRow {
                    Spacer()
                    if let triangle = gamepad.elements[id: "triangle"] {
                        Image(systemName: triangle.state ? triangle.pressed : triangle.released)
                            .resizable()
                            .frame(width: dimension, height: dimension)
                    }
                    Spacer()
                }
                GridRow {
                    if let square = gamepad.elements[id: "square"] {
                        Image(systemName: square.state ? square.pressed : square.released)
                            .resizable()
                            .frame(width: dimension, height: dimension)
                    }
                    Spacer()
                    if let circle = gamepad.elements[id: "circle"] {
                        Image(systemName: circle.state ? circle.pressed : circle.released)
                            .resizable()
                            .frame(width: dimension, height: dimension)
                    }
                }
                GridRow {
                    Spacer()
                    if let cross = gamepad.elements[id: "cross"] {
                        Image(systemName: cross.state ? cross.pressed : cross.released)
                            .resizable()
                            .frame(width: dimension, height: dimension)
                    }
                    Spacer()
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
        }
    }

    var joysticks: some View {
        GeometryReader { proxy in
            let dimension = proxy.size.height/2
            HStack(alignment: .center) {
                Spacer()
                if let l3 = gamepad.elements[id: "l3"] {
                    Image(systemName: l3.state ? l3.pressed : l3.released)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: dimension, height: dimension)
                        .offset(
                            x: CGFloat(l3.xvalue*20),
                            y: -CGFloat(l3.yvalue*20))
                        .padding()
                }
                Spacer()
                if let r3 = gamepad.elements[id: "r3"] {
                    Image(systemName: r3.state ? r3.pressed : r3.released)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: dimension, height: dimension)
                        .offset(
                            x: CGFloat(r3.xvalue*20),
                            y: -CGFloat(r3.yvalue*20))
                        .padding()
                }
                Spacer()
            }
            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
        }
    }

    var home: some View {
        ZStack {
            VStack {
                Spacer()
                joysticks
                    .frame(width: 300, height: 100)
            }
            HStack(spacing: 0) {
                VStack {
                    leftTriggers
                        .frame(width: 150, height: 100)
                    dPad
                        .foregroundColor(colorChange(gamepad.connected))
                        .frame(width: 150, height: 100)
                }
                Spacer()
                VStack {
                    rightTriggers
                        .frame(width: 150, height: 100)
                    shapes
                        .foregroundColor(colorChange(gamepad.connected))
                        .frame(width: 150, height: 100)
                }
            }
        }
        .frame(width: 400, height: 350)
        .scaleEffect(0.5)
    }


    func colorChange(_ connected:Bool) -> Color{
        if connected {
            return Color.green
        } else {
            return Color.blue
        }
    }

    func battery(_ percentage: Float, _ state: GCDeviceBattery.State) -> String{
        if state == .charging {
            return "battery.100.bolt"
        } else {
            if percentage > 75 {
                return "battery.100"
            } else if percentage > 25 {
                return "battery.25"
            } else {
                return "battery.0"
            }
        }
    }
}
