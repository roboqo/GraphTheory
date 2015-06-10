//
//  Graph.swift
//  GraphTheory
//
//  Created by Marius Kažemėkaitis on 2015-06-09.
//  Copyright © 2015 TAPTAP mobile. All rights reserved.
//

import Foundation

enum ShortestPathAlgorithm : Int {
    case AStar, Dijkstra
}

class Graph: NSObject {
    var vertices : Array<Vertex> = []
    var algorithm  = ShortestPathAlgorithm.Dijkstra
    
    func addVertex(vertex : Vertex) {
        
        for currentVertex in vertices {
            if (currentVertex == vertex) {
                return
            }
        }
        
        vertices.append(vertex)
    }
    
    func findVertex(name : String) -> Vertex? {
        for currentVertex in vertices {
            if (currentVertex.name == name) {
                return currentVertex
            }
        }
        
        return nil
    }
    
    func findNearestVertex(source: Vertex, limit: Double = 0.0) -> Vertex {
        var nearestDistance : Double = Double.infinity
        var nearestVertex : Vertex?
        
        for vertex : Vertex in vertices {
            let distance = source.distanceToVertex(vertex)
            if distance < nearestDistance && source.name != vertex.name && distance > limit {
                nearestVertex = vertex
                nearestDistance = distance
            }
        }
        
        return nearestVertex!
    }
    
    func getShortestPath(from from : Vertex, to : Vertex, graphView : GraphView, completion: (path: Array<Vertex>) -> Void) {
        let pr = DISPATCH_QUEUE_PRIORITY_DEFAULT
        var path : Array<Vertex>  = []
        
        dispatch_async(dispatch_get_global_queue(pr, 0)) {
            
            let algorithm = (self.algorithm == ShortestPathAlgorithm.AStar) ? AStar() : Dijkstra()
            algorithm.vertices = self.vertices
            algorithm.go(from: from, to: to, graphView: graphView)
            
            var current : Vertex = to
            while (current.previous != nil) {
                path.append(current)
                
                if let prev = current.previous {
                    current =  prev
                }
            }
            
            path.append(from)
            
            dispatch_async(dispatch_get_main_queue()) {
                completion(path: Array(path.reverse()))
            }
        }
    }
}