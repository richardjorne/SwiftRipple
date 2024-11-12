class RippleParameter: ObservableObject, Identifiable {
    
    init(pos: CGPoint) {
        self.pos = pos
    }
    
    var id = UUID()
    var pos: CGPoint
}