//
//  WeakArray.swift
//  Tweety
//
//  Created by Himanshu Arora on 12/04/21.
//

import Foundation

final class WeakBox<A: AnyObject> {
    weak var unbox: A?
    init(_ value: A) {
        unbox = value
    }
    
    func instance() -> AnyObject?{
        return unbox
    }
}

class WeakArray<E: AnyObject> {
    
    private var items: [WeakBox<E>] = []
    
    init(_ elements: [E]) {
        items = elements.map { WeakBox($0) }
    }
    
    init() {

    }
    
    func insert(element: E){
        if items.contains(where: { $0 === WeakBox(element) }) {
        } else {
            items.append(WeakBox(element))
        }
        //flush nil elements
        if(items.count > 10){
            items = (items.filter { $0.instance() != nil })
        }
    }
    
    func remove(element: E){
        if items.contains(where: { $0.instance() === element }) {
            items = items.filter { ($0.instance() !== element) && ($0.instance() != nil)}
        }

    }
}

extension WeakArray: Collection {
    var startIndex: Int { return items.startIndex }
    var endIndex: Int { return items.endIndex }
    
    subscript(_ index: Int) -> E? {
        return items[index].unbox
    }
    
    func index(after idx: Int) -> Int {
        return items.index(after: idx)
    }
}

