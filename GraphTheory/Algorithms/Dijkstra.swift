//
//  Dijkstra.swift
//  GraphTheory
//
//  Created by Marius Kažemėkaitis on 2015-06-10.
//  Copyright © 2015 TAPTAP mobile. All rights reserved.
//

import Foundation

class Dijkstra: ShortestPathBase {
    
    override func go(from from : Vertex, to : Vertex, graphView : GraphView) {
        for vertex : Vertex in self.vertices {
            vertex.minDistance = Double.infinity
            vertex.previous = nil
        }
        
        from.minDistance = 0.0
        
        let queue : PriorityQueue<Double, Vertex> = PriorityQueue()
        queue.push(0, item: from)
        
        while(queue.count > 0) {
            let current : Vertex = queue.next()!
            guard current != to else { break }
            
            for e : Edge in current.adjacencies {
                let next : Vertex = e.target
                
                dispatch_async(dispatch_get_main_queue()) {
                    graphView.addActivityLine(current, to: next)
                }
                
                if graphView.activityLines.count < self.totalEdges() {
                    NSThread.sleepForTimeInterval(0.01)
                }
                
                let weight : Double = e.weight
                let distanceThroughU : Double  = current.minDistance + weight
                if (distanceThroughU < next.minDistance) {
                    
                    next.minDistance = distanceThroughU
                    next.previous = current
                    queue.push(next.minDistance, item: next)
                }
            }
        }
    }
}