//
//  SwiftRipple.swift
//  SwiftRipple
//
//  Created by Richard Jorne on 2024/7/16.
//

import SwiftUI

public struct SwiftRipple<Ripple: View>: View {
    
    public init(@ViewBuilder ripple: @escaping (CGPoint) -> Ripple, appearAnimation: Animation, disappearAnimation: Animation, ripplePercent: CGFloat?, disappearApproach: RippleDisappearApproach = .extendOpacityDisappear) {
        self.ripple = ripple
        self.appearAnimation = appearAnimation
        self.disappearAnimation = disappearAnimation
        self.ripplePercent = ripplePercent
        self.disappearApproach = disappearApproach
    }
    
    public init(@ViewBuilder ripple: @escaping (CGPoint) -> Ripple, appearDuration: Double = 0.4, disappearDuration: Double = 0.4, ripplePercent: CGFloat?, disappearApproach: RippleDisappearApproach = .extendOpacityDisappear){
        self.ripple = ripple
        self.appearAnimation = .easeOut(duration: appearDuration)
        self.disappearAnimation = .linear(duration: disappearDuration)
        self.ripplePercent = ripplePercent
        self.disappearApproach = disappearApproach
    }
    
    private var ripple: (CGPoint) -> Ripple
    private var appearAnimation: Animation
    private var disappearAnimation: Animation
    private var ripplePercent: CGFloat?
    private var disappearApproach: RippleDisappearApproach
    
    @State private var rippleDiameter: CGFloat = 50.0
    @State private var ripples: [RippleParameter] = []
    @State private var pos: CGPoint = .zero
    
    public var body: some View{
        GeometryReader { geometry in
            ZStack {
                Color.clear
                    .contentShape(Rectangle())
                ForEach(ripples, id: (\.id)) { r in
                    ripple(pos)
                        .frame(width: r.diameter, height: r.diameter, alignment: .center)
                        .position(x: r.pos.x, y: r.pos.y)
                        .transition(.asymmetric(
                            insertion: .scale(scale: 0.3, anchor: .init(x: r.pos.x/geometry.size.width, y: r.pos.y/geometry.size.height)).animation(appearAnimation).combined(with: .opacity).animation(appearAnimation),
                            // 2.8286 is the 2*sqrt(2)
                            removal: (disappearApproach == .opacityDisappear ? .opacity : .scale(scale: max(geometry.size.width/r.diameter,geometry.size.height/r.diameter)*2.8286+0.1, anchor: .init(x: r.pos.x/geometry.size.width, y: r.pos.y/geometry.size.height)).animation(disappearAnimation).combined(with: .opacity.animation(disappearAnimation.delay(0.1))))))
                        .scaleEffect(x: r.scale, y: r.scale, anchor: .init(x: r.pos.x/geometry.size.width, y: r.pos.y/geometry.size.height))
                }
            }
            .onAppear {
                if let ripplePercent = ripplePercent {
                    self.rippleDiameter = max(geometry.size.width, geometry.size.height) * ripplePercent
                }
            }
            .allTouchGesture(onTouchDown: { pos in
                self.pos = pos
                withAnimation {
                    ripples.append(RippleParameter(pos: pos, diameter: self.rippleDiameter))
                }
            }, onTouchUp: { _ in
                withAnimation {
                    if !ripples.isEmpty {
                        _ = ripples.removeFirst()
                    }
                }
            })
        }
    }
    
}

public enum RippleDisappearApproach {
    case opacityDisappear
    case extendOpacityDisappear
}



struct SwiftRipplePreviewProvider: View {
    var body: some View {
        VStack {
            SwiftRipple(ripple: {_ in 
                Color.yellow.opacity(0.5)
                    .clipShape(.circle)
            }, appearDuration: 0.3, disappearDuration: 0.7, ripplePercent: 0.7, disappearApproach: .extendOpacityDisappear)
        }
        .frame(width: 360, height: 500, alignment: .center)
    }
}

#Preview {
    SwiftRipplePreviewProvider()
}
