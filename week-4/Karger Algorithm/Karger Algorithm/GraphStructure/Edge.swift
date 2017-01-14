//
//  Edge.swift
//  Karger Algorithm
//
//  Created by Stanislav Sidelnikov on 11/4/16.
//  Copyright © 2016 Yandex. All rights reserved.
//

import Foundation

class Edge: NSObject, NSCopying {
    var neighbor: Vertex
    var weight: Int
    
    override init() {
        neighbor = Vertex()
        weight = 0
        super.init()
    }
    
    init(neighbor: Vertex, weight: Int) {
        self.neighbor = neighbor
        self.weight = weight
        super.init()
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        return Edge(neighbor: self.neighbor.copy() as! Vertex, weight: self.weight)
    }
}
