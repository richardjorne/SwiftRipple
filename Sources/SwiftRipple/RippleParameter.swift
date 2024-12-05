//
//  RippleParameter.swift
//  SwiftRipple
//
//  Created by mito on 2024/10/23.
//

import SwiftUI

public class RippleParameter: ObservableObject, Identifiable {
    
    public init(pos: CGPoint, diameter: CGFloat, scale: CGFloat = 1.0, isInternal: Bool = false) {
        self.pos = pos
        self.diameter = diameter
        self.scale = scale
        self.isInternal = isInternal
    }
    
    public var id = UUID()
    public var pos: CGPoint
    public var diameter: CGFloat
    public var scale: CGFloat
    public var isInternal: Bool
}


extension Array where Element == RippleParameter {
    public func internalRipples() -> [RippleParameter] {
        return self.filter { $0.isInternal }
    }
    
    public func externalRipples() -> [RippleParameter] {
        return self.filter { !$0.isInternal }
    }
    
    public func internalRipplesIndexes() -> [Int] {
        return self.enumerated().filter { $0.element.isInternal }.map { $0.offset }
    }
    
    public func externalRipplesIndexes() -> [Int] {
        return self.enumerated().filter { !$0.element.isInternal }.map { $0.offset }
    }
    
    @discardableResult
    public mutating func removeFirstInternalRipple() -> RippleParameter? {
        if let index = self.firstIndex(where: {$0.isInternal}), index >= 0 {
            return self.remove(at: self.firstIndex(where: {$0.isInternal}) ?? 0)
        }
        return nil
    }
    
    @discardableResult
    public mutating func removeFirstExternalRipple() -> RippleParameter? {
        if let index = self.firstIndex(where: {!$0.isInternal}), index >= 0 {
            return self.remove(at: self.firstIndex(where: {!$0.isInternal}) ?? 0)
        }
        return nil
    }
    
}
