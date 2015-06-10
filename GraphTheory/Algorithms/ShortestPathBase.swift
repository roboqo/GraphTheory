//
//  ShortestPathBase.swift
//  GraphTheory
//
//  Created by Marius Kažemėkaitis on 2015-06-10.
//  Copyright © 2015 TAPTAP mobile. All rights reserved.
//

import Foundation

class ShortestPathBase: NSObject {
    var vertices : Array<Vertex> = []
    
    func totalEdges() -> Int {
        var total = 0
        
        for vertex : Vertex in self.vertices {
            total += vertex.adjacencies.count
        }
        
        return total
    }
    
    func go(from from : Vertex, to : Vertex, graphView : GraphView) {}
}