import Foundation
import SpriteKit
import UIKit

public class GameScene: SKScene {
    
    private var setNodes:  [SKShapeNode]!
    private var lineNodes: [SKShapeNode]!
    private var prevCameraScale = CGFloat()
    
    private var isLocked: Bool = false
    private var touchCount: Int = 0
    
    private var nodeCount: Int!
    private var circleRadius: CGFloat!
    private var lineWidth: CGFloat!
    private var defaultAlpha: CGFloat!
    private var defaultBlendMode: SKBlendMode! = .none
    private var presentationMode: PresentationMode!
    private var scale: CGPoint = CGPoint(x: 0.6, y: 0.6)
    
    @objc static public override var supportsSecureCoding: Bool {
        get {
            return true
        }
    }
    
    
    public override func didMove(to view: SKView) {
        
        self.setupLines()
        self.setupNodes()

        view.isMultipleTouchEnabled = true
        self.backgroundColor = .black
    }
    
    // MARK: - Setup methods
    
    public func configure(circleCount: Int, circleRadius: CGFloat, lineWidth: CGFloat, colorAlpha: CGFloat, blendMode: SKBlendMode, presentationMode: PresentationMode) {
        
        self.circleRadius = circleRadius
        self.lineWidth = lineWidth
        self.nodeCount = circleCount
        self.defaultAlpha = colorAlpha
        self.defaultBlendMode = blendMode
        self.presentationMode =  presentationMode
    }
    
    
    func setupNodes() {
        let baseNode = SKShapeNode(circleOfRadius: self.circleRadius)
        self.setNodes = [SKShapeNode]()
        
        for i in 0..<self.nodeCount {
            let newNode = baseNode.copy() as! SKShapeNode
            
            newNode.fillColor = UIColor.init(hue: CGFloat.pi * CGFloat(i) / CGFloat(self.nodeCount), saturation: 1, brightness: 1, alpha: 1)
            newNode.strokeColor = .clear
//            newNode.blendMode = self.defaultBlendMode
            
            self.setNodes.append(newNode)
        }
    }
    
    func setupLines() {

        let baseNode = SKShapeNode()
        self.lineNodes = [SKShapeNode]()
        
        for i in 0..<self.nodeCount {
            let newNode = baseNode.copy() as! SKShapeNode
//            newNode.blendMode = self.defaultBlendMode
            newNode.lineWidth = self.lineWidth
            self.lineNodes.append(newNode)
            self.addChild(newNode)
        }
    }
    
    //MARK: - Mandelbrot
    
    func updateMandelbrot(screenPoint pos: ScreenPoint) {
        
        guard !self.isLocked else { return }
        let zPos = pos.normalized(on: self.frame)
        
        let set = self.computeSet(on: zPos)
        

        self.drawDots(on: set)
//
//
//
//            if self.presentationMode != .dotsOnly {
            
//                self.drawLine(from: z.mapped(to: self.frame, scale: self.scale), to: newZ.mapped(to: self.frame, scale: self.scale), on: self.lineNodes[i], color: node.fillColor)
//            }
            
        
    }


    func drawDots(on set: [CGPoint]) {
        for (i, point) in set.enumerated() {
            let node = self.setNodes[i]
            
            if point.x == .infinity || point.y == .infinity{
                node.removeFromParent()
                return
            } else if node.parent == nil {
                self.addChild(node)
            }


            if self.presentationMode == .linesOnly && node.parent != nil {
                node.removeFromParent()
            }
            
            node.position = point
        }
    }
    
    
    func computeSet(on zPos: Z) -> [CGPoint] {
        
        var z = Z.zero
        var ret = [CGPoint]()
        
        for _ in 0..<self.nodeCount {
    
            let newPoint = z.mapped(to: self.frame, scale: self.scale)
            ret.append(newPoint)
            z = (z.squared() + zPos)
        }
        
        return ret
    }
    
    func drawLine(from: ScreenPoint, to: ScreenPoint, on node: SKShapeNode, color: UIColor) {
        let path = CGMutablePath()
        
        path.move(to: from)
        path.addLine(to: to)
//        path.addQuadCurve(to: to, control: to)
        
        node.path = path
        node.strokeColor = color
        
    }
    
    func smalldX(_ p: CGPoint, _ p0: CGPoint) -> CGPoint {
        let m = (p.y - p0.y) / (p.x - p0.x)
        let n = p.y - m*p.x
        let dx: CGFloat = 0.5
        let newX = p.x - dx
        
        return CGPoint(x: newX, y: m*newX + n)
    }
    
    // MARK: - Lock
    
    func updateLockedState() {
        if self.touchCount >= 2 {
            self.isLocked = true
            return
        }
        
        if self.isLocked && self.touchCount == 0 {
            self.isLocked = false
        }
    }
    
    // MARK: - Gestures
    
    func touchDown(atPoint pos : CGPoint) {
        
        
        self.touchCount += 1
        self.updateLockedState()
        
        self.updateMandelbrot(screenPoint: pos)
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
        NSLog("[PG] TouchMoved  touchCount\(self.touchCount)")
        self.updateMandelbrot(screenPoint: pos)
    }
    
    func touchUp(atPoint pos : CGPoint) {
        self.touchCount -= 1
        
        NSLog("[PG] TouchUP  touchCount\(self.touchCount)")
        self.updateLockedState()
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchDown(atPoint: t.location(in: self)) }

    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchMoved(toPoint: t.location(in: self)) }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchUp(atPoint: t.location(in: self)) }

    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchUp(atPoint: t.location(in: self)) }
    }
    
}
