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

    var triggers: some View {
        VStack {
            HStack(alignment: .center) {
                Spacer()
                if let l2 = gamepad.elements[id: "l2"] {
                    Image(systemName: l2.state ? l2.pressed : l2.released)
                        .offset(y: CGFloat(l2.value*16)-8).font(.title)
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(colorChange(gamepad.connected), lineWidth: 2))
                }
                Spacer()
                if let r2 = gamepad.elements[id: "r2"] {
                    Image(systemName: r2.state ? r2.pressed : r2.released)
                        .offset(y: CGFloat(r2.value*16)-8).font(.title)
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(colorChange(gamepad.connected), lineWidth: 2))
                }
                Spacer()
            }
            HStack(alignment: .center) {
                Spacer()
                if let l1 = gamepad.elements[id: "l1"] {
                    Image(systemName: l1.state ? l1.pressed : l1.released)
                        .offset(y: CGFloat(l1.value*16)-8).font(.title)
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(colorChange(gamepad.connected), lineWidth: 2))
                }
                Spacer()
                if let r1 = gamepad.elements[id: "r1"] {
                    Image(systemName: r1.state ? r1.pressed : r1.released)
                        .offset(y: CGFloat(r1.value*16)-8).font(.title)
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(colorChange(gamepad.connected), lineWidth: 2))
                }
                Spacer()
            }
        }
    }

    var dPad: some View {
        VStack {
            HStack(alignment: .center) {
                if let up = gamepad.elements[id: "up"] {
                    Image(systemName: up.state ? up.pressed : up.released)
                        .padding(10)
                        .overlay(Circle().stroke(colorChange(gamepad.connected), lineWidth: 2))
                }
            }
            HStack(alignment: .center) {
                if let left = gamepad.elements[id: "left"] {
                    Image(systemName: left.state ? left.pressed : left.released)
                        .padding(10)
                        .overlay(Circle().stroke(colorChange(gamepad.connected), lineWidth: 2))
                }
                Spacer()
                if let right = gamepad.elements[id: "right"] {
                    Image(systemName: right.state ? right.pressed : right.released)
                        .padding(10)
                        .overlay(Circle().stroke(colorChange(gamepad.connected), lineWidth: 2))
                }
            }
            HStack(alignment: .center) {
                if let down = gamepad.elements[id: "down"] {
                    Image(systemName: down.state ? down.pressed : down.released)
                        .padding(10)
                        .overlay(Circle().stroke(colorChange(gamepad.connected), lineWidth: 2))
                }
            }
        }
        .font(.title)
        .foregroundColor(colorChange(gamepad.connected))
        .frame(width: 150, height: 150)
    }

    var shapes: some View {
        VStack {
            HStack(alignment: .center) {
                if let triangle = gamepad.elements[id: "triangle"] {
                    Image(systemName: triangle.state ? triangle.pressed : triangle.released)
                        .padding(10)
                        .overlay(Circle().stroke(colorChange(gamepad.connected), lineWidth: 2))
                }
            }
            HStack(alignment: .center) {
                if let square = gamepad.elements[id: "square"] {
                    Image(systemName: square.state ? square.pressed : square.released)
                        .padding(10)
                        .overlay(Circle().stroke(colorChange(gamepad.connected), lineWidth: 2))
                }
                Spacer()
                if let circle = gamepad.elements[id: "circle"] {
                    Image(systemName: circle.state ? circle.pressed : circle.released)
                        .padding(10)
                        .overlay(Circle().stroke(colorChange(gamepad.connected), lineWidth: 2))
                }
            }
            HStack(alignment: .center) {
                if let cross = gamepad.elements[id: "cross"] {
                    Image(systemName: cross.state ? cross.pressed : cross.released)
                        .padding(10)
                        .overlay(Circle().stroke(colorChange(gamepad.connected), lineWidth: 2))
                }
            }
        }
        .font(.title)
        .foregroundColor(colorChange(gamepad.connected))
        .frame(width: 150, height: 150)
    }

    var joysticks: some View {
        HStack(alignment: .center) {
            Spacer()
            if let l3 = gamepad.elements[id: "l3"] {
                Image(systemName: l3.state ? l3.pressed : l3.released)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
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
                    .frame(width: 200, height: 200)
                    .offset(
                        x: CGFloat(r3.xvalue*20),
                        y: -CGFloat(r3.yvalue*20))
                    .padding()
            }
            Spacer()
        }
    }

    var home: some View {
        VStack {
            triggers
            HStack {
                dPad
                Spacer()
                shapes
            }
            joysticks
        }
        .padding(.horizontal)
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
