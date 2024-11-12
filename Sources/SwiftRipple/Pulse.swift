//
//  RippleButton.swift
//  SwiftRipple
//
//  Created by Richard Jorne on 2024/7/16.
//

import SwiftUI

public struct RippleButton<Content: View, Background: View, Ripple: View>: View {
    
    init(@ViewBuilder content: () -> Content, @ViewBuilder background: () -> Background, @ViewBuilder ripple: @escaping () -> Ripple, action: @escaping () -> Void, appearAnimation: Animation, disappearAnimation: Animation, ripplePercent: CGFloat?) {
        self.content = content()
        self.background = background()
        self.ripple = SwiftRipple(ripple: ripple, action: action, appearAnimation: appearAnimation, disappearAnimation: disappearAnimation, ripplePercent: ripplePercent)
    }
    
    init(@ViewBuilder content: () -> Content, @ViewBuilder background: () -> Background, @ViewBuilder ripple: @escaping () -> Ripple, action: @escaping () -> Void, appearDuration: Double = 0.4, disappearDuration: Double = 2, ripplePercent: CGFloat?){
        self.content = content()
        self.background = background()
        self.ripple = SwiftRipple(ripple: ripple, action: action, appearAnimation: .easeOut(duration: 0.5), disappearAnimation: .linear(duration: disappearDuration), ripplePercent: ripplePercent)
    }
    
    init(@ViewBuilder content: () -> Content, @ViewBuilder background: () -> Background, ripple: SwiftRipple<Ripple>){
        self.content = content()
        self.background = background()
        self.ripple = ripple
    }
    
    private var content: Content
    private var background: Background
    private var ripple: SwiftRipple<Ripple>
    
    @State private var disabled: Bool = false
    
    public var body: some View {
        ZStack {
            ZStack {
                Color.primary
                background
                content
            }.opacity(disabled ? 0.5 : 1)
            Color.primary.opacity(disabled ? 0.5 : 0)
            
        }
        ripple
    }
    
}


struct RippleButtonPreviewProvider: View {
    var body: some View {
        ZStack {
            RippleButton(content: {
                Text("Happy")
            }, background: {
                Color.orange
            }, ripple: {
                Color.yellow.opacity(0.6).clipShape(.circle)
            }, action: {
                
            }, ripplePercent: 1)
            .cornerRadius(14)
            .frame(width: 120, height: 50, alignment: .center)
        }
        .frame(width: 300, height: 300, alignment: .center)
    }
}

#Preview {
    RippleButtonPreviewProvider()
}

