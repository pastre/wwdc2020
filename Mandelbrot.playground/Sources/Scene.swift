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
            newNode.zPosition = 100
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
        
        if self.presentationMode == .lights {

            self.drawOutlines(on: set)
            return
        }
        
        self.drawDots(on: set)
        
        if self.presentationMode == .dotsOverLines {
            self.drawLines(on: set)
        }
    }

    func drawOutlines(on set: [CGPoint]) {
        let path = RoundedCornerGenerator.path_with_rounded_corners(points: set, corner_radius: 20)
        
        guard let node = self.setNodes.first else { return }
        if node.parent == nil { self.addChild(node) }
        
        node.path = path
        node.strokeColor = .blue
        node.fillColor = .clear
        
        return
        
    }

    func drawLines(on set: [CGPoint]) {
        for (i, node) in self.lineNodes.enumerated() {
            
            guard i < set.count - 1, self.setNodes[i].parent != nil else { continue }
            
            let from = self.setNodes[i].position
            let to = self.setNodes[i + 1 ].position
            let color = self.setNodes[i].fillColor
            
            let path = CGMutablePath()
            
            path.move(to: from)
            path.addLine(to: to)
            
            node.path = path
            node.strokeColor = color
        }
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

            node.position = point
            
        }
    }
    
    
    func computeSet(on zPos: Z) -> [CGPoint] {
        
        var z = Z.zero
        var ret = [CGPoint]()
        
        for _ in 0..<self.nodeCount {

            z = (z.squared() + zPos)
            let newPoint = z.mapped(to: self.frame, scale: self.scale)
            ret.append(newPoint)
        }
        
        return ret
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
        self.updateMandelbrot(screenPoint: pos)
    }
    
    func touchUp(atPoint pos : CGPoint) {
        self.touchCount -= 1
        
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
