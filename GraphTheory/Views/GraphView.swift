//
//  GraphView.swift
//  GraphTheory
//
//  Created by Marius Kažemėkaitis on 2015-06-09.
//  Copyright © 2015 TAPTAP mobile. All rights reserved.
//

import Foundation
import UIKit

struct ActivityLine {
    var from : CGPoint
    var to : CGPoint
}

class GraphView: UIView {
    
    var graph : Graph? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var from : Vertex?
    var to : Vertex?
    
    var activityFrom : Vertex?
    var activityTo : Vertex?
    var activityLines = Array<ActivityLine>()
    
    var path : Array<Vertex>? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        if let _ = self.graph?.vertices {
            
            let context = UIGraphicsGetCurrentContext()
            
            CGContextClearRect(context, self.bounds)
            
            // Set background color
            UIColor(red:1, green:0.98, blue:0.95, alpha:1).setFill()
            CGContextFillRect(context, self.bounds)
            
            // Draw all edges
            CGContextSetLineWidth(context, 1.0);
            CGContextSetLineJoin(context, kCGLineJoinRound);
            CGContextSetLineCap(context, kCGLineCapRound);
            
            for vertex : Vertex in self.graph!.vertices {
                for edge : Edge in vertex.adjacencies {
                    let toVertex : Vertex = edge.target
                    UIColor(red:1, green:0.85, blue:0.67, alpha:1).set()
                    CGContextMoveToPoint(context, CGFloat(vertex.x), CGFloat(vertex.y))
                    CGContextAddLineToPoint(context, CGFloat(toVertex.x), CGFloat(toVertex.y))
                    CGContextStrokePath(context)
                }
            }
            
            // Activity line
            if let _ = self.path {
                //
            } else {
                UIColor(red:0.05, green:0.59, blue:0.93, alpha:1).set()
                
                for line : ActivityLine in self.activityLines {
                    CGContextMoveToPoint(context, CGFloat(line.from.x), CGFloat(line.from.y))
                    CGContextAddLineToPoint(context, CGFloat(line.to.x), CGFloat(line.to.y))
                    CGContextStrokePath(context)
                }
            }
            
            
            
            // Draw path from source to destination vertex
            if let path = self.path {
                CGContextSetLineWidth(context, 3.0)
                UIColor(red:0, green:0.77, blue:0.37, alpha:1).set()
                
                for v1 : Vertex in path {
                    v1.highlighted = true
                    if let v2 = v1.previous {
                        CGContextMoveToPoint(context, CGFloat(v1.x), CGFloat(v1.y))
                        CGContextAddLineToPoint(context, CGFloat(v2.x), CGFloat(v2.y))
                        CGContextStrokePath(context)
                        
                    }
                }
            }
            
            // Draw all vertices
            for vertex : Vertex in self.graph!.vertices {
                
                if (vertex.highlighted) {
                    UIColor(red:0, green:0.77, blue:0.37, alpha:1).set()
                } else {
                    UIColor(red:1, green:0.35, blue:0.24, alpha:1).set()
                }
                
                CGContextAddArc(context, CGFloat(vertex.x), CGFloat(vertex.y), CGFloat(vertex.radius), 0.0, CGFloat(M_PI * 2.0), 1)
                CGContextFillPath(context)
            }
        }
    }
    
    func addActivityLine(from: Vertex, to : Vertex) {
        //println("Processing edge from \(from.name) to \(to.name)")
        self.activityLines.append( ActivityLine(from: CGPointMake(CGFloat(from.x), CGFloat(from.y)), to: CGPointMake(CGFloat(to.x), CGFloat(to.y))) )
        self.setNeedsDisplay()
    }
}