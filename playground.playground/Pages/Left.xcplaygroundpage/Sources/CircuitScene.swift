import SpriteKit

class CircuitScene: SKScene, SKPhysicsContactDelegate {
    
    let electronCategory: UInt32 = 0x1 << 0
    let capacitorCategory: UInt32 = 0x1 << 1
    
    func calcC(Q: Double, U: Double) -> Double { return Q/U }
    
    let font = UIFont.systemFont(ofSize: 12, weight: .medium).fontName
    let fontSize: CGFloat = 24
    
    var maxCInHenry = 5.0
    var currentChargeVal = 0.0
    var voltage = 230.0
    var chargePerElectron = 25
    var fullyCharged = false
    
    var previewArea: SKSpriteNode? = nil
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.speed = 0.5
        self.isPaused = true
        
        if (isPaused) {
            let startLabel = SKLabelNode()
            startLabel.fontName = font
            startLabel.fontSize = fontSize
            startLabel.text = "Tap to Start Animation"
            
            previewArea = SKSpriteNode()
            previewArea!.size = self.size
            previewArea!.color = .black
            
            previewArea!.addChild(startLabel)
            addChild(previewArea!)
        }
        
        let charge = childNode(withName: "charge") as! SKLabelNode
        charge.horizontalAlignmentMode = .right
        charge.text = "0"
        charge.fontSize = fontSize
        charge.fontName = font
        
        let percentSign = childNode(withName: "percentSign") as! SKLabelNode
        percentSign.fontName = font
        percentSign.fontSize = fontSize
        
        let cap = childNode(withName: "capacitor")!
        cap.physicsBody = SKPhysicsBody(rectangleOf: cap.frame.size)
        cap.physicsBody?.affectedByGravity = false
        cap.physicsBody?.isDynamic = false
        cap.physicsBody?.categoryBitMask = capacitorCategory
        (cap.childNode(withName: "SKLabelNode") as! SKLabelNode).text = "Capacitor"
        
        let maxChargeLabel = childNode(withName: "maxLabel") as! SKLabelNode
        maxChargeLabel.fontName = font
        maxChargeLabel.fontSize = fontSize
        
        let currentChargeLabel = childNode(withName: "chargeLabel") as! SKLabelNode
        currentChargeLabel.fontName = font
        currentChargeLabel.fontSize = fontSize
        currentChargeLabel.text = "Charge:"
        
        let maxChargeVal = childNode(withName: "maxVal") as! SKLabelNode
        maxChargeVal.text = String(maxCInHenry) + " H"
        maxChargeVal.fontSize = fontSize
        maxChargeVal.fontName = font
        
        let chargeUnit = childNode(withName: "chargeUnit") as! SKLabelNode
        chargeUnit.fontName = font
        chargeUnit.fontSize = fontSize
        
        let currentCharge = childNode(withName: "chargeVal") as! SKLabelNode
        currentCharge.text = "0"
        currentCharge.fontName = font
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyB.node?.name == "electron" && contact.bodyA.node?.name == "capacitor" {
            let currentCharge = childNode(withName: "chargeVal") as! SKLabelNode
            
            if !fullyCharged {
                let percentage = childNode(withName: "charge") as! SKLabelNode
                //            let newCharge = calcC(Q: Double(number! + chargePerElectron), U: 230)
                self.currentChargeVal += Double(chargePerElectron)
                
                let percentageVal = (calcC(Q: Double(currentChargeVal), U: voltage) / maxCInHenry) * 100
                
                if round(percentageVal) == 100 {
                    fullyCharged = true
                    let percentSign = childNode(withName: "percentSign") as! SKLabelNode
                    percentSign.fontName = font
                    percentSign.fontSize = fontSize
                    percentSign.fontColor = .red
                    percentSign.text = "Full!"
                    
                    percentage.removeFromParent()
                } else {
                    let percentage    = childNode(withName: "charge") as! SKLabelNode
                    percentage.text = String(percentageVal.rounded())
                    
                    let formatter = NumberFormatter()
                    formatter.maximumFractionDigits = 2
                    formatter.minimumFractionDigits = 2
                    
                    let nsnum = NSNumber(value: calcC(Q: self.currentChargeVal, U: self.voltage))
                    currentCharge.text = formatter.string(from: nsnum)
                }
            }
            
            contact.bodyB.node?.removeFromParent()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let loc = touches.first!.location(in: self)
        if (previewArea?.contains(loc))! {
            
            previewArea?.run(SKAction.fadeOut(withDuration: 1.0), completion: {
                self.previewArea?.removeFromParent()
            })
            
            self.isPaused = false
            Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true, block: {_ in
                self.spawnElectron()
            })
        }
        
    }
    
    func spawnElectron() {
        let pos = self.childNode(withName: "positivePole")!.position
        
        let node = SKShapeNode(circleOfRadius: 40)
        node.name = "electron"
        node.strokeColor = .clear
        node.fillColor = UIColor(red: 135/255, green: 223/255, blue: 214/233, alpha: 1.0)
        node.position = CGPoint(x: 0, y: pos.y)
        node.physicsBody?.affectedByGravity = true
        node.physicsBody = SKPhysicsBody(circleOfRadius: 5, center: CGPoint(x: 0.5, y: 0.5))
        node.physicsBody?.categoryBitMask = electronCategory
        node.physicsBody?.contactTestBitMask = capacitorCategory
        
        let label = SKLabelNode(text: "e-")
        label.fontSize = 36
        label.fontName = UIFont.systemFont(ofSize: 36, weight: .semibold).fontName
        
        node.addChild(label)
        addChild(node)
    }
}

public func getScene() -> SKView {
    let sceneView = SKView(frame: CGRect(x: 0, y: 0, width: 445, height: 768))
    
    if let scene = CircuitScene(fileNamed: "CircuitScene") {
        scene.scaleMode = .aspectFill
        sceneView.presentScene(scene)
    }
    
    return sceneView
}
