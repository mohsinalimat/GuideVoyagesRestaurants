//
//  DistancePickerControl.swift
//  GuideVoyagesRestaurants
//
//  Created by Pradheep Rajendirane on 22/09/2016.
//  Copyright © 2016 DI2PRA. All rights reserved.
//

import UIKit

class DistancePickerControl: UIControl, UIDynamicAnimatorDelegate {
    
    open weak var target: AnyObject?
    open var action: Selector?
    
    let totalKM:Int = 100
    var space:CGFloat = 100.0
    
    var distance:CGFloat = 0.1
    
    var MARK_OFFSET:CGFloat = UIScreen.main.bounds.width * 0.5
    
    var OFFSET_MAX:CGFloat {
        return UIScreen.main.bounds.width * 0.5 - space * 0.1
    }
    
    var OFFSET_MIN:CGFloat  {
        
        return -(CGFloat(totalKM) * space - MARK_OFFSET)
    }
    
    var offset:CGFloat = UIScreen.main.bounds.width * 0.5 - 10.0 {
        didSet {
            if offset > OFFSET_MAX {
                offset = OFFSET_MAX
            } else if offset < OFFSET_MIN {
                offset = OFFSET_MIN
            }
            
            let currentValue = round( (MARK_OFFSET-offset)/space * 10 ) / 10
            
            if distance != currentValue {
                distance = currentValue
            }
            
            setNeedsDisplay()
        }
    }
    
    var markAttributes: [String:NSObject] {
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        
        return [
            NSFontAttributeName: UIFont.init(name: "Reglo-Bold", size: 13)!, NSParagraphStyleAttributeName: style,
            NSForegroundColorAttributeName: UIColor.gray.withAlphaComponent(0.8)]
    }
    
    
    var animator: UIDynamicAnimator!
    
    private var dynamicItem: DynamicItem = DynamicItem()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = bgColor
        
        self.animator = UIDynamicAnimator(referenceView: self)
        self.animator.delegate = self
        addGestureRecognizer(PanGestureRecognizer(target: self, action: #selector(self.pan)))
        
    }
    
    func pan(recognizer: UIPanGestureRecognizer) {
        let velocity = recognizer.velocity(in: self)
        
        if recognizer.state == UIGestureRecognizerState.began {
            
            animator.removeAllBehaviors()
            
        } else if recognizer.state == UIGestureRecognizerState.changed {
            
            assert(animator.behaviors.isEmpty)
            
            offset += recognizer.translation(in: self).x
            recognizer.setTranslation(CGPoint.zero, in: self)
            
        } else if recognizer.state == UIGestureRecognizerState.ended {
            
            assert(animator.behaviors.isEmpty)
            
            animator.addBehavior(decelerationBehaviorWithVelocity(velocity: velocity))
        }
        
    }
    
    func decelerationBehaviorWithVelocity(velocity: CGPoint) -> UIDynamicItemBehavior {
        
        let inverseVelocity = CGPoint(x: velocity.x, y: 0)
        let decelerationBehavior = UIDynamicItemBehavior(items: [dynamicItem])
        
        dynamicItem.center = CGPoint(x: offset, y: 0)
        
        decelerationBehavior.addLinearVelocity(inverseVelocity, for: dynamicItem)
        decelerationBehavior.resistance = 10.0
        decelerationBehavior.action = {
            self.offset = self.dynamicItem.center.x
        }
        
        return decelerationBehavior
    }
    
    override func draw(_ rect: CGRect) {
        
        var aPath:UIBezierPath
        var textRect: CGRect
        var text: String
        
        
        for index in 0...totalKM {
            
            aPath = UIBezierPath()
            
            aPath.move(to: CGPoint(x: offset + CGFloat(index)*space, y:0))
            aPath.addLine(to: CGPoint(x: offset + CGFloat(index)*space, y:20))
            aPath.close()
            
            //If you want to stroke it with a red color
            mainColor.set()
            aPath.stroke()
            //If you want to fill it as well
            aPath.fill()
            
            
            if index != totalKM {
                aPath = UIBezierPath()
                aPath.move(to: CGPoint(x: offset + space/2 + CGFloat(index)*space, y:0))
                aPath.addLine(to: CGPoint(x: offset + space/2 + CGFloat(index)*space, y:15))
                aPath.close()
                
                //If you want to stroke it with a red color
                mainColor.set()
                aPath.stroke()
                //If you want to fill it as well
                aPath.fill()
                
                
                for i in 1...9 {
                    
                    
                    // MARQUEUR DIXIEME
                    aPath = UIBezierPath()
                    aPath.move(to: CGPoint(x: offset + CGFloat(index)*space + CGFloat(i)*space/10, y:0))
                    aPath.addLine(to: CGPoint(x: offset + CGFloat(index)*space + CGFloat(i)*space/10, y:10))
                    aPath.close()
                    mainColor.set()
                    aPath.stroke()
                    aPath.fill()
                }
                
            }
            
            textRect = CGRect(x: offset + (CGFloat(index)-0.5)*space, y: 25, width: space, height: 15)
            text = "\(index) KM"
            
            text.draw(in: textRect, withAttributes: markAttributes)
            
        }
        
        // MARQUEUR ROUGE
        aPath = UIBezierPath()
        aPath.move(to: CGPoint(x: MARK_OFFSET, y:0))
        aPath.addLine(to: CGPoint(x: MARK_OFFSET, y:20))
        aPath.close()
        UIColor.red.set()
        aPath.stroke()
        aPath.fill()
        
        
        textRect = CGRect(x: MARK_OFFSET - 50, y: 40, width: 100, height: 15)
        text = "\(distance) KM"
        text.draw(in: textRect, withAttributes: markAttributes)
        
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    open func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        
        precondition(Thread.isMainThread)
        
        // Prevent the deceleration behavior to be called on rotation (overwriting
        // the offset set with frame.didSet)
        animator.removeAllBehaviors()
        
        // The picker can become invisible between the moment the user starts to
        // swipe accross it and when the deceleration ends. This occurs when
        // the user rotates the screen or navigates to the previous/next screen.
        let hasBecomeInvisible = window == nil
        
        if action == nil || target == nil || hasBecomeInvisible {
            return
        }
        
        sendAction(action!,
                   to: target!,
                   for: (gestureRecognizers![0] as! PanGestureRecognizer).endEvent)
    }
}

private class PanGestureRecognizer : UIPanGestureRecognizer {
    
    var endEvent: UIEvent?
    
    /*override func touchesBegan(_ touches: Set<AnyHashable>!, with event: UIEvent!) {
        super.touchesBegan(touches as Set<NSObject>, with: event)
        endEvent = nil
    }
    
    override func touchesEnded(_ touches: Set<AnyHashable>!, with event: UIEvent!) {
        super.touchesEnded(touches as Set<NSObject>, with: event)
        endEvent = event
    }*/
}


private class DynamicItem: NSObject, UIDynamicItem {
    
    @objc var center = CGPoint.zero
    @objc var bounds = CGRect(x: 0, y: 0, width: 1, height: 1)
    @objc var transform = CGAffineTransform()
    
}
