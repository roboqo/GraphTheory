//
//  GraphViewController.swift
//  GraphTheory
//
//  Created by Marius Kažemėkaitis on 2015-06-09.
//  Copyright © 2015 TAPTAP mobile. All rights reserved.
//

import Foundation
import UIKit

class GraphViewController: UIViewController {
    var graph : Graph = Graph()
    var from : Vertex?
    var to : Vertex?
    var touchesEnabled = true
    
    @IBOutlet weak var graphView: GraphView!
    @IBAction func generateNewGraph(sender: UIBarButtonItem)
    {
        self.randomGraph()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUIToSavedAlgorithm()
        self.algorithmsViewTop.constant = -algorithmsView.frame.size.height
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if self.graph.vertices.count == 0 {
            self.randomGraph()
        }
    }
    
    private func randomGraph() {
        self.graph = Graph()
        self.from = nil
        self.to = nil
        self.graphView.activityLines.removeAll(keepCapacity: false)
        self.graphView.graph = self.graph
        self.graphView.path = nil
        
        let numberOfVertices = 100 + Int(arc4random_uniform(UInt32(50)))
        
        let spacing = 20.0
        
        while (self.graph.vertices.count < numberOfVertices) {
            let randomX = Double(arc4random_uniform(UInt32(self.view.bounds.size.width - 20)) + 10)
            let randomY = Double(arc4random_uniform(UInt32(self.view.bounds.size.height - 20)) + 10)
            
            var foundEmptySpace = true
            for vertex : Vertex in self.graph.vertices {
                let r : CGRect = CGRectMake(CGFloat(vertex.x - spacing), CGFloat(vertex.y - spacing), CGFloat(spacing * 2), CGFloat(spacing * 2))
                if CGRectContainsPoint(r, CGPointMake(CGFloat(randomX), CGFloat(randomY))) {
                    foundEmptySpace = false
                    break
                }
            }
            
            if foundEmptySpace {
                let vertex : Vertex = Vertex(name: String(self.graph.vertices.count + 1), x: randomX, y: randomY)
                self.graph.addVertex(vertex)
            }
        }
        
        var processedVertices = [String]()
        
        while (processedVertices.count < numberOfVertices) {
            let index : Int = Int(arc4random_uniform(UInt32(numberOfVertices)))
            let from = self.graph.vertices[index]
            
            if (!processedVertices.contains(from.name)) {
                processedVertices.append(from.name)
                
                var limit : Double = 0.0
                while (from.adjacencies.count < 4) {
                    let to = self.graph.findNearestVertex(from, limit: limit)
                    from.addUndirectedEdgeToVertex(to)
                    limit = from.distanceToVertex(to)
                }
            }
            
        }
        
        print("Generated graph with \(self.graph.vertices.count) vertices")
        self.graphView.graph = self.graph
    }
    
    private func getShortestPath() {
        
        self.graphView.from = nil
        self.graphView.to = nil
        self.graphView.activityLines.removeAll(keepCapacity: false)
        self.graphView.path = nil
        
        if let from : Vertex = self.from {
            if let to : Vertex = self.to {
                
                let defaults = NSUserDefaults.standardUserDefaults()
                let saved : Int = defaults.integerForKey("algorithm")
                self.graph.algorithm = ShortestPathAlgorithm(rawValue: saved)!
                
                self.graph.getShortestPath(from : from, to: to, graphView : self.graphView) {
                    (path: Array<Vertex>) in
                    
                    self.graphView.from = from
                    self.graphView.to = to
                    self.graphView.path = path
                    
                    print("Path from: \(from.name)")
                    print("Path to: \(to.name)")
                    
                    for i in 0 ..< path.count {
                        let vertex : Vertex = path[i]
                        print("\(vertex.name)", appendNewline: false)
                        if (i < path.count - 1) {
                            print(" -> ", appendNewline: false)
                        }
                    }
                    print("")
                    print("---")
                }
            }
        }
    }
    
    private func clearSelection() {
        for vertex : Vertex in self.graph.vertices {
            
            if ( vertex == self.from || vertex == self.to) {
                // do nothing
            } else {
                vertex.highlighted = false
            }
            
            self.graphView.setNeedsDisplay()
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        guard self.touchesEnabled else { return }
        
        var selectedVertex : Vertex?
        let location = touch.locationInView(view)
        
        selectedVertex = self.graph.findNearestVertex(Vertex(name: "-1", x: Double(location.x), y: Double(location.y)), limit: 0.0)
        print("Tap on \(selectedVertex?.name)")
        
        if let vertex = selectedVertex {
            let alert = UIAlertController(title: "Directions", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "From here", style: .Default, handler: { action in
                self.from = vertex
                vertex.highlighted = true
                self.clearSelection()
                self.getShortestPath()
            }))
            alert.addAction(UIAlertAction(title: "To here", style: .Default, handler: { action in
                self.to = vertex
                vertex.highlighted = true
                self.clearSelection()
                self.getShortestPath()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { action in
                
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    // Select different algorithms
    
    @IBOutlet weak var algorithmsView: UIView!
    @IBOutlet weak var algorithmsViewTop: NSLayoutConstraint!
    
    @IBOutlet weak var aStarButton: UIButton!
    @IBOutlet weak var aStarCheckBox: UIImageView!
    
    @IBOutlet weak var dijkstraButton: UIButton!
    @IBOutlet weak var dijkstraCheckBox: UIImageView!
    
    @IBAction func showAlgorithms(sender: AnyObject) {
        toggleAlgorithmsView()
    }
    
    @IBAction func algorithmChanged(sender: UIButton)
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger( Int(sender.tag), forKey : "algorithm")
        defaults.synchronize()
        toggleAlgorithmsView()
        
        cleanup()
    }
    
    private func updateUIToSavedAlgorithm() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let saved : Int = defaults.integerForKey("algorithm")
        let algorithm = ShortestPathAlgorithm(rawValue: saved)
        
        aStarCheckBox.hidden = true
        dijkstraCheckBox.hidden = true
        
        if algorithm == ShortestPathAlgorithm.AStar {
            aStarCheckBox.hidden = false
            self.title = "A*"
        } else if algorithm == ShortestPathAlgorithm.Dijkstra {
            dijkstraCheckBox.hidden = false
            self.title = "Dijkstra"
        }
    }
    
    private func toggleAlgorithmsView() {
        if self.algorithmsViewTop.constant == 0 {
            self.algorithmsViewTop.constant = -self.algorithmsView.frame.size.height
            self.touchesEnabled = true
        } else {
            self.algorithmsViewTop.constant = 0
            self.touchesEnabled = false
        }
        
        updateUIToSavedAlgorithm()
        
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 2.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: ({
            self.view.layoutIfNeeded()
        }), completion: nil)
    }
    
    private func cleanup() {
        for vertex : Vertex in self.graph.vertices {
            vertex.minDistance = Double.infinity
            vertex.previous = nil
        }
        
        self.graphView.from = nil
        self.graphView.to = nil
        self.graphView.activityLines.removeAll(keepCapacity: false)
        self.graphView.path = nil
    }
}