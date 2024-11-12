//
//  AllTouchGestureModifier.swift
//  SwiftRipple
//
//  Created by Richard Jorne on 2024/7/16.
//


import SwiftUI


struct AllTouchGestureModifier: ViewModifier {
    
    let onTouchDown: (CGPoint) -> Void
    let onConfirm: (CGPoint) -> Void
    let onTouchUp: (CGPoint) -> Void
    let onCancel: (CGPoint) -> Void
    let onDragging: (CGPoint) -> Void
    let onDragInside: (CGPoint) -> Void
    let onDragOutside: (CGPoint) -> Void
    
    @State private var isDragging = false
    @State private var dragLocation: CGPoint = .zero
    
    func body(content: Content) -> some View {
        GeometryReader { geo in
            content
                .simultaneousGesture(DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        dragLocation = value.location
                        onDragging(dragLocation)
                        if geo.frame(in: .global).contains(value.location) {
                            onDragInside(dragLocation)
                        } else {
                            onDragOutside(dragLocation)
                        }
                        if !isDragging {
                            isDragging = true
                            onTouchDown(dragLocation)
                        }
                    }
                    .onEnded { value in
                        isDragging = false
                        dragLocation = value.location
                        onTouchUp(dragLocation)
                        if geo.frame(in: .global).contains(value.location) {
                            onConfirm(dragLocation)
                        } else {
                            onCancel(dragLocation)
                        }
                    }
                )
        }
        
    }
}


extension View {
    func allTouchGesture(
        onTouchDown: @escaping (CGPoint) -> Void = {_ in},
        onConfirm: @escaping (CGPoint) -> Void = {_ in},
        onTouchUp: @escaping (CGPoint) -> Void = {_ in},
        onCancel: @escaping (CGPoint) -> Void = {_ in},
        onDragging: @escaping (CGPoint) -> Void = {_ in},
        onDragInside: @escaping (CGPoint) -> Void = {_ in},
        onDragOutside: @escaping (CGPoint) -> Void = {_ in}
    ) -> some View {
        self.modifier(AllTouchGestureModifier(
            onTouchDown: onTouchDown,
            onConfirm: onConfirm,
            onTouchUp: onTouchUp,
            onCancel: onCancel,
            onDragging: onDragging,
            onDragInside: onDragInside,
            onDragOutside: onDragOutside
        ))
    }
}

