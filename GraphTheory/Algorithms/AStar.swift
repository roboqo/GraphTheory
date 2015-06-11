//
//  AStar.swift
//  GraphTheory
//
//  Created by Marius Kažemėkaitis on 2015-06-10.
//  Copyright © 2015 TAPTAP mobile. All rights reserved.
//

import Foundation

class AStar: ShortestPathBase {

    override func go(from from : Vertex, to : Vertex, graphView : GraphView) {
        let queue : PriorityQueue<Double, Vertex> = PriorityQueue()
        queue.push(0, item: from)
        
        var costSoFar : [String: Double] = [from.name : 0.0]
        
        while(queue.count > 0) {
            
            let current : Vertex = queue.next()!
            guard current != to else { break }
            
            for e : Edge in current.adjacencies {
                let next : Vertex = e.target
                let new_cost : Double = Double(costSoFar[current.name]!) + e.weight
                
                dispatch_async(dispatch_get_main_queue()) {
                    graphView.addActivityLine(current, to: next)
                }
                
                if graphView.activityLines.count < self.totalEdges() {
                    NSThread.sleepForTimeInterval(0.01)
                }
                
                if (costSoFar[next.name] == nil || new_cost < Double(costSoFar[next.name]!)) {
                    costSoFar[next.name] = new_cost
                    
                    let priority = new_cost + to.manhattanHeuristic(next)
                    
                    next.minDistance = priority
                    next.previous = current
                    
                    queue.push(priority, item: next)
                }
            }
        }
    }
}