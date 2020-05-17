//: A SpriteKit based Playground

//#-hidden-code

import PlaygroundSupport
import SpriteKit

enum BlendMode: Int {
    
    case add
    case alpha
    case multiply
    case multiplyAlpha
    case multiply2x
    case replace
    case screen
    case subtract
    
    func converted() -> SKBlendMode {
        return SKBlendMode(rawValue: self.rawValue)!
    }
    
}
//#-end-hidden-code

var circleCount: Int = /*#-editable-code number of circles*/1000/*#-end-editable-code*/
var colorAlpha: CGFloat = /*#-editable-code colors alpha (0.0~1.0)*/1.0/*#-end-editable-code*/
var presentationMode: PresentationMode = /*#-editable-code blendMode*/.dotsOverLines/*#-end-editable-code*/

var circleRadius: CGFloat = /*#-editable-code blendMode*/5/*#-end-editable-code*/
var lineWidth: CGFloat = /*#-editable-code blendMode*/1/*#-end-editable-code*/

//#-hidden-code


let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 480))

if let scene = GameScene(fileNamed: "GameScene") {
    // Set the scale mode to scale to fit the window
    scene.scaleMode = .aspectFill
    scene.configure(circleCount: circleCount, circleRadius: circleRadius, lineWidth: lineWidth, colorAlpha: colorAlpha, blendMode: BlendMode.add.converted(), presentationMode: presentationMode)
    
    sceneView.presentScene(scene)
}

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView

//#-end-hidden-code


