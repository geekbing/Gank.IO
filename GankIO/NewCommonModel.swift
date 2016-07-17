//
//  NewCommonModel.swift
//  GankIO
//
//  Created by Bing on 7/16/16.
//  Copyright © 2016 Bing. All rights reserved.
//

class NewCommonModel
{
    var avObject: AVObject
    var isZan: Bool
    var isCollection: Bool
    
    init(avObject: AVObject, isZan: Bool, isCollection: Bool)
    {
        self.avObject = avObject
        self.isZan = isZan
        self.isCollection = isCollection
    }
}