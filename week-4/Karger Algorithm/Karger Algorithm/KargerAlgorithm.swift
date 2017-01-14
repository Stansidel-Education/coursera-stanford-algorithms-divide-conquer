//
//  KargerAlgorithm.swift
//  Karger Algorithm
//
//  Created by Stanislav Sidelnikov on 10/28/16.
//  Copyright © 2016 Yandex. All rights reserved.
//

import Foundation

class KargerAlgorithm {
    var originalGraph: Graph?
    
    func readFile(named filename: String) {
        let fileContent = try! String(contentsOfFile: filename)
        let lines = fileContent.components(separatedBy: .newlines)
        let graph = Graph()
        for line in lines {
            let scanner = Scanner(string: line)
            var number = 0
            scanner.scanInt(&number)
            guard number > 0 else { continue }
            let sourceVertex = graph.vertices(withKey: number).first ?? graph.addVertex(key: number)
            var value = 0
            while scanner.scanInt(&value) && value > 0 {
                guard sourceVertex.neighbors.filter({ $0.neighbor.key == value }).count == 0 else {
                    continue
                }

                let neighborVertex = graph.vertices(withKey: value).first ?? graph.addVertex(key: value)
                graph.addEdge(source: sourceVertex, neighbor: neighborVertex, weight: 0)
             }
        }
        originalGraph = graph
    }
    
    func perform() -> Int {
        let graph = originalGraph!//.copy() as! Graph
        while graph.count > 2 {
            let randomIndex = Int(arc4random_uniform(UInt32(graph.count)))
            let sourceVertex = graph.vertex(at: randomIndex)!
            let randomNeigborIndex = Int(arc4random_uniform(UInt32(sourceVertex.neighbors.count)))
            let neighborVertex = sourceVertex.neighbors[randomNeigborIndex].neighbor
            merge(vertex: sourceVertex, andVertex: neighborVertex, inGraph: graph)
        }
        return graph.vertex(at: 0)!.neighbors.count
    }
    
    fileprivate func merge(vertex vertex1: Vertex, andVertex vertex2: Vertex, inGraph graph: Graph) {
        var edges = [Edge]()
        for edge in vertex1.neighbors + vertex2.neighbors {
            if edge.neighbor.key != vertex1.key && edge.neighbor.key != vertex2.key {
                edges.append(edge)
            }
        }
        let index1 = graph.indexOfVertex(where: { $0.key == vertex1.key })!
        removeVertex(at: index1, inGraph: graph)
        let index2 = graph.indexOfVertex(where: { $0.key == vertex2.key })!
        removeVertex(at: index2, inGraph: graph)
        let newVertex = graph.addVertex(key: vertex1.key!)
        for edge in edges {
            graph.addEdge(source: newVertex, neighbor: edge.neighbor, weight: edge.weight)
        }
//        print("Merged vertex \(vertex1.key!) and \(vertex2.key!) into \(newVertex.key!). Edges before: \((vertex1.neighbors + vertex2.neighbors).count). Edges after: \(edges.count).")
    }
    
    fileprivate func removeVertex(at index: Int, inGraph graph: Graph) {
        guard let vertex = graph.vertex(at: index) else {
            print("Unable to get vertex at index \(index)")
            return
        }
        for edge in vertex.neighbors {
            let neighbor = edge.neighbor
            let initialCount = neighbor.neighbors.count
            neighbor.neighbors = neighbor.neighbors.filter({ $0.neighbor.key != vertex.key })
//            print("Neighbors filtered for vertex \(neighbor.key!) (for \(vertex.key!)). Was: \(initialCount). Now: \(neighbor.neighbors.count).")
        }
//        print("Removing vertex \(vertex.key!) at index \(index)")
        graph.removeVertex(at: index)
    }
}
