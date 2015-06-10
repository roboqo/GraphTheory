/*
Copyright (C) 2014 Bouke Haarsma

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

import Foundation

public class PriorityQueue<PrioType: Comparable, ValueType>: GeneratorType {
    typealias Element = ValueType
    private final var heap = [(PrioType, ValueType)]()
    
    public init() { }
    
    public func push(priority: PrioType, item: ValueType) {
        heap.append((priority, item))
        
        if heap.count == 1 {
            return
        }
        
        var current = heap.count - 1
        while current > 0 {
            let parent = (current - 1) >> 1
            if heap[parent].0 <= heap[current].0 {
                break
            }
            (heap[parent], heap[current]) = (heap[current], heap[parent])
            current = parent
        }
    }
    
    public func next() -> ValueType? {
        return pop()?.1
    }
    
    public func pop() -> (PrioType, ValueType)? {
        if heap.count == 0 {
            return nil
        }
        swap(&heap[0], &heap[heap.endIndex - 1])
        let pop = heap.removeLast()
        heapify(0)
        return pop
    }
    
    public func removeAll() {
        heap = []
    }
    
    private func heapify(index: Int) {
        let left = index * 2 + 1
        let right = index * 2 + 2
        var smallest = index
        
        let count = heap.count
        
        if left < count && heap[left].0 < heap[smallest].0 {
            smallest = left
        }
        if right < count && heap[right].0 < heap[smallest].0 {
            smallest = right
        }
        if smallest != index {
            swap(&heap[index], &heap[smallest])
            heapify(smallest)
        }
    }
    
    public var count: Int {
        return heap.count
    }
}

extension PriorityQueue: SequenceType {
    typealias Generator = PriorityQueue
    public func generate() -> Generator {
        return self
    }
}
