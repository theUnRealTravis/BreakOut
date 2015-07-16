//
//  ViewController.swift
//  Dynamics Hackwich
//
//  Created by travis on 7/9/15.
//  Copyright © 2015 Travis. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollisionBehaviorDelegate {
    
    @IBOutlet weak var livesLabel: UILabel!
    
    var dynamicAnimator = UIDynamicAnimator()
    var paddle = UIView()
    var collisionBehavior = UICollisionBehavior()
    var ball = UIView()
    var brick = UIView()
    var bricks = [UIView]()
    var lives = 5

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add a ball
        ball = UIView(frame: CGRectMake(view.center.x, view.center.y, 20, 20))
        ball.backgroundColor = UIColor.blackColor()
        ball.layer.cornerRadius = 10
        ball.clipsToBounds = true
        view.addSubview(ball)
        
        //add a red paddle
        paddle = UIView(frame: CGRectMake(view.center.x, view.center.y * 1.7, 80, 20))
        paddle.backgroundColor = UIColor.redColor()
        view.addSubview(paddle)
        
        dynamicAnimator = UIDynamicAnimator(referenceView: view)
        
        //add a blue brick
        //for var x ... 40 {
        
        brick = UIView(frame: CGRectMake(20, 20, 40, 20))
        brick.backgroundColor = UIColor.blueColor()
        view.addSubview(brick)
        //}
        
        //
        let ballDynamicBehavior = UIDynamicItemBehavior(items: [ball])
        ballDynamicBehavior.friction = 0
        ballDynamicBehavior.resistance = 0
        ballDynamicBehavior.elasticity = 1.0
        ballDynamicBehavior.allowsRotation = false
        dynamicAnimator.addBehavior(ballDynamicBehavior)
        //
        let paddleDynamicBehavior = UIDynamicItemBehavior(items: [paddle])
        paddleDynamicBehavior.density = 10000
        paddleDynamicBehavior.resistance = 100
        paddleDynamicBehavior.allowsRotation = false
        dynamicAnimator.addBehavior(paddleDynamicBehavior)
        
        //create dynamic behavior for the brick
        let brickDynamicBehavior = UIDynamicItemBehavior(items: [brick])
        brickDynamicBehavior.density = 10000
        brickDynamicBehavior.resistance = 100
        brickDynamicBehavior.allowsRotation = false
        dynamicAnimator.addBehavior(brickDynamicBehavior)
        
        //
        let pushBehavior = UIPushBehavior(items: [ball], mode: UIPushBehaviorMode.Instantaneous)
        pushBehavior.pushDirection = CGVectorMake(0.2, 1)
        pushBehavior.magnitude = 0.25
        dynamicAnimator.addBehavior(pushBehavior)
        
        //create collision behaviors so ball can bounce off other objects
        collisionBehavior = UICollisionBehavior(items: [ball, paddle, brick])
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        collisionBehavior.collisionMode = .Everything //UICollisionBehaviorMode
        collisionBehavior.collisionDelegate = self
        dynamicAnimator.addBehavior(collisionBehavior)
        
    }

    @IBAction func dragPaddle(sender: UIPanGestureRecognizer) {
        let panGesture = sender.locationInView(view)
        paddle.center = CGPointMake(panGesture.x, paddle.center.y)
        dynamicAnimator.updateItemUsingCurrentState(paddle)
        livesLabel.text = "Lives: \(lives)"
    }
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, atPoint p: CGPoint) {
        if item.isEqual(ball) && p.y > paddle.center.y {
            lives--
            if lives > 0 {
                livesLabel.text = "Lives: \(lives)"
                ball.center = view.center
                dynamicAnimator.updateItemUsingCurrentState(ball)
            } else {
                livesLabel.text = "Game Over"
                ball.removeFromSuperview()
            }
        }
    }
    
    //collision behavior delegate method (with another object)
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item1: UIDynamicItem, withItem item2: UIDynamicItem, atPoint p: CGPoint) {
        if (item1.isEqual(ball) && item2.isEqual(brick)) || (item1.isEqual(brick) && item2.isEqual(ball)) {
            if brick.backgroundColor == UIColor.blueColor() {
                brick.backgroundColor = UIColor.yellowColor()
            } else {
                brick.hidden = true
                collisionBehavior.removeItem(brick)
                livesLabel.text = "You win!"
                ball.removeFromSuperview()
                collisionBehavior.removeItem(ball)
                dynamicAnimator.updateItemUsingCurrentState(ball)
            }
        }
    }
}

