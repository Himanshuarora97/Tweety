//
//  TimeHelper.swift
//  Tweety
//
//  Created by Himanshu Arora on 12/04/21.
//

import Foundation

protocol TimeHelperDelegate:class {

    func timerUpdated()

}

class TimeHelper: NSObject {
    
    private let listeners = WeakArray<AnyObject>()
    
    static let shared = TimeHelper()
    
    private override init() {
        super.init()
        startTimer()
    }
    
    private func startTimer(){
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }
    
    @objc func update() {
        for listener in (listeners.filter { $0 != nil }){
            if let currentClass = listener as? TimeHelperDelegate {
                currentClass.timerUpdated()
            }
        }
    }
    
//    Public Methods
    func addListener(_ object: AnyObject){
        listeners.insert(element: object)
    }
    
    func removeListener(_ object: AnyObject){
        listeners.remove(element: object)
    }
}
