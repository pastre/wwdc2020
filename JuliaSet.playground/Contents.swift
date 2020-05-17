//: A Julia Set based playground

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
/*:
  - Note: For better experience, use this PlaygroundBook in fullscreen landscape and turn off Enable Results
 */

/*:
 ## Imaginary Numbers
 Have you ever heard of imaginary numbers?
 
 Any imaginary number is defined by a real part and an imaginary part.
 
 In the world of math, we use imaginary numbers to work with otherwise impossible values, like the square root of a negative number
 
 Mathematically speaking, we can say that an imaginary number "Z" is defined by a real part "A" and an imaginary part "B". A and B could be any normal number that we know, like 10
 
 We can write this as an equation described by Z = A + Bi
 
 B is the imaginary part because of the i is sitting right next to it. The i stands for the square root of -1
 
 ## Julia Set
 
 The Julia set is the set of numbers that follows this equation: Z[n + 1] = Z[n] * Z[n] + C
 
 Where C is an imaginary number,  and Z is a recusrive function.
 
 Z being a recursive function means that it uses it's own previous value to compute it's next value.
 
 That's why we have our N there, to indicate which value is being calculated
 
 So, to compute a Julia Set, we basically determine how many Zs do we want, pick a C and iterate through the equation!
 
 
 With the Julia Set calculated, we can then plot A and B, and this is what this playground does! Want to try it out?
 
 # Instructions
 
 * Slowly panning through the canvas will change the value of C
 
 * Tapping with another finger while you're panning will lock the shape until you start a new pan
 
 * If you feel like the shape has turned too fast, pan slower. This equation is pretty, but highly unstable
 
 * Change the presentation modes for a different visualization
 
 * Change the circleCount to get more or less iterations and circles
 
 * Change the circleRadius to get bigger or smaller circles
 
 * Change the lineWidth to get bigger or smaller lines. This will not affect the lights
 
 
 ### Hope you enjoy it as much as I enjoyed developing!
 
*/
var circleCount: Int = /*#-editable-code number of circles*/1000/*#-end-editable-code*/
var circleRadius: CGFloat = /*#-editable-code blendMode*/5/*#-end-editable-code*/
var lineWidth: CGFloat = /*#-editable-code blendMode*/1/*#-end-editable-code*/
var presentationMode: PresentationMode = /*#-editable-code blendMode*/.dotsOverLines/*#-end-editable-code*/


//#-hidden-code


var colorAlpha: CGFloat = 1.0
let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 480))

if let scene = GameScene(fileNamed: "GameScene") {
    // Set the scale mode to scale to fit the window
    scene.scaleMode = .aspectFill
    scene.configure(circleCount: circleCount, circleRadius: circleRadius, lineWidth: lineWidth, colorAlpha: colorAlpha, blendMode: BlendMode.add.converted(), presentationMode: presentationMode)
    
    sceneView.presentScene(scene)
}

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView

//#-end-hidden-code


