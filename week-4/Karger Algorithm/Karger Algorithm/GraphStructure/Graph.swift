//
//  Graph.swift
//  Karger Algorithm
//
//  Created by Stanislav Sidelnikov on 11/4/16.
//  Copyright © 2016 Yandex. All rights reserved.
//

import Foundation

class Graph: NSObject, NSCopying {
    fileprivate var canvas = [Vertex]()
    var isDirected = false
    
    override init() {
        super.init()
    }
    
    init(canvas: [Vertex], isDirected: Bool) {
        self.canvas = canvas
        self.isDirected = isDirected
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let canvasCopy = canvas.map { $0.copy() as! Vertex }
        return Graph(canvas: canvasCopy, isDirected: self.isDirected)
    }
    
    func addVertex(key: Int) -> Vertex {
        let childVertex = Vertex()
        childVertex.key = key
        
        canvas.append(childVertex)
        
        return childVertex
    }
    
    func vertices(withKey key: Int) -> [Vertex] {
        return canvas.filter({ $0.key == key })
    }
    
    func vertex(at index: Int) -> Vertex? {
        return index < canvas.count ? canvas[index] : nil
    }
    
    func indexOfVertex(where predicate: (Vertex) throws -> Bool) rethrows -> Int? {
        return try canvas.index(where: predicate)
    }
    
    func removeVertex(at index: Int) {
        guard index < canvas.count else { return }
        canvas.remove(at: index)
    }
    
    var count: Int { return canvas.count }
    
    func addEdge(source: Vertex, neighbor: Vertex, weight: Int) {
        let newEdge = Edge()
        
        newEdge.neighbor = neighbor
        newEdge.weight = weight
        source.neighbors.append(newEdge)
        
        if !isDirected {
            let reverseEdge = Edge()
            
            reverseEdge.neighbor = source
            reverseEdge.weight = weight
            neighbor.neighbors.append(reverseEdge)
        }
    }
    
}
