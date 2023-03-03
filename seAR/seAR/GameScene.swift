//
//  GameScene.swift
//  seAR
//
//  Created by Tempnixk on 2022/08/27.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //플레이어
    private var playerNode:Player?
    var moving:Bool = false
    // 타이머
    var renderTime: TimeInterval = 0.0
    var changeTime: TimeInterval = 1
    var seconds: Int = 0
    var minutes: Int = 0
    var label: SKLabelNode = SKLabelNode()
    // 햅틱
    var generator:UIImpactFeedbackGenerator!
    
    override public func didMove(to view: SKView) {
        playerNode = self.childNode(withName: "player") as? Player
        generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        // 타이머
        label.text = "00 : 00"
    }
    
    // 타이머
    override public func didChangeSize(_ oldSize: CGSize) {
            label.position.x = self.size.width/2
            label.position.y = self.size.height/2
        }
    
    func updatePlayer (state:PlayerState) {
        if !moving {
            movePlayer(state: state)
        }
    }
    
    func movePlayer (state:PlayerState) {
        if let player = playerNode {
            player.texture = SKTexture(imageNamed: state.rawValue)
            
            var direction:CGFloat = 0
            
            //상하 이동
            switch state {
            case .open:
                direction = 116
            case .close:
                direction = -116
            }
            
            if Int(player.position.y) + Int(direction) >= -232 && Int(player.position.y) + Int(direction) <= 232 {
                
                moving = true
                
                let moveAction = SKAction.moveBy(x: 0, y: direction, duration: 0.3)
                
                let moveEndedAction = SKAction.run {
                    self.moving = false
                    if direction != 0 {
                        self.generator.impactOccurred()
                    }
                }
                let moveSequence = SKAction.sequence([moveAction, moveEndedAction])
                player.run(moveSequence)
            }
        }
    }
    
    //타이머
    override public func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if currentTime > renderTime {
            seconds += 1
            if seconds == 60 {
                seconds = 0
                minutes += 1
            }
            let secondsText = (seconds < 10) ?
            "0\(seconds)" : "\(seconds)"
            let minutesText = (minutes < 10) ?
            "0\(minutes)" : "\(minutes)"
            label.text = "\(minutesText) : \(secondsText)"
        }
        renderTime = currentTime + changeTime
    }
}
