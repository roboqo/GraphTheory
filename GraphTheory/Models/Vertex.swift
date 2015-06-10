//
//  Vertex.swift
//  GraphTheory
//
//  Created by Marius Kažemėkaitis on 2015-06-09.
//  Copyright © 2015 TAPTAP mobile. All rights reserved.
//

import Foundation

class Vertex: DrawableVertex, Comparable, CustomStringConvertible {
    let name : String
    var adjacencies : Array<Edge> = []
    var minDistance : Double = Double.infinity
    var previous : Vertex? = nil
    let x, y : Double
    
    
    init(name: String, x : Double, y : Double) {
        self.name = name
        self.x = x
        self.y = y
    }
    
    var description: String {
        return "Vertex: \(name), minDistance: \(minDistance)"
    }
    
    func addUndirectedEdgeToVertex(vertex : Vertex) {
        self.addDirectedEdgeToVertex(vertex)
        vertex.addDirectedEdgeToVertex(self)
    }
    
    func addDirectedEdgeToVertex(vertex : Vertex) {
        
        for edge : Edge in self.adjacencies {
            if edge.target == vertex {
                return
            }
        }
        
        adjacencies.append(Edge(target: vertex, weight: self.distanceToVertex(vertex)))
    }
    
    func distanceToVertex(vertex : Vertex) -> Double {
        return sqrt( (x - vertex.x) * (x - vertex.x) + (y - vertex.y) * (y - vertex.y));
    }
    
    // Heuristics for A*
    func manhattanHeuristic(vertex : Vertex) -> Double {
        let D = 1.0
        let dx = abs(x - vertex.x)
        let dy = abs(y - vertex.y)
        
        return D * (dx + dy)
    }
    
    func diagonalHeuristic(vertex : Vertex) -> Double {
        let D = 1.0
        let dx = abs(x - vertex.x)
        let dy = abs(y - vertex.y)
        
        return D * max(dx, dy)
    }
    
    func euclideanHeuristic(vertex : Vertex) -> Double {
        let D = 1.0
        let dx = abs(x - vertex.x)
        let dy = abs(y - vertex.y)
        
        return D * sqrt(dx * dx + dy * dy)
    }
}

func < (lhs: Vertex, rhs: Vertex) -> Bool {
    return lhs.minDistance < rhs.minDistance
}

func == (lhs: Vertex, rhs: Vertex) -> Bool {
    return lhs.name == rhs.name
}