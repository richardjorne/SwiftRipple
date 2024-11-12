// Created by Richard Jorne 07/16 2024

import SwiftUI

public struct RippleButton<Content: View, Background: View, Ripple: View>: View {
    
    init(@ViewBuilder content: () -> Content, @ViewBuilder background: () -> Background, @ViewBuilder ripple: @escaping () -> Ripple, action: @escaping () -> Void, appearAnimation: Animation, disappearAnimation: Animation, ripplePercent: CGFloat?) {
        self.content = content()
        self.background = background()
        self.ripple = ripple
        self.action = action
        self.appearAnimation = appearAnimation
        self.disappearAnimation = disappearAnimation
        self.ripplePercent = ripplePercent
    }
    
    init(@ViewBuilder content: () -> Content, @ViewBuilder background: () -> Background, @ViewBuilder ripple: @escaping () -> Ripple, action: @escaping () -> Void, appearDuration: Double = 0.4, disappearDuration: Double = 2, ripplePercent: CGFloat?){
        self.content = content()
        self.background = background()
        self.ripple = ripple
        self.action = action
        self.appearAnimation = .easeOut(duration: 0.5)
        self.disappearAnimation = .linear(duration: disappearDuration)
        self.ripplePercent = ripplePercent
    }
    
    private var content: Content
    private var background: Background
    private var ripple: () -> Ripple
    private var action: (()->Void)
    private var appearAnimation: Animation
    private var disappearAnimation: Animation
    private var ripplePercent: CGFloat?
    
    @State private var rippleDiameter: CGFloat = 50.0
    @State private var disabled: Bool = false
    @State private var ripples: [RippleParameter] = []
    
    public var body: some View {
        GeometryReader { geo in
            ZStack {
                ZStack {
                    Color.primary
                    background
                    content
                }.opacity(disabled ? 0.5 : 1)
                Color.primary.opacity(disabled ? 0.5 : 0)
            }
            .onAppear(perform: {
                if let ripplePercent = ripplePercent {
                    self.rippleDiameter = max(geo.size.width,geo.size.height)*ripplePercent
                }
            })
            .overlay {
                ForEach(ripples, id: (\.id)) { r in
                    ripple()
                        .frame(width: rippleDiameter, height: rippleDiameter, alignment: .center)
                        .clipShape(.circle)
                        .position(x: r.pos.x, y: r.pos.y)
                        .transition(.asymmetric(insertion: .scale(scale: 0.3, anchor: .init(x: r.pos.x/geo.size.width, y: r.pos.y/geo.size.height)).animation(.easeOut(duration: 0.5)), removal: .opacity.animation(.linear)))
                }
            }
            .pressPosition(beginAction: { pos in
                withAnimation {
                    ripples.append(RippleParameter(pos: pos))
                }
            }, endAction: { _ in
                withAnimation {
                    if !ripples.isEmpty {
                        _ = ripples.removeFirst()
                    }
                }
            })
            .animation(.easeInOut(duration: 0.3), value: disabled)
        }
    }
}


struct RButtonPreviewProvider: View {
    var body: some View {
        ZStack {
            RippleButton(content: {
                Text("Happy")
            }, background: {
                Color.orange
            }, ripple: {
                Color.yellow.opacity(0.6)
            }, action: {
                
            }, ripplePercent: 1)
            .cornerRadius(14)
            .frame(width: 120, height: 50, alignment: .center)
        }
        .frame(width: 300, height: 300, alignment: .center)
    }
}

fileprivate class RippleParameter: ObservableObject, Identifiable {
    
    init(pos: CGPoint) {
        self.pos = pos
    }
    
    var id = UUID()
    var pos: CGPoint
}

#Preview {
    RButtonPreviewProvider()
}

