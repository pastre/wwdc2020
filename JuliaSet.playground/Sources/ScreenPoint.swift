import CoreGraphics


typealias ScreenPoint = CGPoint

public extension ScreenPoint {
    func normalized( on frame: CGRect) -> Z {
        let smallest = frame.width > frame.height ? frame.height : frame.width
        
        return Z(real: self.x / frame.width  * 0.8, imaginary: self.y  / frame.height * 1.2)
    }
}
