//
//  GameScene.swift
//  AngryWords
//
//  Created by Robert Pankrath on 24.10.14.
//  Copyright (c) 2014 Lesson Nine GmbH. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var terrain : TerrainNode = TerrainNode()

    var slingback : SKSpriteNode  = SKSpriteNode()
    var slingfront : SKSpriteNode  = SKSpriteNode()
    var slingDrawer : SKSpriteNode = SKSpriteNode()
    var initialDrawerPos:CGPoint = CGPointZero
    
    var slingBase : SKSpriteNode = SKSpriteNode();
    
    var slingpos1 : CGPoint = CGPointZero
    var slingpos2 : CGPoint = CGPointZero
    
    
    var camera : SKNode = SKNode()
    
    var touchStartPoint :CGPoint = CGPointZero
    
    var mapNode = SKNode()
    var backNode1 = SKNode()
    var backNode2 = SKNode()

    
    var isDraggingSwing :(Bool)  = false
    
    var babbelworm : SKSpriteNode = SKSpriteNode(color: SKColor.orangeColor(), size: CGSizeMake(50, 50))
    
    var word: [String] = ["B","a","b","b","e","l","-","H","a","c","k","d","a","y","2"]
    var currentWordIndex = 0
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
       
        self.backgroundColor = AngyWordsStyleKit.babbelBlue
        self.physicsWorld.contactDelegate = self;
        srandom(arc4random())
       
        restart()
        self.addChild(camera)
        
        createBackground()
    }
    
    func restart(){
        srandom(arc4random())

        mapNode.removeFromParent();
        mapNode = SKNode()
        self.addChild(mapNode)
        terrain.createTerrain(-40, length: 3000, miny: 50, maxY: 500, initialFlatLength: 700, endFlatRange: 500)
        terrain.position = CGPoint(x: 0, y: 0)
        terrain.zPosition = 1
        createClouds()
        mapNode.addChild(terrain)
        createTarget()
        createSling()

        babbelworm = SKSpriteNode(texture: SKTexture(image: AngyWordsStyleKit.imageOfCanvasBabbelFigure))
        mapNode.addChild(babbelworm);
        babbelworm.zPosition = 15
        
        
        setCameraPosition(CGPointMake(-terrain.length, 0))
        camera.runAction(SKAction.sequence([SKAction.waitForDuration(1),SKAction.moveTo(CGPointZero, duration: 1)]));

    }
    
    func createBackground(){
        var x = CGFloat(0);
        
        while x<terrain.length*2 {
            
            var node = SKSpriteNode(texture: SKTexture(image: AngyWordsStyleKit.imageOfBlueMountainDark))
            node.xScale = 3;
            node.yScale = 3;
            node.position = CGPointMake(x, node.size.height-100)
            
            node.zPosition = 0
            backNode1.addChild(node);
            x += node.size.width
        }
        
        backNode1.zPosition = 0
        self.addChild(backNode1)
        
        x = CGFloat(0);
        while x<terrain.length*4 {
            
            var node = SKSpriteNode(texture: SKTexture(image: AngyWordsStyleKit.imageOfBlueMountain))
            node.xScale = 5;
            node.yScale = 5;
            node.position = CGPointMake(x, node.size.height-200)
            
            node.zPosition = -1
            backNode2.addChild(node);
            x += node.size.width
        }
        
        backNode2.zPosition = 0
        self.addChild(backNode2)
    }
    
    func createClouds(){
        
        for var x=50; x<Int(terrain.length); x+=200{
            var y = (random()%Int(self.size.height/2)) + Int(self.size.height/2)
            var texture = SKTexture(image: AngyWordsStyleKit.imageOfCanvasCloud)
            var cloud = SKSpriteNode(texture: texture)
            
            var scale = CGFloat(random()%1000)/2000
            
            cloud.xScale = 0.2 + scale
            cloud.yScale = 0.2 + scale
            cloud.position = CGPoint(x: x, y: y)
            cloud.zPosition = 0
            cloud.color = AngyWordsStyleKit.babbelBeige50;
            cloud.colorBlendFactor = 1
            var dx = CGFloat(random()%40)
            var dur = NSTimeInterval(random()%5)+5
            var move1 = SKAction.moveByX(dx, y: 0, duration: dur)
            var move2 = SKAction.moveByX(-dx, y: 0, duration: dur)
            var action = SKAction.repeatActionForever(SKAction.sequence([ move1, move2]))
            cloud.runAction(action)
            mapNode.addChild(cloud)
        }
        
    }
    
    func createTarget(){
        
        var xRange = terrain.targetAreaXRange
        let baseY = terrain.targetAreaY
        
        var blockLength = CGFloat(80)

        
        var numBlocks = (xRange.length-40)/Int(blockLength)
        
        let width = CGFloat(xRange.length-40)
        var y = baseY;
        
        while numBlocks>0{
        
            let xoff = (width-CGFloat(numBlocks)*blockLength)/2
            
            
            for var i=0; i<numBlocks+1;i++ {
                let x = CGFloat(xRange.location)+xoff+CGFloat(i)*blockLength;
                createBlock(CGPoint(x: x, y: y+blockLength/2), length: blockLength, vertical: true)
            }
            
            for var i=0; i<numBlocks;i++ {
                let x = CGFloat(xRange.location)+xoff+CGFloat(i)*blockLength + blockLength/2;
                createBlock(CGPoint(x: x, y: y+blockLength + 8), length: blockLength, vertical: false)
                
                createBird(CGPointMake(x, y-16))
                
            }
            
            numBlocks--;
            y += blockLength+16
        }
        
        
    }
    
    func createBird(position: CGPoint){
        var bird = SKSpriteNode(texture: SKTexture(image: AngyWordsStyleKit.imageOfCanvasEule))
        bird.name = "owl"
        bird.position = CGPointMake(position.x, position.y+bird.size.height);
        bird.physicsBody = SKPhysicsBody(rectangleOfSize: bird.size);
        bird.physicsBody?.dynamic = true;
        bird.physicsBody?.contactTestBitMask = 1
        bird.zPosition = 30
        mapNode.addChild(bird)
        
        let l = word[currentWordIndex]
        var letter = LetterNode()
        letter.setLetter(l, index: currentWordIndex, bird: bird)
        letter.zPosition = 50
        mapNode.addChild(letter)
        
        currentWordIndex++;
    }
    
    func createBlock(pos: CGPoint, length:CGFloat, vertical:Bool){
        var w = vertical ? 16 : length;
        var h = vertical ? length : 16;
        var node = SKSpriteNode(color: SKColor(red: 0.3, green:0, blue: 0.4, alpha: 1), size: CGSize(width: w, height: h));
        if vertical {
            node.color = SKColor.greenColor()
        }
        var image = vertical ? AngyWordsStyleKit.imageOfCanvasWoodBlockVertical : AngyWordsStyleKit.imageOfCanvasWoodBlockHorizontal
        node.texture = SKTexture(image: image )
        
        let red = CGFloat(random()%1000)/3000;
        let green = CGFloat(0);
        let blue = CGFloat(random()%1000)/2000;
        node.color = SKColor(red: red, green: green, blue: blue, alpha: 1)
        node.colorBlendFactor = 0.5
        node.name = "block"
        node.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: w, height: h))
        node.physicsBody?.dynamic = true
        node.physicsBody?.contactTestBitMask = 1;
        node.position = pos
        node.zPosition = 10
        mapNode.addChild(node)
    }
    
    func createSling(){
        var xpos = CGFloat(terrain.startAreaXRange.location + terrain.startAreaXRange.length/2)
        var ypos = terrain.startAreaY
        
        
        var texBack = SKTexture(image: AngyWordsStyleKit.imageOfCanvasSchleuderHinten)
        var texFront = SKTexture(image: AngyWordsStyleKit.imageOfCanvasSchleuderVorne)
        var texBase = SKTexture(image: AngyWordsStyleKit.imageOfCanvasStamm)

        var back = SKSpriteNode(texture: texBack)
        var front = SKSpriteNode(texture: texFront)
        slingBase = SKSpriteNode(texture: texBase)
        
        slingBase.position = CGPoint(x: xpos, y: ypos+slingBase.size.height/2)
        back.position = slingBase.position
        front.position = slingBase.position
        slingBase.name = "sling"
        
        slingBase.zPosition = 20
        back.zPosition = 10
        front.zPosition = 20
        
        mapNode.addChild(back)
        mapNode.addChild(front)
        mapNode.addChild(slingBase)
        mapNode.addChild(slingDrawer)
        
//        slingDrawer.size = CGSizeMake(10, 10)
//        slingDrawer.color = SKColor.redColor()
//        slingDrawer.colorBlendFactor = 1

        slingpos1 = CGPointMake(slingBase.position.x-slingBase.size.width/2+13, slingBase.position.y+slingBase.size.height/2-13)
        slingpos2 = CGPointMake(slingBase.position.x-slingBase.size.width/2+65, slingBase.position.y+slingBase.size.height/2-15)
        
        slingDrawer.zPosition = 100;
        var vec = Helper.CGPointSub(slingpos1, b: slingpos2)
        var l = Helper.CGPointLength(vec)
        vec = Helper.CGPointNorm(vec)
        slingDrawer.position = CGPointMake(slingpos2.x+vec.x*l/2, slingpos2.y+vec.y*l/2)
        initialDrawerPos = slingDrawer.position
        
        
//        var dummy = SKSpriteNode(color: SKColor.redColor(), size: CGSizeMake(10, 10))
//        dummy.zPosition = 100
//        dummy.position = slingpos1
//        mapNode.addChild(dummy)
//        
//        dummy = SKSpriteNode(color: SKColor.redColor(), size: CGSizeMake(10, 10))
//        dummy.zPosition = 100
//        dummy.position = slingpos2
//        mapNode.addChild(dummy)
        
        
        slingfront.texture = SKTexture(image: AngyWordsStyleKit.imageOfCanvasSling)
        slingfront.color = SKColor(red: 1, green: 0.3, blue: 0.3, alpha: 1);
        slingfront.colorBlendFactor = 1;
        slingfront.zPosition = 19;
        mapNode.addChild(slingfront);
        
        slingback.texture = SKTexture(image: AngyWordsStyleKit.imageOfCanvasSling)
        slingback.color = SKColor(red: 0.7, green: 0, blue: 0, alpha: 1);
        slingback.colorBlendFactor = 1;
        slingback.zPosition = 9
        mapNode.addChild(slingback);

        babbelworm.position = CGPointMake(slingDrawer.position.x+babbelworm.size.width/2, slingDrawer.position.y);

    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        let touch: AnyObject = touches.anyObject()!

        isDraggingSwing = false
        let location = touch.locationInNode(self)
        
        let locationInMap = touch.locationInNode(mapNode)
        if(slingBase.containsPoint(locationInMap)){
            isDraggingSwing = true
            babbelworm.physicsBody = nil
            slingDrawer.position = location
            updateSling()
        }
        
        touchStartPoint = location
    }
   
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        let touch: AnyObject = touches.anyObject()!
        let location = touch.locationInNode(self)
        
        if(isDraggingSwing){
            slingDrawer.position = location
            updateSling()
        }
        else{
            let translation = location.x-touchStartPoint.x;
            
            var x = camera.position.x + translation;
            setCameraPosition(CGPointMake(x, camera.position.y))
        }
        touchStartPoint = location
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        
        
        if isDraggingSwing {
            var p2 = slingDrawer.position
            var p1 = slingpos2
            var p21  = Helper.CGPointSub(p1, b: p2)
            var l = Helper.CGPointLength(p21);

            babbelworm.physicsBody = SKPhysicsBody(rectangleOfSize: babbelworm.size)
            babbelworm.physicsBody?.dynamic = true
            babbelworm.physicsBody?.applyImpulse(CGVectorMake(p21.x*0.8, p21.y*0.8))
            babbelworm.physicsBody?.contactTestBitMask = 1
            slingDrawer.runAction(SKAction.moveTo(initialDrawerPos, duration: 0.4))
        }else{
        
            let touch: AnyObject = touches.anyObject()!
            let location = touch.locationInNode(self)
            if location.x<44 {
//                self.restart();
            }
            
        }
    }
    
    
    override func update(currentTime: CFTimeInterval) {
        if let body = babbelworm.physicsBody{
            var resting = body.resting
            if resting {
                babbelworm.physicsBody = nil;
                camera.runAction(SKAction.moveTo(CGPointZero, duration: 1));
            }else{
                if(babbelworm.position.x>terrain.length){
                    babbelworm.physicsBody = nil;
                    camera.runAction(SKAction.moveTo(CGPointZero, duration: 1));
                }
                
            }
        }
        
        self.enumerateChildNodesWithName("owl", usingBlock: {
            (node: SKNode!, stop: UnsafeMutablePointer <ObjCBool>) -> Void in
            if node.position.x>self.terrain.length {
                self.killBird(node)
            }
            
        })
    }
 
    func updateSling() {
//        slingback.position = slingDrawer.
        
        let h = CGFloat(5)
        
        var p1 = slingpos1
        var p2 = slingDrawer.position
        var p21  = Helper.CGPointSub(p1, b: p2)
        var l = Helper.CGPointLength(p21);
        p21 = Helper.CGPointNorm(p21)
        var midPoint = CGPointMake(p2.x + p21.x*l/2 , p2.y+p21.y*l/2)
        
        slingback.position = midPoint;
        slingback.size = CGSize(width: l, height: h);
        slingback.zRotation = Helper.CGPointToAngle(p21);

        
        p1 = slingpos2
        p2 = slingDrawer.position
        p21  = Helper.CGPointSub(p1, b: p2)
        l = Helper.CGPointLength(p21);
        p21 = Helper.CGPointNorm(p21)
        midPoint = CGPointMake(p2.x + p21.x*l/2 , p2.y+p21.y*l/2)
        
        slingfront.position = midPoint;
        slingfront.size = CGSize(width: l, height: h);
        slingfront.zRotation = Helper.CGPointToAngle(p21);

        if isDraggingSwing {
            babbelworm.position = CGPointMake(slingDrawer.position.x+babbelworm.size.width/2, slingDrawer.position.y);
        }
    }
    
    override func didSimulatePhysics() {
        
        mapNode.enumerateChildNodesWithName("letter", usingBlock: {
            (node: SKNode!, stop: UnsafeMutablePointer <ObjCBool>) -> Void in
            
            let letter = node as LetterNode            
                letter.updatePosition()
        })

        
        if babbelworm.physicsBody != nil {
            setCameraPosition(CGPointMake(-babbelworm.position.x+100, camera.position.y))
        }else{
            updateSling()
        }
        
        mapNode.position = CGPointMake(camera.position.x, 0)
        backNode1.position = CGPointMake(camera.position.x/2, 0)
        backNode2.position = CGPointMake(camera.position.x/4, 0)
}
    
    func setCameraPosition(pos : CGPoint){
        var x = pos.x
        if x>0 {
            x=0;
        }else if x < -(terrain.length-self.size.width){
            x = -(terrain.length-self.size.width)
        }
        
        camera.position = CGPointMake(x, camera.position.y);
    }
 
     func didBeginContact(contact: SKPhysicsContact) {
        let impulse = contact.collisionImpulse
        
        if(impulse>5){
            if let node = contact.bodyA.node {
                if node.name == "owl" {
                    killBird(node)
                }
            }
            
            if let node = contact.bodyB.node {
                if node.name == "owl" {
                    killBird(node)
                }
            }
        }
    }
    
    func killBird(bird: SKNode){
        bird.runAction(SKAction.removeFromParent())
        
        var emitter = SKEmitterNode()
        emitter.particleTexture = SKTexture(image: AngyWordsStyleKit.imageOfCanvasSmoke)
        emitter.numParticlesToEmit = 15
        emitter.particleLifetime = 0.5
        emitter.particleSize = CGSizeMake(42, 32)
        emitter.particleBlendMode = SKBlendMode.Alpha
        emitter.particleBirthRate = 1000
        emitter.particleScale = 0
        emitter.particleScaleSpeed = 1
        emitter.particleSpeed = 50
        emitter.particleAlphaSpeed = -1
        emitter.particleRotationRange = CGFloat(2*M_PI)
        emitter.particleRotationSpeed = 1
        emitter.emissionAngleRange = CGFloat(2*M_PI)
        emitter.position = bird.position
        emitter.runAction(SKAction.sequence([SKAction.waitForDuration(4),SKAction.removeFromParent()]))
        mapNode.addChild(emitter)
        
        mapNode.enumerateChildNodesWithName("letter", usingBlock: {
            (node: SKNode!, stop: UnsafeMutablePointer <ObjCBool>) -> Void in
            
            let letter = node as LetterNode
            
            if(letter.bird==bird){
                self.moveLetterUp(letter)
            }
            
        })
    }
    
    func moveLetterUp(letter: LetterNode){
        let letterWidth = CGFloat(40)
        let wordWidth = CGFloat(CGFloat(word.count)*letterWidth)
        let offset = CGFloat((self.size.width-wordWidth)/2)
        let location = CGPointMake(offset + CGFloat(letter.index)*letterWidth, 600)
        letter.removeFromParent()
        letter.position = self.convertPoint(letter.position, fromNode: mapNode)
        self.addChild(letter)
        letter.runAction(SKAction.group([SKAction .scaleTo(1, duration: 0.5), SKAction .moveTo(location, duration: 0.5), SKAction.colorizeWithColor(SKColor(red: 0, green: 0.45, blue: 0.52, alpha: 1), colorBlendFactor: 1, duration: 0.5)]))
    }
}
