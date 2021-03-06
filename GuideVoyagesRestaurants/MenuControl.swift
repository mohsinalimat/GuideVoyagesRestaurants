//
//  MenuControl.swift
//  GuideVoyagesRestaurants
//
//  Created by Pradheep Rajendirane on 20/09/2016.
//  Copyright © 2016 DI2PRA. All rights reserved.
//

import UIKit
import QuartzCore

class MenuControl: UIControl {
    
    var items: [MenuItem] = []
    var animator: UIDynamicAnimator? = nil
    var snappingBehavior: UISnapBehavior?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setItems(items: [MenuItem]) {
        self.items = items
        self.animator = UIDynamicAnimator(referenceView: self)
        self.updateItemsView()
        self.setSelectedItem(item: 1)
    }
    
    private func updateItemsView() {
        
        let itemSpacing:CGFloat = 6.0
        let itemWidth = (self.bounds.width - ((CGFloat(items.count)+1.0) * itemSpacing))/CGFloat(items.count)
        let itemHeight = self.bounds.height - itemSpacing*2
        
        
        let itemView: UIView? = UIView(frame: CGRect(x: itemSpacing, y: itemSpacing, width: itemWidth, height: itemHeight))
        itemView?.tag = items.count+1
        itemView?.layer.cornerRadius = 10.0
        itemView?.backgroundColor = highlightColor
        
        self.addSubview(itemView!)
        
        
        var index: Int = 0
        var button: UIButton
        
        for menuItem in items {
            
            button = UIButton(frame: CGRect(x: CGFloat(index+1) * itemSpacing + CGFloat(index) * itemWidth, y: itemSpacing, width: itemWidth, height: itemHeight))
            
            button.addTarget(self, action: #selector(self.itemClicked), for: UIControlEvents.touchUpInside)
            button.setTitle(menuItem.title.uppercased(), for: UIControlState())
            button.setTitleColor(mainColor, for: UIControlState())
            
            button.layer.cornerRadius = 10.0
            
            button.titleLabel?.font = UIFont(name: "Reglo-Bold", size: 8)
            
            
            
            button.setImage(UIImage(named: menuItem.icon), for: UIControlState())
            
            if itemWidth > (itemHeight-15.0) {
                button.imageEdgeInsets = UIEdgeInsets(top: 2.0, left: (itemWidth-itemHeight+19)/2, bottom:17.0, right: (itemWidth-itemHeight+19)/2)
                
            } else {
                
                button.imageEdgeInsets = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 17.0, right: 2.0)
            }
            
            button.titleEdgeInsets = UIEdgeInsets(top: itemHeight-15.0, left: -256, bottom: 0, right: 0)
            
            button.tintColor = mainColor
            button.tag = index+1
            
            self.addSubview(button)

            index += 1
        }
        
    }
    
    func itemClicked(button: UIButton) {
        setSelectedItem(item: button.tag)
    }
    
    func setSelectedItem(item: Int) {
        
        self.animator?.removeAllBehaviors()
        
        let selectedItem = self.viewWithTag(item)
        let bgView = self.viewWithTag(items.count+1)
        let point = selectedItem?.center
        
        snappingBehavior = UISnapBehavior(item: bgView!, snapTo: point!)
        snappingBehavior?.damping = 0.8
        
        self.animator?.addBehavior(snappingBehavior!)
        
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

struct MenuItem {
    let title:String!
    let icon:String!
    
    
    init(title: String, icon: String) {
        self.title = title
        self.icon = icon
    }
    
}
