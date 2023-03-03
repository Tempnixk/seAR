//
//  GameViewController.swift
//  seAR
//
//  Created by Tempnixk on 2022/08/27.
//

import UIKit
import SpriteKit
import ARKit

class GameViewController: UIViewController, ARSessionDelegate {

    var gameScene:GameScene!
    var session:ARSession!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") as? GameScene {
                gameScene = scene
                // Set the scale mode to scale to fit the window
                gameScene.scaleMode = .aspectFill
            
                // Present the scene
                view.presentScene(gameScene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            
            session = ARSession()
            session.delegate = self
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard ARFaceTrackingConfiguration.isSupported else {print("iPhone X required"); return}
        
        let configuration = ARFaceTrackingConfiguration()
        
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    // MARK: ARSession Delegate
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        if let faceAnchor = anchors.first as? ARFaceAnchor {
            update(withFaceAnchor: faceAnchor)
        }
    }
    
    
    // 눈 깜빡임 인식
    func update(withFaceAnchor faceAnchor: ARFaceAnchor) {
        var blendShapes:[ARFaceAnchor.BlendShapeLocation:Any] = faceAnchor.blendShapes
        var closedEye: Bool = false
        guard let eyeBlinkLeft = blendShapes[.eyeBlinkLeft] as? Float else {return}
        guard let eyeBlinkRight = blendShapes[.eyeBlinkRight] as? Float else {return}

        // eyeBlinkLeft||eyeBlinkRight인 변수를 만들어주고 밑의 if에다가 넣어준다. 일정 이상으로 감으면 종료되게끔
        if eyeBlinkLeft < 0.1 {
            closedEye = true
        } else if eyeBlinkRight < 0.1 {
            closedEye = true
        } else  { closedEye = false }
        if closedEye == true {
            // 이 부분을 이제 종료 후 새로운 뷰로 넘어가게끔
            gameScene.updatePlayer(state: .open)
        } else {
            //이 부분은 계속 진행이 되면서 시간 측정을 하게끔
            gameScene.updatePlayer(state: .close)
        }
    }
}
