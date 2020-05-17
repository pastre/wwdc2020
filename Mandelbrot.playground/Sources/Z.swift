import CoreGraphics



public struct Z {
    static let zero = Z(real: 0, imaginary: 0)
    
    func abs() -> CGFloat { sqrt( real * real + imaginary * imaginary ) }
    func squared() -> Z { Z(real: real * real - imaginary * imaginary, imaginary: 2 * real * imaginary) }
    
    
    func mapped(to frame: CGRect, scale: CGPoint = CGPoint(x: 1, y: 1)) ->  CGPoint {
        
        let smallest = frame.width > frame.height ? frame.height : frame.width
        
        return CGPoint(x: smallest * real * scale.x, y: smallest * imaginary * scale.y)
    }
    
    func negative() -> Z {
        Z(real: forceNegative(real), imaginary: forceNegative(imaginary) )
    }
    
    func inverse() -> Z  {
        let den = (real  * real + imaginary + imaginary)
        
        return Z(real: real / den, imaginary: -imaginary / den)
    }
    
    var real: CGFloat
    var imaginary: CGFloat
}
func forceNegative(_ val: CGFloat) -> CGFloat{
    return val  * (val >= 0 ? 1 : -1)
}

public func + (_ lhs: Z, _  rhs: Z) -> Z { Z(real: lhs.real + rhs.real, imaginary: lhs.imaginary + rhs.imaginary) }

public func * (_ lhs: Z, _  rhs: Z) -> Z { Z(real: lhs.real * rhs.real - lhs.imaginary * rhs.imaginary, imaginary: lhs.imaginary * rhs.real + lhs.real * rhs.imaginary) }

extension CGPoint {
    func lenght() -> CGFloat {
        return sqrt(self.x * self.x + self.y + self.y)
    }
    
    func proportion(_ segment: CGFloat, _ lenght: CGFloat, _ dx: CGFloat, _ dy: CGFloat) -> CGPoint {
        let factor = segment / lenght
        
        return CGPoint(x: self.x - dx * factor, y: self.y * dy * factor)
    }
}
