//
//  RippleButton.swift
//  SwiftRipple
//
//  Created by Richard Jorne on 2024/7/16.
//

import SwiftUI
import AllTouchGestureModifier

public struct RippleButton<Content: View, Background: View, Ripple: View>: View {
    
    public init(@ViewBuilder content: @escaping (Bool, CGPoint) -> Content, @ViewBuilder background: @escaping (Bool, CGPoint) -> Background, @ViewBuilder ripple: @escaping (CGPoint) -> Ripple, action: @escaping (CGPoint) -> Void, appearAnimation: Animation, disappearAnimation: Animation, ripplePercent: CGFloat?) {
        self.content = content
        self.background = background
        self.action = action
        self.ripple = SwiftRipple(ripple: ripple, appearAnimation: appearAnimation, disappearAnimation: disappearAnimation, ripplePercent: ripplePercent)
    }
    
    public init(@ViewBuilder content: @escaping (Bool, CGPoint) -> Content, @ViewBuilder background: @escaping (Bool, CGPoint) -> Background, @ViewBuilder ripple: @escaping (CGPoint) -> Ripple, action: @escaping (CGPoint) -> Void, appearDuration: Double = 0.4, disappearDuration: Double = 0.4, ripplePercent: CGFloat?){
        self.content = content
        self.background = background
        self.action = action
        self.ripple = SwiftRipple(ripple: ripple, appearAnimation: .easeOut(duration: appearDuration), disappearAnimation: .linear(duration: disappearDuration), ripplePercent: ripplePercent)
    }
    
    public init(@ViewBuilder content: @escaping (Bool, CGPoint) -> Content, @ViewBuilder background: @escaping (Bool, CGPoint) -> Background, action: @escaping (CGPoint) -> Void, ripple: SwiftRipple<Ripple>){
        self.content = content
        self.background = background
        self.action = action
        self.ripple = ripple
    }
    
    private var content: (Bool, CGPoint) -> Content
    private var background: (Bool, CGPoint) -> Background
    private var action: ((CGPoint)->Void)
    private var ripple: SwiftRipple<Ripple>
    
    @State private var disabled: Bool = false
    @State private var tapped: Bool = false
    @State private var pos: CGPoint = .zero
    @State private var state: TouchState = .touchUp
    
    public var body: some View {
        ZStack {
            background(tapped, pos)
            content(tapped, pos)
            ripple
        }
        .animation(nil, value: tapped)
        .fixedSize()
        .opacity(disabled ? 0.6 : 1)
        .animation(.easeInOut(duration: 0.4), value: tapped)
        .allTouchGesture { pos in
            tapped = true
        } onConfirm: { pos in
            action(pos)
        } onTouchUp: { _ in
            tapped = false
        }
    }
    
    private func stateText(_ state: TouchState) -> String {
        switch state {
        case .touchDown:
            return "touchDown"
        case .confirm:
            return "confirm"
        case .touchUp:
            return "touchUp"
        case .cancel:
            return "cancel"
        case .dragging:
            return "dragging"
        case .dragInside:
            return "dragInside"
        case .dragOutside:
            return "dragOutside"
        case .dragEnter:
            return "dragEnter"
        case .dragExit:
            return "dragExit"
        }
    }
}


struct RippleButtonPreviewProvider: View {
    @State var pressing: Bool = false
    @State var n1: Float = 3
    @State var n2: Float = 2
    var body: some View {
        VStack {
            Text("\(String(format: "%.4f", n1))/\(String(format: "%.4f", n2))=\(String(format: "%.4f", n1/n2))")
            RippleButton(content: { pressing, _ in
                Text("Happy \(pressing ? "Impressed " : "Unpressed")")
                    .animation(nil, value: pressing)
                    .padding(.all)
            }, background: { pressing, _ in
                Color(red: 255.0/256.0, green: 158.0/256.0, blue: (pressing ? 105.0 : 11.0)/256.0)
                    .animation(.linear, value: pressing)
                
                if #available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *) {
                    Color.clear
                        .onChange(of: pressing) { newValue in
                            self.pressing = newValue
                        }
                }
            }, ripple: {_ in 
                Color.yellow.opacity(0.6).clipShape(.circle)
            }, action: {_ in 
                n1 = Float.random(in: -999...999)
                n2 = Float.random(in: 1...999)
            }, ripplePercent: 0.7)
            .cornerRadius(14)
            .scaleEffect(x: pressing ? 0.94 : 1.0, y: pressing ? 0.94 : 1.0, anchor: .center)
            .animation(.easeInOut(duration: 0.1), value: pressing)
        }
        .frame(width: 300, height: 300, alignment: .center)
    }
}

#Preview {
    RippleButtonPreviewProvider()
}

