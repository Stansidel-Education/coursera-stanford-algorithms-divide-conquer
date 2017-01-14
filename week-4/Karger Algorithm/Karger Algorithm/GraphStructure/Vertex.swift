//
//  Vertex.swift
//  Karger Algorithm
//
//  Created by Stanislav Sidelnikov on 11/4/16.
//  Copyright © 2016 Yandex. All rights reserved.
//

import Foundation

class Vertex: NSObject, NSCopying {
    var key: Int?
    var neighbors: [Edge]
    
    override init() {
        neighbors = [Edge]()
        super.init()
    }
    
    init(key: Int?, neighbors: [Edge]) {
        self.key = key
        self.neighbors = neighbors
        super.init()
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let neighborsCopy = neighbors.map { $0.copy() as! Edge }
        return Vertex(key: self.key, neighbors: neighborsCopy)
    }
}
