//
//  Article.swift
//  GuideVoyagesRestaurants
//
//  Created by Pradheep Rajendirane on 31/07/2016.
//  Copyright © 2016 DI2PRA. All rights reserved.
//

import Foundation

/*struct Article {
    
    let id:Int!
    let category: Category!
    var title:String!
    var author:String?
    var cover:String?
    var desc:String?
    
    init(id: Int, category: Category, title: String, author: String, cover: String, desc: String) {
        self.id = id
        self.category = category
        self.title = title
        self.author = author
        self.cover = cover
        self.desc = desc
        
    }
    
}*/

struct Article {
    
    let id:String!
    //let category: Category!
    var title:String!
    var category: String!
    var author:String?
    var cover:String?
    var desc:String?
    var date:String?
    var longitude: Double?
    var latitude: Double?
    var distance: Double?
    
    init(id: String, category: String, title: String, author: String, cover: String, desc: String, date: String? = nil,  longitude: Double? = nil, latitude: Double? = nil, distance:Double? = nil) {
        self.id = id
        self.category = category
        self.title = title
        self.author = author
        self.cover = cover
        self.desc = desc
        self.date = date
        self.longitude = longitude
        self.latitude = latitude
        self.distance = distance
    }
    
}


struct Category {
    
    let id: Int!
    let title: String!
    
    init(id: Int, title: String) {
        self.id = id
        self.title = title
    }
}
