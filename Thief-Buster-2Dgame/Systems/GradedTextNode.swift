import SpriteKit
import UIKit

class GradedTextNode: SKNode {
    
    init(text: String, fontName: String = "Pixellari", fontSize: CGFloat, gradientColors: [UIColor]) {
        super.init()
        
       
        let labelMask = SKLabelNode(text: text)
        labelMask.fontName = fontName
        labelMask.fontSize = fontSize
        labelMask.horizontalAlignmentMode = .center
        labelMask.verticalAlignmentMode = .center
        
        
        let shadowLabel = labelMask.copy() as! SKLabelNode
        shadowLabel.fontColor = .black
        shadowLabel.position = CGPoint(x: 2, y: -2)
        
       
        let gradientSize = CGSize(width: labelMask.frame.width + 10, height: labelMask.frame.height + 10)
        let gradientNode = GradedTextNode.gradientSprite(size: gradientSize, colors: gradientColors)
        
        
        let cropNode = SKCropNode()
        cropNode.maskNode = labelMask
        cropNode.addChild(gradientNode)
        
       
        addChild(shadowLabel)
        addChild(cropNode)
        
      
//        self.alpha = 0
//        self.run(SKAction.fadeIn(withDuration: 0.2))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

 
    private static func gradientSprite(size: CGSize, colors: [UIColor]) -> SKSpriteNode {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(origin: .zero, size: size)
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { ctx in
            gradientLayer.render(in: ctx.cgContext)
        }
        let texture = SKTexture(image: image)
        return SKSpriteNode(texture: texture)
    }
}



