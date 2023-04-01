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
    @ObservedObject var gamepad = GameController()

    var body: some View {
        home
            .frame(width: 500, height: 350)
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
                    .frame(width: 75, height: 75)
                    .offset(
                        x: CGFloat(l3.xvalue*20),
                        y: -CGFloat(l3.yvalue*20))
                    .padding()
            }
            Spacer()
            if let r3 = gamepad.elements[id: "r3"] {
                Image(systemName: r3.state ? r3.pressed : r3.released)
                    .resizable()
                    .frame(width: 75, height: 75)
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
            HStack {
                dPad
                Spacer()
                shapes
            }
            joysticks

//            let columns: [GridItem] = [GridItem(), GridItem(), GridItem(), GridItem()]
//            LazyVGrid(columns: columns) {
//                ForEach(gamepad.elements, id: \.id){ item in
//                    switch item.type{
//
//                    case "button":
//                        Image(systemName: item.state ? item.pressed : item.released).font(.title).padding().foregroundColor(colorChange(gamepad.connected))
//                            .overlay(RoundedRectangle(cornerRadius: 15).stroke(colorChange(gamepad.connected), lineWidth: 2))
//
//                    case "trigger":
//                        Image(systemName: item.state ? item.pressed : item.released).offset(y: CGFloat(item.value*16)-8).font(.title).padding().foregroundColor(colorChange(gamepad.connected))
//                            .overlay(RoundedRectangle(cornerRadius: 15).stroke(colorChange(gamepad.connected), lineWidth: 2))
//
//                    case "stick":
//                        Image(systemName: item.state ? item.pressed : item.released).offset(x: CGFloat(item.xvalue*10), y: -CGFloat(item.yvalue*10)).font(.title).padding().foregroundColor(colorChange(gamepad.connected))
//                            .overlay(RoundedRectangle(cornerRadius: 15).stroke(colorChange(gamepad.connected), lineWidth: 2))
//
//                    case "battery":
//                        VStack{
//                            Image(systemName: battery(item.value, gamepad.state)).font(.title).padding().foregroundColor(colorChange(gamepad.connected))
//                                .overlay(RoundedRectangle(cornerRadius: 15).stroke(colorChange(gamepad.connected), lineWidth: 2))
//                            Text(String(format: "%.f", item.value)+" %").foregroundColor(colorChange(gamepad.connected))
//                        }
//
//                    case "color":
//                        Button(action: {
//                            if gamepad.connected{
//                                presented.toggle()
//                            }
//                        }){
//                            VStack{
//                                Image(systemName: item.released).font(.title).padding().foregroundColor(colorChange(gamepad.connected))
//                                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(colorChange(gamepad.connected), lineWidth: 2))
//                                Text("color").foregroundColor(colorChange(gamepad.connected))
//                            }
//                        }.sheet(isPresented: $presented){
//                            List{
//                                ForEach(gamepad.colors, id: \.id){item in
//                                    Button(action: {
//                                        presented.toggle()
//                                        gamepad.changeColor(item.id)
//                                    }){
//                                        Text(item.name).foregroundColor(item.Color)
//                                    }
//                                }
//                            }
//                        }
//
//                    case "vibration":
//                        Button(action: {
//                            gamepad.vibrate()
//                        }){
//                            VStack{
//                                Image(systemName: item.released).font(.title).padding().foregroundColor(colorChange(gamepad.connected))
//                                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(colorChange(gamepad.connected), lineWidth: 2))
//                                Text("vibration").foregroundColor(colorChange(gamepad.connected))
//                            }
//                        }
//
//                    default:
//                        EmptyView()
//                    }
//                }
//            }

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

    func battery(_ percentage:Float, _ state:GCDeviceBattery.State)-> String{
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
