//
//  Pulse.swift
//  SwiftRipple
//
//  Created by Richard Jorne on 2024/7/16.
//

import SwiftUI

public struct Pulse<Ripple: View>: View {
    
    public init(@ViewBuilder ripple: @escaping (Bool, CGPoint) -> Ripple, appearAnimation: Animation, disappearAnimation: Animation, defaultRipplePercent: CGFloat? = 0.8, disappearApproach: RippleDisappearApproach = .extendOpacityDisappear, ripples: Binding<[RippleParameter]>, allowTouch: Bool = false) {
        self.ripple = ripple
        self.appearAnimation = appearAnimation
        self.disappearAnimation = disappearAnimation
        self.ripplePercent = defaultRipplePercent
        self.disappearApproach = disappearApproach
        self._ripples = ripples
        self.allowTouch = allowTouch
    }
    
    public init(@ViewBuilder ripple: @escaping (Bool, CGPoint) -> Ripple, appearDuration: Double = 0.4, disappearDuration: Double = 0.4, defaultRipplePercent: CGFloat? = 0.8, disappearApproach: RippleDisappearApproach = .extendOpacityDisappear, ripples: Binding<[RippleParameter]>, allowTouch: Bool = false){
        self.ripple = ripple
        self.appearAnimation = .easeOut(duration: appearDuration)
        self.disappearAnimation = .linear(duration: disappearDuration)
        self.ripplePercent = defaultRipplePercent
        self.disappearApproach = disappearApproach
        self._ripples = ripples
        self.allowTouch = allowTouch
    }
    
    private var ripple: (Bool, CGPoint) -> Ripple
    private var appearAnimation: Animation
    private var disappearAnimation: Animation
    private var ripplePercent: CGFloat?
    private var disappearApproach: RippleDisappearApproach
    private var allowTouch: Bool = false
    @Binding private var ripples: [RippleParameter]
    
    @State private var rippleDiameter: CGFloat = 50.0
    @State private var tapped: Bool = false
    @State private var pos: CGPoint = .zero
    
    
    public var body: some View{
        GeometryReader { geometry in
            ZStack {
                Color.clear
                    .contentShape(Rectangle())
                ForEach(ripples, id: (\.id)) { r in
                    ripple(tapped, pos)
                        .frame(width: r.diameter > 0 ? r.diameter : rippleDiameter, height: r.diameter > 0 ? r.diameter : rippleDiameter, alignment: .center)
                        .position(x: r.pos.x, y: r.pos.y)
                        .transition(.asymmetric(
                            insertion: .scale(scale: 0.3, anchor: .init(x: r.pos.x/geometry.size.width, y: r.pos.y/geometry.size.height)).animation(appearAnimation).combined(with: .opacity).animation(appearAnimation),
                            removal: (disappearApproach == .opacityDisappear ? .opacity : .scale(scale: max(geometry.size.width/(r.diameter > 0 ? r.diameter : rippleDiameter),geometry.size.height/(r.diameter > 0 ? r.diameter : rippleDiameter))*2+0.1, anchor: .init(x: r.pos.x/geometry.size.width, y: r.pos.y/geometry.size.height)).animation(disappearAnimation).combined(with: .opacity.animation(disappearAnimation.delay(0.1))))))
                        .scaleEffect(x: r.scale, y: r.scale, anchor: .init(x: r.pos.x/geometry.size.width, y: r.pos.y/geometry.size.height))
                }
            }
            .onAppear {
                if let ripplePercent = ripplePercent {
                    self.rippleDiameter = max(geometry.size.width, geometry.size.height) * ripplePercent
                }
            }
            .allTouchGesture(onTouchDown: { pos, size in
                if allowTouch {
                    withAnimation {
                        ripples.append(RippleParameter(pos: pos, diameter: self.rippleDiameter))
                    }
                }
            }, onTouchUp: { _, _ in
                if allowTouch {
                    withAnimation {
                        if !ripples.isEmpty {
                            _ = ripples.removeFirstExternalRipple()
                        }
                    }
                }
            })
        }
    }
    
}

struct PulsePreviewProvider: View {
    
    enum PulsePreviewType {
        case single
        case ripple
    }
    
    var type: PulsePreviewType
    
    @State private var ripples: [RippleParameter] = []
    @State private var timer: Timer?
    @State private var size: CGSize = .zero
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Pulse(ripple: { _, _ in
                    Color.blue.clipShape(.circle).opacity(type == .ripple ? 0.6 : 1.0)
                }, appearAnimation: .timingCurve(0.726, 0.025, 0.124, 0.69, duration: 0.8), disappearAnimation: .spring, defaultRipplePercent: 0.6,ripples: $ripples, allowTouch: true)
                .onAppear {
                    size = geo.size
                    timer?.invalidate()
                    if type == .single {
                        timer = Timer.scheduledTimer(withTimeInterval: 1.2, repeats:    true) { _ in
                            DispatchQueue.main.async {
                                ripples.append(RippleParameter(pos: CGPoint(x:  size.width/2, y: size.height/2), diameter: -1, isInternal: true))
                            }
                            Timer.scheduledTimer(withTimeInterval: 0.82, repeats:    false) { _ in
                                DispatchQueue.main.async {
                                    ripples.removeFirstInternalRipple()
                                }
                            }
                        }
                    } else if type == .ripple {
                        timer = Timer.scheduledTimer(withTimeInterval: 2.3, repeats:    true) { _ in
                            for delay in [0.0,0.15,0.3] {
                                Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
                                    DispatchQueue.main.async {
                                        ripples.append(RippleParameter(pos: CGPoint(x:  size.width/2, y: size.height/2), diameter: -1, scale: 1-delay, isInternal: true))
                                    }
                                }
                            }
                            
                            Timer.scheduledTimer(withTimeInterval: 0.8, repeats:    false) { _ in
                                for delay in [0.0,0.1,0.2] {
                                    Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
                                        DispatchQueue.main.async {
                                            ripples.removeFirstInternalRipple()
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                }
            }
            .onDisappear {
                timer?.invalidate()
                timer = nil
            }
        }
        .frame(width: 300, height: 300, alignment: .center)
    }
}



#Preview {
    PulsePreviewProvider(type: .ripple)
}
