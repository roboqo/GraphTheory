//
//  Edge.swift
//  GraphTheory
//
//  Created by Marius Kažemėkaitis on 2015-06-09.
//  Copyright © 2015 TAPTAP mobile. All rights reserved.
//

import Foundation

class Edge: DrawableEdge {
    let target : Vertex
    let weight : Double
    
    init(target: Vertex, weight: Double) {
        self.target = target
        self.weight = weight
        
        super.init()
    }
}