//
//  TransparentNavigationBar.swift
//  GuideVoyagesRestaurants
//
//  Created by Pradheep Rajendirane on 09/09/2016.
//  Copyright © 2016 DI2PRA. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    
    
    public func mainNavigationBar() {
        navigationBar.barTintColor = bgColor
        navigationBar.translucent = false
        navigationBar.tintColor = mainColor
        
        let attributes = [
            NSFontAttributeName : UIFont(name: "Reglo-Bold", size: 15)!,
            NSForegroundColorAttributeName : mainColor
        ]
        navigationBar.titleTextAttributes = attributes
    }
    
    
    public func presentTransparentNavigationBar() {
        navigationBar.setBackgroundImage(UIImage(), forBarMetrics:UIBarMetrics.Default)
        navigationBar.translucent = true
        navigationBar.shadowImage = UIImage()
        setNavigationBarHidden(false, animated:true)
        
    }
    
    public func hideTransparentNavigationBar() {
        setNavigationBarHidden(true, animated:false)
        navigationBar.setBackgroundImage(UINavigationBar.appearance().backgroundImageForBarMetrics(UIBarMetrics.Default), forBarMetrics:UIBarMetrics.Default)
        navigationBar.translucent = UINavigationBar.appearance().translucent
        navigationBar.shadowImage = UINavigationBar.appearance().shadowImage
    }
    
    
    public func addBlurEffect() {
        // Add blur view
        var bounds = navigationBar.bounds as CGRect!
        bounds.offsetInPlace(dx: 0.0, dy: -20.0)
        bounds.size.height = bounds.height + 20.0
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        visualEffectView.frame = bounds
        visualEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        visualEffectView.userInteractionEnabled = false
        navigationBar.addSubview(visualEffectView)
        
        navigationBar.sendSubviewToBack(visualEffectView)
        
        // Here you can add visual effects to any UIView control.
        // Replace custom view with navigation bar in above code to add effects to custom view.
    }
}