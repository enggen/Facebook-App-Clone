//
//  Post.swift
//  Facebook UK
//
//  Created by Ang Sherpa on 31/01/2017.
//  Copyright © 2017 ES Studios Inc. All rights reserved.
//

import UIKit


class Post: SafeJsonObject {
    var name: String?
    var profileImageName: String?
    var statusText: String?
    var statusImageName: String?
    var numLikes: NSNumber?
    var numComments: NSNumber?

    var location: Location?
    
    var infoKey: String?
    
   // var statusImageUrl: String?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "location" {
            location = Location()
            location?.setValuesForKeys(value as! [String: AnyObject])
        } else {
            super.setValue(value, forKey: key)
        }
    }
    
}

class SafeJsonObject: NSObject {
    
    override func setValue(_ value: Any?, forKey key: String) {
        let selectorString = "set\(key.uppercased().characters.first!)\(String(key.characters.dropFirst())):"
        let selector = Selector(selectorString)
        if responds(to: selector) {
            super.setValue(value, forKey: key)
        }
    }
}


class Location: NSObject {
    var city: String?
    var state: String?
}


class Feed: SafeJsonObject {
    var feedUrl, title, link, author, type: String?
}
