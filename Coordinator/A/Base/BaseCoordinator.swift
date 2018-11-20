//
//  BaseCoordinator.swift
//  Coordinator
//
//  Created by Александрк Бельковский on 20/11/2018.
//  Copyright © 2018 Александрк Бельковский. All rights reserved.
//

import Foundation

class BaseCoordinator: Coordinator {
    
    private var childs: [Coordinator] = []
    
    var router: Routable
    
    required init(router: Routable) {
        self.router = router
    }
    
    func start() {
        
    }
    
    func add(coordinator: Coordinator) {
        guard !childs.contains(where: { $0 === coordinator }) else {
            return
        }
        
        childs.append(coordinator)
    }
    
    func remove(coordinator: Coordinator) {
        guard let index = childs.index(where: { $0 === coordinator }) else {
            return
        }
        
        childs.remove(at: index)
    }
    
}
